package com.stylestock.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Set;

@WebFilter("/*")
public class FiltroSeguridad implements Filter {

    // Rutas públicas — NO requieren sesión
    private static final Set<String> RUTAS_PUBLICAS = Set.of(
        "/",
        "/index.jsp",
        "/login.jsp",
        "/registro.jsp",
        "/api/usuarios",
        "/api/sesion"
    );

    // Rutas exclusivas del Administrador (id_rol = 1)
    private static final Set<String> RUTAS_SOLO_ADMIN = Set.of(
        "/usuarios.jsp"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req        = (HttpServletRequest)  request;
        HttpServletResponse resp       = (HttpServletResponse) response;
        String              contextPath = req.getContextPath();
        String              uri        = req.getRequestURI();
        String              ruta       = uri.substring(contextPath.length());

        // 1. Recursos estáticos — siempre pasan
        if (ruta.startsWith("/css/") || ruta.startsWith("/js/")
                || ruta.startsWith("/img/") || ruta.startsWith("/WEB-INF/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Rutas públicas — siempre pasan
        if (RUTAS_PUBLICAS.contains(ruta)) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Verificar sesión
        HttpSession sesion = req.getSession(false);
        Integer     idRol  = (sesion != null)
                             ? (Integer) sesion.getAttribute("id_rol")
                             : null;

        // Sin sesión → login
        if (sesion == null || idRol == null) {
            resp.sendRedirect(contextPath + "/index.jsp");
            return;
        }

        // 4. Solo Administrador puede entrar a ciertas rutas
        if (RUTAS_SOLO_ADMIN.contains(ruta) && idRol != 1) {
            resp.sendRedirect(contextPath + "/menu.jsp");
            return;
        }

        // 5. Acceso permitido
        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}