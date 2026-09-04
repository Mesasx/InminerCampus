import { createFileRoute, Link } from '@tanstack/react-router'
import { Building2, Check, CreditCard, ShieldCheck, UserRound, UsersRound } from 'lucide-react'
import { useEffect, useMemo, useState, type FormEvent, type ReactNode } from 'react'
import { BillingDetailsForm } from '../components/BillingDetailsForm'
import { ProtectedGate } from '../components/ProtectedGate'
import { PublicLayout } from '../components/PublicLayout'
import {
  calculateOrderAmounts,
  checkoutRequestSchema,
  decimalToCents,
  emptyBillingForm,
  formatCents,
  getCompanyVolumeDiscountBasisPoints,
  taxRateToBasisPoints,
} from '../lib/billing'
import { modalityLabel } from '../lib/format'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/comprar-empresa/$courseSlug')({
  validateSearch: (search: Record<string, unknown>): { version?: string } => ({
    version: typeof search.version === 'string' && search.version.trim() ? search.version : undefined,
  }),
  head: () => seoHead({
    title: 'Contratar formación para empresa',
    description: 'Contratación de licencias de formación para empresa.',
    path: '/comprar-empresa',
    noindex: true,
  }),
  component: CompanyCheckoutPage,
})

type CompanyCourse = {
  versionId: string
  versionNumber: number
  title: string
  duration: number
  modality: string
  requirements: string[]
  practiceRequired: boolean
  accreditationReference: string | null
  price: number | string
  currency: string
  taxRate: number | string
}
type Organization = {
  id: string
  legal_name: string
  tax_id: string
  billing_email: string | null
  billing_address: Record<string, unknown>
}
type Participant = { givenName: string; familyName: string; email: string }

function CompanyCheckoutPage() {
  const { courseSlug } = Route.useParams()
  const { version } = Route.useSearch()
  const returnTo = `/comprar-empresa/${encodeURIComponent(courseSlug)}${version ? `?version=${encodeURIComponent(version)}` : ''}`
  return (
    <ProtectedGate returnTo={returnTo}>
      {(user) => <CompanyCheckout user={user} courseSlug={courseSlug} versionId={version} />}
    </ProtectedGate>
  )
}

