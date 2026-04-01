package com.tap.servlet;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


public class RegistrationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String phone    = request.getParameter("phone");
        String role     = request.getParameter("role");

        if (role == null || role.isEmpty()) {
            role = "customer";
        }

        User user = new User(0, name, email, password, phone, role);

        UserDAO userDAO = new UserDAOImpl();
        int result = userDAO.registerUser(user);

        if (result > 0) {
            response.sendRedirect("login.html?status=success");
        } else {
            response.sendRedirect("registration.html?status=failed");
        }
    }
}