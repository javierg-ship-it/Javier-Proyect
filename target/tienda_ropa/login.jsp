<%--
    login.jsp
    Formulario de autenticación de usuario.
    Envía POST al servlet /api/usuarios con accion=auth.
    Ubicación: src/main/webapp/login.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StyleStock | Login</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #0f0f13;
            color: #eeeef5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .card {
            background: #1e1e2a;
            border: 1px solid #2a2a3a;
            border-radius: 16px;
            padding: 44px 36px;
            width: 360px;
            text-align: center;
            box-shadow: 0 24px 64px rgba(0,0,0,0.5);
        }

        .card h1 {
            color: #4f8aff;
            font-size: 1.7rem;
            letter-spacing: 2px;
            margin-bottom: 6px;
        }

        .card p {
            color: #9999b0;
            font-size: 0.8rem;
            margin-bottom: 28px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .grupo {
            display: flex;
            flex-direction: column;
            text-align: left;
            margin-bottom: 16px;
        }

        .grupo label {
            font-size: 0.78rem;
            color: #9999b0;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .grupo input {
            padding: 10px 13px;
            background: #16161d;
            border: 1px solid #2a2a3a;
            border-radius: 8px;
            color: #eeeef5;
            font-size: 0.92rem;
        }

        .grupo input:focus {
            outline: none;
            border-color: #4f8aff;
        }

        .btn {
            width: 100%;
            padding: 11px;
            background: #4f8aff;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 0.97rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 8px;
            transition: background 0.2s;
        }

        .btn:hover { background: #6fa3ff; }

        /* Mensaje de error enviado como parámetro de redirección */
        .error {
            color: #e74c3c;
            font-size: 0.82rem;
            margin-bottom: 10px;
            min-height: 18px;
        }

        .hint {
            margin-top: 16px;
            font-size: 0.74rem;
            color: #9999b0;
        }
    </style>
</head>
<body>

<div class="card">

    <div style="font-size: 2rem; margin-bottom: 8px;">👕</div>
    <h1>StyleStock</h1>
    <p>Sistema de Inventario</p>

    <%-- Muestra error si el servlet redirige con ?error=1 --%>
    <%
        String error = request.getParameter("error");
    %>
    <div class="error">
        <% if ("1".equals(error)) { %>
            ✕ Correo o contraseña incorrectos.
        <% } %>
    </div>

    <%--
        Formulario de login.
        action apunta al UsuarioServlet (/api/usuarios).
        Se usa GET con accion=auth para la autenticación básica.
        En producción se usaría POST con sesión.
    --%>
    <form action="<%= request.getContextPath() %>/api/usuarios" method="get">

        <%-- Parámetro que indica al servlet que debe autenticar --%>
        <input type="hidden" name="accion" value="auth">

        <div class="grupo">
            <label for="correo">Correo electrónico</label>
            <input type="email" id="correo" name="correo"
                   placeholder="usuario@correo.com" required autocomplete="off">
        </div>

        <div class="grupo">
            <label for="contrasena">Contraseña</label>
            <input type="password" id="contrasena" name="contrasena"
                   placeholder="Tu contraseña" required>
        </div>

        <button type="submit" class="btn">Ingresar</button>
        
    <div style="margin-top:15px;text-align:center;">
        <a href="registro.jsp" style="color:#4f8aff;text-decoration:none;">
        Crear una cuenta
        </a>
    </div>
    </form>

    <p class="hint">¿No tienes cuenta? Contacta al administrador.</p>

</div>

</body>
</html>
