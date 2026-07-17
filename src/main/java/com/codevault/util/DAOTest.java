package com.codevault.util;

import com.codevault.dao.UserDAO;
import com.codevault.model.User;

public class DAOTest {

    public static void main(String[] args) {

        User user = new User();

        user.setUsername("Abhishek");
        user.setEmail("abhishek@gmail.com");
        user.setPassword("123456");

        UserDAO dao = new UserDAO();

        boolean result = dao.registerUser(user);

        if (result) {

            System.out.println("User Registered Successfully!");

        } else {

            System.out.println("Registration Failed!");

        }

    }

}