<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_sesion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StyleStock | Reportes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body>
  <header class="topbar">
    <div class="topbar-left">
      <span class="topbar-icon">👕</span>
      <span class="brand-name">StyleStock</span>
    </div>
    <div class="topbar-right">
      <span class="sesion-info">👤 <%= usuarioSesion %></span>
      <button class="btn-secondary" onclick="window.location.href='menu.jsp'">← Menú</button>
      <a href="${pageContext.request.contextPath}/api/sesion?action=logout" class="btn-logout">Cerrar sesión</a>
    </div>
  </header>

  <main class="page-main">
    <div class="page-header">
      <h1>Reportes</h1>
      <button onclick="imprimirReporte()">🖨 Imprimir</button>
    </div>
    <div class="reportes-grid" id="reportes-kpi"></div>
    <div class="reporte-seccion">
      <h2 class="seccion-titulo">Productos con stock crítico</h2>
      <div class="tabla-wrapper">
        <table class="tabla">
          <thead>
            <tr><th>Producto</th><th>Categoría</th><th>Talla</th><th>Precio</th><th>Stock</th><th>Estado</th></tr>
          </thead>
          <tbody id="tabla-criticos"></tbody>
        </table>
      </div>
    </div>
    <div class="reporte-seccion">
      <h2 class="seccion-titulo">Todos los productos</h2>
      <div class="tabla-wrapper">
        <table class="tabla">
          <thead>
            <tr><th>Producto</th><th>Categoría</th><th>Talla</th><th>Precio</th><th>Stock</th><th>Valor en stock</th><th>Estado</th></tr>
          </thead>
          <tbody id="tabla-todos"></tbody>
        </table>
      </div>
    </div>
  </main>

  <div id="toast" class="toast"></div>
  <script src="${pageContext.request.contextPath}/js/app.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', cargarReportes);
  </script>
</body>
</html>