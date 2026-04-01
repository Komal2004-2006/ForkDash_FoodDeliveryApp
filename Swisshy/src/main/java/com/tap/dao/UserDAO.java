package com.tap.dao;

import com.tap.model.User;

public interface UserDAO {
    int registerUser(User user);
    User loginUser(String email, String password);
}