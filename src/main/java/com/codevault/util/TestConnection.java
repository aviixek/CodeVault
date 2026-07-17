package com.codevault.util;

import java.sql.Connection;

public class TestConnection {

    public static void main(String[] args) {

        Connection con = DBConnection.getConnection();

        if (con != null) {
            System.out.println("Connection Test Successful!");
        } else {
            System.out.println("Connection Test Failed!");
        }
    }
}
