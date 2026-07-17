package com.codevault.util;

import com.codevault.model.User;

public class ModelTest {

    public static void main(String[] args) {

        User user = new User();

        user.setUsername("Abhishek");
        user.setEmail("abhishek@gmail.com");
        user.setPassword("123456");

        System.out.println("Username : " + user.getUsername());
        System.out.println("Email    : " + user.getEmail());
        System.out.println("Password : " + user.getPassword());
    }
}