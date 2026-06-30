<%--
    inventario.jsp
    Formulario para actualizar el stock de una variante.
    Muestra el inventario completo usando VarianteDAO.
    Ubicación: src/main/webapp/inventario.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stylestock.dao.VarianteDAO" %>
<%@ page import="com.stylestock.model.Variante" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StyleStock | Inventario</title>
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

        h2 { font-size: 1.2rem; margin-bottom: 18px; }

        /* ── Formulario ── */
        .card {
            background: #1e1e2a;
            border: 1px solid #2a2a3a;
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 36px;
            max-width: 520px;
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

        .grupo input {
            padding: 10px 13px;
            background: #16161d;
            border: 1px solid #2a2a3a;
            border-radius: 8px;
            color: #eeeef5;
            font-size: 0.92rem;
        }

        .grupo input:focus {
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

        /* ── Mensajes ── */
        .msg-ok  { color: #2ecc71; font-size: 0.85rem; margin-bottom: 12px; }
        .msg-err { color: #e74c3c; font-size: 0.85rem; margin-bottom: 12px; }

        /* ── Badges de stock ── */
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.72rem;
            font-weight: 600;
        }

        .badge-ok    { background: rgba(46,204,113,0.12); color: #2ecc71; border: 1px solid rgba(46,204,113,0.25); }
        .badge-bajo  { background: rgba(243,156,18,0.12);  color: #f39c12; border: 1px solid rgba(243,156,18,0.25); }
        .badge-vacio { background: rgba(231,76,60,0.12);   color: #e74c3c; border: 1px solid rgba(231,76,60,0.25); }

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
            white-space: nowrap;
        }

        tbody td {
            padding: 11px 15px;
            border-top: 1px solid #2a2a3a;
            vertical-align: middle;
        }

        tbody tr:hover td { background: #1c1c26; }
    </style>
</head>
<body>

<%-- ── Barra de navegación ── --%>
<header>
    <span>👕 StyleStock</span>
    <a href="productos.jsp">👕 Productos</a>
</header>

<main>

    <%-- ══════════════════════════════
         SECCIÓN: ACTUALIZAR STOCK
    ══════════════════════════════ --%>
    <h2>Actualizar Stock de Variante</h2>

    <%-- Muestra mensaje devuelto tras actualizar --%>
    <%
        String resultado = request.getParameter("resultado");
        String tipoMsg   = request.getParameter("tipo");
    %>
    <% if (resultado != null && !resultado.isEmpty()) { %>
        <p class="<%= "ok".equals(tipoMsg) ? "msg-ok" : "msg-err" %>">
            <%= resultado %>
        </p>
    <% } %>

    <%--
        Formulario POST → VarianteServlet (/api/variantes)
        accion=stock indica al servlet que solo debe actualizar el stock.
        Requiere: id (id_variante) y stock (nuevo valor).
    --%>
    <div class="card">
        <form action="<%= request.getContextPath() %>/api/variantes" method="post">

            <%-- Indica al servlet la operación de stock --%>
            <input type="hidden" name="accion" value="stock">

            <div class="grupo">
                <label for="id">ID de la Variante *</label>
                <input type="number" id="id" name="id"
                       placeholder="Ej: 3" min="1" required>
            </div>

            <div class="grupo">
                <label for="stock">Nuevo Stock *</label>
                <input type="number" id="stock" name="stock"
                       placeholder="Ej: 25" min="0" required>
            </div>

            <button type="submit" class="btn">Actualizar Stock</button>

        </form>
    </div>

    <%-- ══════════════════════════════
         SECCIÓN: ESTADO DEL INVENTARIO
         Consulta directa con VarianteDAO
    ══════════════════════════════ --%>
    <h2>Estado del Inventario</h2>

    <%
        /* Consulta todas las variantes con JOIN a productos */
        VarianteDAO varianteDAO = new VarianteDAO();
        List<Variante> variantes = varianteDAO.obtenerTodas();
    %>

    <div class="tabla-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID Variante</th>
                    <th>Producto</th>
                    <th>Color</th>
                    <th>Talla</th>
                    <th>Stock</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
                <% if (variantes == null || variantes.isEmpty()) { %>
                    <tr>
                        <td colspan="6" style="text-align:center; color:#9999b0; padding:30px;">
                            No hay variantes registradas en el inventario.
                        </td>
                    </tr>
                <% } else {
                       for (Variante v : variantes) {
                           /* Determina badge según nivel de stock */
                           String badgeClase;
                           String badgeTexto;
                           if (v.getStock() == 0) {
                               badgeClase = "badge-vacio";
                               badgeTexto = "Sin stock";
                           } else if (v.getStock() <= 10) {
                               badgeClase = "badge-bajo";
                               badgeTexto = "Stock bajo";
                           } else {
                               badgeClase = "badge-ok";
                               badgeTexto = "En stock";
                           }
                %>
                    <tr>
                        <td><%= v.getIdVariante() %></td>
                        <td><strong><%= v.getProductoNombre() %></strong></td>
                        <td><%= v.getColor() %></td>
                        <td><%= v.getTalla() %></td>
                        <td><strong><%= v.getStock() %></strong></td>
                        <td>
                            <span class="badge <%= badgeClase %>">
                                <%= badgeTexto %>
                            </span>
                        </td>
                    </tr>
                <%     }
                   } %>
            </tbody>
        </table>
    </div>

</main>

</body>
</html>