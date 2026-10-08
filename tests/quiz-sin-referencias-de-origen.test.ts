import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

import { stripSourceReferences } from '../src/lib/quiz-text.ts'

const cleaned: Array<[string, string]> = [
  // Caso real del banco de Establecimientos de beneficio (EB-20H-B4-Q02).
  [
    '¿Qué función preventiva tiene un manómetro según la diapositiva?',
    '¿Qué función preventiva tiene un manómetro?',
  ],
  ['¿Cuál es la distancia mínima? (Diapositiva 8)', '¿Cuál es la distancia mínima?'],
  ['¿Cuál es la distancia mínima? [Slide 14]', '¿Cuál es la distancia mínima?'],
  ['Diapositiva 8: ¿Cuál es la distancia mínima?', '¿Cuál es la distancia mínima?'],
  ['Tema 2 · ¿Qué EPI es obligatorio?', '¿Qué EPI es obligatorio?'],
  ['Slide 14 - ¿Qué EPI es obligatorio?', '¿Qué EPI es obligatorio?'],
  ['Unidad 1.3. ¿Qué EPI es obligatorio?', '¿Qué EPI es obligatorio?'],
  ['¿Qué EPI es obligatorio? (Tema 2, diapositiva 5)', '¿Qué EPI es obligatorio?'],
  ['¿Qué EPI es obligatorio? (Fuente: diapositiva 8)', '¿Qué EPI es obligatorio?'],
  ['¿Qué EPI es obligatorio? Fuente: diapositiva 8', '¿Qué EPI es obligatorio?'],
  ['¿Qué EPI es obligatorio? — Diapositivas 41–42', '¿Qué EPI es obligatorio?'],
  ['¿Qué EPI es obligatorio? (D8)', '¿Qué EPI es obligatorio?'],
  ['¿Qué EPI es obligatorio? (pág. 14)', '¿Qué EPI es obligatorio?'],
  [
    '¿Qué indica la señal que aparece en la diapositiva 12?',
    '¿Qué indica la señal?',
  ],
  [
    'De acuerdo con el tema 3, ¿quién autoriza el acceso?',
    '¿Quién autoriza el acceso?',
  ],
  ['Comunicarlo al vigilante (diapositiva 9)', 'Comunicarlo al vigilante'],
]

for (const [input, expected] of cleaned) {
  test(`retira la referencia de origen: «${input}»`, () => {
    assert.equal(stripSourceReferences(input), expected)
  })
}

// Textos que son contenido evaluable y no deben alterarse.
const untouched = [
  '¿Qué sistemas de frenado deben comprobarse conforme al manual?',
  '¿Qué debe respetarse del manual del fabricante?',
  '¿Qué función cumple la lámina de agua en el riego de pistas?',
  '¿Cuál es el tema central de la evaluación de riesgos?',
  '¿A qué distancia deben señalizarse las líneas de 25 kV?',
  'Mantener la alimentación activa',
  'Detectar sobrepresión en circuitos',
  '¿Qué fuente de energía debe consignarse antes de intervenir?',
  'Solo bloqueo mecánico (sin consignación eléctrica)',
  '-10 °C',
  '¿Qué ocurre si la presión baja de 2 bar ?',
  'Tema 2', // sin separador ni contexto: no se toca
]

for (const input of untouched) {
  test(`no altera contenido legítimo: «${input}»`, () => {
    assert.equal(stripSourceReferences(input), input)
  })
}

test('nunca devuelve una pregunta vacía', () => {
  assert.equal(stripSourceReferences('(Diapositiva 8)'), '(Diapositiva 8)')
})

test('la evaluación del alumno limpia enunciado y opciones antes de pintarlos', async () => {
  const source = await readFile(
    new URL('../src/routes/evaluacion.$enrollmentId.$quizId.tsx', import.meta.url),
    'utf8',
  )
  assert.match(source, /stripSourceReferences\(question\.prompt\)/)
  assert.match(source, /stripSourceReferences\(option\.text\)/)
  // El enunciado y las opciones sólo se pintan a través de la limpieza.
  assert.doesNotMatch(source, /\{question\.prompt\}/)
  assert.doesNotMatch(source, /\{option\.text\}/)
  // La justificación interna nunca llega a la interfaz del alumno.
  assert.doesNotMatch(source, /explanation/)
})

test('la RPC del intento no entrega al navegador la justificación interna', async () => {
  const source = await readFile(
    new URL(
      '../supabase/migrations/202608040001_block_one_implementation.sql',
      import.meta.url,
    ),
    'utf8',
  )
  const start = source.indexOf('create or replace function public.start_quiz_attempt')
  const end = source.indexOf('create or replace function public.submit_quiz_attempt')
  const body = source.slice(start, end)
  assert.ok(start > -1 && end > start)
  assert.doesNotMatch(body, /'explanation'/)
  assert.match(body, /'prompt', q\.prompt/)
})
