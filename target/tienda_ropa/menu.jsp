<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_sesion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StyleStock | Menú</title>
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
      <a href="${pageContext.request.contextPath}/api/sesion?action=logout"
         class="btn-logout">Cerrar sesión</a>
    </div>
  </header>

  <main class="menu-main">
    <div class="menu-hero">
      <h1>Panel Principal</h1>
      <p>Bienvenido, <%= nombreSesion %>. Gestiona tu tienda desde aquí.</p>
    </div>

    <div class="stats-bar">
      <div class="stat-item">
        <span class="stat-num" id="stat-total">—</span>
        <span class="stat-label">Productos</span>
      </div>
      <div class="stat-divider"></div>
      <div class="stat-item">
        <span class="stat-num" id="stat-valor">—</span>
        <span class="stat-label">Valor inventario</span>
      </div>
      <div class="stat-divider"></div>
      <div class="stat-item">
        <span class="stat-num stat-warn" id="stat-bajo">—</span>
        <span class="stat-label">Stock bajo</span>
      </div>
      <div class="stat-divider"></div>
      <div class="stat-item">
        <span class="stat-num stat-danger" id="stat-vacio">—</span>
        <span class="stat-label">Sin stock</span>
      </div>
    </div>

    <div class="menu-grid">
      <div class="menu-card" onclick="window.location.href='productos.jsp'">
        <div class="menu-card-icon">👕</div>
        <div class="menu-card-body">
          <h3>Ver Productos</h3>
          <p>Consulta, busca y filtra el catálogo completo</p>
        </div>
        <span class="menu-card-arrow">→</span>
      </div>
      <div class="menu-card" onclick="window.location.href='agregar.jsp'">
        <div class="menu-card-icon">➕</div>
        <div class="menu-card-body">
          <h3>Agregar Producto</h3>
          <p>Registra un nuevo producto en el sistema</p>
        </div>
        <span class="menu-card-arrow">→</span>
      </div>
      <div class="menu-card" onclick="window.location.href='inventario.jsp'">
        <div class="menu-card-icon">📦</div>
        <div class="menu-card-body">
          <h3>Actualizar Inventario</h3>
          <p>Ajusta el stock de los productos existentes</p>
        </div>
        <span class="menu-card-arrow">→</span>
      </div>
      <div class="menu-card" onclick="window.location.href='reportes.jsp'">
        <div class="menu-card-icon">📊</div>
        <div class="menu-card-body">
          <h3>Reportes</h3>
          <p>Resumen del estado del inventario y estadísticas</p>
        </div>
        <span class="menu-card-arrow">→</span>
      </div>
      <% if (rolSesion == 1) { %>
      <div class="menu-card" onclick="window.location.href='usuarios.jsp'">
        <div class="menu-card-icon">👥</div>
        <div class="menu-card-body">
          <h3>Gestión de Usuarios</h3>
          <p>Solo visible para Administradores</p>
        </div>
        <span class="menu-card-arrow">→</span>
      </div>
      <% } %>
    </div>
  </main>

  <script src="${pageContext.request.contextPath}/js/app.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function () {
      var productos = obtenerProductos();
      var total  = productos.length;
      var vacio  = productos.filter(function(p){ return p.stock === 0; }).length;
      var bajo   = productos.filter(function(p){ return p.stock > 0 && p.stock <= 10; }).length;
      var valor  = productos.reduce(function(s,p){ return s + (p.precio * p.stock); }, 0);
      document.getElementById('stat-total').textContent = total;
      document.getElementById('stat-vacio').textContent = vacio;
      document.getElementById('stat-bajo').textContent  = bajo;
      document.getElementById('stat-valor').textContent = '$' + valor.toLocaleString('es-CO');
    });
  </script>
</body>
</html>