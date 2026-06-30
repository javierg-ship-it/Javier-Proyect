package com.stylestock.model;

import java.time.LocalDateTime;

public class Usuario {

    private int           idUsuario;
    private String        usuario;
    private String        nombre;
    private String        correo;
    private String        contrasena;
    private String        telefono;
    private LocalDateTime fechaRegistro;
    private int           estado;
    private int           idRol;

    public Usuario() {}

    public Usuario(String usuario, String nombre, String correo,
                   String contrasena, int idRol) {
        this.usuario   = usuario;
        this.nombre    = nombre;
        this.correo    = correo;
        this.contrasena = contrasena;
        this.idRol     = idRol;
    }

    // ── Getters y Setters ──

    public int getIdUsuario()              { return idUsuario; }
    public void setIdUsuario(int v)        { this.idUsuario = v; }

    public String getUsuario()             { return usuario; }
    public void setUsuario(String v)       { this.usuario = v; }

    public String getNombre()              { return nombre; }
    public void setNombre(String v)        { this.nombre = v; }

    public String getCorreo()              { return correo; }
    public void setCorreo(String v)        { this.correo = v; }

    public String getContrasena()          { return contrasena; }
    public void setContrasena(String v)    { this.contrasena = v; }

    public String getTelefono()            { return telefono; }
    public void setTelefono(String v)      { this.telefono = v; }

    public LocalDateTime getFechaRegistro()         { return fechaRegistro; }
    public void setFechaRegistro(LocalDateTime v)   { this.fechaRegistro = v; }

    public int getEstado()                 { return estado; }
    public void setEstado(int v)           { this.estado = v; }

    public int getIdRol()                  { return idRol; }
    public void setIdRol(int v)            { this.idRol = v; }
}