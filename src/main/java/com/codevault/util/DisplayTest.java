package com.codevault.util;

import com.codevault.dao.UserDAO;

public class DisplayTest {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        dao.displayAllUsers();

    }

}