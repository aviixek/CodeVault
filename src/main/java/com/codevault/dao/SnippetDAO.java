package com.codevault.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.codevault.model.Snippet;
import com.codevault.util.DBConnection;

public class SnippetDAO {

    public boolean addSnippet(Snippet snippet) {

        boolean status = false;

        String sql =
        		"INSERT INTO snippets(title,language,description,code,user_id) VALUES(?,?,?,?,?)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, snippet.getTitle());
            ps.setString(2, snippet.getLanguage());
            ps.setString(3, snippet.getDescription());
            ps.setString(4, snippet.getCode());
            ps.setInt(5, snippet.getUserId());

            int rows = ps.executeUpdate();

            if(rows > 0) {

                status = true;

            }

            con.close();

        }
        catch(Exception e) {

            e.printStackTrace();

        }

        return status;

    }
    public boolean deleteSnippet(int id) {

        boolean status = false;

        String sql = "DELETE FROM snippets WHERE id=?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            int rows = ps.executeUpdate();

            if(rows > 0) {
                status = true;
            }

            con.close();

        } catch(Exception e) {
            e.printStackTrace();
        }

        return status;

    }
    public Snippet getSnippetById(int id) {

        Snippet snippet = null;

        String sql = "SELECT * FROM snippets WHERE id=?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                snippet = new Snippet();

                snippet.setId(rs.getInt("id"));
                snippet.setTitle(rs.getString("title"));
                snippet.setLanguage(rs.getString("language"));
                snippet.setDescription(rs.getString("description"));
                snippet.setCode(rs.getString("code"));

            }

            con.close();

        }
        catch(Exception e){

            e.printStackTrace();

        }

        return snippet;

    }
    public boolean updateSnippet(Snippet snippet) {

        boolean status = false;

        String sql =
        "UPDATE snippets SET title=?, language=?, description=?, code=? WHERE id=?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, snippet.getTitle());
            ps.setString(2, snippet.getLanguage());
            ps.setString(3, snippet.getDescription());
            ps.setString(4, snippet.getCode());
            ps.setInt(5, snippet.getId());

            int rows = ps.executeUpdate();

            if(rows > 0){

                status = true;

            }

            con.close();

        }
        catch(Exception e){

            e.printStackTrace();

        }

        return status;

    }

    public List<Snippet> getAllSnippets(int userId) {

        List<Snippet> snippets = new ArrayList<>();

        String sql = "SELECT * FROM snippets WHERE user_id = ? ORDER BY created_at DESC";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                Snippet snippet = new Snippet();

                snippet.setId(rs.getInt("id"));
                snippet.setTitle(rs.getString("title"));
                snippet.setLanguage(rs.getString("language"));
                snippet.setCode(rs.getString("code"));
                snippet.setDescription(rs.getString("description"));
                snippet.setCreatedAt(rs.getTimestamp("created_at"));

                snippets.add(snippet);

            }

            con.close();

        }
        catch(Exception e) {

            e.printStackTrace();

        }

        return snippets;

    }
    public int getTotalSnippets() {

        int total = 0;

        String sql = "SELECT COUNT(*) FROM snippets";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

}