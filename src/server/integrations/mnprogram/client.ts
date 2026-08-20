const SOAP_NAMESPACE = 'http://tempuri.org/'
const CONTRATOS_CLIENTE_ACTION = `${SOAP_NAMESPACE}ContratosCliente`

export class MnProgramNotConfiguredError extends Error {
  readonly retryable = false

  constructor(message: string) {
    super(message)
    this.name = 'MnProgramNotConfiguredError'
  }
}

export class MnProgramRequestError extends Error {
  readonly retryable: boolean
  readonly ambiguous: boolean

  constructor(
    message: string,
    retryable: boolean,
    ambiguous = false,
  ) {
    super(message)
    this.name = 'MnProgramRequestError'
    this.retryable = retryable
    this.ambiguous = ambiguous
  }
}

export type MnProgramContractPayload = {
  customerName: string
  customerTaxId: string
  totalAmount: number
  nature: string
  expedientTitle: string
  expedientType: string
  customTab: string
  customFields: Record<string, string | number>
}

type MnProgramWebConfig = {
  baseUrl: string
  instance: string
  companyNumber: string
  operator: string
  passMd5: string
}

export function escapeXml(value: string): string {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;')
}

export function buildContratosClienteEnvelope(
  config: MnProgramWebConfig,
  payload: MnProgramContractPayload,
): string {
  const contractData = JSON.stringify({
    nombreCliente: payload.customerName,
    cifCliente: payload.customerTaxId,
    importe: payload.totalAmount,
    naturaleza: payload.nature,
    tituloExpediente: payload.expedientTitle,
    tipoExpediente: payload.expedientType,
  })
  const customData = JSON.stringify([
    {
      entidad: '2',
      nombrePestana: payload.customTab,
      ...payload.customFields,
    },
  ])

  return `<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="${SOAP_NAMESPACE}">
  <soap:Header/>
  <soap:Body>
    <tem:ContratosCliente>
      <tem:instancia>${escapeXml(config.instance)}</tem:instancia>
      <tem:numEmpresa>${escapeXml(config.companyNumber)}</tem:numEmpresa>
      <tem:operador>${escapeXml(config.operator)}</tem:operador>
      <tem:passMD5>${escapeXml(config.passMd5)}</tem:passMD5>
      <tem:datosContrato>${escapeXml(contractData)}</tem:datosContrato>
      <tem:datosPerso>${escapeXml(customData)}</tem:datosPerso>
    </tem:ContratosCliente>
  </soap:Body>
</soap:Envelope>`
}

export class MnProgramClient {
  private readonly config: MnProgramWebConfig

  private constructor(config: MnProgramWebConfig) {
    this.config = config
  }

  static fromEnvironment(): MnProgramClient {
    if (process.env.MNPROGRAM_SYNC_ENABLED?.trim().toLowerCase() !== 'true') {
      throw new MnProgramNotConfiguredError('MNPROGRAM_SYNC_ENABLED is false')
    }

    const baseUrl = process.env.MNPROGRAM_BASE_URL?.trim().replace(/\/+$/, '')
    const companyNumber = process.env.MNPROGRAM_COMPANY_NUMBER?.trim()
    const operator = process.env.MNPROGRAM_OPERATOR?.trim()
    const passMd5 = process.env.MNPROGRAM_PASS_MD5?.trim()
    const instance = process.env.MNPROGRAM_INSTANCE?.trim() ?? ''

    if (!baseUrl || !companyNumber || !operator) {
      throw new MnProgramNotConfiguredError(
        'MNprogram base URL, company number and operator are required',
      )
    }

    // The public MNprogram example documents passMD5 for the proven Web SOAP
    // signature. Token-only Cloud variants must be confirmed against the
    // private instance WSDL before adding parameters to the SOAP operation.
    if (!passMd5) {
      throw new MnProgramNotConfiguredError(
        process.env.MNPROGRAM_TOKEN?.trim()
          ? 'Token authentication requires the private MNprogram WSDL'
          : 'MNPROGRAM_PASS_MD5 is required for the documented Web SOAP API',
      )
    }

    let parsedUrl: URL
    try {
      parsedUrl = new URL(baseUrl)
    } catch {
      throw new MnProgramNotConfiguredError('MNPROGRAM_BASE_URL is invalid')
    }
    if (!['http:', 'https:'].includes(parsedUrl.protocol)) {
      throw new MnProgramNotConfiguredError(
        'MNPROGRAM_BASE_URL must use HTTP or HTTPS',
      )
    }

    return new MnProgramClient({
      baseUrl,
      companyNumber,
      operator,
      passMd5,
      instance,
    })
  }

  async contratosCliente(
    payload: MnProgramContractPayload,
  ): Promise<{ reference: string | null }> {
    const controller = new AbortController()
    const timeout = setTimeout(() => controller.abort(), 8_000)
    const endpoint = `${this.config.baseUrl}/API/ContratosService.asmx`

    try {
      const response = await fetch(endpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          SOAPAction: `"${CONTRATOS_CLIENTE_ACTION}"`,
        },
        body: buildContratosClienteEnvelope(this.config, payload),
        signal: controller.signal,
      })
      const responseText = await response.text()

      if (!response.ok) {
        throw new MnProgramRequestError(
          `MNprogram returned HTTP ${response.status}`,
          false,
        )
      }
      if (/<(?:\w+:)?Fault\b/i.test(responseText)) {
        throw new MnProgramRequestError('MNprogram returned a SOAP fault', false)
      }
      if (!/<(?:\w+:)?ContratosClienteResult\b/i.test(responseText)) {
        throw new MnProgramRequestError(
          'MNprogram returned an invalid SOAP response',
          false,
        )
      }

      return { reference: extractSoapResult(responseText) }
    } catch (error) {
      if (error instanceof MnProgramRequestError) throw error
      if (error instanceof DOMException && error.name === 'AbortError') {
        // A timeout may happen after MNprogram accepted the request. Automatic
        // retries are disabled to avoid a duplicate actuación.
        throw new MnProgramRequestError(
          'MNprogram request timed out; verify the expediente before retrying',
          false,
          true,
        )
      }
      const code =
        error instanceof Error &&
        typeof (error as Error & { cause?: { code?: unknown } }).cause?.code ===
          'string'
          ? String((error as Error & { cause: { code: string } }).cause.code)
          : ''
      throw new MnProgramRequestError(
        'MNprogram is unreachable',
        ['ECONNREFUSED', 'ENOTFOUND', 'EAI_AGAIN'].includes(code),
      )
    } finally {
      clearTimeout(timeout)
    }
  }
}

function extractSoapResult(xml: string): string | null {
  const match = xml.match(
    /<(?:\w+:)?ContratosClienteResult[^>]*>([\s\S]*?)<\/(?:\w+:)?ContratosClienteResult>/i,
  )
  if (!match) return null
  const value = decodeXml(match[1].replace(/<[^>]+>/g, '')).trim()
  return value ? value.slice(0, 240) : null
}

function decodeXml(value: string): string {
  return value
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    .replaceAll('&amp;', '&')
}
