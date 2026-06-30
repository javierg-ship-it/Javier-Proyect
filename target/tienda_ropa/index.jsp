<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StyleStock | Login</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="login-page">

  <div class="login-container">
    <div class="login-logo">👕</div>
    <h1 class="login-brand">StyleStock</h1>
    <p class="login-sub">Sistema de Inventario</p>

    <%-- Mensaje de registro exitoso --%>
    <% if ("true".equals(request.getParameter("registrado"))) { %>
      <p class="login-success">✓ Cuenta creada correctamente. Inicia sesión.</p>
    <% } %>

    <%-- Error proveniente del Servlet de login --%>
    <% String loginError = (String) request.getAttribute("loginError"); %>
    <% if (loginError != null && !loginError.isEmpty()) { %>
      <p class="error-msg" style="margin-bottom:10px;">✕ <%= loginError %></p>
    <% } %>

    <form id="formLogin" method="post"
          action="${pageContext.request.contextPath}/api/usuarios"
          novalidate>

      <%-- Indica al Servlet que es una petición de login --%>
      <input type="hidden" name="action" value="login">

      <div class="input-group">
        <label for="usuario">Usuario</label>
        <input type="text" id="usuario" name="usuario"
               placeholder="Ingresa tu usuario" autocomplete="off">
      </div>

      <div class="input-group">
        <label for="contrasena">Contraseña</label>
        <input type="password" id="contrasena" name="contrasena"
               placeholder="Ingresa tu contraseña">
      </div>

      <p id="error-msg" class="error-msg"></p>

      <button type="button" class="btn-full" id="btn-login">Ingresar</button>
    </form>

    <button class="btn-full btn-secondary btn-crear"
            onclick="window.location.href='${pageContext.request.contextPath}/registro.jsp'">
      Crear cuenta
    </button>

    <p class="login-hint">Usuario: <b>admin</b> &nbsp;|&nbsp; Contraseña: <b>1234</b></p>
  </div>

  <script>
    document.getElementById('btn-login').addEventListener('click', function () {
      var usuario    = document.getElementById('usuario').value.trim();
      var contrasena = document.getElementById('contrasena').value.trim();
      var msg        = document.getElementById('error-msg');

      msg.textContent = '';

      if (!usuario || !contrasena) {
        msg.textContent = '⚠ Por favor completa todos los campos.';
        return;
      }

      document.getElementById('formLogin').submit();
    });

    // Enter en contraseña → submit
    document.getElementById('contrasena').addEventListener('keydown', function (e) {
      if (e.key === 'Enter') document.getElementById('btn-login').click();
    });

    // Enter en usuario → pasar a contraseña
    document.getElementById('usuario').addEventListener('keydown', function (e) {
      if (e.key === 'Enter') document.getElementById('contrasena').focus();
    });
  </script>
</body>
</html>