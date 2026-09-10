# Extrae las cincuenta unidades del manual maestro de operador de perforadora.
# El manual ya está escrito con los encabezados que reconoce el reproductor
# (Idea central, Definición y alcance, Riesgo que debe comprenderse, Criterio de
# actuación y Caso razonado), así que la extracción respeta su orden editorial.
import json
import re
import subprocess
import sys
from os import makedirs

PDF = r'Contenido Cursos/Diapositivas y documentos/Manual_Operador_Perforadora_Inminer_Campus.pdf'

text = subprocess.run(
    ['pdftotext', '-enc', 'UTF-8', PDF, '-'],
    capture_output=True, text=True, encoding='utf-8',
).stdout

noise_exact = ['MANUAL MAESTRO · OPERADOR DE PERFORADORA']
lines = []
for raw in text.split('\n'):
    line = raw.replace('\x0c', '').strip()
    for header in noise_exact:
        if line.startswith(header):
            line = line[len(header):].strip()
    # El pie lleva la paginación pegada al identificador de la especificación.
    line = re.sub(r'INMÍNER CAMPUS · ET 2003-1-10 PÁGINA \d+', '', line).strip()
    if not line:
        continue
    # Estos rótulos abren sección pero no siempre abren línea.
    for marker in (
        'IDEA CENTRAL',
        'Trazabilidad con las locuciones aportadas',
        'BASE DEL FUTURO GUION',
        'Fuentes específicas del capítulo',
    ):
        line = line.replace(marker, '\n' + marker + '\n')
    line = re.sub(r'(BLOQUE \d · CAPÍTULO \d\.\d{1,2})', r'\n\1\n', line)
    line = re.sub(r'(CAPÍTULO \d\.\d{1,2} · APLICACIÓN OPERATIVA)', r'\n\1\n', line)
    for piece in line.split('\n'):
        piece = piece.strip()
        if piece:
            lines.append(piece)

starts = [
    index for index, line in enumerate(lines)
    if re.fullmatch(r'BLOQUE \d · CAPÍTULO \d\.\d{1,2}', line)
]
if len(starts) != 50:
    sys.exit(f'Se esperaban 50 capítulos y se encontraron {len(starts)}')

# El salto de columna del PDF parte algunas frases por la mitad. Una línea que
# no cierra oración y continúa en minúscula pertenece al párrafo anterior.
def merge_wrapped(block):
    merged = []
    for line in block:
        if (
            merged
            and not re.search(r'[.:!?»)]$', merged[-1])
            and line[:1].islower()
        ):
            merged[-1] = merged[-1] + ' ' + line
        else:
            merged.append(line)
    return merged


SECTION_HEADINGS = [
    'Definición y alcance',
    'Riesgo que debe comprenderse',
    'Criterio de actuación',
    'Caso razonado',
    'Fundamento técnico ampliado',
]

units = []
for index, start in enumerate(starts):
    end = starts[index + 1] if index + 1 < len(starts) else len(lines)
    body = lines[start:end]
    code = re.fullmatch(r'BLOQUE \d · CAPÍTULO (\d\.\d{1,2})', body[0]).group(1)

    def find(value, exact=True):
        for position, line in enumerate(body):
            if line == value if exact else line.startswith(value):
                return position
        return None

    idea = find('IDEA CENTRAL')
    traza = find('Trazabilidad con las locuciones aportadas')
    if idea is None or traza is None:
        sys.exit(f'Capítulo {code}: falta IDEA CENTRAL o la trazabilidad')

    # En la primera unidad de cada bloque el índice del bloque se cuela entre el
    # rótulo y el título, así que el título fiable es la línea anterior al
    # resumen, no la que sigue al rótulo.
    title = body[idea - 1]

    # El cuerpo útil llega hasta la trazabilidad; lo posterior son notas de
    # producción y fuentes, que no forman parte de la explicación del alumno.
    useful = body[idea:traza]
    marks = [
        (position, line) for position, line in enumerate(useful)
        if line in SECTION_HEADINGS or line == 'IDEA CENTRAL'
        or re.fullmatch(r'CAPÍTULO \d\.\d{1,2} · APLICACIÓN OPERATIVA', line)
    ]

    sections = []
    for order, (position, heading) in enumerate(marks):
        stop = marks[order + 1][0] if order + 1 < len(marks) else len(useful)
        paragraphs = merge_wrapped([line for line in useful[position + 1:stop] if line])
        if re.fullmatch(r'CAPÍTULO \d\.\d{1,2} · APLICACIÓN OPERATIVA', heading):
            continue
        label = 'Idea central' if heading == 'IDEA CENTRAL' else heading
        if paragraphs:
            sections.append({'heading': label, 'paragraphs': paragraphs})

    original = ''
    for line in body[traza:]:
        if line.startswith('Locución breve original:'):
            original = line.split(':', 1)[1].strip()
            break

    units.append({
        'code': code,
        'block': int(code.split('.')[0]),
        'position': int(code.split('.')[1]),
        'title': title,
        'sections': sections,
        'originalLocution': original,
    })

# El JSON intermedio es material de trabajo, no contenido publicable: vive en
# tmp/, que está ignorado por git.
out = 'tmp/perforadora-units.json'
makedirs('tmp', exist_ok=True)
with open(out, 'w', encoding='utf-8') as handle:
    json.dump(units, handle, ensure_ascii=False, indent=1)

print('unidades', len(units))
print('secciones por unidad', sorted({len(u['sections']) for u in units}))
short = [u['code'] for u in units if sum(len(' '.join(s['paragraphs'])) for s in u['sections']) < 1200]
print('cuerpos cortos', short)
print('sin locucion original', [u['code'] for u in units if not u['originalLocution']])
