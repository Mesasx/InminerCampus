# Estrategia de crecimiento — InmínerCampus

Objetivo: que InmínerCampus sea una referencia nacional en formación preventiva
minera (ITC 02.1.02 e ITC 02.0.02) y que eso se traduzca en matrículas, sobre
todo de empresas.

Este documento recoge lo que **no** depende del código. Lo implementado en la
web está en [`SEO_CHANGELOG.md`](./SEO_CHANGELOG.md).

## Por qué el foco es la empresa

Quien compra la formación minera suele ser la empresa (explotación, cantera,
planta o contrata), no el trabajador. Además la obligación es recurrente: el
reciclaje se repite cada 2 o 4 años según el puesto y la formación de sílice
cada año. Un cliente empresa bien atendido vuelve solo.

La web ya da soporte a esto: `/empresas` (landing B2B con precios por plaza y
descuento por volumen), la calculadora de reciclaje y la compra para empresa
con licencias por trabajador.

## Acciones priorizadas

| # | Acción | Por qué | Esfuerzo |
|---|---|---|---|
| 1 | **Recordatorios de reciclaje por correo** (función nueva) | La plataforma ya sabe qué curso completó cada alumno y cuándo. Un aviso a los 60–90 días del vencimiento —al alumno y, si lo compró una empresa, a su responsable— convierte la obligación periódica en recompra. Requiere consentimiento en el registro, una tarea programada (ya existe `vercel.json` con crons) y Resend. | Medio |
| 2 | **Campaña directa a empresas del sector** | Explotaciones y canteras son pocas miles en España y están identificadas. Un envío a responsables de prevención con el enlace a `/empresas` y a la calculadora tiene más retorno que cualquier anuncio. | Bajo |
| 3 | **Asociaciones y federaciones** | ANEFA, federaciones autonómicas de áridos, colegios de ingenieros de minas y cámaras mineras publican formación y noticias: un artículo técnico (p. ej. sobre la presencialidad de la ITC 02.1.02) o un acuerdo de descuento para asociados da enlaces de autoridad y clientes. | Medio |
| 4 | **Enlace desde inminer.es** | La web corporativa debe enlazar a InmínerCampus desde el menú y desde sus páginas de minería y seguridad. Refuerza la entidad (frente a otros «Inminer») y transmite autoridad. | Bajo |
| 5 | **Servicios de prevención ajenos y mutuas** | Gestionan la formación de muchas empresas pequeñas. Un acuerdo de derivación (con la compra para empresa y sus descuentos) multiplica el alcance. | Medio |
| 6 | **Google Business Profile** | Sólo si hay atención real en Calle La Solana 60, Ciudad Real. Ayuda a las búsquedas de marca y a la desambiguación. | Bajo |
| 7 | **Reseñas reales** | Pedir a empresas clientes una valoración en Google Business Profile. **No** se marcan en los datos estructurados de la web: Google no admite reseñas propias en `Course`, y no deben inventarse. | Bajo |
| 8 | **Revisión técnica firmada** | Que una persona con titulación (p. ej. el director de Ingeniería) asuma la revisión de las guías normativas y aparezca como revisor con fecha. Refuerza E-E-A-T. Requiere su consentimiento. | Bajo |
| 9 | **Nuevos itinerarios** | ET 2002-1-08 (interior) o puestos de la ET 2004-1-10 aún sin curso. Cada curso nuevo entra solo en catálogo, sitemap, guías y calculadora. | Alto |
| 10 | **Medición** | Search Console (consultas por país España) y Vercel Analytics: visitas orgánicas a ficha → clic en comprar → compra. Revisar mensualmente qué consultas crecen y qué páginas no convierten. | Bajo |

## Lo que no conviene hacer

- Prometer formación ITC 02.1.02 «100 % online»: contradice la Orden
  ITC/2699/2011 y expone a reclamaciones.
- Páginas por ciudad o provincia sin sede ni convocatoria real (*doorway pages*).
- Comprar enlaces o publicar artículos genéricos escritos sólo para buscadores.
- Usar «homologado», «oficial» o «habilitante» sin respaldo jurídico.
