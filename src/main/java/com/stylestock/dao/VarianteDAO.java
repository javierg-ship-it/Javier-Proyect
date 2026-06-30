package com.stylestock.dao;

import com.stylestock.model.Variante;
import com.stylestock.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD sobre la tabla 'variantes_producto'.
 * El stock del inventario reside en esta tabla.
 */
public class VarianteDAO {

    // ── INSERT ──────────────────────────────────────────────────
    public boolean insertar(Variante variante) {
        String sql = "INSERT INTO variantes_producto (id_producto, color, talla, stock) VALUES (?, ?, ?, ?)";
        Connection conexion = null;
        PreparedStatement ps = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setInt   (1, variante.getIdProducto());
            ps.setString(2, variante.getColor());
            ps.setString(3, variante.getTalla());
            ps.setInt   (4, variante.getStock());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[VarianteDAO.insertar] " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(ps, conexion);
        }
    }

    // ── SELECT BY PRODUCTO ───────────────────────────────────────
    /**
     * Retorna todas las variantes de un producto específico.
     */
    public List<Variante> obtenerPorProducto(int idProducto) {
        String sql = """
                SELECT v.id_variante, v.id_producto, v.color, v.talla, v.stock,
                       p.nombre AS nombre_producto
                FROM variantes_producto v
                INNER JOIN productos p ON v.id_producto = p.id_producto
                WHERE v.id_producto = ?
                ORDER BY v.id_variante ASC
                """;
        List<Variante> lista = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setInt(1, idProducto);
            rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapearVariante(rs));
            }
        } catch (SQLException e) {
            System.err.println("[VarianteDAO.obtenerPorProducto] " + e.getMessage());
        } finally {
            cerrarRecursos(rs, ps, conexion);
        }
        return lista;
    }

    // ── SELECT ALL ───────────────────────────────────────────────
    /**
     * Retorna todas las variantes con nombre de producto (para inventario general).
     */
    public List<Variante> obtenerTodas() {
        String sql = """
                SELECT v.id_variante, v.id_producto, v.color, v.talla, v.stock,
                       p.nombre AS nombre_producto
                FROM variantes_producto v
                INNER JOIN productos p ON v.id_producto = p.id_producto
                ORDER BY p.nombre ASC, v.talla ASC
                """;
        List<Variante> lista = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapearVariante(rs));
            }
        } catch (SQLException e) {
            System.err.println("[VarianteDAO.obtenerTodas] " + e.getMessage());
        } finally {
            cerrarRecursos(rs, ps, conexion);
        }
        return lista;
    }

    // ── SELECT BY ID ─────────────────────────────────────────────
    public Variante obtenerPorId(int idVariante) {
        String sql = """
                SELECT v.id_variante, v.id_producto, v.color, v.talla, v.stock,
                       p.nombre AS nombre_producto
                FROM variantes_producto v
                INNER JOIN productos p ON v.id_producto = p.id_producto
                WHERE v.id_variante = ?
                """;
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setInt(1, idVariante);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapearVariante(rs);
            }
        } catch (SQLException e) {
            System.err.println("[VarianteDAO.obtenerPorId] " + e.getMessage());
        } finally {
            cerrarRecursos(rs, ps, conexion);
        }
        return null;
    }

    // ── UPDATE ───────────────────────────────────────────────────
    public boolean actualizar(Variante variante) {
        String sql = """
                UPDATE variantes_producto
                SET color = ?, talla = ?, stock = ?
                WHERE id_variante = ?
                """;
        Connection conexion = null;
        PreparedStatement ps = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setString(1, variante.getColor());
            ps.setString(2, variante.getTalla());
            ps.setInt   (3, variante.getStock());
            ps.setInt   (4, variante.getIdVariante());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[VarianteDAO.actualizar] " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(ps, conexion);
        }
    }

    // ── UPDATE STOCK ÚNICAMENTE ───────────────────────────────────
    /**
     * Actualiza solo el stock de una variante (operación de inventario).
     */
    public boolean actualizarStock(int idVariante, int nuevoStock) {
        String sql = "UPDATE variantes_producto SET stock = ? WHERE id_variante = ?";
        Connection conexion = null;
        PreparedStatement ps = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setInt(1, nuevoStock);
            ps.setInt(2, idVariante);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[VarianteDAO.actualizarStock] " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(ps, conexion);
        }
    }

    // ── DELETE ───────────────────────────────────────────────────
    public boolean eliminar(int idVariante) {
        String sql = "DELETE FROM variantes_producto WHERE id_variante = ?";
        Connection conexion = null;
        PreparedStatement ps = null;

        try {
            conexion = ConexionDB.obtenerConexion();
            ps = conexion.prepareStatement(sql);
            ps.setInt(1, idVariante);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[VarianteDAO.eliminar] " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(ps, conexion);
        }
    }

    // ── MAPPER ───────────────────────────────────────────────────
    private Variante mapearVariante(ResultSet rs) throws SQLException {
        Variante v = new Variante();
        v.setIdVariante    (rs.getInt   ("id_variante"));
        v.setIdProducto    (rs.getInt   ("id_producto"));
        v.setColor         (rs.getString("color"));
        v.setTalla         (rs.getString("talla"));
        v.setStock         (rs.getInt   ("stock"));
        v.setProductoNombre(rs.getString("nombre_producto"));
        return v;
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