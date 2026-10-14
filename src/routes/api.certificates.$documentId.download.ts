import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/api/certificates/$documentId/download')({
  server: {
    handlers: {
      GET: async ({ request, params }) => {
        const { getBearerToken, getSupabaseAdmin } = await import(
          '../server/supabase-admin'
        )
        const token = getBearerToken(request)
        if (!token) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const supabase = getSupabaseAdmin()
        const {
          data: { user },
          error: userError,
        } = await supabase.auth.getUser(token)
        if (userError || !user) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const { data: roles } = await supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', user.id)
        const isAdministrator = (roles ?? []).some((row) =>
          ['administrador', 'superadministrador'].includes(row.role),
        )

        const { data: document, error: documentError } = await supabase
          .from('certificate_documents')
          .select('id, user_id, storage_path, original_file_name')
          .eq('id', params.documentId)
          .maybeSingle()
        if (documentError) {
          return Response.json(
            { error: 'No se ha podido preparar la descarga.' },
            { status: 500 },
          )
        }

        if (document) {
          if (document.user_id !== user.id && !isAdministrator) {
            return Response.json({ error: 'No autorizado.' }, { status: 403 })
          }
          const { data: signed, error: signedError } = await supabase.storage
            .from('certificates')
            .createSignedUrl(document.storage_path, 60, {
              download: document.original_file_name,
            })
          if (signedError || !signed) {
            return Response.json(
              { error: 'No se ha podido preparar la descarga.' },
              { status: 500 },
            )
          }
          return Response.json(
            { url: signed.signedUrl },
            { headers: { 'Cache-Control': 'private, no-store' } },
          )
        }

        const { data: certificate, error: certificateError } = await supabase
          .from('certificates')
          .select('id, user_id, status, pdf_storage_path, certificate_code')
          .eq('id', params.documentId)
          .maybeSingle()
        if (certificateError || !certificate) {
          return Response.json({ error: 'Certificado no encontrado.' }, { status: 404 })
        }
        if (certificate.user_id !== user.id && !isAdministrator) {
          return Response.json({ error: 'No autorizado.' }, { status: 403 })
        }
        if (certificate.status !== 'valid' || !certificate.pdf_storage_path) {
          return Response.json(
            { error: 'Este certificado no está disponible.' },
            { status: 409 },
          )
        }

        const { data: signed, error: signedError } = await supabase.storage
          .from('certificates')
          .createSignedUrl(certificate.pdf_storage_path, 60, {
            download: `${certificate.certificate_code}.pdf`,
          })
        if (signedError || !signed) {
          return Response.json(
            { error: 'No se ha podido preparar la descarga.' },
            { status: 500 },
          )
        }
        return Response.json(
          { url: signed.signedUrl },
          { headers: { 'Cache-Control': 'private, no-store' } },
        )
      },
    },
  },
})
