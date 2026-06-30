/* ══════════════════════════════════════
   STYLESTOCK — app.js
══════════════════════════════════════ */

// ── Credenciales ──
const USUARIO_VALIDO  = 'admin';
const PASSWORD_VALIDO = '1234';
const STORAGE_KEY     = 'ss_productos';

// ── Datos iniciales ──
const PRODUCTOS_INICIALES = [
  { id: 1, nombre: 'Camiseta Básica',  categoria: 'Camisas',    talla: 'M',  precio: 50000,  stock: 30, descripcion: '100% algodón',      imagen: 'img/camiseta.jpg'  },
  { id: 2, nombre: 'Pantalón Clásico', categoria: 'Pantalones', talla: 'L',  precio: 80000,  stock: 8,  descripcion: 'Corte recto',        imagen: 'img/pantalon.jpg'  },
  { id: 3, nombre: 'Chaqueta Sport',   categoria: 'Chaquetas',  talla: 'XL', precio: 120000, stock: 0,  descripcion: 'Ideal para el frío', imagen: 'img/chaqueta.jpg'  },
];

/* ════════════════════
   STORAGE
════════════════════ */
function obtenerProductos() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(PRODUCTOS_INICIALES));
      return JSON.parse(JSON.stringify(PRODUCTOS_INICIALES));
    }
    return JSON.parse(raw);
  } catch (e) {
    return JSON.parse(JSON.stringify(PRODUCTOS_INICIALES));
  }
}

function guardarProductos(lista) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(lista));
    return true;
  } catch (e) {
    return false;
  }
}

/* ════════════════════
   TOAST
════════════════════ */
let toastTimer = null;

function showToast(msg, tipo) {
  const t = document.getElementById('toast');
  if (!t) return;
  t.textContent = (tipo === 'ok' ? '✓ ' : '⚠ ') + msg;
  t.style.borderLeftColor = tipo === 'ok' ? 'var(--success)' : 'var(--danger)';
  t.style.borderLeftWidth = '3px';
  t.style.borderLeftStyle = 'solid';
  t.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => t.classList.remove('show'), 3000);
}

/* ════════════════════
   UTILIDADES
════════════════════ */
function formatPrecio(n) {
  return '$' + Number(n).toLocaleString('es-CO');
}

function badgeStock(stock) {
  if (stock === 0)  return `<span class="stock-badge stock-vacio">Sin stock</span>`;
  if (stock <= 10)  return `<span class="stock-badge stock-bajo">Stock bajo · ${stock}</span>`;
  return                   `<span class="stock-badge stock-ok">En stock · ${stock}</span>`;
}

function setMsg(id, texto, tipo) {
  const el = document.getElementById(id);
  if (!el) return;
  el.textContent = texto;
  el.style.color = tipo === 'ok' ? 'var(--success)' : 'var(--danger)';
}

/* ════════════════════
   LOGIN
════════════════════ */
function login() {
  const usuario  = document.getElementById('usuario').value.trim();
  const password = document.getElementById('password').value.trim();
  const errorMsg = document.getElementById('error-msg');
  const btn      = document.getElementById('btn-login');

  errorMsg.textContent = '';

  if (!usuario || !password) {
    errorMsg.textContent = '⚠ Por favor completa todos los campos.';
    return;
  }

  btn.textContent = 'Ingresando...';
  btn.disabled    = true;

  setTimeout(function () {
    if (usuario === USUARIO_VALIDO && password === PASSWORD_VALIDO) {
      window.location.href = 'menu.html';
    } else {
      errorMsg.textContent = '✕ Usuario o contraseña incorrectos.';
      btn.textContent      = 'Ingresar';
      btn.disabled         = false;
    }
  }, 400);
}

