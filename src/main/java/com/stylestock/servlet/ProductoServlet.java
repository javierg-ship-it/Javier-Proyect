package com.stylestock.servlet;

import com.stylestock.dao.ProductoDAO;
import com.stylestock.model.Producto;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet para operaciones CRUD sobre productos.
 * URL base: /api/productos
 *
 * GET    /api/productos           → listar todos
 * GET    /api/productos?id=X      → buscar por id
 * POST   /api/productos           → insertar
 * PUT    /api/productos           → actualizar
 * DELETE /api/productos?id=X      → eliminar
 */
@WebServlet("/api/productos")
public class ProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    // ── LISTAR / BUSCAR POR ID ───────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String idParam = request.getParameter("id");

        if (idParam != null) {
            // Buscar por ID
            try {
                int idProducto = Integer.parseInt(idParam);
                Producto producto = productoDAO.obtenerPorId(idProducto);

                if (producto != null) {
                    out.println("=== PRODUCTO ENCONTRADO ===");
                    out.println("ID:          " + producto.getIdProducto());
                    out.println("Nombre:      " + producto.getNombre());
                    out.println("Descripcion: " + producto.getDescripcion());
                    out.println("Precio:      " + producto.getPrecio());
                    out.println("Categoria:   " + producto.getCategoriaNombre());
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.println("Producto no encontrado con ID: " + idProducto);
                }

            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Error: el parametro 'id' debe ser un numero entero.");
            }

        } else {
            // Listar todos
            List<Producto> productos = productoDAO.obtenerTodos();

            if (productos.isEmpty()) {
                out.println("No hay productos registrados.");
            } else {
                out.println("=== LISTA DE PRODUCTOS ===");
                for (Producto p : productos) {
                    out.println("---");
                    out.println("ID:          " + p.getIdProducto());
                    out.println("Nombre:      " + p.getNombre());
                    out.println("Descripcion: " + p.getDescripcion());
                    out.println("Precio:      " + p.getPrecio());
                    out.println("Categoria:   " + p.getCategoriaNombre());
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

        String nombre      = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String precioParam = request.getParameter("precio");
        String catParam    = request.getParameter("id_categoria");

        // Validar parámetros obligatorios
        if (nombre == null || nombre.trim().isEmpty()
                || precioParam == null || catParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: nombre, precio e id_categoria son obligatorios.");
            return;
        }

        try {
            double precio      = Double.parseDouble(precioParam);
            int    idCategoria = Integer.parseInt(catParam);

            Producto producto = new Producto();
            producto.setNombre(nombre.trim());
            producto.setDescripcion(descripcion != null ? descripcion.trim() : "");
            producto.setPrecio(precio);
            producto.setIdCategoria(idCategoria);

            boolean insertado = productoDAO.insertar(producto);

            if (insertado) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.println("Producto insertado correctamente: " + nombre.trim());
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.println("Error: no se pudo insertar el producto.");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: precio e id_categoria deben ser numericos.");
        }
    }

    // ── ACTUALIZAR ───────────────────────────────────────────────
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String idParam     = request.getParameter("id");
        String nombre      = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String precioParam = request.getParameter("precio");
        String catParam    = request.getParameter("id_categoria");

        if (idParam == null || nombre == null || nombre.trim().isEmpty()
                || precioParam == null || catParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: id, nombre, precio e id_categoria son obligatorios.");
            return;
        }

        try {
            int    idProducto  = Integer.parseInt(idParam);
            double precio      = Double.parseDouble(precioParam);
            int    idCategoria = Integer.parseInt(catParam);

            Producto producto = new Producto();
            producto.setIdProducto(idProducto);
            producto.setNombre(nombre.trim());
            producto.setDescripcion(descripcion != null ? descripcion.trim() : "");
            producto.setPrecio(precio);
            producto.setIdCategoria(idCategoria);

            boolean actualizado = productoDAO.actualizar(producto);

            if (actualizado) {
                out.println("Producto actualizado correctamente. ID: " + idProducto);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.println("Producto no encontrado con ID: " + idProducto);
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: id, precio e id_categoria deben ser numericos.");
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
            int idProducto = Integer.parseInt(idParam);
            boolean eliminado = productoDAO.eliminar(idProducto);

            if (eliminado) {
                out.println("Producto eliminado correctamente. ID: " + idProducto);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.println("Producto no encontrado con ID: " + idProducto);
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Error: el parametro 'id' debe ser un numero entero.");
        }
    }
}