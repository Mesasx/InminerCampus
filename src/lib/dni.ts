import {
  isValidDni as hasValidDniControl,
  isValidNie as hasValidNieControl,
  normalizeTaxIdentifier,
} from './billing.ts'

/**
 * Identificación personal del alumno. A diferencia de
 * `isValidSpanishTaxIdentifier`, aquí no vale un CIF: el certificado y el aviso
 * interno de finalización identifican a una persona física, no a una empresa.
 *
 * La restricción `profiles_dni_format` de la base de datos solo comprueba el
 * formato; esto valida además la letra de control, así que un DNI mal tecleado
 * se detecta antes de guardarlo y no reaparece al emitir el certificado.
 */
export function normalizeDni(value: string): string {
  return normalizeTaxIdentifier(value)
}

export function isValidDni(value: string): boolean {
  const normalized = normalizeDni(value)
  return hasValidDniControl(normalized) || hasValidNieControl(normalized)
}

export const DNI_ERROR_MESSAGE = 'El DNI/NIE no tiene un formato válido.'