/* ════════════════════
   PRODUCTOS
════════════════════ */
function renderizarProductos() {
  const productos = obtenerProductos();
  const buscador  = document.getElementById('buscador');
  const filtroC   = document.getElementById('filtro-categoria');
  const filtroS   = document.getElementById('filtro-stock');
  const grid      = document.getElementById('productos-grid');
  const sinRes    = document.getElementById('sin-resultados');
  const contador  = document.getElementById('contador-resultados');
  if (!grid) return;

  const texto    = buscador ? buscador.value.toLowerCase().trim() : '';
  const categoria = filtroC ? filtroC.value : 'todas';
  const estado    = filtroS ? filtroS.value : 'todos';

  const filtrados = productos.filter(function (p) {
    const okN = p.nombre.toLowerCase().includes(texto);
    const okC = categoria === 'todas' || p.categoria === categoria;
    const okS = estado === 'todos'
      || (estado === 'ok'    && p.stock > 10)
      || (estado === 'bajo'  && p.stock > 0 && p.stock <= 10)
      || (estado === 'vacio' && p.stock === 0);
    return okN && okC && okS;
  });

  if (contador) {
    contador.textContent = filtrados.length === productos.length
      ? productos.length + ' productos en total'
      : filtrados.length + ' de ' + productos.length + ' productos';
  }

  if (filtrados.length === 0) {
    grid.innerHTML = '';
    if (sinRes) sinRes.style.display = 'block';
    return;
  }

  if (sinRes) sinRes.style.display = 'none';

  grid.innerHTML = filtrados.map(function (p) {
    return `
      <div class="producto">
        <img class="producto-img"
             src="${p.imagen}"
             alt="${p.nombre}"
             onerror="this.outerHTML='<div class=\\'producto-img-placeholder\\'>👕</div>'">
        <div class="producto-body">
          <div class="producto-nombre">${p.nombre}</div>
          <div class="producto-cat">${p.categoria}${p.talla ? ' · Talla ' + p.talla : ''}</div>
          <div class="producto-precio">${formatPrecio(p.precio)}</div>
          ${badgeStock(p.stock)}
          ${p.descripcion ? '<div class="producto-desc">' + p.descripcion + '</div>' : ''}
          <div class="producto-actions">
            <button onclick="irAEditar(${p.id})">✏ Editar</button>
          </div>
        </div>
      </div>
    `;
  }).join('');
}

function filtrarProductos() {
  renderizarProductos();
}

function irAEditar(id) {
  localStorage.setItem('ss_editarId', id);
  window.location.href = 'editar.html';
}

/* ════════════════════
   AGREGAR PRODUCTO
════════════════════ */
function agregarProducto() {
  const nombre      = document.getElementById('nombre').value.trim();
  const categoria   = document.getElementById('categoria').value;
  const talla       = document.getElementById('talla').value;
  const precio      = parseFloat(document.getElementById('precio').value);
  const stock       = parseInt(document.getElementById('stock').value);
  const descripcion = document.getElementById('descripcion').value.trim();
  const btn         = document.getElementById('btn-agregar');

  if (!nombre) {
    setMsg('agregar-msg', '⚠ El nombre es obligatorio.', 'err');
    return;
  }
  if (isNaN(precio) || precio < 0) {
    setMsg('agregar-msg', '⚠ Ingresa un precio válido.', 'err');
    return;
  }
  if (isNaN(stock) || stock < 0) {
    setMsg('agregar-msg', '⚠ Ingresa un stock válido.', 'err');
    return;
  }

  const imagenes = {
    'Camisas':    'img/camiseta.jpg',
    'Pantalones': 'img/pantalon.jpg',
    'Chaquetas':  'img/chaqueta.jpg',
  };

  const productos = obtenerProductos();
  const nuevoId   = productos.length > 0
    ? Math.max.apply(null, productos.map(function (p) { return p.id; })) + 1
    : 1;

  productos.push({
    id: nuevoId,
    nombre: nombre,
    categoria: categoria,
    talla: talla,
    precio: precio,
    stock: stock,
    descripcion: descripcion,
    imagen: imagenes[categoria] || 'img/camiseta.jpg'
  });

  if (guardarProductos(productos)) {
    setMsg('agregar-msg', '✓ Producto guardado correctamente.', 'ok');
    showToast('Producto "' + nombre + '" agregado.', 'ok');
    document.getElementById('nombre').value      = '';
    document.getElementById('precio').value      = '';
    document.getElementById('stock').value       = '';
    document.getElementById('descripcion').value = '';
    setTimeout(function () { setMsg('agregar-msg', '', 'ok'); }, 3000);
  } else {
    setMsg('agregar-msg', '✕ Error al guardar. Intenta de nuevo.', 'err');
  }
}

/* ════════════════════
   EDITAR PRODUCTO
════════════════════ */
function cargarDatosEdicion() {
  const id        = parseInt(localStorage.getItem('ss_editarId'));
  const productos = obtenerProductos();
  const producto  = productos.find(function (p) { return p.id === id; });

  if (!producto) {
    document.querySelector('.form-card').innerHTML =
      '<p style="color:var(--text2);padding:20px;">Producto no encontrado. ' +
      '<a href="productos.html" style="color:var(--accent);">Volver al catálogo</a></p>';
    return;
  }

  document.getElementById('nombre').value      = producto.nombre;
  document.getElementById('categoria').value   = producto.categoria;
  document.getElementById('talla').value       = producto.talla || 'M';
  document.getElementById('precio').value      = producto.precio;
  document.getElementById('stock').value       = producto.stock;
  document.getElementById('descripcion').value = producto.descripcion || '';
}

