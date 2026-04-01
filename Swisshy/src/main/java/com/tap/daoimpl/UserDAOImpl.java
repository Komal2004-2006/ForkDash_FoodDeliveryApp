package com.tap.daoimpl;

import com.tap.dao.UserDAO;
import com.tap.model.User;
import com.tap.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAOImpl implements UserDAO {

    private static final String INSERT_USER =
        "INSERT INTO users (uname, uemail,upwd, uphonenumber, role) VALUES (?, ?, ?, ?, ?)";

    private static final String LOGIN_USER =
        "SELECT * FROM users WHERE uemail = ? AND upwd = ?";

    @Override
    public int registerUser(User user) {
        int result = 0;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(INSERT_USER)) {

            pst.setString(1, user.getName());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPassword());
            pst.setString(4, user.getPhone());
            pst.setString(5, user.getRole());

            result = pst.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public User loginUser(String email, String password) {
        User user = null;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(LOGIN_USER)) {

            pst.setString(1, email);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                user = new User(
                    rs.getInt("id"),
                    rs.getString("uname"),
                    rs.getString("uemail"),
                    rs.getString("upwd"),
                    rs.getString("uphonenumber"),
                    rs.getString("role")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
}