import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);

export default async function handler(req, res) {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const { type, email, url } = req.body;
    
    if (!type || !email || !url) {
      res.status(400).json({ error: 'Faltan parámetros requeridos (type, email, url)' });
      return;
    }

    // El dominio debe estar verificado en Resend (ej. tudominio.com)
    // O puedes usar onboarding@resend.dev para pruebas
    const fromDomain = process.env.RESEND_FROM_DOMAIN || 'resend.dev';
    const fromAddress = `no-reply@${fromDomain}`;

    let subject = '';
    let title = '';
    let message = '';
    let buttonText = '';

    if (type === 'verification') {
      subject = 'Verifica tu cuenta - Login Pro';
      title = '¡Bienvenido a Login Pro!';
      message = 'Gracias por registrarte. Para comenzar a usar la aplicación, por favor verifica tu dirección de correo electrónico haciendo clic en el siguiente botón:';
      buttonText = 'Verificar mi cuenta';
    } else if (type === 'recovery') {
      subject = 'Recuperar contraseña - Login Pro';
      title = 'Recuperación de contraseña';
      message = 'Hemos recibido una solicitud para restablecer tu contraseña. Si fuiste tú, haz clic en el siguiente botón para crear una nueva contraseña. Si no fuiste tú, puedes ignorar este correo.';
      buttonText = 'Restablecer contraseña';
    } else {
      res.status(400).json({ error: 'Tipo de correo no válido' });
      return;
    }

    const htmlContent = `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <style>
          body { font-family: Arial, sans-serif; background-color: #f6f9fc; color: #333333; margin: 0; padding: 20px; }
          .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
          .header { background-color: #00308F; padding: 20px; text-align: center; border-bottom: 4px solid #FFD100; }
          .header h1 { color: #ffffff; margin: 0; font-size: 24px; }
          .content { padding: 30px; text-align: center; }
          .content p { font-size: 16px; line-height: 1.5; margin-bottom: 25px; }
          .button { display: inline-block; background-color: #00308F; color: #ffffff !important; text-decoration: none; padding: 12px 24px; border-radius: 6px; font-weight: bold; font-size: 16px; border-bottom: 3px solid #E30613; }
          .footer { background-color: #f8f9fa; padding: 15px; text-align: center; font-size: 12px; color: #888888; border-top: 1px solid #eeeeee; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>Login Pro</h1>
          </div>
          <div class="content">
            <h2>${title}</h2>
            <p>${message}</p>
            <a href="${url}" class="button">${buttonText}</a>
          </div>
          <div class="footer">
            <p>Si tienes problemas con el botón, copia y pega este enlace en tu navegador:</p>
            <p><a href="${url}" style="color: #00308F;">${url}</a></p>
            <p>&copy; ${new Date().getFullYear()} Login Pro. Todos los derechos reservados.</p>
          </div>
        </div>
      </body>
      </html>
    `;

    const data = await resend.emails.send({
      from: fromAddress,
      to: email,
      subject: subject,
      html: htmlContent,
    });

    res.status(200).json({ success: true, data });
  } catch (error) {
    console.error('Error enviando correo con Resend:', error);
    res.status(500).json({ error: 'Error interno del servidor al enviar el correo' });
  }
}
