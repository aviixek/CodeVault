package com.codevault.model;

import java.sql.Timestamp;

public class Snippet {

    private int id;
    private String title;
    private String language;
    private String code;
    private String description;
    private Timestamp createdAt;
    private int userId;

    public Snippet() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
    public String getPreviewCode() {

        if(code == null)
            return "";

        String[] lines = code.split("\n");

        StringBuilder preview = new StringBuilder();

        int limit = Math.min(lines.length, 6);

        for(int i = 0; i < limit; i++) {

            preview.append(lines[i]);

            if(i < limit - 1)
                preview.append("\n");

        }

        if(lines.length > 6)
            preview.append("\n...");

        return preview.toString();

    }

}