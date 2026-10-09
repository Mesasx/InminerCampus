// Fuente única de los datos normativos que publican las guías de formación
// minera (`/formacion-minera`, `/itc-02-1-02`, `/itc-02-0-02`…).
//
// Regla de precisión legal: aquí sólo hay referencias identificadas en el BOE
// (norma, fecha e identificador) y cifras que la norma fija expresamente. Cada
// dato lleva su fuente para que cualquier cambio pueda revisarse contra el
// texto oficial. Ninguna página debe escribir a mano una referencia que no
// esté en este archivo.
//
// Fecha de la última revisión de estos datos frente a las fuentes oficiales.
// Se muestra en las páginas («Última revisión») y alimenta `dateModified`: si
// se cambia un dato, se actualiza la fecha.
export const REGULATION_REVIEWED_AT = '2026-10-08'

export function boeUrl(id: string): string {
  return `https://www.boe.es/buscar/doc.php?id=${id}`
}

export type Norm = {
  /** Denominación corta (p. ej. «ITC 02.1.02»). */
  code: string
  /** Título oficial de la instrucción o especificación. */
  title: string
  /** Disposición que la aprueba o modifica. */
  instrument: string
  /** Identificador BOE, cuando existe. */
  boeId?: string
  url: string
}

export const RGNBSM: Norm = {
  code: 'RGNBSM',
  title: 'Reglamento General de Normas Básicas de Seguridad Minera',
  instrument: 'Real Decreto 863/1985, de 2 de abril',
  url: 'https://www.boe.es/eli/es/rd/1985/04/02/863/con',
}

export const ITC_02_1_02: Norm = {
  code: 'ITC 02.1.02',
  title: 'Formación preventiva para el desempeño del puesto de trabajo',
  instrument: 'Orden ITC/1316/2008, de 7 de mayo',
  boeId: 'BOE-A-2008-8415',
  url: boeUrl('BOE-A-2008-8415'),
}

/**
 * Modificación de 2011: añade el carácter únicamente presencial y el mínimo de
 * cinco horas lectivas de los cursos de reciclaje. Las citas son literales.
 */
export const ITC_02_1_02_AMENDMENT = {
  code: 'Orden ITC/2699/2011',
  title: 'Modificación de la ITC 02.1.02',
  instrument: 'Orden ITC/2699/2011, de 4 de octubre',
  boeId: 'BOE-A-2011-15940',
  url: 'https://www.boe.es/diario_boe/txt.php?id=BOE-A-2011-15940',
  presencialQuote:
    'La formación regulada en la presente instrucción técnica complementaria tendrá únicamente carácter presencial.',
  refresherQuote:
    'Los cursos de formación con carácter de reciclaje o actualización de conocimientos, se adecuarán a un mínimo de cinco horas lectivas.',
} as const

export const ITC_02_0_02: Norm = {
  code: 'ITC 02.0.02',
  title:
    'Protección de los trabajadores contra el riesgo por inhalación de polvo y sílice cristalina respirables',
  instrument: 'Orden TED/723/2021, de 1 de julio',
  boeId: 'BOE-A-2021-11458',
  url: boeUrl('BOE-A-2021-11458'),
}

/** Recopilación oficial de las especificaciones técnicas del RGNBSM. */
export const MITECO_SPECIFICATIONS_INDEX = {
  title: 'Especificaciones técnicas del RGNBSM (Ministerio para la Transición Ecológica)',
  url: 'https://www.miteco.gob.es/content/dam/miteco/es/energia/files-1/mineria/Seguridad/Documents/Especificaciones_tecnicas_del_RGNBSM_abril_2020.pdf',
}

export type TechnicalSpecification = Norm & {
  /** Puestos o grupos que cubre, en la denominación de la propia ET. */
  scope: string
  /** Ámbito, sólo cuando la propia denominación de la ET lo indica. */
  setting?: string
}

/**
 * Especificaciones técnicas que desarrollan la ITC 02.1.02. El orden es el de
 * su numeración. `scope` resume los puestos sin ampliarlos.
 */
