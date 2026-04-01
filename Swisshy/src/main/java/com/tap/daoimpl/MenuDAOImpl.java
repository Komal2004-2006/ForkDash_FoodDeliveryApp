package com.tap.daoimpl;

import com.tap.dao.MenuDAO;
import com.tap.model.MenuItem;
import com.tap.util.DBUtil;

import java.sql.*;
import java.util.*;

public class MenuDAOImpl implements MenuDAO {

    private static final String INSERT_MENU =
        "INSERT INTO menu (restaurant, item_name, description, price, category) VALUES (?, ?, ?, ?, ?)";

    private static final String GET_MENU =
        "SELECT * FROM menu WHERE restaurant = ?";

    @Override
    public int addMenuItem(MenuItem item) {
        int result = 0;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(INSERT_MENU)) {

            pst.setString(1, item.getRestaurant());
            pst.setString(2, item.getItemName());
            pst.setString(3, item.getDescription());
            pst.setDouble(4, item.getPrice());
            pst.setString(5, item.getCategory());

            result = pst.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public List<MenuItem> getMenuByRestaurant(String restaurantName) {
        List<MenuItem> menuList = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(GET_MENU)) {

            pst.setString(1, restaurantName);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                MenuItem item = new MenuItem(
                    rs.getInt("id"),
                    rs.getString("restaurant"),
                    rs.getString("item_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("category")
                );
                menuList.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menuList;
    }
}