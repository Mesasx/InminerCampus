import assert from 'node:assert/strict'
import test from 'node:test'
import {
  buildContratosClienteEnvelope,
  escapeXml,
  MnProgramClient,
  MnProgramNotConfiguredError,
  MnProgramRequestError,
} from '../src/server/integrations/mnprogram/client.ts'
import { toMnProgramContract } from '../src/server/integrations/mnprogram/sync.ts'

test('escapa XML y serializa el contrato documentado por MNprogram', () => {
  assert.equal(escapeXml(`A&B <C> "D" 'E'`), 'A&amp;B &lt;C&gt; &quot;D&quot; &apos;E&apos;')
  const envelope = buildContratosClienteEnvelope(
    {
      baseUrl: 'https://example.invalid',
      instance: 'demo&uno',
      companyNumber: '1',
      operator: 'campus',
      passMd5: 'abc<123',
    },
    {
      customerName: 'Áridos & Minas',
      customerTaxId: 'B13476148',
      totalAmount: 180.29,
      nature: 'Venta formación',
      expedientTitle: 'Pedido CAMPUS-42',
      expedientType: 'INMINERCAMPUS',
      customTab: 'InminerCampus',
      customFields: { pedido: 'CAMPUS-42' },
    },
  )

  assert.match(envelope, /<tem:ContratosCliente>/)
  assert.match(envelope, /<tem:passMD5>abc&lt;123<\/tem:passMD5>/)
  assert.match(envelope, /demo&amp;uno/)
  assert.doesNotMatch(envelope, /Áridos & Minas/)
})

test('mapea la trazabilidad de Stripe y del pedido a campos personalizados', () => {
  const contract = toMnProgramContract({
    purchaseId: '11111111-1111-4111-8111-111111111111',
    orderNumber: 'CAMPUS-2026-42',
    purchaseKind: 'company',
    customerName: 'Minas del Centro, S.L.',
    customerTaxId: 'B13476148',
    customerEmail: 'admin@example.com',
    totalAmountCents: 18_029,
    subtotalCents: 14_900,
    taxCents: 3_129,
    currency: 'EUR',
    paidAt: '2026-08-20T10:15:00.000Z',
    stripePaymentIntentId: 'pi_test_42',
    stripeCheckoutSessionId: 'cs_test_42',
    stripeCustomerId: 'cus_test_42',
    invoiceNumber: 'CAMPUS-2026-000042',
    invoiceStatus: 'pending',
    items: [
      {
        courseTitle: 'Formación minera',
        courseCode: 'MIN-01',
        courseVersion: 2,
        modality: 'online',
        quantity: 3,
      },
    ],
  })

  assert.equal(contract.customerTaxId, 'B13476148')
  assert.equal(contract.totalAmount, 180.29)
  assert.equal(contract.customFields['Stripe Payment ID'], 'pi_test_42')
  assert.equal(contract.customFields['Número pedido'], 'CAMPUS-2026-42')
  assert.equal(contract.customFields['Código curso'], 'MIN-01')
  assert.equal(contract.customFields['Número plazas'], 3)
})

test('permanece NOT_CONFIGURED sin credenciales verificadas', () => {
  const previous = process.env.MNPROGRAM_SYNC_ENABLED
  process.env.MNPROGRAM_SYNC_ENABLED = 'false'
  try {
    assert.throws(
      () => MnProgramClient.fromEnvironment(),
      MnProgramNotConfiguredError,
    )
  } finally {
    if (previous === undefined) delete process.env.MNPROGRAM_SYNC_ENABLED
    else process.env.MNPROGRAM_SYNC_ENABLED = previous
  }
})

test('interpreta una respuesta SOAP válida sin guardar el sobre completo', async () => {
  await withConfiguredClient(
    async () =>
      new Response(
        '<soap:Envelope><soap:Body><ContratosClienteResponse><ContratosClienteResult>ACT&amp;42</ContratosClienteResult></ContratosClienteResponse></soap:Body></soap:Envelope>',
        { status: 200 },
      ),
    async (client) => {
      const result = await client.contratosCliente(minimalContract)
      assert.equal(result.reference, 'ACT&42')
    },
  )
})

