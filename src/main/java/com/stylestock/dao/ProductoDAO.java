package com.stylestock.dao;

import com.stylestock.model.Producto;
import com.stylestock.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD sobre la tabla 'productos'.
 * Base de datos: Tienda_ropa
 */
public class ProductoDAO {

    // ── INSERT ──────────────────────────────────────────────────
    /**
     * Inserta un nuevo producto en la base de datos.
     * @return true si se insertó correctamente
     */
    public boolean insertar(Producto producto) {
        String sql = "INSERT INTO productos (nombre, descripcion, precio, id_categoria) VALUES (?, ?, ?, ?)";
        Connection conexion = null;
        PreparedStatement ps = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setString(1, producto.getNombre());
            ps.setString(2, producto.getDescripcion());
            ps.setDouble(3, producto.getPrecio());
            ps.setInt   (4, producto.getIdCategoria());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[ProductoDAO.insertar] " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(ps, conexion);
        }
    }

    // ── SELECT ALL ───────────────────────────────────────────────
    /**
     * Retorna todos los productos con el nombre de su categoría (JOIN).
     */
    public List<Producto> obtenerTodos() {
        String sql = """
                SELECT p.id_producto, p.nombre, p.descripcion, p.precio,
                       p.id_categoria, c.nombre_categoria
                FROM productos p
                INNER JOIN categorias c ON p.id_categoria = c.id_categoria
                ORDER BY p.id_producto ASC
                """;
        List<Producto> lista = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
        } catch (SQLException e) {
            System.err.println("[ProductoDAO.obtenerTodos] " + e.getMessage());
        } finally {
            cerrarRecursos(rs, ps, conexion);
        }
        return lista;
    }

    // ── SELECT BY ID ─────────────────────────────────────────────
    /**
     * Retorna un producto por su ID, incluye nombre de categoría.
     * @return Producto encontrado o null si no existe
     */
    public Producto obtenerPorId(int idProducto) {
        String sql = """
                SELECT p.id_producto, p.nombre, p.descripcion, p.precio,
                       p.id_categoria, c.nombre_categoria
                FROM productos p
                INNER JOIN categorias c ON p.id_categoria = c.id_categoria
                WHERE p.id_producto = ?
                """;
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setInt(1, idProducto);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapearProducto(rs);
            }
        } catch (SQLException e) {
            System.err.println("[ProductoDAO.obtenerPorId] " + e.getMessage());
        } finally {
            cerrarRecursos(rs, ps, conexion);
        }
        return null;
    }

    // ── UPDATE ───────────────────────────────────────────────────
    /**
     * Actualiza los datos de un producto existente.
     * @return true si se actualizó correctamente
     */
    public boolean actualizar(Producto producto) {
        String sql = """
                UPDATE productos
                SET nombre = ?, descripcion = ?, precio = ?, id_categoria = ?
                WHERE id_producto = ?
                """;
        Connection conexion = null;
        PreparedStatement ps = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setString(1, producto.getNombre());
            ps.setString(2, producto.getDescripcion());
            ps.setDouble(3, producto.getPrecio());
            ps.setInt   (4, producto.getIdCategoria());
            ps.setInt   (5, producto.getIdProducto());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[ProductoDAO.actualizar] " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(ps, conexion);
        }
    }

    // ── DELETE ───────────────────────────────────────────────────
    /**
     * Elimina un producto por su ID.
     * Nota: eliminará en cascada sus variantes (ON DELETE CASCADE en BD).
     * @return true si se eliminó correctamente
     */
    public boolean eliminar(int idProducto) {
        String sql = "DELETE FROM productos WHERE id_producto = ?";
        Connection conexion = null;
        PreparedStatement ps = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setInt(1, idProducto);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[ProductoDAO.eliminar] " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(ps, conexion);
        }
    }

    // ── MAPPER ───────────────────────────────────────────────────
    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setIdProducto     (rs.getInt   ("id_producto"));
        p.setNombre         (rs.getString("nombre"));
        p.setDescripcion    (rs.getString("descripcion"));
        p.setPrecio         (rs.getDouble("precio"));
        p.setIdCategoria    (rs.getInt   ("id_categoria"));
        p.setCategoriaNombre(rs.getString("nombre_categoria"));
        return p;
    }

    // ── CIERRE DE RECURSOS ────────────────────────────────────────
    private void cerrarRecursos(PreparedStatement ps, Connection conexion) {
        cerrarRecursos(null, ps, conexion);
    }

    private void cerrarRecursos(ResultSet rs, PreparedStatement ps, Connection conexion) {
        try { if (rs  != null) rs.close();  } catch (SQLException e) { System.err.println(e.getMessage()); }
        try { if (ps  != null) ps.close();  } catch (SQLException e) { System.err.println(e.getMessage()); }
        ConexionDB.cerrarConexion(conexion);
    }
}