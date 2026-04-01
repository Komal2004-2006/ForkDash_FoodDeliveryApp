package com.tap.servlet;

import com.tap.dao.MenuDAO;
import com.tap.daoimpl.MenuDAOImpl;
import com.tap.model.MenuItem;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;


public class MenuServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String restaurantName = request.getParameter("restaurant");
        if (restaurantName == null || restaurantName.isEmpty()) {
            response.sendRedirect("restaurant");
            return;
        }

        MenuDAO menuDAO = new MenuDAOImpl();
        List<MenuItem> menuList = menuDAO.getMenuByRestaurant(restaurantName);

        request.setAttribute("menuList",       menuList);
        request.setAttribute("restaurantName", restaurantName);
        request.getRequestDispatcher("/menu.jsp")
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

        String restaurant  = request.getParameter("restaurant");
        String itemName    = request.getParameter("item_name");
        String description = request.getParameter("description");
        String category    = request.getParameter("category");
        double price       = Double.parseDouble(request.getParameter("price"));

        MenuItem item = new MenuItem(0, restaurant, itemName,
                                     description, price, category);

        MenuDAO menuDAO = new MenuDAOImpl();
        int result = menuDAO.addMenuItem(item);

        if (result > 0) {
            response.sendRedirect("addMenu.html?status=success");
        } else {
            response.sendRedirect("addMenu.html?status=failed");
        }
    }
}