function CompanyCheckout({ user, courseSlug, versionId }: { user: SessionUser; courseSlug: string; versionId?: string }) {
  const [course, setCourse] = useState<CompanyCourse | null>(null)
  const [organizations, setOrganizations] = useState<Organization[]>([])
  const [organizationId, setOrganizationId] = useState('')
  const [useNewOrganization, setUseNewOrganization] = useState(false)
  const [quantity, setQuantity] = useState(1)
  const [participants, setParticipants] = useState<Participant[]>([{ givenName: '', familyName: '', email: '' }])
  const [contact, setContact] = useState({ givenName: user.firstName, familyName: '', email: user.email, phone: '' })
  const [privacyConfirmed, setPrivacyConfirmed] = useState(false)
  const [error, setError] = useState('')
  const [paying, setPaying] = useState(false)
  const [checkoutRequestId] = useState(() => crypto.randomUUID())
  const [billing, setBilling] = useState(() => emptyBillingForm(user.email, 'business'))

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    let versionQuery = supabase.from('course_versions').select(
      'id, version_number, duration_hours, modality, requirements, practice_required, accreditation_reference, price_net, currency, tax_rate, courses!inner(title, slug, status)',
    ).eq('status', 'published').eq('courses.slug', courseSlug).eq('courses.status', 'published')
    if (versionId) versionQuery = versionQuery.eq('id', versionId)
    const organizationQuery = user.roles.includes('superadministrador')
      ? supabase.from('organizations').select('id, legal_name, tax_id, billing_email, billing_address')
      : supabase.from('organization_members').select(
          'organizations!inner(id, legal_name, tax_id, billing_email, billing_address)',
        ).eq('user_id', user.id).eq('role', 'responsable_empresa').eq('status', 'active')

    void Promise.all([
      versionQuery.order('version_number', { ascending: false }).limit(1).maybeSingle(),
      organizationQuery,
    ]).then(([{ data: version }, { data: organizationRows }]) => {
      if (version?.price_net !== null && version?.price_net !== undefined) {
        const row = version as unknown as {
          id: string; version_number: number; duration_hours: number; modality: string
          requirements: string[]; practice_required: boolean; accreditation_reference: string | null
          price_net: number | string; currency: string; tax_rate: number | string; courses: { title: string }
        }
        setCourse({
          versionId: row.id, versionNumber: row.version_number, title: row.courses.title,
          duration: row.duration_hours, modality: row.modality, requirements: row.requirements ?? [],
          practiceRequired: row.practice_required, accreditationReference: row.accreditation_reference,
          price: row.price_net, currency: row.currency, taxRate: row.tax_rate,
        })
      }
      const orgs = (organizationRows ?? []).map((row) => user.roles.includes('superadministrador')
        ? (row as unknown as Organization)
        : (row as unknown as { organizations: Organization }).organizations)
      setOrganizations(orgs)
      const first = orgs[0]
      setOrganizationId(first?.id ?? '')
      setUseNewOrganization(!first)
      if (first) setBilling((current) => billingForOrganization(first, current))
    })
  }, [courseSlug, user.id, user.roles, versionId])

  useEffect(() => {
    setParticipants((current) => Array.from(
      { length: quantity },
      (_, index) => current[index] ?? { givenName: '', familyName: '', email: '' },
    ))
  }, [quantity])

  const amounts = useMemo(() => course ? calculateOrderAmounts(
    decimalToCents(course.price), quantity, taxRateToBasisPoints(course.taxRate),
    getCompanyVolumeDiscountBasisPoints(quantity),
  ) : null, [course, quantity])

  function selectOrganization(next: string) {
    setOrganizationId(next)
    setUseNewOrganization(!next)
    const organization = organizations.find(({ id }) => id === next)
    if (organization) setBilling((current) => billingForOrganization(organization, current))
  }

  function updateParticipant(index: number, patch: Partial<Participant>) {
    setParticipants((current) => current.map((participant, candidate) =>
      candidate === index ? { ...participant, ...patch } : participant))
  }

  async function beginCheckout(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!course || !amounts) return
    setError('')
    const parsed = checkoutRequestSchema.safeParse({
      courseVersionId: course.versionId,
      kind: 'company',
      quantity,
      organizationId: useNewOrganization ? undefined : organizationId || undefined,
      checkoutRequestId,
      billing,
      contact,
      recipients: participants,
      participantPrivacyConfirmed: privacyConfirmed,
    })
    if (!parsed.success) {
      const issue = parsed.error.issues[0]
      setError(issue?.message ?? 'Revisa los datos del pedido.')
      focusCheckoutIssue(issue?.path ?? [])
      return
    }
    const { data } = (await getSupabaseBrowserClient()?.auth.getSession()) ?? { data: null }
    const token = data?.session?.access_token
    if (!token) { setError('Tu sesión ha caducado.'); return }
    setPaying(true)
    try {
      const response = await fetch('/api/checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
        body: JSON.stringify(parsed.data),
      })
      const result = (await response.json()) as { url?: string; error?: string }
      if (!response.ok || !result.url) {
        setError(result.error ?? 'No se ha podido iniciar el pago.')
        setPaying(false)
        return
      }
      window.location.assign(result.url)
    } catch {
      setError('No se ha podido conectar con el pago seguro.')
      setPaying(false)
    }
  }

  return (
    <PublicLayout>
      <header className="company-checkout-hero">
        <div className="container">
          <span className="eyebrow">Compra empresarial segura</span>
          <h1>Formación para tu equipo, sin fricciones.</h1>
          <p>Configura las plazas, identifica a las personas y revisa todo antes de pagar.</p>
          <ol className="checkout-progress" aria-label="Pasos del pedido">
            {['Plazas', 'Empresa', 'Personas', 'Pago'].map((step, index) => <li key={step}><span>{index + 1}</span>{step}</li>)}
          </ol>
        </div>
      </header>

      <section className="section section--tight">
        <div className="container company-checkout-layout">
          {course ? (
            <form className="company-checkout-form" noValidate onSubmit={beginCheckout}>
              {error ? <div className="alert alert--error" role="alert">{error}</div> : null}
              <CheckoutSection icon={UsersRound} number="01" title="Curso y número de plazas">
                <div className="checkout-course-card">
                  <div><span className="status status--orange">Versión {course.versionNumber}</span><h2>{course.title}</h2><p>{course.duration} horas · {modalityLabel(course.modality)}</p></div>
                  <strong>{formatCents(decimalToCents(course.price), course.currency)} <small>+ IVA / plaza</small></strong>
                </div>
                <div className="field quantity-field">
                  <label htmlFor="company-seats">¿Para cuántas personas quieres comprar este curso?</label>
                  <input id="company-seats" inputMode="numeric" min={1} max={500} required type="number" value={quantity} onChange={(event) => {
                    const next = Number.parseInt(event.target.value, 10)
                    setQuantity(Number.isFinite(next) ? Math.max(1, Math.min(500, next)) : 1)
                  }} />
                </div>
                <div className="discount-scale" aria-label="Descuentos por volumen">
                  <span className={quantity <= 5 ? 'is-active' : ''}><b>1–5 plazas</b>Precio estándar</span>
                  <span className={quantity >= 6 && quantity <= 7 ? 'is-active' : ''}><b>6–7 plazas</b>5 % de descuento</span>
                  <span className={quantity >= 8 ? 'is-active' : ''}><b>8+ plazas</b>10 % de descuento</span>
                </div>
                {amounts?.discountBasisPoints ? <p className="discount-applied"><Check size={17} /> {amounts.discountBasisPoints / 100} % de descuento por volumen aplicado</p> : null}
              </CheckoutSection>

              <CheckoutSection icon={Building2} number="02" title="Datos de la empresa">
                {organizations.length ? (
                  <div className="field"><label htmlFor="company-org">Empresa compradora</label><select id="company-org" value={useNewOrganization ? '' : organizationId} onChange={(event) => selectOrganization(event.target.value)}>{organizations.map((organization) => <option key={organization.id} value={organization.id}>{organization.legal_name}</option>)}<option value="">Registrar otra empresa</option></select></div>
                ) : <div className="alert alert--info">Crearemos una organización provisional con los datos fiscales. Si el CIF ya está registrado, no se realizará ninguna vinculación automática.</div>}
                <BillingDetailsForm disabled={paying} lockBuyerType onChange={setBilling} value={billing} />
                <fieldset className="billing-form" disabled={paying}>
                  <legend>Persona de contacto</legend>
                  <div className="form-row"><div className="field"><label htmlFor="contact-name">Nombre</label><input id="contact-name" autoComplete="given-name" required value={contact.givenName} onChange={(event) => setContact({ ...contact, givenName: event.target.value })} /></div><div className="field"><label htmlFor="contact-family">Apellidos</label><input id="contact-family" autoComplete="family-name" required value={contact.familyName} onChange={(event) => setContact({ ...contact, familyName: event.target.value })} /></div></div>
                  <div className="form-row"><div className="field"><label htmlFor="contact-email">Email</label><input id="contact-email" autoComplete="email" type="email" required value={contact.email} onChange={(event) => setContact({ ...contact, email: event.target.value })} /></div><div className="field"><label htmlFor="contact-phone">Teléfono (opcional)</label><input id="contact-phone" autoComplete="tel" type="tel" value={contact.phone} onChange={(event) => setContact({ ...contact, phone: event.target.value })} /></div></div>
                </fieldset>
              </CheckoutSection>

              <CheckoutSection icon={UserRound} number="03" title={`Personas que recibirán las licencias (${quantity})`}>
                <p className="muted">No necesitan contraseña ahora. Cada persona recibirá su código individual después de que Stripe confirme el pago.</p>
                <div className="participant-list">{participants.map((participant, index) => (
                  <fieldset className="participant-card" key={index}><legend>Persona {index + 1}</legend><div className="participant-fields">
                    <div className="field"><label htmlFor={`participant-name-${index}`}>Nombre</label><input id={`participant-name-${index}`} maxLength={100} required value={participant.givenName} onChange={(event) => updateParticipant(index, { givenName: event.target.value })} /></div>
                    <div className="field"><label htmlFor={`participant-family-${index}`}>Apellidos</label><input id={`participant-family-${index}`} maxLength={160} required value={participant.familyName} onChange={(event) => updateParticipant(index, { familyName: event.target.value })} /></div>
                    <div className="field"><label htmlFor={`participant-email-${index}`}>Correo electrónico</label><input id={`participant-email-${index}`} maxLength={320} type="email" required value={participant.email} onChange={(event) => updateParticipant(index, { email: event.target.value })} /></div>
                  </div></fieldset>
                ))}</div>
                <label className="checkbox privacy-confirmation"><input checked={privacyConfirmed} required type="checkbox" onChange={(event) => setPrivacyConfirmed(event.target.checked)} /><span>Declaro que estoy autorizado para facilitar estos datos dentro de la relación con las personas inscritas y que he proporcionado o proporcionaré la información pertinente sobre su tratamiento. Consulta la <Link className="text-link" params={{ legalSlug: 'privacidad' }} target="_blank" to="/legal/$legalSlug">política de privacidad</Link>.</span></label>
              </CheckoutSection>

              <CheckoutSection icon={ShieldCheck} number="04" title="Revisión y pago">
                <div className="modality-scope"><h3>Modalidad y alcance de la formación</h3><p>{modalityLabel(course.modality)} · {course.duration} horas. {course.practiceRequired ? 'Esta versión incluye práctica presencial obligatoria.' : 'La ficha y el programa determinan el alcance concreto de esta versión.'}</p>{course.accreditationReference ? <p>{course.accreditationReference}</p> : null}{course.requirements.length ? <ul>{course.requirements.map((requirement) => <li key={requirement}>{requirement}</li>)}</ul> : null}<a className="text-link" href={`/contacto?curso=${encodeURIComponent(courseSlug)}`}>¿Necesitáis modalidad o apoyo presencial?</a></div>
                <p className="muted">Tras el pago, el webhook de Stripe validará el pedido, generará las licencias y enviará un correo individual a cada participante. El pago y la emisión administrativa de la factura son estados distintos.</p>
                <button className="button button--primary button--wide checkout-pay" disabled={paying} type="submit"><CreditCard size={19} /> {paying ? 'Abriendo Stripe…' : `Pagar ${amounts ? formatCents(amounts.totalAmountCents, course.currency) : ''} con Stripe`}</button>
              </CheckoutSection>
            </form>
          ) : <div className="empty-state"><p>Cargando la oferta publicada…</p></div>}

          {course && amounts ? <details className="order-summary panel">
            <summary>Resumen · {formatCents(amounts.totalAmountCents, course.currency)}</summary>
            <div className="order-summary__content"><span className="eyebrow">Resumen del pedido</span><h2>{course.title}</h2><p className="muted">{quantity} {quantity === 1 ? 'plaza' : 'plazas'} · {course.duration} h</p>
            <dl className="order-totals"><div><dt>Precio unitario</dt><dd>{formatCents(amounts.unitNetCents, course.currency)}</dd></div><div><dt>Subtotal ({quantity} plazas)</dt><dd>{formatCents(amounts.grossSubtotalCents, course.currency)}</dd></div>{amounts.discountAmountCents ? <div className="order-discount"><dt>Descuento ({amounts.discountBasisPoints / 100} %)</dt><dd>− {formatCents(amounts.discountAmountCents, course.currency)}</dd></div> : null}<div><dt>Base tras descuento</dt><dd>{formatCents(amounts.subtotalNetCents, course.currency)}</dd></div><div><dt>IVA ({course.taxRate} %)</dt><dd>{formatCents(amounts.taxAmountCents, course.currency)}</dd></div><div className="order-totals__total"><dt>Total</dt><dd>{formatCents(amounts.totalAmountCents, course.currency)}</dd></div></dl>
            {amounts.discountAmountCents ? <p className="savings">Ahorras {formatCents(amounts.discountAmountCents, course.currency)}</p> : null}<p className="secure-note"><ShieldCheck size={17} /> Importes recalculados en servidor. Pago seguro con Stripe.</p></div>
          </details> : null}
        </div>
      </section>
    </PublicLayout>
  )
}

