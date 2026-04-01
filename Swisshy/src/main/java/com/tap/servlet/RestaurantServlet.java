package com.tap.servlet;

import com.tap.dao.RestaurantDAO;
import com.tap.daoimpl.RestaurantDAOImpl;
import com.tap.model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


public class RestaurantServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        RestaurantDAO dao = new RestaurantDAOImpl();
        request.setAttribute("restaurants", dao.getAllRestaurants());
        request.getRequestDispatcher("/restaurant.jsp")
               .forward(request, response);
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!role.equals("restaurant_admin")) {
            response.sendRedirect("login.html");
            return;
        }

        String name        = request.getParameter("name");
        String cuisine     = request.getParameter("cuisine");
        String location    = request.getParameter("location");
        String imageUrl    = request.getParameter("imageUrl");
        String rating      = request.getParameter("rating");
        String eta         = request.getParameter("eta");
        String description = request.getParameter("description");
        String offer       = request.getParameter("offer");
        int ownerId        = (int) session.getAttribute("userId");

        Restaurant r = new Restaurant(0, name, cuisine, location,
                                      imageUrl, ownerId, rating,
                                      eta, description, offer);

        RestaurantDAO dao = new RestaurantDAOImpl();
        int result = dao.addRestaurant(r);

        if (result > 0) {
            response.sendRedirect("addRestaurant.html?status=success");
        } else {
            response.sendRedirect("addRestaurant.html?status=failed");
        }
    }
}