function guardarCambios() {
  const id          = parseInt(localStorage.getItem('ss_editarId'));
  const nombre      = document.getElementById('nombre').value.trim();
  const categoria   = document.getElementById('categoria').value;
  const talla       = document.getElementById('talla').value;
  const precio      = parseFloat(document.getElementById('precio').value);
  const stock       = parseInt(document.getElementById('stock').value);
  const descripcion = document.getElementById('descripcion').value.trim();

  if (!nombre) {
    setMsg('edit-msg', '⚠ El nombre es obligatorio.', 'err');
    return;
  }
  if (isNaN(precio) || precio < 0) {
    setMsg('edit-msg', '⚠ Ingresa un precio válido.', 'err');
    return;
  }
  if (isNaN(stock) || stock < 0) {
    setMsg('edit-msg', '⚠ Ingresa un stock válido.', 'err');
    return;
  }

  const productos = obtenerProductos();
  const index     = productos.findIndex(function (p) { return p.id === id; });

  if (index === -1) {
    setMsg('edit-msg', '✕ Producto no encontrado.', 'err');
    return;
  }

  productos[index] = Object.assign({}, productos[index], {
    nombre: nombre,
    categoria: categoria,
    talla: talla,
    precio: precio,
    stock: stock,
    descripcion: descripcion
  });

  if (guardarProductos(productos)) {
    showToast('Cambios guardados correctamente.', 'ok');
    setTimeout(function () { window.location.href = 'productos.html'; }, 1000);
  } else {
    setMsg('edit-msg', '✕ Error al guardar. Intenta de nuevo.', 'err');
  }
}

function eliminarProducto() {
  const id = parseInt(localStorage.getItem('ss_editarId'));
  const productos = obtenerProductos();
  const producto  = productos.find(function (p) { return p.id === id; });

  if (!producto) return;

  if (!confirm('¿Eliminar "' + producto.nombre + '"? Esta acción no se puede deshacer.')) return;

  const nuevaLista = productos.filter(function (p) { return p.id !== id; });

  if (guardarProductos(nuevaLista)) {
    showToast('Producto eliminado.', 'ok');
    setTimeout(function () { window.location.href = 'productos.html'; }, 800);
  }
}

/* ════════════════════
   INVENTARIO
════════════════════ */
function cargarInventario() {
  const productos = obtenerProductos();

  const select = document.getElementById('producto-inv');
  if (select) {
    select.innerHTML = productos.map(function (p) {
      return '<option value="' + p.id + '">' + p.nombre + ' (' + p.categoria + ')</option>';
    }).join('');
    mostrarStockActual();
  }

  const tbody = document.getElementById('tabla-body');
  if (tbody) {
    if (productos.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;color:var(--text2);padding:30px;">Sin productos registrados.</td></tr>';
      return;
    }
    tbody.innerHTML = productos.map(function (p) {
      return `
        <tr>
          <td><strong>${p.nombre}</strong></td>
          <td>${p.categoria}</td>
          <td>${p.talla || '—'}</td>
          <td>${formatPrecio(p.precio)}</td>
          <td><strong>${p.stock}</strong></td>
          <td>${badgeStock(p.stock)}</td>
          <td>
            <button style="font-size:0.78rem;padding:5px 12px;"
                    onclick="editarDesdeTabla(${p.id})">✏ Editar</button>
          </td>
        </tr>
      `;
    }).join('');
  }
}

function mostrarStockActual() {
  const select  = document.getElementById('producto-inv');
  const box     = document.getElementById('stock-actual-box');
  const numEl   = document.getElementById('stock-actual-num');
  if (!select || !box || !numEl) return;

  const id       = parseInt(select.value);
  const producto = obtenerProductos().find(function (p) { return p.id === id; });

  if (producto) {
    box.style.display = 'flex';
    numEl.textContent = producto.stock + ' unidades';
  }
}

