package com.tap.servlet;

import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.List;

public class CheckoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("restaurant");
            return;
        }
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("restaurant");
            return;
        }

        int    userId   = (int)    session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");
        String address  = request.getParameter("address");
        String phone    = request.getParameter("phone");
        double total    = cart.getTotal() * 1.05;

        // Get restaurant name from cart
        String restaurantName = cart.getItems().get(0).getRestaurant();

        try (Connection conn = DBUtil.getConnection()) {

            // 1. Insert order — now includes restaurant_name
            String orderSQL = "INSERT INTO orders (user_id, user_name, total, address, phone, status, restaurant_name) VALUES (?, ?, ?, ?, ?, 'Placed', ?)";
            PreparedStatement ps = conn.prepareStatement(orderSQL, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setString(2, userName);
            ps.setDouble(3, total);
            ps.setString(4, address);
            ps.setString(5, phone);
            ps.setString(6, restaurantName);
            ps.executeUpdate();

            // 2. Get generated order ID
            ResultSet rs = ps.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) orderId = rs.getInt(1);

            // 3. Insert order items
            String itemSQL = "INSERT INTO order_items (order_id, item_name, restaurant, price, quantity) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps2 = conn.prepareStatement(itemSQL);
            for (CartItem item : cart.getItems()) {
                ps2.setInt(1, orderId);
                ps2.setString(2, item.getItemName());
                ps2.setString(3, item.getRestaurant());
                ps2.setDouble(4, item.getPrice());
                ps2.setInt(5, item.getQuantity());
                ps2.executeUpdate();
            }

            // 4. Clear cart
            cart.clear();
            session.setAttribute("cart", cart);

            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastOrderTotal", String.format("%.0f", total));

            response.sendRedirect("orderConfirmation.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("checkout?error=Order failed. Please try again.");
        }
    }
}
