# Empareja, unidad a unidad, la diapositiva, la pista de audio y el apartado del
# manual del curso «Administración y personal de servicios distintos a los de
# mantenimiento» (ITC 02.1.02 · ET 2004-1-10 · Grupo 5.5.d).
#
# La correspondencia no se supone: el título de cada diapositiva se reconstruye
# uniendo las líneas de su cabecera hasta que coincide con el nombre del fichero
# de audio, y el apartado del manual debe abrir con el mismo ordinal. Si alguna
# de las tres piezas no encaja, el script falla en vez de publicar una unidad
# descolocada.
#
# Salida: JSON con las cincuenta unidades, su explicación detallada ya compuesta
# con los rótulos que sabe pintar `AudioLessonPlayer`, y la ruta de las dos
# locuciones (5 h y 20 h) que le corresponden.
import json
import re
import sys
import unicodedata
from pathlib import Path

import pymupdf

BASE = Path('Contenido Cursos/Diapositivas y documentos/Curso Administracion')
SLIDES_PDF = BASE / 'Presntacion' / '1-Introduccion-a-la-formacion-preventiva-minera.pdf'
MANUAL_PDF = BASE / 'Manual y explicaciones detalladas' / 'test_new_manual.pdf'
AUDIO_ROOT = Path('Contenido Cursos/Pistas de Audio/Administracion')
OUT = Path(sys.argv[1] if len(sys.argv) > 1 else 'content/administracion-units.json')

# Los seis bloques de la ET 2004-1-10 y el número de unidades de cada uno. La
# suma es de cincuenta, que es también el número de diapositivas y de pistas.
BLOCKS = [
    (1, 'Definición de los trabajos', 9),
    (2, 'Técnicas preventivas y de protección', 10),
    (3, 'Equipos de trabajo, EPI y medios auxiliares', 9),
    (4, 'Control y vigilancia sobre el lugar de trabajo y su entorno', 6),
    (5, 'Interferencias con otras actividades', 9),
    (6, 'Normativa y legislación', 7),
]


def slugify(value):
    value = unicodedata.normalize('NFD', value.lower())
    value = ''.join(c for c in value if unicodedata.category(c) != 'Mn')
    return re.sub(r'-+', '-', re.sub(r'[^a-z0-9]+', '-', value)).strip('-')


# --------------------------------------------------------------------- audio
def audio_index():
    """Las cien locuciones indexadas por modalidad y código de unidad."""
    tracks = {}
    for folder, hours in (('Curso de 5 horas', 5), ('Curso de 20 horas', 20)):
        for block_dir in sorted((AUDIO_ROOT / folder).iterdir()):
            if not block_dir.is_dir():
                continue
            block = int(re.search(r'bloque-(\d+)', block_dir.name).group(1))
            for track in sorted(block_dir.glob('*.mp3')):
                match = re.match(r'parte-(\d+)\.(\d+)-(.+)\.mp3$', track.name)
                if not match or int(match.group(1)) != block:
                    raise AssertionError(f'pista no interpretable: {track}')
                code = f'{block}.{int(match.group(2))}'
                tracks[(hours, code)] = {'slug': match.group(3), 'path': str(track)}
    return tracks


# ------------------------------------------------------------------- slides
def read_pages(pdf, sort=False):
    # El manual se lee en orden geométrico: sin `sort` las flechas «→» de los
    # procedimientos salen agrupadas al final del párrafo y los pasos quedan
    # pegados unos a otros.
    document = pymupdf.open(pdf)
    pages = [page.get_text(sort=sort) for page in document]
    document.close()
    return pages


def slide_title(text, ordinal, want_slug):
    """Reconstruye el título uniendo las líneas de cabecera hasta casar con el
    nombre del audio. La plantilla parte los títulos largos en dos o tres
    líneas, así que la unión es la única forma de recuperarlos completos."""
    lines = [line.strip() for line in text.split('\n') if line.strip()]
    head = lines[0]
    match = re.match(rf'{ordinal}\.\s*(.*)$', head)
    if not match:
        raise AssertionError(f'la diapositiva {ordinal} abre con «{head}»')
    title = match.group(1).strip()
    for extra in [''] + lines[1:4]:
        candidate = f'{title} {extra}'.strip() if extra else title
        if slugify(candidate) == want_slug:
            return re.sub(r'\s+', ' ', candidate)
    raise AssertionError(
        f'unidad {ordinal}: «{title}» no casa con la locución «{want_slug}»'
    )


