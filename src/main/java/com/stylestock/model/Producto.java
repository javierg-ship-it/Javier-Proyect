package com.stylestock.model;

public class Producto {

    private int    idProducto;
    private String nombre;
    private String descripcion;
    private double precio;
    private int    idCategoria;
    private String categoriaNombre; // auxiliar para JOIN

    public Producto() {}

    public Producto(int idProducto, String nombre, String descripcion,
                    double precio, int idCategoria, String categoriaNombre) {
        this.idProducto      = idProducto;
        this.nombre          = nombre;
        this.descripcion     = descripcion;
        this.precio          = precio;
        this.idCategoria     = idCategoria;
        this.categoriaNombre = categoriaNombre;
    }

    public int    getIdProducto()      { return idProducto; }
    public void   setIdProducto(int v) { this.idProducto = v; }

    public String getNombre()          { return nombre; }
    public void   setNombre(String v)  { this.nombre = v; }

    public String getDescripcion()         { return descripcion; }
    public void   setDescripcion(String v) { this.descripcion = v; }

    public double getPrecio()          { return precio; }
    public void   setPrecio(double v)  { this.precio = v; }

    public int    getIdCategoria()     { return idCategoria; }
    public void   setIdCategoria(int v){ this.idCategoria = v; }

    public String getCategoriaNombre()         { return categoriaNombre; }
    public void   setCategoriaNombre(String v) { this.categoriaNombre = v; }

    @Override
    public String toString() {
        return "Producto{id=" + idProducto + ", nombre='" + nombre + "', precio=" + precio + "}";
    }
}