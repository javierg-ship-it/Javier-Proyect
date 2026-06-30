<%--
    productos.jsp
    Formulario para insertar un nuevo producto.
    Muestra la lista de productos consultados desde ProductoDAO.
    Ubicación: src/main/webapp/productos.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stylestock.dao.ProductoDAO" %>
<%@ page import="com.stylestock.model.Producto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StyleStock | Productos</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #0f0f13;
            color: #eeeef5;
            min-height: 100vh;
        }

        /* ── Barra superior ── */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 28px;
            height: 56px;
            background: #16161d;
            border-bottom: 1px solid #2a2a3a;
        }

        header span { color: #4f8aff; font-weight: 700; letter-spacing: 1.5px; }

        header a {
            color: #9999b0;
            text-decoration: none;
            font-size: 0.85rem;
            border: 1px solid #2a2a3a;
            padding: 6px 14px;
            border-radius: 8px;
        }

        header a:hover { background: #1c1c26; color: #eeeef5; }

        /* ── Contenido principal ── */
        main {
            max-width: 960px;
            margin: 0 auto;
            padding: 32px 20px;
        }

        h2 {
            font-size: 1.2rem;
            margin-bottom: 18px;
            color: #eeeef5;
        }

        /* ── Formulario ── */
        .card {
            background: #1e1e2a;
            border: 1px solid #2a2a3a;
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 36px;
        }

        .fila {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .grupo {
            display: flex;
            flex-direction: column;
            margin-bottom: 14px;
        }

        .grupo label {
            font-size: 0.78rem;
            color: #9999b0;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .grupo input,
        .grupo select {
            padding: 10px 13px;
            background: #16161d;
            border: 1px solid #2a2a3a;
            border-radius: 8px;
            color: #eeeef5;
            font-size: 0.92rem;
        }

        .grupo input:focus,
        .grupo select:focus {
            outline: none;
            border-color: #4f8aff;
        }

        .btn {
            background: #4f8aff;
            color: #fff;
            padding: 10px 24px;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn:hover { background: #6fa3ff; }

        /* ── Mensaje de resultado del servlet ── */
        .msg-ok  { color: #2ecc71; font-size: 0.85rem; margin-bottom: 10px; }
        .msg-err { color: #e74c3c; font-size: 0.85rem; margin-bottom: 10px; }

        /* ── Tabla ── */
        .tabla-wrapper {
            overflow-x: auto;
            border: 1px solid #2a2a3a;
            border-radius: 16px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.86rem;
        }

        thead th {
            background: #16161d;
            padding: 11px 15px;
            text-align: left;
            color: #9999b0;
            font-size: 0.76rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        tbody td {
            padding: 11px 15px;
            border-top: 1px solid #2a2a3a;
            vertical-align: middle;
        }

        tbody tr:hover td { background: #1c1c26; }

        @media (max-width: 600px) {
            .fila { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<%-- ── Barra de navegación ── --%>
<header>
    <span>👕 StyleStock</span>
    <a href="inventario.jsp">📦 Inventario</a>
</header>

<main>

    <%-- ══════════════════════════════
         SECCIÓN: FORMULARIO INSERTAR
    ══════════════════════════════ --%>
    <h2>Agregar Producto</h2>

    <%--
        Muestra el mensaje devuelto por el servlet si existe.
        El servlet ProductoServlet responde con texto plano;
        para efectos de la evidencia el mensaje se pasa como
        parámetro de redirección desde un formulario externo.
    --%>
    <%
        String resultado = request.getParameter("resultado");
    %>
    <% if (resultado != null && !resultado.isEmpty()) { %>
        <p class="msg-ok">✓ <%= resultado %></p>
    <% } %>

    <%--
        Formulario POST → ProductoServlet (/api/productos)
        El servlet recibe: nombre, descripcion, precio, id_categoria
    --%>
    <div class="card">
        <form action="<%= request.getContextPath() %>/api/productos" method="post">

            <div class="grupo">
                <label for="nombre">Nombre del producto *</label>
                <input type="text" id="nombre" name="nombre"
                       placeholder="Ej: Camiseta Básica Blanca"
                       maxlength="100" required>
            </div>

            <div class="grupo">
                <label for="descripcion">Descripción</label>
                <input type="text" id="descripcion" name="descripcion"
                       placeholder="Ej: 100% algodón" maxlength="150">
            </div>

            <div class="fila">
                <div class="grupo">
                    <label for="precio">Precio (COP) *</label>
                    <input type="number" id="precio" name="precio"
                           placeholder="Ej: 50000" min="0" step="0.01" required>
                </div>

                <%-- id_categoria: coincide con la tabla 'categorias' de Tienda_ropa --%>
                <div class="grupo">
                    <label for="id_categoria">Categoría *</label>
                    <select id="id_categoria" name="id_categoria" required>
                        <option value="">-- Selecciona --</option>
                        <%--
                            Los id corresponden a los registros reales
                            de la tabla categorias en Tienda_ropa.
                            Ajusta los valores si tu BD tiene IDs diferentes.
                        --%>
                        <option value="1">Camisas</option>
                        <option value="2">Pantalones</option>
                        <option value="3">Chaquetas</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn">Guardar Producto</button>

        </form>
    </div>

    <%-- ══════════════════════════════
         SECCIÓN: LISTA DE PRODUCTOS
         Se consulta directamente desde JSP usando ProductoDAO
    ══════════════════════════════ --%>
    <h2>Productos Registrados</h2>

    <%
        /* Instancia el DAO y consulta todos los productos de Tienda_ropa */
        ProductoDAO productoDAO = new ProductoDAO();
        List<Producto> productos = productoDAO.obtenerTodos();
    %>

    <div class="tabla-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Precio</th>
                    <th>Categoría</th>
                </tr>
            </thead>
            <tbody>
                <% if (productos == null || productos.isEmpty()) { %>
                    <tr>
                        <td colspan="5" style="text-align:center; color:#9999b0; padding:30px;">
                            No hay productos registrados.
                        </td>
                    </tr>
                <% } else {
                       for (Producto p : productos) { %>
                    <tr>
                        <td><%= p.getIdProducto() %></td>
                        <td><strong><%= p.getNombre() %></strong></td>
                        <td><%= p.getDescripcion() != null ? p.getDescripcion() : "—" %></td>
                        <td>$ <%= String.format("%,.0f", p.getPrecio()) %></td>
                        <td><%= p.getCategoriaNombre() %></td>
                    </tr>
                <%     }
                   } %>
            </tbody>
        </table>
    </div>

</main>

</body>
</html>