test('rechaza fault y respuesta SOAP incorrecta sin reintento automático', async () => {
  for (const body of [
    '<soap:Envelope><soap:Body><soap:Fault>error</soap:Fault></soap:Body></soap:Envelope>',
    '<html>respuesta inesperada</html>',
  ]) {
    await withConfiguredClient(
      async () => new Response(body, { status: 200 }),
      async (client) => {
        await assert.rejects(
          () => client.contratosCliente(minimalContract),
          (error: unknown) =>
            error instanceof MnProgramRequestError && !error.retryable,
        )
      },
    )
  }
})

test('un timeout queda ambiguo y no puede duplicar una actuación', async () => {
  await withConfiguredClient(
    async () => {
      throw new DOMException('timeout', 'AbortError')
    },
    async (client) => {
      await assert.rejects(
        () => client.contratosCliente(minimalContract),
        (error: unknown) =>
          error instanceof MnProgramRequestError &&
          error.ambiguous &&
          !error.retryable,
      )
    },
  )
})

test('solo reintenta una caída previa a conectar y no un HTTP remoto', async () => {
  await withConfiguredClient(
    async () => {
      throw new Error('offline', { cause: { code: 'ECONNREFUSED' } })
    },
    async (client) => {
      await assert.rejects(
        () => client.contratosCliente(minimalContract),
        (error: unknown) =>
          error instanceof MnProgramRequestError && error.retryable,
      )
    },
  )
  await withConfiguredClient(
    async () => new Response('unavailable', { status: 503 }),
    async (client) => {
      await assert.rejects(
        () => client.contratosCliente(minimalContract),
        (error: unknown) =>
          error instanceof MnProgramRequestError && !error.retryable,
      )
    },
  )
})

const minimalContract = {
  customerName: 'Cliente Prueba',
  customerTaxId: '12345678Z',
  totalAmount: 121,
  nature: 'Venta InmínerCampus - TEST',
  expedientTitle: 'INMINERCAMPUS',
  expedientType: 'Formación',
  customTab: 'InmínerCampus',
  customFields: { 'Número pedido': 'TEST' },
}

async function withConfiguredClient(
  mockFetch: typeof fetch,
  operation: (client: MnProgramClient) => Promise<void>,
) {
  const originalFetch = globalThis.fetch
  const previous = {
    enabled: process.env.MNPROGRAM_SYNC_ENABLED,
    baseUrl: process.env.MNPROGRAM_BASE_URL,
    company: process.env.MNPROGRAM_COMPANY_NUMBER,
    operator: process.env.MNPROGRAM_OPERATOR,
    password: process.env.MNPROGRAM_PASS_MD5,
  }
  process.env.MNPROGRAM_SYNC_ENABLED = 'true'
  process.env.MNPROGRAM_BASE_URL = 'https://mnprogram.example'
  process.env.MNPROGRAM_COMPANY_NUMBER = '1'
  process.env.MNPROGRAM_OPERATOR = 'api'
  process.env.MNPROGRAM_PASS_MD5 = 'hash'
  globalThis.fetch = mockFetch
  try {
    await operation(MnProgramClient.fromEnvironment())
  } finally {
    globalThis.fetch = originalFetch
    restoreEnv('MNPROGRAM_SYNC_ENABLED', previous.enabled)
    restoreEnv('MNPROGRAM_BASE_URL', previous.baseUrl)
    restoreEnv('MNPROGRAM_COMPANY_NUMBER', previous.company)
    restoreEnv('MNPROGRAM_OPERATOR', previous.operator)
    restoreEnv('MNPROGRAM_PASS_MD5', previous.password)
  }
}

function restoreEnv(name: string, value: string | undefined) {
  if (value === undefined) delete process.env[name]
  else process.env[name] = value
}
