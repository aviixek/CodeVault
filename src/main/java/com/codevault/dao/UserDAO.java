package com.codevault.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

import com.codevault.model.User;
import com.codevault.util.DBConnection;

public class UserDAO {

    public boolean registerUser(User user) {

        boolean status = false;

        String sql = "INSERT INTO users(username,email,password) VALUES(?,?,?)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, user.getUsername());

            ps.setString(2, user.getEmail());

            ps.setString(3, user.getPassword());

            int rows = ps.executeUpdate();

            if (rows > 0) {

                status = true;

            }

            con.close();

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return status;

    }
    
    public boolean validateUser(String login, String password) {

        boolean status = false;

        String sql = "SELECT * FROM users WHERE (username=? OR email=?) AND password=?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, login);
            ps.setString(2, login);
            ps.setString(3, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                status = true;
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    
    public void displayAllUsers() {

        String sql = "SELECT * FROM users";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                System.out.println("---------------------------");
                System.out.println("ID : " + rs.getInt("id"));
                System.out.println("Username : " + rs.getString("username"));
                System.out.println("Email : " + rs.getString("email"));
                System.out.println("Password : " + rs.getString("password"));

            }

            con.close();

        } catch (SQLException e) {

            e.printStackTrace();

        }

    }

}

