<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_sesion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StyleStock | Inventario</title>
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
      <h1>Actualizar Inventario</h1>
    </div>
    <div class="form-card" style="margin-bottom:32px;">
      <p class="form-card-title">Selecciona un producto y ajusta su cantidad en stock</p>
      <div class="input-group">
        <label for="producto-inv">Producto</label>
        <select id="producto-inv" onchange="mostrarStockActual()"></select>
      </div>
      <div class="stock-actual-box" id="stock-actual-box" style="display:none;">
        <span>Stock actual:</span>
        <strong id="stock-actual-num">—</strong>
      </div>
      <div class="input-group">
        <label for="cantidad-inv">Nueva cantidad en stock</label>
        <input type="number" id="cantidad-inv" placeholder="Ej: 50" min="0">
      </div>
      <div class="form-actions">
        <p id="inv-msg" class="form-msg"></p>
        <button id="btn-actualizar">Actualizar Stock</button>
      </div>
    </div>
    <h2 class="seccion-titulo">Estado del inventario</h2>
    <div class="tabla-wrapper">
      <table class="tabla">
        <thead>
          <tr>
            <th>Producto</th><th>Categoría</th><th>Talla</th>
            <th>Precio</th><th>Stock</th><th>Estado</th><th>Acción</th>
          </tr>
        </thead>
        <tbody id="tabla-body"></tbody>
      </table>
    </div>
  </main>

  <div id="toast" class="toast"></div>
  <script src="${pageContext.request.contextPath}/js/app.js"></script>
  <script>
    function editarDesdeTabla(id) {
      localStorage.setItem('ss_editarId', id);
      window.location.href = 'editar.jsp';
    }
    document.addEventListener('DOMContentLoaded', function () {
      cargarInventario();
      document.getElementById('btn-actualizar').addEventListener('click', actualizarInventario);
    });
  </script>
</body>
</html>