<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_sesion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StyleStock | Editar Producto</title>
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
      <button class="btn-secondary" onclick="window.location.href='productos.jsp'">← Volver</button>
      <a href="${pageContext.request.contextPath}/api/sesion?action=logout" class="btn-logout">Cerrar sesión</a>
    </div>
  </header>

  <main class="page-main">
    <div class="page-header">
      <h1>Editar Producto</h1>
    </div>
    <div class="form-card">
      <div class="input-group">
        <label for="nombre">Nombre del producto *</label>
        <input type="text" id="nombre" maxlength="60">
      </div>
      <div class="form-row">
        <div class="input-group">
          <label for="categoria">Categoría *</label>
          <select id="categoria">
            <option value="Camisas">Camisas</option>
            <option value="Pantalones">Pantalones</option>
            <option value="Chaquetas">Chaquetas</option>
          </select>
        </div>
        <div class="input-group">
          <label for="talla">Talla</label>
          <select id="talla">
            <option value="XS">XS</option>
            <option value="S">S</option>
            <option value="M">M</option>
            <option value="L">L</option>
            <option value="XL">XL</option>
            <option value="XXL">XXL</option>
          </select>
        </div>
      </div>
      <div class="form-row">
        <div class="input-group">
          <label for="precio">Precio ($) *</label>
          <input type="number" id="precio" min="0">
        </div>
        <div class="input-group">
          <label for="stock">Stock *</label>
          <input type="number" id="stock" min="0">
        </div>
      </div>
      <div class="input-group">
        <label for="descripcion">Descripción (opcional)</label>
        <input type="text" id="descripcion" maxlength="100">
      </div>
      <div class="form-actions">
        <p id="edit-msg" class="form-msg"></p>
        <div class="form-btns">
          <button class="btn-danger" id="btn-eliminar">🗑 Eliminar</button>
          <button class="btn-secondary" onclick="window.location.href='productos.jsp'">Cancelar</button>
          <button id="btn-guardar">Guardar Cambios</button>
        </div>
      </div>
    </div>
  </main>

  <div id="toast" class="toast"></div>
  <script src="${pageContext.request.contextPath}/js/app.js"></script>
  <script>
    // Sobrescribir redirecciones de .html a .jsp
    function guardarCambiosJSP() {
      var id          = parseInt(localStorage.getItem('ss_editarId'));
      var nombre      = document.getElementById('nombre').value.trim();
      var categoria   = document.getElementById('categoria').value;
      var talla       = document.getElementById('talla').value;
      var precio      = parseFloat(document.getElementById('precio').value);
      var stock       = parseInt(document.getElementById('stock').value);
      var descripcion = document.getElementById('descripcion').value.trim();

      if (!nombre) { setMsg('edit-msg', '⚠ El nombre es obligatorio.', 'err'); return; }
      if (isNaN(precio) || precio < 0) { setMsg('edit-msg', '⚠ Precio inválido.', 'err'); return; }
      if (isNaN(stock)  || stock  < 0) { setMsg('edit-msg', '⚠ Stock inválido.', 'err'); return; }

      var productos = obtenerProductos();
      var index     = productos.findIndex(function(p){ return p.id === id; });
      if (index === -1) { setMsg('edit-msg', '✕ Producto no encontrado.', 'err'); return; }

      productos[index] = Object.assign({}, productos[index],
        { nombre: nombre, categoria: categoria, talla: talla,
          precio: precio, stock: stock, descripcion: descripcion });

      if (guardarProductos(productos)) {
        showToast('Cambios guardados correctamente.', 'ok');
        setTimeout(function(){ window.location.href = 'productos.jsp'; }, 1000);
      } else {
        setMsg('edit-msg', '✕ Error al guardar.', 'err');
      }
    }

    function eliminarProductoJSP() {
      var id       = parseInt(localStorage.getItem('ss_editarId'));
      var productos = obtenerProductos();
      var producto  = productos.find(function(p){ return p.id === id; });
      if (!producto) return;
      if (!confirm('¿Eliminar "' + producto.nombre + '"? Esta acción no se puede deshacer.')) return;
      var nueva = productos.filter(function(p){ return p.id !== id; });
      if (guardarProductos(nueva)) {
        showToast('Producto eliminado.', 'ok');
        setTimeout(function(){ window.location.href = 'productos.jsp'; }, 800);
      }
    }

    document.addEventListener('DOMContentLoaded', function () {
      cargarDatosEdicion();
      document.getElementById('btn-guardar').addEventListener('click', guardarCambiosJSP);
      document.getElementById('btn-eliminar').addEventListener('click', eliminarProductoJSP);
    });
  </script>
</body>
</html>