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

public class DeliveryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"delivery_agent".equals(role)) {
            response.sendRedirect("login.html");
            return;
        }

        int    agentId   = (int)    session.getAttribute("userId");
        String agentName = (String) session.getAttribute("userName");

        try (Connection conn = DBUtil.getConnection()) {

            // 1. All orders with status = Ready (available for pickup)
            List<Map<String, String>> availableOrders = new ArrayList<>();
            String availSQL = "SELECT * FROM orders WHERE status = 'Ready' ORDER BY created_at DESC";
            PreparedStatement ps1 = conn.prepareStatement(availSQL);
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                availableOrders.add(mapOrder(rs1));
            }
            request.setAttribute("availableOrders", availableOrders);

            // 2. My active deliveries
            List<Map<String, String>> myDeliveries = new ArrayList<>();
            String mySQL = "SELECT * FROM orders WHERE delivery_agent_id = ? AND status = 'Out for Delivery' ORDER BY created_at DESC";
            PreparedStatement ps2 = conn.prepareStatement(mySQL);
            ps2.setInt(1, agentId);
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                myDeliveries.add(mapOrder(rs2));
            }
            request.setAttribute("myDeliveries", myDeliveries);

            // 3. My delivery history
            List<Map<String, String>> history = new ArrayList<>();
            String histSQL = "SELECT * FROM orders WHERE delivery_agent_id = ? AND status = 'Delivered' ORDER BY created_at DESC";
            PreparedStatement ps3 = conn.prepareStatement(histSQL);
            ps3.setInt(1, agentId);
            ResultSet rs3 = ps3.executeQuery();
            while (rs3.next()) {
                history.add(mapOrder(rs3));
            }
            request.setAttribute("history", history);

            // Debug — print to console
            System.out.println("=== DELIVERY DEBUG ===");
            System.out.println("Agent ID: " + agentId);
            System.out.println("Available orders: " + availableOrders.size());
            System.out.println("My deliveries: " + myDeliveries.size());
            System.out.println("History: " + history.size());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/delivery.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        int    agentId   = (int)    session.getAttribute("userId");
        String agentName = (String) session.getAttribute("userName");
        String action    = request.getParameter("action");
        int    orderId   = Integer.parseInt(request.getParameter("orderId"));

        try (Connection conn = DBUtil.getConnection()) {

            if ("accept".equals(action)) {
                String sql = "UPDATE orders SET status = 'Out for Delivery', delivery_agent_id = ?, delivery_agent_name = ? WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, agentId);
                ps.setString(2, agentName);
                ps.setInt(3, orderId);
                ps.executeUpdate();

            } else if ("deliver".equals(action)) {
                String sql = "UPDATE orders SET status = 'Delivered' WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("delivery");
    }

    private Map<String, String> mapOrder(ResultSet rs) throws SQLException {
        Map<String, String> order = new HashMap<>();
        order.put("id",              String.valueOf(rs.getInt("id")));
        order.put("user_name",       rs.getString("user_name"));
        order.put("total",           String.valueOf(rs.getDouble("total")));
        order.put("address",         rs.getString("address"));
        order.put("phone",           rs.getString("phone"));
        order.put("status",          rs.getString("status"));
        order.put("restaurant_name", rs.getString("restaurant_name") != null ? rs.getString("restaurant_name") : "");
        order.put("created_at",      rs.getString("created_at"));
        return order;
    }
}
