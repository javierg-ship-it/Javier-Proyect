package com.stylestock.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    private static final String URL =
            "jdbc:mysql://localhost:3306/Tienda_ropa?useSSL=false&serverTimezone=America/Bogota&allowPublicKeyRetrieval=true";

    private static final String USUARIO = "root";
    private static final String PASSWORD = "011007Javi&";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver MySQL cargado correctamente.");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("No se encontró el Driver JDBC de MySQL.", e);
        }
    }

    private ConexionDB() {}

    public static Connection obtenerConexion() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, PASSWORD);
    }

    public static void cerrarConexion(Connection conexion) {
        if (conexion != null) {
            try {
                conexion.close();
            } catch (SQLException e) {
                System.err.println(e.getMessage());
            }
        }
    }
}