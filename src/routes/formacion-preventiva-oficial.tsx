import { createFileRoute, Link } from '@tanstack/react-router'
import { AlertCircle, BookOpenCheck, CheckCircle2, Scale } from 'lucide-react'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/formacion-preventiva-oficial')({
  component: OfficialTrainingPage,
})

const distinctions = [
  {
    title: 'ITC 02.1.02',
    text: 'Regula la formación profesional mínima en seguridad y salud para el desempeño habitual de puestos de trabajo en centros adscritos a actividades mineras. Tiene carácter habilitante para el puesto y exige actualización o reciclaje.',
  },
  {
    title: 'ET 2001-1-08',
    text: 'Desarrolla el itinerario del operador de maquinaria de arranque, carga y viales en actividades extractivas de exterior. La formación inicial tiene una duración mínima de 20 horas.',
  },
  {
    title: 'ET 2000-1-08',
    text: 'Desarrolla el itinerario del operador de maquinaria de transporte, camión y volquete en actividades extractivas de exterior. La formación inicial tiene una duración mínima de 20 horas.',
  },
  {
    title: 'ITC 02.0.02',
    text: 'Regula la protección frente al riesgo por inhalación de polvo y sílice cristalina respirables. Es un marco distinto de la ITC 02.1.02 e incluye obligaciones específicas de información, formación y protección.',
  },
]

function OfficialTrainingPage() {
  return (
    <StaticPage
      eyebrow="Información normativa"
      title="Formación Preventiva Oficial, con nombre y norma."
      description="Explicamos exactamente qué se imparte, bajo qué disposición y qué requisitos deben completarse. Sin etiquetas ambiguas."
    >
      <div className="official-intro">
        <Scale size={30} />
        <div>
          <h2>¿Por qué no decimos simplemente “curso homologado”?</h2>
          <p>
            Porque esa expresión puede inducir a pensar que existe un carné
            universal o que cualquier modalidad online habilita automáticamente.
            La denominación precisa es Formación Preventiva Oficial para el
            desempeño del puesto de trabajo o frente a un riesgo concreto,
            identificando la ITC, el itinerario, la duración y la modalidad.
          </p>
        </div>
      </div>

      <div className="feature-grid">
        {distinctions.map((item) => (
          <article className="feature-card" key={item.title}>
            <span className="feature-card__icon"><BookOpenCheck size={22} /></span>
            <h2 style={{ fontSize: '1.15rem' }}>{item.title}</h2>
            <p>{item.text}</p>
          </article>
        ))}
      </div>

      <div className="panel legal-panel">
        <h2>Qué incluye y qué no significa</h2>
        <div className="form-grid">
          <p><CheckCircle2 size={18} /> Programa mínimo reglado y adaptado al puesto.</p>
          <p><CheckCircle2 size={18} /> Docencia por profesionales con cualificación preventiva y experiencia minera.</p>
          <p><CheckCircle2 size={18} /> Evaluación, trazabilidad, registro y acreditación documental.</p>
          <p><CheckCircle2 size={18} /> Parte práctica y adaptación al centro cuando procedan.</p>
          <p><AlertCircle size={18} /> No sustituye permisos de conducción, autorizaciones internas ni otras formaciones obligatorias.</p>
          <p><AlertCircle size={18} /> Completar vídeos o un test no habilita si quedan prácticas o validaciones pendientes.</p>
        </div>
      </div>

      <p className="legal-note">
        Normativa de referencia: Orden ITC/1316/2008, de 7 de mayo;
        Resoluciones de 9 de junio de 2008 que aprueban las ET 2001-1-08
        y 2000-1-08; y Orden TED/723/2021, de 1 de julio, para la ITC
        02.0.02. La empresa empleadora conserva sus obligaciones conforme
        a la Ley 31/1995 y a la evaluación de riesgos del puesto y del centro.
      </p>
      <Link className="button button--primary" to="/catalogo">Ver formación disponible</Link>
    </StaticPage>
  )
}
