<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StyleStock | Crear cuenta</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="login-page">

  <div class="login-container login-container--wide">
    <div class="login-logo">👕</div>
    <h1 class="login-brand">StyleStock</h1>
    <p class="login-sub">Crear cuenta nueva</p>

    <%-- Mensaje de error proveniente del Servlet --%>
    <% String msg = (String) request.getAttribute("msg"); %>
    <% if (msg != null && !msg.isEmpty()) { %>
      <p class="error-msg" style="margin-bottom:12px;">⚠ <%= msg %></p>
    <% } %>

    <form id="formRegistro" method="post"
          action="${pageContext.request.contextPath}/api/usuarios"
          novalidate>

      <div class="input-group">
        <label for="usuario">Nombre de usuario</label>
        <input type="text" id="usuario" name="usuario"
               placeholder="Ej: maria_garcia" autocomplete="off" maxlength="50">
      </div>

      <div class="input-group">
        <label for="nombre">Nombre completo</label>
        <input type="text" id="nombre" name="nombre"
               placeholder="Ej: María García" autocomplete="off" maxlength="100">
      </div>

      <div class="input-group">
        <label for="correo">Correo electrónico</label>
        <input type="email" id="correo" name="correo"
               placeholder="Ej: maria@correo.com" autocomplete="off" maxlength="100">
      </div>

      <div class="input-group">
        <label for="contrasena">Contraseña</label>
        <input type="password" id="contrasena" name="contrasena"
               placeholder="Mínimo 6 caracteres" maxlength="100">
      </div>

      <div class="input-group">
        <label for="confirmar">Confirmar contraseña</label>
        <input type="password" id="confirmar"
               placeholder="Repite tu contraseña" maxlength="100">
      </div>

      <%-- El rol NO se muestra. Se asigna en el Servlet como id_rol = 3 --%>

      <p id="registro-msg" class="error-msg"></p>

      <button type="button" class="btn-full" id="btn-registrar">
        Crear cuenta
      </button>
    </form>

    <button class="btn-full btn-secondary btn-crear"
            onclick="window.location.href='${pageContext.request.contextPath}/index.jsp'">
      ← Volver al login
    </button>
  </div>

  <script>
    document.getElementById('btn-registrar').addEventListener('click', function () {
      var usuario    = document.getElementById('usuario').value.trim();
      var nombre     = document.getElementById('nombre').value.trim();
      var correo     = document.getElementById('correo').value.trim();
      var contrasena = document.getElementById('contrasena').value;
      var confirmar  = document.getElementById('confirmar').value;
      var msg        = document.getElementById('registro-msg');

      msg.textContent = '';

      // Campos vacíos
      if (!usuario || !nombre || !correo || !contrasena || !confirmar) {
        msg.textContent = '⚠ Todos los campos son obligatorios.';
        return;
      }

      // Formato de correo
      var reCorreo = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!reCorreo.test(correo)) {
        msg.textContent = '⚠ Ingresa un correo electrónico válido.';
        return;
      }

      // Longitud de contraseña
      if (contrasena.length < 6) {
        msg.textContent = '⚠ La contraseña debe tener al menos 6 caracteres.';
        return;
      }

      // Coincidencia de contraseñas
      if (contrasena !== confirmar) {
        msg.textContent = '⚠ Las contraseñas no coinciden.';
        return;
      }

      // Todo válido: enviar el formulario al Servlet
      document.getElementById('formRegistro').submit();
    });
  </script>
</body>
</html>