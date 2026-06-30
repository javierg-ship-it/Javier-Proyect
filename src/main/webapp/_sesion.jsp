<<%@ page contentType="text/html;charset=UTF-8" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("id_rol") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String nombreSesion  = (String)  s.getAttribute("nombre");
    String usuarioSesion = (String)  s.getAttribute("usuario");
    int    rolSesion     = (Integer) s.getAttribute("id_rol");
%>