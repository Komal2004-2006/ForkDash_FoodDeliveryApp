package com.tap.dao;

import com.tap.model.Restaurant;
import java.util.List;

public interface RestaurantDAO {
    int addRestaurant(Restaurant r);
    List<Restaurant> getAllRestaurants();
    Restaurant getRestaurantById(int id);
}