# ------------------------------------------------------------------- manual
# Cabecera y pie se repiten en cada hoja; el orden geométrico los coloca en
# posiciones distintas según la página, así que se retiran por contenido.
CHROME = (
    'INMÍNER CAMPUS',
    'Manual formativo · ET 2004-1-10',
)


def manual_lines(text):
    return [
        line.strip()
        for line in text.split('\n')
        if line.strip() and not line.strip().startswith(CHROME)
    ]


def manual_heading(lines):
    """Índice de la línea que abre el apartado («24. Resguardos y»)."""
    for index, line in enumerate(lines[:4]):
        match = re.match(r'(\d{1,2})\.\s', line)
        if match:
            return index, int(match.group(1))
    return None, None


def manual_unit_pages(pages):
    """Página de cada apartado, saltando portada, índice y divisorias."""
    found = {}
    for index, text in enumerate(pages):
        if index <= 3 or 'Objetivo formativo' not in text:
            continue
        _, ordinal = manual_heading(manual_lines(text))
        if ordinal:
            found.setdefault(ordinal, index)
    missing = [number for number in range(1, 51) if number not in found]
    if missing:
        raise AssertionError(f'faltan apartados del manual: {missing}')
    return found


def clean(block):
    # El extractor rompe las flechas «→» a su propia línea y parte los párrafos
    # por el ancho de la caja de texto; se rehacen como texto corrido.
    text = block.replace('→', ' → ')
    text = re.sub(r'[ \t]*\n[ \t]*', ' ', text)
    return re.sub(r'\s+', ' ', text).strip()


# Los tres cierres que el manual añade dentro del desarrollo de cada unidad.
# El apartado 44 fusiona dos temas en una página y repite la terna, así que los
# rótulos se localizan todos y se recorren en orden de lectura.
MARKERS = (
    ('mensaje', r'Mensaje (?:clave|final)'),
    ('ejemplo', r'Ejemplo(?:\s+pr[áa]ctico)?'),
    ('procedimiento', r'Procedimiento(?:\s+\w+){0,2}'),
    # El segundo tema del apartado 44 reabre con su propio «Objetivo.»; vuelve
    # al cuerpo de la explicación, no a ninguno de los cierres.
    ('cuerpo', r'Objetivo'),
)
MARKER_RE = re.compile(
    '|'.join(f'(?P<{key}>{pattern}\\s*[:.]\\s*)' for key, pattern in MARKERS)
)

# El apartado 19 arrastra el rótulo divisorio del bloque siguiente pegado al
# final del desarrollo. Es ruido de maquetación del PDF, no contenido de la
# unidad.
BLOCK_DIVIDER_RE = re.compile(r'\s*BLOQUE\s*:\s*[A-ZÁÉÍÓÚÑ,\s]+—.*$')


def split_markers(body):
    """Separa el desarrollo en texto corrido, mensaje clave, ejemplo y
    procedimiento, respetando el orden de lectura y las repeticiones."""
    parts = {key: [] for key, _ in MARKERS}
    matches = list(MARKER_RE.finditer(body))
    head = (body[: matches[0].start()] if matches else body).strip()
    if head:
        parts['cuerpo'].append(head)
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(body)
        chunk = body[match.end():end].strip()
        if chunk:
            parts[match.lastgroup].append(chunk)
    return parts


def manual_unit(pages, index, ordinal):
    lines = manual_lines(pages[index])
    position, found = manual_heading(lines)
    if found != ordinal:
        raise AssertionError(
            f'apartado {ordinal}: la página abre con «{lines[0]}»'
        )
    text = '\n'.join(lines[position + 1:])

    objetivo_raw, _, rest = text.partition('Desarrollo detallado')
    if not rest:
        raise AssertionError(f'apartado {ordinal} sin «Desarrollo detallado»')
    desarrollo_raw, _, profundizacion_raw = rest.partition(
        'Profundización y aplicación práctica'
    )
    if not profundizacion_raw:
        raise AssertionError(f'apartado {ordinal} sin profundización')

    objetivo = re.sub(
        r'^Objetivo formativo\s*[.:]\s*', '', clean(objetivo_raw)
    )
    parts = split_markers(BLOCK_DIVIDER_RE.sub('', clean(desarrollo_raw)))
    return {
        'objetivo': objetivo,
        'cuerpo': parts['cuerpo'],
        'mensaje': parts['mensaje'],
        'ejemplo': parts['ejemplo'],
        'procedimiento': parts['procedimiento'],
        'profundizacion': clean(profundizacion_raw),
        'page': index + 1,
    }


