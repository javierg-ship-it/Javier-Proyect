<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_sesion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StyleStock | Productos</title>
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
      <h1>Productos</h1>
      <button onclick="window.location.href='agregar.jsp'">+ Agregar</button>
    </div>
    <div class="top-bar">
      <input type="text" id="buscador" placeholder="🔍 Buscar por nombre..." oninput="filtrarProductos()">
      <select id="filtro-categoria" onchange="filtrarProductos()">
        <option value="todas">Todas las categorías</option>
        <option value="Camisas">Camisas</option>
        <option value="Pantalones">Pantalones</option>
        <option value="Chaquetas">Chaquetas</option>
      </select>
      <select id="filtro-stock" onchange="filtrarProductos()">
        <option value="todos">Todos los estados</option>
        <option value="ok">En stock</option>
        <option value="bajo">Stock bajo</option>
        <option value="vacio">Sin stock</option>
      </select>
    </div>
    <div id="contador-resultados" class="contador-resultados"></div>
    <div class="productos-grid" id="productos-grid"></div>
    <p id="sin-resultados" class="sin-resultados" style="display:none;">
      😕 No se encontraron productos con ese criterio.
    </p>
  </main>

  <div id="toast" class="toast"></div>
  <script src="${pageContext.request.contextPath}/js/app.js"></script>
  <script>
    // Corregir referencia a editar.jsp
    function irAEditar(id) {
      localStorage.setItem('ss_editarId', id);
      window.location.href = 'editar.jsp';
    }
    document.addEventListener('DOMContentLoaded', renderizarProductos);
  </script>
</body>
</html>