function focusCheckoutIssue(path: readonly PropertyKey[]) {
  const key = path.map(String).join('.')
  const fieldIds: Record<string, string> = {
    'billing.fiscalName': 'billing-fiscal-name',
    'billing.taxId': 'billing-tax-id',
    'billing.addressLine1': 'billing-address',
    'billing.postalCode': 'billing-postal-code',
    'billing.city': 'billing-city',
    'billing.province': 'billing-province',
    'billing.countryCode': 'billing-country',
    'billing.billingEmail': 'billing-email',
    'billing.phone': 'billing-phone',
    'billing.invoiceEmail': 'billing-invoice-email',
    'contact.givenName': 'contact-name',
    'contact.familyName': 'contact-family',
    'contact.email': 'contact-email',
    'contact.phone': 'contact-phone',
  }
  let fieldId = fieldIds[key]
  if (path[0] === 'recipients' && typeof path[1] === 'number') {
    const recipientField = path[2]
    const prefix = recipientField === 'givenName'
      ? 'participant-name'
      : recipientField === 'familyName'
        ? 'participant-family'
        : 'participant-email'
    fieldId = `${prefix}-${path[1]}`
  }
  requestAnimationFrame(() => {
    const target = fieldId
      ? document.getElementById(fieldId)
      : key === 'billing.acceptLegal'
        ? document.querySelector<HTMLElement>('.billing-form__legal input')
        : key === 'participantPrivacyConfirmed'
          ? document.querySelector<HTMLElement>('.privacy-confirmation input')
          : document.querySelector<HTMLElement>('.alert--error')
    target?.focus()
    target?.scrollIntoView({ behavior: 'smooth', block: 'center' })
  })
}

function CheckoutSection({ icon: Icon, number, title, children }: { icon: typeof Building2; number: string; title: string; children: ReactNode }) {
  return <section className="checkout-section panel"><header><span className="checkout-section__icon"><Icon size={20} /></span><div><small>Paso {number}</small><h2>{title}</h2></div></header><div className="checkout-section__body">{children}</div></section>
}

function billingForOrganization(organization: Organization, current: ReturnType<typeof emptyBillingForm>) {
  const address = organization.billing_address ?? {}
  const text = (...keys: string[]) => {
    for (const key of keys) { const value = address[key]; if (typeof value === 'string' && value.trim()) return value.trim() }
    return ''
  }
  const country = text('country_code', 'countryCode', 'country') || current.countryCode
  return { ...current, buyerType: 'business' as const, fiscalName: organization.legal_name, taxId: organization.tax_id, addressLine1: text('line1', 'address_line1', 'street', 'address') || current.addressLine1, postalCode: text('postal_code', 'postalCode', 'zip') || current.postalCode, city: text('city', 'locality', 'town') || current.city, province: text('province', 'state', 'region') || current.province, countryCode: country.length === 2 ? country.toUpperCase() : 'ES', billingEmail: organization.billing_email || current.billingEmail }
}
