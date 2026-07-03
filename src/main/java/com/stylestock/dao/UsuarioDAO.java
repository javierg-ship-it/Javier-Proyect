package com.stylestock.dao;

import com.stylestock.model.Usuario;
import com.stylestock.util.ConexionDB;

import java.sql.*;

public class UsuarioDAO {

    // ── Verificar si el nombre de usuario ya existe ──
    public boolean existeUsuario(String usuario) throws SQLException {
        String sql = "SELECT 1 FROM usuarios WHERE usuario = ?";
        Connection cn = ConexionDB.obtenerConexion();
        try (cn; PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } finally {
            ConexionDB.cerrarConexion(cn);
        }
    }

    // ── Verificar si el correo ya está registrado ──
    public boolean existeCorreo(String correo) throws SQLException {
        String sql = "SELECT 1 FROM usuarios WHERE correo = ?";
        Connection cn = ConexionDB.obtenerConexion();
        try (cn; PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } finally {
            ConexionDB.cerrarConexion(cn);
        }
    }

    // ── Insertar nuevo usuario (rol siempre 3 = Cliente) ──
    public boolean insertar(Usuario u) throws SQLException {

        String sql = "INSERT INTO usuarios (usuario, nombre, correo, contrasena, id_rol) VALUES (?, ?, ?, ?, ?)";

        System.out.println("=== INSERTANDO USUARIO ===");
        System.out.println("Usuario: " + u.getUsuario());
        System.out.println("Nombre : " + u.getNombre());
        System.out.println("Correo : " + u.getCorreo());
        System.out.println("Rol    : " + u.getIdRol());

        Connection cn = ConexionDB.obtenerConexion();

        try (PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, u.getUsuario());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getCorreo());
            ps.setString(4, u.getContrasena());
            ps.setInt(5, u.getIdRol());

            int filas = ps.executeUpdate();

            System.out.println("Filas insertadas: " + filas);

            return filas > 0;

        } finally {
        ConexionDB.cerrarConexion(cn);
        }
    }

    // ── Buscar usuario por nombre de usuario y contraseña (login) ──
    public Usuario login(String usuario, String contrasena) throws SQLException {
        String sql = "SELECT id_usuario, usuario, nombre, correo, id_rol, estado " +
                     "FROM usuarios WHERE usuario = ? AND contrasena = ?";
        Connection cn = ConexionDB.obtenerConexion();
        try (cn; PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, usuario);
            ps.setString(2, contrasena);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getInt("id_usuario"));
                    u.setUsuario(rs.getString("usuario"));
                    u.setNombre(rs.getString("nombre"));
                    u.setCorreo(rs.getString("correo"));
                    u.setIdRol(rs.getInt("id_rol"));
                    u.setEstado(rs.getInt("estado"));
                    return u;
                }
            }
        } finally {
            ConexionDB.cerrarConexion(cn);
        }
        return null;
    }

    // ── Verificar si el usuario existe (para distinguir error de login) ──
    public boolean existeNombreUsuario(String usuario) throws SQLException {
        String sql = "SELECT 1 FROM usuarios WHERE usuario = ?";
        Connection cn = ConexionDB.obtenerConexion();
        try (cn; PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } finally {
            ConexionDB.cerrarConexion(cn);
        }
    }
}