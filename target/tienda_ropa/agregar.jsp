<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_sesion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StyleStock | Agregar Producto</title>
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
      <h1>Agregar Producto</h1>
    </div>
    <div class="form-card">
      <div class="input-group">
        <label for="nombre">Nombre del producto *</label>
        <input type="text" id="nombre" placeholder="Ej: Camiseta básica blanca" maxlength="60">
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
            <option value="M" selected>M</option>
            <option value="L">L</option>
            <option value="XL">XL</option>
            <option value="XXL">XXL</option>
          </select>
        </div>
      </div>
      <div class="form-row">
        <div class="input-group">
          <label for="precio">Precio ($) *</label>
          <input type="number" id="precio" placeholder="Ej: 50000" min="0">
        </div>
        <div class="input-group">
          <label for="stock">Stock inicial *</label>
          <input type="number" id="stock" placeholder="Ej: 30" min="0">
        </div>
      </div>
      <div class="input-group">
        <label for="descripcion">Descripción (opcional)</label>
        <input type="text" id="descripcion" placeholder="Ej: 100% algodón, varios colores" maxlength="100">
      </div>
      <div class="form-actions">
        <p id="agregar-msg" class="form-msg"></p>
        <div class="form-btns">
          <button class="btn-secondary" onclick="window.location.href='productos.jsp'">Cancelar</button>
          <button id="btn-agregar">Guardar Producto</button>
        </div>
      </div>
    </div>
  </main>

  <div id="toast" class="toast"></div>
  <script src="${pageContext.request.contextPath}/js/app.js"></script>
  <script>
    // Después de agregar, redirigir a productos.jsp
    var _agregarOriginal = agregarProducto;
    document.addEventListener('DOMContentLoaded', function () {
      document.getElementById('btn-agregar').addEventListener('click', function() {
        agregarProductoJSP();
      });
    });

    function agregarProductoJSP() {
      var nombre      = document.getElementById('nombre').value.trim();
      var categoria   = document.getElementById('categoria').value;
      var talla       = document.getElementById('talla').value;
      var precio      = parseFloat(document.getElementById('precio').value);
      var stock       = parseInt(document.getElementById('stock').value);
      var descripcion = document.getElementById('descripcion').value.trim();

      if (!nombre) { setMsg('agregar-msg', '⚠ El nombre es obligatorio.', 'err'); return; }
      if (isNaN(precio) || precio < 0) { setMsg('agregar-msg', '⚠ Precio inválido.', 'err'); return; }
      if (isNaN(stock)  || stock  < 0) { setMsg('agregar-msg', '⚠ Stock inválido.', 'err'); return; }

      var imagenes = { 'Camisas': 'img/camiseta.jpg', 'Pantalones': 'img/pantalon.jpg', 'Chaquetas': 'img/chaqueta.jpg' };
      var productos = obtenerProductos();
      var nuevoId   = productos.length > 0
        ? Math.max.apply(null, productos.map(function(p){ return p.id; })) + 1 : 1;

      productos.push({ id: nuevoId, nombre: nombre, categoria: categoria, talla: talla,
                       precio: precio, stock: stock, descripcion: descripcion,
                       imagen: imagenes[categoria] || 'img/camiseta.jpg' });

      if (guardarProductos(productos)) {
        showToast('Producto "' + nombre + '" agregado.', 'ok');
        setTimeout(function(){ window.location.href = 'productos.jsp'; }, 1000);
      } else {
        setMsg('agregar-msg', '✕ Error al guardar.', 'err');
      }
    }
  </script>
</body>
</html>