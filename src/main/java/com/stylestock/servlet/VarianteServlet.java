package com.stylestock.servlet;

import com.stylestock.dao.VarianteDAO;
import com.stylestock.model.Variante;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet para operaciones CRUD sobre variantes de producto.
 * URL base: /api/variantes
 *
 * GET    /api/variantes                       → listar todas
 * GET    /api/variantes?id=X                  → buscar por id
 * GET    /api/variantes?id_producto=X         → listar por producto
 * POST   /api/variantes                       → insertar
 * PUT    /api/variantes                       → actualizar
 * PUT    /api/variantes?accion=stock          → actualizar solo stock
 * DELETE /api/variantes?id=X                  → eliminar
 */
@WebServlet("/api/variantes")
public class VarianteServlet extends HttpServlet {

    private final VarianteDAO varianteDAO = new VarianteDAO();

    // ── LISTAR / BUSCAR ──────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String idParam          = request.getParameter("id");
        String idProductoParam  = request.getParameter("id_producto");

        if (idParam != null) {
            // Buscar variante por ID
            try {
                int idVariante = Integer.parseInt(idParam);
                Variante variante = varianteDAO.obtenerPorId(idVariante);

                if (variante != null) {
                    out.println("=== VARIANTE ENCONTRADA ===");
                    out.println("ID:        " + variante.getIdVariante());
                    out.println("Producto:  " + variante.getProductoNombre());
                    out.println("Color:     " + variante.getColor());
                    out.println("Talla:     " + variante.getTalla());
                    out.println("Stock:     " + variante.getStock());
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.println("Variante no encontrada con ID: " + idVariante);
                }

            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Error: el parametro 'id' debe ser un numero entero.");
            }

        } else if (idProductoParam != null) {
            // Listar variantes por producto
            try {
                int idProducto = Integer.parseInt(idProductoParam);
                List<Variante> variantes = varianteDAO.obtenerPorProducto(idProducto);

                if (variantes.isEmpty()) {
                    out.println("No hay variantes para el producto ID: " + idProducto);
                } else {
                    out.println("=== VARIANTES DEL PRODUCTO ID: " + idProducto + " ===");
                    for (Variante v : variantes) {
                        out.println("---");
                        out.println("ID:       " + v.getIdVariante());
                        out.println("Color:    " + v.getColor());
                        out.println("Talla:    " + v.getTalla());
                        out.println("Stock:    " + v.getStock());
                    }
                }

            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Error: el parametro 'id_producto' debe ser un numero entero.");
            }

        } else {
            // Listar todas las variantes
            List<Variante> variantes = varianteDAO.obtenerTodas();

            if (variantes.isEmpty()) {
                out.println("No hay variantes registradas.");
            } else {
                out.println("=== LISTA DE VARIANTES ===");
                for (Variante v : variantes) {
                    out.println("---");
                    out.println("ID:        " + v.getIdVariante());
                    out.println("Producto:  " + v.getProductoNombre());
                    out.println("Color:     " + v.getColor());
                    out.println("Talla:     " + v.getTalla());
                    out.println("Stock:     " + v.getStock());
                }
            }
        }
    }

    // ── INSERTAR ─────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String idProductoParam = request.getParameter("id_producto");
        String color           = request.getParameter("color");
        String talla           = request.getParameter("talla");
        String stockParam      = request.getParameter("stock");

        if (idProductoParam == null || color == null || color.trim().isEmpty()
                || talla == null || talla.trim().isEmpty() || stockParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: id_producto, color, talla y stock son obligatorios.");
            return;
        }

        try {
            int idProducto = Integer.parseInt(idProductoParam);
            int stock      = Integer.parseInt(stockParam);

            Variante variante = new Variante();
            variante.setIdProducto(idProducto);
            variante.setColor(color.trim());
            variante.setTalla(talla.trim());
            variante.setStock(stock);

            boolean insertada = varianteDAO.insertar(variante);

            if (insertada) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.println("Variante insertada correctamente para producto ID: " + idProducto);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.println("Error: no se pudo insertar la variante.");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: id_producto y stock deben ser numericos.");
        }
    }

    // ── ACTUALIZAR / ACTUALIZAR STOCK ────────────────────────────
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String accion  = request.getParameter("accion");
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: el parametro 'id' es obligatorio.");
            return;
        }

        try {
            int idVariante = Integer.parseInt(idParam);

            if ("stock".equals(accion)) {
                // Actualizar únicamente el stock
                String stockParam = request.getParameter("stock");

                if (stockParam == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.println("Error: el parametro 'stock' es obligatorio para esta accion.");
                    return;
                }

                int nuevoStock = Integer.parseInt(stockParam);
                boolean actualizado = varianteDAO.actualizarStock(idVariante, nuevoStock);

                if (actualizado) {
                    out.println("Stock actualizado correctamente. ID variante: " + idVariante
                            + " | Nuevo stock: " + nuevoStock);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.println("Variante no encontrada con ID: " + idVariante);
                }

            } else {
                // Actualizar todos los campos de la variante
                String color      = request.getParameter("color");
                String talla      = request.getParameter("talla");
                String stockParam = request.getParameter("stock");

                if (color == null || color.trim().isEmpty()
                        || talla == null || talla.trim().isEmpty()
                        || stockParam == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.println("Error: color, talla y stock son obligatorios.");
                    return;
                }

                int stock = Integer.parseInt(stockParam);

                Variante variante = new Variante();
                variante.setIdVariante(idVariante);
                variante.setColor(color.trim());
                variante.setTalla(talla.trim());
                variante.setStock(stock);

                boolean actualizado = varianteDAO.actualizar(variante);

                if (actualizado) {
                    out.println("Variante actualizada correctamente. ID: " + idVariante);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.println("Variante no encontrada con ID: " + idVariante);
                }
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: id y stock deben ser numericos.");
        }
    }

    // ── ELIMINAR ─────────────────────────────────────────────────
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: el parametro 'id' es obligatorio.");
            return;
        }

        try {
            int idVariante = Integer.parseInt(idParam);
            boolean eliminada = varianteDAO.eliminar(idVariante);

            if (eliminada) {
                out.println("Variante eliminada correctamente. ID: " + idVariante);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.println("Variante no encontrada con ID: " + idVariante);
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: el parametro 'id' debe ser un numero entero.");
        }
    }
}
