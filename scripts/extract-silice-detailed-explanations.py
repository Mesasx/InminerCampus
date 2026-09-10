# Extrae las cincuenta explicaciones detalladas del curso de polvo y sílice.
# El documento dedica una página a cada parte, con ocho secciones fijas, y
# conserva los títulos acentuados que la base de datos perdió al importarse.
import json
import re
import subprocess
import sys
from os import makedirs

PDF = (
    'Contenido Cursos/Diapositivas y documentos/Explicaciones detalladas/'
    'Curso_6_Polvo_Silice_20h_Explicaciones_Detalladas_INMINER.pdf'
)

text = subprocess.run(
    ['pdftotext', '-enc', 'UTF-8', PDF, '-'],
    capture_output=True, encoding='utf-8', errors='replace',
).stdout

CAPS = {'OBJETIVO': 'Objetivo', 'IDEA CLAVE': 'Idea clave'}
PLAIN = [
    'Explicación vinculada al audio',
    'Profundización técnica',
    'Secuencia de aplicación',
    'Caso práctico razonado',
    'Errores críticos',
    'Comprobación antes de continuar',
]
LIST_SECTIONS = {
    'Secuencia de aplicación',
    'Errores críticos',
    'Comprobación antes de continuar',
}
ORDER = [
    'Objetivo',
    'Explicación vinculada al audio',
    'Profundización técnica',
    'Secuencia de aplicación',
    'Caso práctico razonado',
    'Errores críticos',
    'Comprobación antes de continuar',
    'Idea clave',
]

NOISE = (
    'INMÍNERCAMPUS · CURSO 6 · POLVO Y SÍLICE · 20 H',
    'EXPLICACIONES DETALLADAS',
)

units = []
for page in text.split('\x0c'):
    match = re.search(r'^PARTE ([1-5])\.(10|[1-9])$', page, re.M)
    if not match:
        continue
    # La página de síntesis de cada bloque repite el rótulo de su primera parte
    # sin desarrollarla; sólo cuentan las páginas con las ocho secciones.
    if 'OBJETIVO' not in page or 'IDEA CLAVE' not in page:
        continue
    block, position = int(match.group(1)), int(match.group(2))

    lines = []
    for raw in page.split('\n'):
        line = raw.strip()
        if not line or line in NOISE or re.fullmatch(r'\d{2}', line):
            continue
        if line.startswith('Formación preventiva frente a polvo y sílice'):
            continue
        lines.append(line)

    start = lines.index(f'PARTE {block}.{position}')
    title = lines[start + 1]

    sections = {}
    current = None
    for line in lines[start + 2:]:
        heading = CAPS.get(line) or (line if line in PLAIN else None)
        if heading:
            current = heading
            sections.setdefault(current, [])
            continue
        if current is not None:
            sections[current].append(line)

    missing = [heading for heading in ORDER if not sections.get(heading)]
    if missing:
        sys.exit(f'Parte {block}.{position}: faltan las secciones {missing}')

    # La secuencia llega encadenada en una línea con viñetas y la comprobación
    # en líneas sueltas con marca de verificación; ambas se normalizan antes de
    # compararlas.
    def bullets(paragraphs):
        items = []
        for line in paragraphs:
            for piece in re.split(r'[●✓•]', line):
                piece = piece.strip()
                if piece:
                    items.append('• ' + piece)
        return items

    rendered = []
    for heading in ORDER:
        paragraphs = sections[heading]
        if heading in LIST_SECTIONS:
            paragraphs = bullets(paragraphs)
        # El documento repite la secuencia de aplicación como lista de
        # verificación en las cincuenta partes. Mostrar dos veces la misma lista
        # en la misma diapositiva no aporta nada, así que se deja una sola vez.
        if (
            heading == 'Comprobación antes de continuar'
            and paragraphs == bullets(sections['Secuencia de aplicación'])
        ):
            continue
        rendered.append({'heading': heading, 'paragraphs': paragraphs})

    units.append({
        'code': f'{block}.{position}',
        'block': block,
        'position': position,
        'title': title,
        'sections': rendered,
    })

expected = [f'{block}.{unit}' for block in range(1, 6) for unit in range(1, 11)]
if sorted(
    (unit['code'] for unit in units),
    key=lambda code: (int(code.split('.')[0]), int(code.split('.')[1])),
) != expected:
    sys.exit(f'Se esperaban 50 partes de 1.1 a 5.10 y se encontraron {len(units)}')

makedirs('tmp', exist_ok=True)
with open('tmp/silice-units.json', 'w', encoding='utf-8') as handle:
    json.dump(units, handle, ensure_ascii=False, indent=1)

print('partes', len(units))
lengths = [
    sum(len(' '.join(section['paragraphs'])) for section in unit['sections'])
    for unit in units
]
print('cuerpo min/max', min(lengths), max(lengths))
print('titulos acentuados', sum(1 for unit in units if re.search(r'[áéíóúÁÉÍÓÚñÑ]', unit['title'])))
