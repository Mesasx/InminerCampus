// Texto común de las evaluaciones.
//
// La mecánica es la misma en todos los cursos: responder correctamente todas
// las preguntas de una ronda y repetirlo tantas rondas perfectas como exija el
// bloque. Lo único que cambia entre un test y otro son las cifras, así que se
// escriben una sola vez aquí y cada evaluación aporta las suyas.
//
// Nada de este módulo modifica preguntas, respuestas ni bancos: sólo redacta.

export type QuizRules = {
  questionCount: number
  requiredPerfectRounds: number
  completionMode: 'consecutive_perfect' | 'cumulative_perfect'
}

export const QUIZ_INTRO_TITLE = 'Evaluación del bloque'

function rounds(count: number) {
  return count === 1 ? 'una ronda perfecta' : `${count} rondas perfectas`
}

function questions(count: number) {
  return count === 1 ? 'una pregunta' : `${count} preguntas`
}

/**
 * Explicación general de la mecánica, idéntica para todos los tests.
 */
export function quizMechanicsCopy(rules: QuizRules) {
  const consecutive = rules.completionMode === 'consecutive_perfect'
  return `Responde todas las preguntas del test. Para completar esta evaluación deberás realizar ${rounds(
    rules.requiredPerfectRounds,
  )}, contestando correctamente todas las preguntas de cada ronda${
    consecutive
      ? ' y de forma consecutiva'
      : '; no es necesario que sean consecutivas'
  }. Si cometes algún error, sigue practicando y vuelve a intentarlo: el objetivo es reforzar los conceptos esenciales antes de continuar.`
}

/**
 * Una línea con las cifras reales del test, para cuando conviene anunciarlas.
 */
export function quizFactsCopy(rules: QuizRules) {
  return `Este test contiene ${questions(rules.questionCount)}.`
}

export function quizIntroCopy(rules: QuizRules) {
  return `${quizFactsCopy(rules)} ${quizMechanicsCopy(rules)}`
}

/**
 * Estado de las rondas conseguidas frente a las exigidas.
 */
export function quizRoundsLabel(
  completionMode: QuizRules['completionMode'],
) {
  return completionMode === 'consecutive_perfect'
    ? 'Rondas perfectas consecutivas'
    : 'Rondas perfectas'
}
