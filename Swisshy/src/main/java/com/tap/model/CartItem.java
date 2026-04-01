package com.tap.model;

public class CartItem {
    private int itemId;
    private String itemName;
    private double price;
    private int quantity;
    private String restaurant;

    public CartItem() {}

    public CartItem(int itemId, String itemName, double price, int quantity, String restaurant) {
        this.itemId     = itemId;
        this.itemName   = itemName;
        this.price      = price;
        this.quantity   = quantity;
        this.restaurant = restaurant;
    }

    public double getSubtotal() {
        return price * quantity;
    }

    // Getters & Setters
    public int    getItemId()            { return itemId; }
    public void   setItemId(int i)       { this.itemId = i; }
    public String getItemName()          { return itemName; }
    public void   setItemName(String n)  { this.itemName = n; }
    public double getPrice()             { return price; }
    public void   setPrice(double p)     { this.price = p; }
    public int    getQuantity()          { return quantity; }
    public void   setQuantity(int q)     { this.quantity = q; }
    public String getRestaurant()        { return restaurant; }
    public void   setRestaurant(String r){ this.restaurant = r; }
}