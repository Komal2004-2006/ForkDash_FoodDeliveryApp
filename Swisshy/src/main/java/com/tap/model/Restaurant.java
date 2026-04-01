package com.tap.model;

public class Restaurant {
    private int id;
    private String name;
    private String cuisine;
    private String location;
    private String imageUrl;
    private int ownerId;
    private String rating;
    private String eta;
    private String description;
    private String offer;

    public Restaurant() {}

    public Restaurant(int id, String name, String cuisine, String location,
                      String imageUrl, int ownerId, String rating,
                      String eta, String description, String offer) {
        this.id = id;
        this.name = name;
        this.cuisine = cuisine;
        this.location = location;
        this.imageUrl = imageUrl;
        this.ownerId = ownerId;
        this.rating = rating;
        this.eta = eta;
        this.description = description;
        this.offer = offer;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCuisine() { return cuisine; }
    public void setCuisine(String cuisine) { this.cuisine = cuisine; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public String getRating() { return rating; }
    public void setRating(String rating) { this.rating = rating; }

    public String getEta() { return eta; }
    public void setEta(String eta) { this.eta = eta; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getOffer() { return offer; }
    public void setOffer(String offer) { this.offer = offer; }
}