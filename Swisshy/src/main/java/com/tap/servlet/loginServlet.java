package com.tap.servlet;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


public class loginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAOImpl();
        User user = userDAO.loginUser(email, password);

        if (user == null) {
            response.sendRedirect("login.html?status=failed");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("loggedUser", user);
        session.setAttribute("userId",     user.getUserId());
        session.setAttribute("userName",   user.getName());
        session.setAttribute("role",       user.getRole());

        switch (user.getRole()) {
            case "customer":
                response.sendRedirect("index.jsp");
                break;
            case "restaurant_admin":
                response.sendRedirect("restaurantAdmin");
                break;
            case "delivery_agent":
                response.sendRedirect("delivery.jsp");
                break;
            case "admin":
                response.sendRedirect("admin.jsp");
                break;
            default:
                response.sendRedirect("login.html?status=failed");
        }
    }
}