# ------------------------------------------------------- explicación detallada
def paragraphs(text, target=520):
    """Reparte un texto corrido en párrafos legibles cortando entre frases."""
    out = []
    current = ''
    for sentence in re.split(r'(?<=[.:;])\s+', text):
        if current and len(current) + len(sentence) + 1 > target:
            out.append(current.strip())
            current = sentence
        else:
            current = f'{current} {sentence}'.strip()
    if current.strip():
        out.append(current.strip())
    return [paragraph for paragraph in out if paragraph]


def wrap(chunks):
    """Cada fragmento del manual, en párrafos y con la frase bien abierta."""
    return [
        paragraph
        for chunk in chunks
        for paragraph in paragraphs(sentence_case(chunk))
    ]


def sentence_case(text):
    text = text.strip()
    return f'{text[0].upper()}{text[1:]}' if text else text


def steps(chunks):
    raw = [
        part.strip(' .;')
        for chunk in chunks
        for part in re.split(r'→|;', chunk)
    ]
    return [f'- {sentence_case(part)}' for part in raw if part]


def explanation(unit):
    """Compone la explicación detallada con los rótulos que ya sabe pintar el
    reproductor de lecciones (`detailedInformationHeadings`)."""
    sections = [
        ('Objetivo', [unit['objetivo']]),
        ('Explicación detallada', wrap(unit['cuerpo'])),
    ]
    if unit['ejemplo']:
        sections.append(('Aplicación práctica', wrap(unit['ejemplo'])))
    if unit['procedimiento']:
        sections.append(
            ('Secuencia operativa recomendada', steps(unit['procedimiento']))
        )
    sections.append(
        (
            'Profundización técnica y criterio preventivo',
            paragraphs(unit['profundizacion']),
        )
    )
    if unit['mensaje']:
        sections.append(
            ('Idea clave', [sentence_case(chunk) for chunk in unit['mensaje']])
        )

    chunks = [
        heading + '\n' + '\n'.join(body) for heading, body in sections if body
    ]
    return '\n' + '\n\n'.join(chunks) + '\n'


# --------------------------------------------------------------- ensamblado
def main():
    tracks = audio_index()
    slides = read_pages(SLIDES_PDF)
    if len(slides) != 50:
        raise AssertionError(f'la presentación tiene {len(slides)} páginas, no 50')
    manual = read_pages(MANUAL_PDF, sort=True)
    unit_pages = manual_unit_pages(manual)

    codes = []
    for block, _, count in BLOCKS:
        codes.extend(f'{block}.{unit}' for unit in range(1, count + 1))
    if len(codes) != 50:
        raise AssertionError(f'los bloques suman {len(codes)} unidades, no 50')

    units = []
    for ordinal, code in enumerate(codes, 1):
        five = tracks.get((5, code))
        twenty = tracks.get((20, code))
        if not five or not twenty:
            raise AssertionError(f'faltan locuciones de la unidad {code}')
        if five['slug'] != twenty['slug']:
            raise AssertionError(f'unidad {code}: las dos modalidades no coinciden')
        title = slide_title(slides[ordinal - 1], ordinal, five['slug'])
        entry = manual_unit(manual, unit_pages[ordinal], ordinal)
        units.append(
            {
                'ordinal': ordinal,
                'code': code,
                'block': int(code.split('.')[0]),
                'position': int(code.split('.')[1]),
                'title': title,
                'slidePage': ordinal,
                'manualPage': entry['page'],
                'explanation': explanation(entry),
                'audio': {'5': five['path'], '20': twenty['path']},
            }
        )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(
        json.dumps(
            {
                'blocks': [
                    {'position': position, 'title': title, 'units': count}
                    for position, title, count in BLOCKS
                ],
                'units': units,
            },
            ensure_ascii=False,
            indent=1,
        ),
        encoding='utf-8',
    )
    print(f'{len(units)} unidades verificadas -> {OUT}')


main()
