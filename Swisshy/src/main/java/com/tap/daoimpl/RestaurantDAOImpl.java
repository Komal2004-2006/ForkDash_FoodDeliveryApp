package com.tap.daoimpl;

import com.tap.dao.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.util.DBUtil;

import java.sql.*;
import java.util.*;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String INSERT_RESTAURANT =
        "INSERT INTO restaurants (name, cuisine, location, image_url, owner_id, rating, eta, description, offer) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_ALL =
        "SELECT * FROM restaurants";

    private static final String GET_BY_ID =
        "SELECT * FROM restaurants WHERE id = ?";

    @Override
    public int addRestaurant(Restaurant r) {
        int result = 0;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(INSERT_RESTAURANT)) {

            pst.setString(1, r.getName());
            pst.setString(2, r.getCuisine());
            pst.setString(3, r.getLocation());
            pst.setString(4, r.getImageUrl());
            pst.setInt(5,    r.getOwnerId());
            pst.setString(6, r.getRating());
            pst.setString(7, r.getEta());
            pst.setString(8, r.getDescription());
            pst.setString(9, r.getOffer());

            result = pst.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(GET_ALL)) {

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(new Restaurant(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("cuisine"),
                    rs.getString("location"),
                    rs.getString("image_url"),
                    rs.getInt("owner_id"),
                    rs.getString("rating"),
                    rs.getString("eta"),
                    rs.getString("description"),
                    rs.getString("offer")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Restaurant getRestaurantById(int id) {
        Restaurant r = null;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(GET_BY_ID)) {

            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                r = new Restaurant(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("cuisine"),
                    rs.getString("location"),
                    rs.getString("image_url"),
                    rs.getInt("owner_id"),
                    rs.getString("rating"),
                    rs.getString("eta"),
                    rs.getString("description"),
                    rs.getString("offer")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }
}