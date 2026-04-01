package com.tap.servlet;

import com.tap.model.Cart;
import com.tap.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class CartServlet extends HttpServlet {

    // GET — show cart page
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    // POST — add / remove / increase / decrease / clear
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        // Get or create cart from session
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            int    itemId     = Integer.parseInt(request.getParameter("itemId"));
            String itemName   = request.getParameter("itemName");
            double itemPrice  = Double.parseDouble(request.getParameter("itemPrice"));
            String restaurant = request.getParameter("restaurant");

            // If cart has items from a DIFFERENT restaurant, clear it first
            if (!cart.isEmpty() && !cart.getItems().get(0).getRestaurant().equals(restaurant)) {
                cart.clear();
            }

            CartItem item = new CartItem(itemId, itemName, itemPrice, 1, restaurant);
            cart.addItem(item);
            session.setAttribute("cart", cart);

            // Redirect to cart page
            response.sendRedirect("cart");

        } else if ("remove".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            cart.removeItem(itemId);
            session.setAttribute("cart", cart);
            response.sendRedirect("cart");

        } else if ("increase".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            cart.increaseQty(itemId);
            session.setAttribute("cart", cart);
            response.sendRedirect("cart");

        } else if ("decrease".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            cart.decreaseQty(itemId);
            session.setAttribute("cart", cart);
            response.sendRedirect("cart");

        } else if ("clear".equals(action)) {
            cart.clear();
            session.setAttribute("cart", cart);
            response.sendRedirect("cart");

        } else {
            response.sendRedirect("cart");
        }
    }
}
