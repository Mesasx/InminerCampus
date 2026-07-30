import { Link } from '@tanstack/react-router'
import type { BillingFormValue } from '../lib/billing'

export function BillingDetailsForm({
  value,
  disabled = false,
  lockBuyerType = false,
  onChange,
}: {
  value: BillingFormValue
  disabled?: boolean
  lockBuyerType?: boolean
  onChange: (value: BillingFormValue) => void
}) {
  const update = <Key extends keyof BillingFormValue>(
    key: Key,
    nextValue: BillingFormValue[Key],
  ) => onChange({ ...value, [key]: nextValue })

  return (
    <fieldset className="billing-form" disabled={disabled}>
      <legend>Datos fiscales</legend>
      <p className="muted">
        Se conservarán con el pedido para que Administración pueda preparar la
        factura.
      </p>

      <div className="form-row">
        <div className="field">
          <label htmlFor="billing-buyer-type">Tipo de comprador</label>
          <select
            disabled={lockBuyerType}
            id="billing-buyer-type"
            value={value.buyerType}
            onChange={(event) =>
              update(
                'buyerType',
                event.target.value as BillingFormValue['buyerType'],
              )
            }
          >
            <option value="individual">Particular</option>
            <option value="business">Empresa o autónomo</option>
          </select>
        </div>
        <div className="field">
          <label htmlFor="billing-fiscal-name">
            {value.buyerType === 'individual'
              ? 'Nombre y apellidos'
              : 'Razón social o nombre fiscal'}
          </label>
          <input
            autoComplete="name"
            id="billing-fiscal-name"
            maxLength={200}
            required
            value={value.fiscalName}
            onChange={(event) => update('fiscalName', event.target.value)}
          />
        </div>
      </div>

      <div className="form-row">
        <div className="field">
          <label htmlFor="billing-tax-id">DNI, NIF, NIE o CIF</label>
          <input
            autoCapitalize="characters"
            id="billing-tax-id"
            maxLength={40}
            required
            value={value.taxId}
            onChange={(event) => update('taxId', event.target.value)}
          />
        </div>
        <div className="field">
          <label htmlFor="billing-country">País</label>
          <select
            autoComplete="country"
            id="billing-country"
            value={value.countryCode}
            onChange={(event) => update('countryCode', event.target.value)}
          >
            <option value="ES">España</option>
            <option value="PT">Portugal</option>
            <option value="FR">Francia</option>
            <option value="DE">Alemania</option>
            <option value="IT">Italia</option>
          </select>
        </div>
      </div>

      <div className="field">
        <label htmlFor="billing-address">Dirección fiscal</label>
        <input
          autoComplete="street-address"
          id="billing-address"
          maxLength={240}
          required
          value={value.addressLine1}
          onChange={(event) => update('addressLine1', event.target.value)}
        />
      </div>

      <div className="billing-form__location">
        <div className="field">
          <label htmlFor="billing-postal-code">Código postal</label>
          <input
            autoComplete="postal-code"
            id="billing-postal-code"
            maxLength={20}
            required
            value={value.postalCode}
            onChange={(event) => update('postalCode', event.target.value)}
          />
        </div>
        <div className="field">
          <label htmlFor="billing-city">Localidad</label>
          <input
            autoComplete="address-level2"
            id="billing-city"
            maxLength={120}
            required
            value={value.city}
            onChange={(event) => update('city', event.target.value)}
          />
        </div>
        <div className="field">
          <label htmlFor="billing-province">Provincia</label>
          <input
            autoComplete="address-level1"
            id="billing-province"
            maxLength={120}
            required
            value={value.province}
            onChange={(event) => update('province', event.target.value)}
          />
        </div>
      </div>

      <div className="form-row">
        <div className="field">
          <label htmlFor="billing-email">Correo de facturación</label>
          <input
            autoComplete="email"
            id="billing-email"
            maxLength={320}
            required
            type="email"
            value={value.billingEmail}
            onChange={(event) => update('billingEmail', event.target.value)}
          />
        </div>
        <div className="field">
          <label htmlFor="billing-phone">Teléfono (opcional)</label>
          <input
            autoComplete="tel"
            id="billing-phone"
            maxLength={40}
            type="tel"
            value={value.phone}
            onChange={(event) => update('phone', event.target.value)}
          />
        </div>
      </div>

      <label className="checkbox">
        <input
          checked={value.sendInvoiceToDifferentEmail}
          type="checkbox"
          onChange={(event) =>
            update('sendInvoiceToDifferentEmail', event.target.checked)
          }
        />
        Necesito que la factura se envíe a un correo distinto.
      </label>

      {value.sendInvoiceToDifferentEmail ? (
        <div className="field">
          <label htmlFor="billing-invoice-email">
            Correo de entrega de la factura
          </label>
          <input
            id="billing-invoice-email"
            maxLength={320}
            required
            type="email"
            value={value.invoiceEmail}
            onChange={(event) => update('invoiceEmail', event.target.value)}
          />
        </div>
      ) : null}

      <label className="checkbox billing-form__legal">
        <input
          checked={value.acceptLegal}
          required
          type="checkbox"
          onChange={(event) => update('acceptLegal', event.target.checked)}
        />
        <span>
          He leído y acepto las{' '}
          <Link
            className="text-link"
            params={{ legalSlug: 'contratacion' }}
            target="_blank"
            to="/legal/$legalSlug"
          >
            condiciones de contratación
          </Link>{' '}
          y la{' '}
          <Link
            className="text-link"
            params={{ legalSlug: 'privacidad' }}
            target="_blank"
            to="/legal/$legalSlug"
          >
            política de privacidad
          </Link>
          .
        </span>
      </label>
    </fieldset>
  )
}
