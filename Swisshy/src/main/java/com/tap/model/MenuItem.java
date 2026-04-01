package com.tap.model;

public class MenuItem {
    private int id;
    private String restaurant;
    private String itemName;
    private String description;
    private double price;
    private String category;

    public MenuItem() {}

    public MenuItem(int id, String restaurant, String itemName,
                    String description, double price, String category) {
        this.id = id;
        this.restaurant = restaurant;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.category = category;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRestaurant() { return restaurant; }
    public void setRestaurant(String restaurant) { this.restaurant = restaurant; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}