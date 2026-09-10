# Extrae las cincuenta unidades del manual maestro de establecimientos de
# beneficio: locución de 20 h, locución de 5 h, criterio esencial y el
# desarrollo escrito, separado en la parte base y la parte de aplicación.
import json
import re
import subprocess
import sys
from os import makedirs

PDF = r'Contenido Cursos/Diapositivas y documentos/Manual_Establecimientos_Beneficio_Inminer_Campus (2).pdf'

text = subprocess.run(
    ['pdftotext', '-enc', 'UTF-8', PDF, '-'],
    capture_output=True, text=True, encoding='utf-8',
).stdout

# El pie de página se repite en cada hoja y estorba al partir por secciones.
noise = [
    'INMÍNER CAMPUS · FORMACIÓN PREVENTIVA ITC 02.1.02',
    'MANUAL MAESTRO · ESTABLECIMIENTOS DE BENEFICIO',
]
lines = []
for raw in text.split('\n'):
    # El salto de página pega la cabecera corrida al primer rótulo de la hoja,
    # así que el pie se retira como prefijo y no como línea completa.
    line = raw.replace('\x0c', '').strip()
    for header in noise:
        if line.startswith(header):
            line = line[len(header):].strip()
    if not line:
        continue
    if line in noise or re.fullmatch(r'PÁGINA \d+', line):
        continue
    # Los rótulos de cierre de unidad no siempre abren línea propia: en unas
    # unidades van solos y en otras continúan el párrafo anterior. Se separan
    # aquí para que el troceado posterior no dependa de esa irregularidad.
    for marker in (
        'LOCUCIÓN ALTERNATIVA · RECICLAJE 5 H',
        'CRITERIO PREVENTIVO ESENCIAL',
        'FUENTES ESPECÍFICAS DEL CAPÍTULO',
    ):
        line = line.replace(marker, '\n' + marker + '\n')
    for piece in line.split('\n'):
        piece = piece.strip()
        if piece:
            lines.append(piece)

starts = [i for i, line in enumerate(lines) if re.fullmatch(r'BLOQUE \d · UNIDAD \d\.\d{1,2}', line)]
if len(starts) != 50:
    sys.exit(f'Se esperaban 50 unidades y se encontraron {len(starts)}')

units = []
for index, start in enumerate(starts):
    end = starts[index + 1] if index + 1 < len(starts) else len(lines)
    body = lines[start:end]
    code = re.fullmatch(r'BLOQUE \d · UNIDAD (\d\.\d{1,2})', body[0]).group(1)
    title = re.sub(r'^\d\.\d{1,2}\s+', '', body[1]).strip()

    def find(prefix):
        for position, line in enumerate(body):
            if line.startswith(prefix):
                return position
        return None

    principal = find('LOCUCIÓN PRINCIPAL')
    desarrollo = find(f'UNIDAD {code} · DESARROLLO Y APLICACIÓN')
    alternativa = find('LOCUCIÓN ALTERNATIVA')
    criterio = find('CRITERIO PREVENTIVO ESENCIAL')
    fuentes = find('FUENTES ESPECÍFICAS DEL CAPÍTULO')
    if None in (principal, desarrollo, alternativa, criterio):
        sys.exit(f'Unidad {code}: falta alguna sección obligatoria')

    # La locución de 20 h comparte línea con su rótulo.
    narration20 = body[principal].split('FORMACIÓN INICIAL 20 H', 1)[1].strip()
    narration5 = ' '.join(body[alternativa + 1:criterio]).strip()
    key_end = fuentes if fuentes is not None else len(body)
    key = ' '.join(body[criterio + 1:key_end]).strip()

    base = body[principal + 1:desarrollo]
    applied = body[desarrollo + 1:alternativa]

    units.append({
        'code': code,
        'block': int(code.split('.')[0]),
        'position': int(code.split('.')[1]),
        'title': title,
        'narration20': narration20,
        'narration5': narration5.strip(),
        'key': key,
        'base': base,
        'applied': applied,
        'sources': ' '.join(body[fuentes + 1:]).strip() if fuentes is not None else '',
    })

# Un párrafo del manual es una línea larga; un subtítulo es una línea corta sin
# punto final. Se usa esa distinción para reconstruir las secciones.
def split_sections(block):
    sections = []
    current = {'heading': None, 'paragraphs': []}
    for line in block:
        is_heading = len(line) < 95 and not line.endswith('.') and not line.endswith(':')
        if is_heading:
            if current['heading'] or current['paragraphs']:
                sections.append(current)
            current = {'heading': line, 'paragraphs': []}
        else:
            current['paragraphs'].append(line)
    if current['heading'] or current['paragraphs']:
        sections.append(current)
    return [s for s in sections if s['paragraphs']]

for unit in units:
    unit['base'] = split_sections(unit['base'])
    unit['applied'] = split_sections(unit['applied'])

# El JSON intermedio es material de trabajo, no contenido publicable: vive en
# tmp/, que está ignorado por git.
out = 'tmp/beneficio-units.json'
makedirs('tmp', exist_ok=True)
with open(out, 'w', encoding='utf-8') as handle:
    json.dump(units, handle, ensure_ascii=False, indent=1)

print('unidades', len(units))
print('sin locucion 20h', sum(1 for u in units if len(u['narration20']) < 200))
print('sin locucion 5h', sum(1 for u in units if len(u['narration5']) < 80))
print('sin criterio', sum(1 for u in units if len(u['key']) < 40))
print('base media', sum(len(u['base']) for u in units) / 50)
print('aplicada media', sum(len(u['applied']) for u in units) / 50)
