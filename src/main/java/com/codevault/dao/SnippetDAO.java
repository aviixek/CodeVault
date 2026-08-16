package com.codevault.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.codevault.model.Snippet;
import com.codevault.util.DBConnection;

public class SnippetDAO {

    private static final Logger LOGGER = Logger.getLogger(SnippetDAO.class.getName());

    /**
     * Adds a new snippet. The userId comes from the server-side session,
     * never from the request.
     */
    public boolean addSnippet(Snippet snippet) {
        String sql = "INSERT INTO snippets(title, language, description, code, user_id) VALUES(?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, snippet.getTitle());
            ps.setString(2, snippet.getLanguage());
            ps.setString(3, snippet.getDescription());
            ps.setString(4, snippet.getCode());
            ps.setInt(5, snippet.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding snippet.", e);
            return false;
        }
    }

    /**
     * Deletes a snippet ONLY if it belongs to the specified user.
     * Authorization is enforced at the SQL level — user_id is always checked.
     *
     * @return true if a row was deleted (i.e. the user owns this snippet)
     */
    public boolean deleteSnippet(int id, int userId) {
        String sql = "DELETE FROM snippets WHERE id=? AND user_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting snippet.", e);
            return false;
        }
    }

    /**
     * Fetches a snippet ONLY if it belongs to the specified user.
     * Returns null if the snippet doesn't exist or doesn't belong to this user.
     */
    public Snippet getSnippetById(int id, int userId) {
        String sql = "SELECT * FROM snippets WHERE id=? AND user_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSnippet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching snippet by ID.", e);
        }

        return null;
    }

    /**
     * Updates a snippet ONLY if it belongs to the specified user.
     * Authorization is enforced at the SQL level.
     *
     * @return true if a row was updated (i.e. the user owns this snippet)
     */
    public boolean updateSnippet(Snippet snippet, int userId) {
        String sql = "UPDATE snippets SET title=?, language=?, description=?, code=? WHERE id=? AND user_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, snippet.getTitle());
            ps.setString(2, snippet.getLanguage());
            ps.setString(3, snippet.getDescription());
            ps.setString(4, snippet.getCode());
            ps.setInt(5, snippet.getId());
            ps.setInt(6, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating snippet.", e);
            return false;
        }
    }

    /**
     * Gets all snippets belonging to a specific user.
     */
    public List<Snippet> getAllSnippets(int userId) {
        List<Snippet> snippets = new ArrayList<>();
        String sql = "SELECT * FROM snippets WHERE user_id=? ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    snippets.add(mapSnippet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all snippets.", e);
        }

        return snippets;
    }

    /**
     * Gets distinct languages used by a specific user.
     */
    public List<String> getAllLanguages(int userId) {
        List<String> languages = new ArrayList<>();
        String sql = "SELECT DISTINCT language FROM snippets WHERE user_id=? ORDER BY language";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    languages.add(rs.getString("language"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching languages.", e);
        }

        return languages;
    }

    /**
     * Gets the timestamp of the most recently created snippet for a user.
     */
    public Timestamp getLastUpdated(int userId) {
        String sql = "SELECT MAX(created_at) AS last_updated FROM snippets WHERE user_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getTimestamp("last_updated");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching last updated timestamp.", e);
        }

        return null;
    }

    /**
     * Maps a ResultSet row to a Snippet object.
     */
    private Snippet mapSnippet(ResultSet rs) throws SQLException {
        Snippet snippet = new Snippet();
        snippet.setId(rs.getInt("id"));
        snippet.setTitle(rs.getString("title"));
        snippet.setLanguage(rs.getString("language"));
        snippet.setDescription(rs.getString("description"));
        snippet.setCode(rs.getString("code"));
        snippet.setUserId(rs.getInt("user_id"));
        snippet.setCreatedAt(rs.getTimestamp("created_at"));
        return snippet;
    }
}