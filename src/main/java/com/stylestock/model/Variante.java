package com.stylestock.model;

public class Variante {

    private int    idVariante;
    private int    idProducto;
    private String color;
    private String talla;
    private int    stock;
    private String productoNombre; // auxiliar para JOIN

    public Variante() {}

    public Variante(int idVariante, int idProducto, String color,
                    String talla, int stock, String productoNombre) {
        this.idVariante     = idVariante;
        this.idProducto     = idProducto;
        this.color          = color;
        this.talla          = talla;
        this.stock          = stock;
        this.productoNombre = productoNombre;
    }

    public int    getIdVariante()      { return idVariante; }
    public void   setIdVariante(int v) { this.idVariante = v; }

    public int    getIdProducto()      { return idProducto; }
    public void   setIdProducto(int v) { this.idProducto = v; }

    public String getColor()           { return color; }
    public void   setColor(String v)   { this.color = v; }

    public String getTalla()           { return talla; }
    public void   setTalla(String v)   { this.talla = v; }

    public int    getStock()           { return stock; }
    public void   setStock(int v)      { this.stock = v; }

    public String getProductoNombre()          { return productoNombre; }
    public void   setProductoNombre(String v)  { this.productoNombre = v; }

    @Override
    public String toString() {
        return "Variante{id=" + idVariante + ", talla='" + talla + "', color='" + color + "', stock=" + stock + "}";
    }
}