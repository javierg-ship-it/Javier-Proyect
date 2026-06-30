package com.stylestock.servlet;

import com.stylestock.dao.UsuarioDAO;
import com.stylestock.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/usuarios")
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    // ══════════════════════════
    //  POST — Registro de usuario
    // ══════════════════════════
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        if ("login".equals(action)) {
            doLogin(req, resp);
        } else {
            doRegistro(req, resp);
        }
    }

    // ── Registro ──
    private void doRegistro(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String usuario    = param(req, "usuario");
        String nombre     = param(req, "nombre");
        String correo     = param(req, "correo");
        String contrasena = param(req, "contrasena");

        // Validación: campos obligatorios
        if (usuario.isEmpty() || nombre.isEmpty() ||
            correo.isEmpty()  || contrasena.isEmpty()) {
            reenviarRegistro(req, resp, "error",
                "Todos los campos son obligatorios.");
            return;
        }

        try {
            // Validación: usuario duplicado
            if (dao.existeUsuario(usuario)) {
                reenviarRegistro(req, resp, "error",
                    "El nombre de usuario ya está en uso.");
                return;
            }

            // Validación: correo duplicado
            if (dao.existeCorreo(correo)) {
                reenviarRegistro(req, resp, "error",
                    "El correo ya está registrado.");
                return;
            }

            // El rol SIEMPRE es 3 (Cliente) — nunca viene del formulario
            Usuario u = new Usuario(usuario, nombre, correo, contrasena, 3);

            if (dao.insertar(u)) {
                // Éxito: redirigir al login con mensaje
                resp.sendRedirect(req.getContextPath() +
                    "/index.jsp?registrado=true");
            } else {
                reenviarRegistro(req, resp, "error",
                    "No se pudo crear la cuenta. Intenta de nuevo.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            reenviarRegistro(req, resp, "error",
                "Error del servidor. Intenta más tarde.");
        }
    }

    // ── Login ──
    private void doLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String usuario    = param(req, "usuario");
        String contrasena = param(req, "contrasena");

        if (usuario.isEmpty() || contrasena.isEmpty()) {
            reenviarLogin(req, resp, "Completa todos los campos.");
            return;
        }

        try {
            Usuario u = dao.login(usuario, contrasena);

            if (u != null) {
                if (u.getEstado() == 0) {
                    reenviarLogin(req, resp,
                        "Tu cuenta está desactivada. Contacta al administrador.");
                    return;
                }

                // Crear sesión
                HttpSession sesion = req.getSession(true);
                sesion.setAttribute("id_usuario", u.getIdUsuario());
                sesion.setAttribute("nombre",     u.getNombre());
                sesion.setAttribute("usuario",    u.getUsuario());
                sesion.setAttribute("id_rol",     u.getIdRol());

                // Redirigir según rol
                String destino = u.getIdRol() == 3
                    ? req.getContextPath() + "/tienda.jsp"
                    : req.getContextPath() + "/menu.jsp";

                resp.sendRedirect(destino);

            } else {
                // Distinguir: ¿el usuario existe? → contraseña incorrecta
                //             ¿no existe?         → usuario inexistente
                String msg = dao.existeNombreUsuario(usuario)
                    ? "Contraseña incorrecta."
                    : "El usuario no existe.";
                reenviarLogin(req, resp, msg);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            reenviarLogin(req, resp, "Error del servidor. Intenta más tarde.");
        }
    }

    // ══════════════════════════
    //  GET — no utilizado en este módulo
    // ══════════════════════════
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    // ── Helpers ──

    private String param(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return (v == null) ? "" : v.trim();
    }

    private void reenviarRegistro(HttpServletRequest req,
                                   HttpServletResponse resp,
                                   String tipo, String msg)
            throws ServletException, IOException {
        req.setAttribute("tipo", tipo);
        req.setAttribute("msg",  msg);
        req.getRequestDispatcher("/registro.jsp").forward(req, resp);
    }

    private void reenviarLogin(HttpServletRequest req,
                                HttpServletResponse resp,
                                String msg)
            throws ServletException, IOException {
        req.setAttribute("loginError", msg);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}