export const TECHNICAL_SPECIFICATIONS: Array<TechnicalSpecification> = [
  {
    code: 'ET 2000-1-08',
    title:
      'Operador de maquinaria de transporte, camión y volquete, en actividades extractivas de exterior',
    instrument: 'Resolución de 9 de junio de 2008',
    boeId: 'BOE-A-2008-10482',
    url: boeUrl('BOE-A-2008-10482'),
    scope: 'Operador de maquinaria de transporte: camión y volquete.',
    setting: 'Exterior',
  },
  {
    code: 'ET 2001-1-08',
    title:
      'Operador de maquinaria de arranque/carga/viales, pala cargadora y excavadora hidráulica de cadenas, en actividades extractivas de exterior',
    instrument:
      'Resolución de 9 de junio de 2008 (modificada por Resolución de 16 de octubre de 2014, que incorpora el tractor de cadenas)',
    boeId: 'BOE-A-2008-11500',
    url: boeUrl('BOE-A-2008-11500'),
    scope:
      'Operador de maquinaria de arranque, carga y viales: pala cargadora, excavadora hidráulica de cadenas y tractor de cadenas.',
    setting: 'Exterior',
  },
  {
    code: 'ET 2002-1-08',
    title:
      'Operador de arranque/carga y operador de perforación/voladura; picador, barrenista y ayudante minero, en actividades extractivas de interior',
    instrument: 'Resolución de 7 de octubre de 2008',
    boeId: 'BOE-A-2008-17191',
    url: boeUrl('BOE-A-2008-17191'),
    scope:
      'Arranque y carga, perforación y voladura; picador, barrenista y ayudante minero.',
    setting: 'Interior',
  },
  {
    code: 'ET 2003-1-10',
    title:
      'Puestos de los grupos 5.1 a), b) y c) y 5.2 a), b), d), f) y h) del apartado 5 de la ITC 02.1.02',
    instrument: 'Resolución de la Dirección General de Política Energética y Minas (2010)',
    boeId: 'BOE-A-2010-18826',
    url: boeUrl('BOE-A-2010-18826'),
    scope:
      'Grupos 5.1 a), b) y c) y 5.2 a), b), d), f) y h), entre ellos el operador de perforadora.',
  },
  {
    code: 'ET 2004-1-10',
    title:
      'Puestos de los grupos 5.4 y 5.5 del apartado 5 de la ITC 02.1.02',
    instrument: 'Resolución de la Dirección General de Política Energética y Minas (2010)',
    boeId: 'BOE-A-2010-18827',
    url: boeUrl('BOE-A-2010-18827'),
    scope:
      'Grupos 5.4 y 5.5: establecimientos de beneficio y puestos comunes, como administración y personal de servicios distintos a los de mantenimiento (5.5.d).',
    setting: 'Establecimientos de beneficio y puestos comunes',
  },
  {
    code: 'ET 2005-1-11',
    title:
      'Cartilla de formación personal del trabajador y Libro de registro de cursos recibidos',
    instrument: 'Resolución de 16 de octubre de 2014',
    boeId: 'BOE-A-2014-11208',
    url: boeUrl('BOE-A-2014-11208'),
    scope:
      'No es un itinerario formativo: regula cómo se documenta la formación recibida.',
    setting: 'Documentación',
  },
]

/** Busca las especificaciones citadas en un texto («ITC 02.1.02 · ET 2001-1-08»). */
export function specificationsIn(text: string | null | undefined) {
  if (!text) return []
  return TECHNICAL_SPECIFICATIONS.filter((spec) =>
    text.replace(/\s+/g, ' ').includes(spec.code),
  )
}

/**
 * Plazos de reciclaje que la norma fija expresamente. La ITC 02.1.02 establece
 * un máximo general; algunas especificaciones técnicas lo acortan para su
 * puesto. Sólo se recogen las que se han comprobado.
 */
export const REFRESHER_RULES = {
  generalMaxYears: 4,
  bySpecification: {
    'ET 2000-1-08': 2,
    'ET 2001-1-08': 2,
  } as Record<string, number>,
  minimumHours: 5,
} as const
