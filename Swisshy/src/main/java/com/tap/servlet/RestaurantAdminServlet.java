package com.tap.servlet;

import com.tap.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.*;

public class RestaurantAdminServlet extends HttpServlet {

    // GET — load dashboard data
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"restaurant_admin".equals(role)) {
            response.sendRedirect("login.html");
            return;
        }

        int ownerId = (int) session.getAttribute("userId");

        try (Connection conn = DBUtil.getConnection()) {

            // 1. Get this admin's restaurant
            String restSQL = "SELECT * FROM restaurants WHERE owner_id = ? LIMIT 1";
            PreparedStatement ps = conn.prepareStatement(restSQL);
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();

            Map<String, String> restaurant = new HashMap<>();
            String restaurantName = null;

            if (rs.next()) {
                restaurantName = rs.getString("name");
                restaurant.put("id",          String.valueOf(rs.getInt("id")));
                restaurant.put("name",         restaurantName);
                restaurant.put("cuisine",      rs.getString("cuisine"));
                restaurant.put("location",     rs.getString("location"));
                restaurant.put("rating",       rs.getString("rating"));
                restaurant.put("eta",          rs.getString("eta"));
                restaurant.put("description",  rs.getString("description") != null ? rs.getString("description") : "");
                restaurant.put("offer",        rs.getString("offer") != null ? rs.getString("offer") : "");
            }
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("restaurantName", restaurantName);

            // 2. Get menu items for this restaurant
            List<Map<String, String>> menuItems = new ArrayList<>();
            if (restaurantName != null) {
                String menuSQL = "SELECT * FROM menu WHERE restaurant = ?";
                PreparedStatement ps2 = conn.prepareStatement(menuSQL);
                ps2.setString(1, restaurantName);
                ResultSet rs2 = ps2.executeQuery();
                while (rs2.next()) {
                    Map<String, String> item = new HashMap<>();
                    item.put("id",          String.valueOf(rs2.getInt("id")));
                    item.put("item_name",   rs2.getString("item_name"));
                    item.put("price",       String.valueOf(rs2.getDouble("price")));
                    item.put("category",    rs2.getString("category"));
                    item.put("description", rs2.getString("description") != null ? rs2.getString("description") : "");
                    menuItems.add(item);
                }
            }
            request.setAttribute("menuItems", menuItems);

            // 3. Get incoming orders for this restaurant
            List<Map<String, String>> orders = new ArrayList<>();
            if (restaurantName != null) {
                String orderSQL = "SELECT * FROM orders WHERE restaurant_name = ? ORDER BY created_at DESC";
                PreparedStatement ps3 = conn.prepareStatement(orderSQL);
                ps3.setString(1, restaurantName);
                ResultSet rs3 = ps3.executeQuery();
                while (rs3.next()) {
                    Map<String, String> order = new HashMap<>();
                    order.put("id",         String.valueOf(rs3.getInt("id")));
                    order.put("user_name",  rs3.getString("user_name"));
                    order.put("total",      String.valueOf(rs3.getDouble("total")));
                    order.put("address",    rs3.getString("address"));
                    order.put("phone",      rs3.getString("phone"));
                    order.put("status",     rs3.getString("status"));
                    order.put("created_at", rs3.getString("created_at"));
                    orders.add(order);
                }
            }
            request.setAttribute("orders", orders);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/restaurantDashboard.jsp").forward(request, response);
    }

    // POST — update order status
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            int    orderId   = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");

            try (Connection conn = DBUtil.getConnection()) {
                String sql = "UPDATE orders SET status = ? WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, newStatus);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("restaurantAdmin");
    }
}