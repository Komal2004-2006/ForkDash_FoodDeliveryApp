package com.tap.dao;

import com.tap.model.MenuItem;
import java.util.List;

public interface MenuDAO {
    int addMenuItem(MenuItem item);
    List<MenuItem> getMenuByRestaurant(String restaurantName);
}