import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/api/certificado-stvh')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const { getBearerToken, getSupabaseAdmin } = await import(
          '../server/supabase-admin'
        )

        const token = getBearerToken(request)
        if (!token) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const url = new URL(request.url)
        const certificateId = url.searchParams.get('certificateId')?.trim()
        if (!certificateId) {
          return Response.json(
            { error: 'Falta el identificador del certificado.' },
            { status: 400 },
          )
        }

        const supabase = getSupabaseAdmin()
        const {
          data: { user },
          error: userError,
        } = await supabase.auth.getUser(token)
        if (userError || !user) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const { data: roleRows } = await supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', user.id)
        const isStaff = (roleRows ?? []).some((row) =>
          ['administrador', 'superadministrador'].includes(row.role),
        )

        const { data: certificate, error: certificateError } = await supabase
          .from('certificates')
          .select(
            'id, user_id, status, certificate_code, holder_name, holder_dni, started_at, completion_date, active_seconds, issued_at, validated_by, pdf_storage_path',
          )
          .eq('id', certificateId)
          .maybeSingle()

        if (certificateError || !certificate) {
          return Response.json(
            { error: 'Certificado no encontrado.' },
            { status: 404 },
          )
        }
        if (certificate.user_id !== user.id && !isStaff) {
          return Response.json({ error: 'No autorizado.' }, { status: 403 })
        }
        if (certificate.status !== 'valid') {
          return Response.json(
            { error: 'Este certificado no está disponible.' },
            { status: 409 },
          )
        }
        // Solo los certificados emitidos por el flujo STVH tienen
        // validated_by relleno; el resto de cursos sigue usando la
        // generación anterior desde el cliente.
        if (!certificate.validated_by) {
          return Response.json(
            { error: 'Este certificado usa otro formato de descarga.' },
            { status: 400 },
          )
        }

        const bucket = supabase.storage.from('certificates')

        if (certificate.pdf_storage_path) {
          const { data: signed, error: signedError } =
            await bucket.createSignedUrl(certificate.pdf_storage_path, 60)
          if (signedError || !signed) {
            return Response.json(
              { error: 'No se ha podido preparar la descarga.' },
              { status: 500 },
            )
          }
          return Response.json({ url: signed.signedUrl })
        }

        const [{ createStvhCertificatePdf, stvhCertificateStoragePath }, appUrl] =
          await Promise.all([
            import('../lib/stvh-certificate-pdf'),
            Promise.resolve(process.env.VITE_APP_URL?.trim().replace(/\/+$/, '')),
          ])

        const templateResponse = await fetch(
          `${appUrl || new URL(request.url).origin}/certificates/stvh-certificado-base.pdf`,
        )
        if (!templateResponse.ok) {
          return Response.json(
            { error: 'No se ha podido cargar la plantilla del certificado.' },
            { status: 500 },
          )
        }
        const templateBytes = new Uint8Array(
          await templateResponse.arrayBuffer(),
        )

        const issuedAt = certificate.issued_at ?? new Date().toISOString()
        const pdfBytes = await createStvhCertificatePdf(templateBytes, {
          certificateCode: certificate.certificate_code,
          holderName: certificate.holder_name,
          holderDni: certificate.holder_dni,
          startedAt: certificate.started_at ?? certificate.completion_date,
          completedAt: certificate.completion_date,
          activeSeconds: certificate.active_seconds ?? 0,
          issuedAt,
        })

        const storagePath = stvhCertificateStoragePath(
          certificate.user_id,
          certificate.certificate_code,
        )
        const { error: uploadError } = await bucket.upload(
          storagePath,
          pdfBytes,
          { contentType: 'application/pdf', upsert: false },
        )
        if (uploadError) {
          return Response.json(
            { error: 'No se ha podido guardar el certificado.' },
            { status: 500 },
          )
        }

        // Guardado condicional: solo se fija la primera vez, evitando que
        // una descarga concurrente regenere/reescriba el certificado ya
        // emitido.
        await supabase
          .from('certificates')
          .update({ pdf_storage_path: storagePath, issued_at: issuedAt })
          .eq('id', certificate.id)
          .is('pdf_storage_path', null)

        const { data: signed, error: signedError } = await bucket.createSignedUrl(
          storagePath,
          60,
        )
        if (signedError || !signed) {
          return Response.json(
            { error: 'No se ha podido preparar la descarga.' },
            { status: 500 },
          )
        }
        return Response.json({ url: signed.signedUrl })
      },
    },
  },
})