function actualizarInventario() {
  const select   = document.getElementById('producto-inv');
  const id       = parseInt(select.value);
  const cantidad = parseInt(document.getElementById('cantidad-inv').value);

  if (isNaN(cantidad) || cantidad < 0) {
    setMsg('inv-msg', '⚠ Ingresa una cantidad válida (0 o más).', 'err');
    return;
  }

  const productos = obtenerProductos();
  const index     = productos.findIndex(function (p) { return p.id === id; });

  if (index === -1) {
    setMsg('inv-msg', '✕ Producto no encontrado.', 'err');
    return;
  }

  const nombre = productos[index].nombre;
  productos[index].stock = cantidad;

  if (guardarProductos(productos)) {
    setMsg('inv-msg', '✓ Stock actualizado a ' + cantidad + ' unidades.', 'ok');
    showToast('"' + nombre + '" actualizado a ' + cantidad + ' unidades.', 'ok');
    document.getElementById('cantidad-inv').value = '';
    cargarInventario();
    setTimeout(function () { setMsg('inv-msg', '', 'ok'); }, 3000);
  } else {
    setMsg('inv-msg', '✕ Error al guardar. Intenta de nuevo.', 'err');
  }
}

function editarDesdeTabla(id) {
  localStorage.setItem('ss_editarId', id);
  window.location.href = 'editar.html';
}

/* ════════════════════
   REPORTES
════════════════════ */
function cargarReportes() {
  const productos = obtenerProductos();
  if (!productos) return;

  const total    = productos.length;
  const sinStock = productos.filter(function (p) { return p.stock === 0; }).length;
  const bajo     = productos.filter(function (p) { return p.stock > 0 && p.stock <= 10; }).length;
  const enStock  = productos.filter(function (p) { return p.stock > 10; }).length;
  const valor    = productos.reduce(function (s, p) { return s + (p.precio * p.stock); }, 0);
  const masStock = productos.reduce(function (a, b) { return a.stock > b.stock ? a : b; }, productos[0]);
  const menosStock = productos
    .filter(function (p) { return p.stock > 0; })
    .reduce(function (a, b) { return a.stock < b.stock ? a : b; }, productos.find(function (p) { return p.stock > 0; }));

  // KPIs
  const kpiDiv = document.getElementById('reportes-kpi');
  if (kpiDiv) {
    kpiDiv.innerHTML = `
      <div class="kpi-card">
        <div class="kpi-icon">📦</div>
        <div class="kpi-num kpi-accent">${total}</div>
        <div class="kpi-label">Total productos</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon">💰</div>
        <div class="kpi-num kpi-ok">${formatPrecio(valor)}</div>
        <div class="kpi-label">Valor en inventario</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon">⚠️</div>
        <div class="kpi-num kpi-warn">${bajo}</div>
        <div class="kpi-label">Con stock bajo</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon">🚫</div>
        <div class="kpi-num kpi-danger">${sinStock}</div>
        <div class="kpi-label">Sin stock</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon">✅</div>
        <div class="kpi-num kpi-ok">${enStock}</div>
        <div class="kpi-label">En stock normal</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon">🏆</div>
        <div class="kpi-num" style="font-size:1rem;">${masStock ? masStock.nombre : '—'}</div>
        <div class="kpi-label">Mayor stock</div>
      </div>
    `;
  }

  // Tabla críticos
  const criticos = productos.filter(function (p) { return p.stock <= 10; })
    .sort(function (a, b) { return a.stock - b.stock; });

  const tblCrit = document.getElementById('tabla-criticos');
  if (tblCrit) {
    if (criticos.length === 0) {
      tblCrit.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--success);padding:20px;">✓ Todos los productos tienen stock suficiente.</td></tr>';
    } else {
      tblCrit.innerHTML = criticos.map(function (p) {
        return `
          <tr>
            <td><strong>${p.nombre}</strong></td>
            <td>${p.categoria}</td>
            <td>${p.talla || '—'}</td>
            <td>${formatPrecio(p.precio)}</td>
            <td><strong>${p.stock}</strong></td>
            <td>${badgeStock(p.stock)}</td>
          </tr>
        `;
      }).join('');
    }
  }

  // Tabla todos
  const tblTodos = document.getElementById('tabla-todos');
  if (tblTodos) {
    tblTodos.innerHTML = productos.map(function (p) {
      return `
        <tr>
          <td><strong>${p.nombre}</strong></td>
          <td>${p.categoria}</td>
          <td>${p.talla || '—'}</td>
          <td>${formatPrecio(p.precio)}</td>
          <td>${p.stock}</td>
          <td>${formatPrecio(p.precio * p.stock)}</td>
          <td>${badgeStock(p.stock)}</td>
        </tr>
      `;
    }).join('');
  }
}

function imprimirReporte() {
  window.print();
}