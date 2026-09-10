# Extrae las cuarenta explicaciones de los bloques 2 a 5 del curso de arranque
# de 20 horas. El documento dedica una página a cada parte y ya usa los
# encabezados que reconoce el reproductor, así que aquí sólo hay que separar las
# secciones, rehacer las listas y descartar el texto de la barra lateral del
# bloque, que el extractor de PDF deja caer dentro de la primera sección.
import json
import re
import subprocess
import sys
from os import makedirs

PDF = (
    'Contenido Cursos/Diapositivas y documentos/'
    'Curso_4_Bloques_2_3_4_5_Explicaciones_Muy_Detalladas_INMINER.pdf'
)

text = subprocess.run(
    ['pdftotext', '-enc', 'UTF-8', PDF, '-'],
    capture_output=True, encoding='utf-8', errors='replace',
).stdout

# Los rótulos en versales del documento se corresponden con estos encabezados.
CAPS = {
    'OBJETIVO': 'Objetivo',
    'IDEA CLAVE': 'Idea clave',
}
PLAIN = [
    'Explicación de base',
    'Profundización técnica y criterio preventivo',
    'Secuencia operativa recomendada',
    'Caso práctico razonado',
    'Errores críticos que deben evitarse',
    'Comprobación antes de continuar',
]
LIST_SECTIONS = {
    'Secuencia operativa recomendada',
    'Errores críticos que deben evitarse',
    'Comprobación antes de continuar',
}
ORDER = [
    'Objetivo',
    'Explicación de base',
    'Profundización técnica y criterio preventivo',
    'Secuencia operativa recomendada',
    'Caso práctico razonado',
    'Errores críticos que deben evitarse',
    'Comprobación antes de continuar',
    'Idea clave',
]

NOISE = (
    'INMÍNERCAMPUS · CURSO 4 · BLOQUES 2-5',
    'EXPLICACIONES MUY DETALLADAS',
    'Operador de maquinaria de arranque, carga y viales · 20 h',
)

# Cada bloque abre con un «ENFOQUE DEL BLOQUE» que el PDF vuelve a insertar
# dentro de la primera sección larga de cada parte. Se recogen para poder
# retirarlos después sin borrar texto propio de la unidad.
enfoques = set()
for page in text.split('\x0c'):
    if 'ENFOQUE DEL BLOQUE' not in page:
        continue
    tail = page.split('ENFOQUE DEL BLOQUE', 1)[1]
    for line in tail.split('\n'):
        line = line.strip()
        if len(line) > 120 and line not in NOISE:
            enfoques.add(line)

units = []
for page in text.split('\x0c'):
    match = re.search(r'^PARTE ([2-5])\.(10|[1-9])$', page, re.M)
    if not match:
        continue
    # La página de síntesis de cada bloque abre con el rótulo de su primera
    # parte, pero no desarrolla ninguna: sólo cuentan las que traen las
    # secciones completas.
    if 'OBJETIVO' not in page or 'IDEA CLAVE' not in page:
        continue
    block, position = int(match.group(1)), int(match.group(2))

    lines = []
    for raw in page.split('\n'):
        line = raw.strip()
        if not line or line in NOISE or re.fullmatch(r'\d{2}', line):
            continue
        lines.append(line)

    start = lines.index(f'PARTE {block}.{position}')
    title = lines[start + 1]
    body = lines[start + 2:]

    sections = {}
    current = None
    for line in body:
        heading = CAPS.get(line) or (line if line in PLAIN else None)
        if heading:
            current = heading
            sections.setdefault(current, [])
            continue
        if current is None:
            continue
        if line in enfoques:
            continue
        sections[current].append(line)

    missing = [heading for heading in ORDER if not sections.get(heading)]
    if missing:
        sys.exit(f'Parte {block}.{position}: faltan las secciones {missing}')

    rendered = []
    for heading in ORDER:
        paragraphs = sections[heading]
        if heading in LIST_SECTIONS:
            items = []
            for line in paragraphs:
                # Las viñetas del documento llegan encadenadas en una sola línea.
                for piece in re.split(r'[●✓]', line):
                    piece = piece.strip()
                    if piece:
                        items.append('• ' + piece)
            rendered.append({'heading': heading, 'paragraphs': items})
        else:
            rendered.append({'heading': heading, 'paragraphs': paragraphs})

    units.append({
        'code': f'{block}.{position}',
        'block': block,
        'position': position,
        'title': title,
        'sections': rendered,
    })

expected = [f'{block}.{unit}' for block in range(2, 6) for unit in range(1, 11)]
found = [unit['code'] for unit in units]
if sorted(found, key=lambda code: (int(code.split('.')[0]), int(code.split('.')[1]))) != expected:
    sys.exit(f'Se esperaban 40 partes de 2.1 a 5.10 y se encontraron {len(found)}')

makedirs('tmp', exist_ok=True)
with open('tmp/arranque-20h-units.json', 'w', encoding='utf-8') as handle:
    json.dump(units, handle, ensure_ascii=False, indent=1)

print('partes', len(units))
print('enfoques de bloque retirados', len(enfoques))
lengths = [
    sum(len(' '.join(section['paragraphs'])) for section in unit['sections'])
    for unit in units
]
print('cuerpo min/max', min(lengths), max(lengths))
