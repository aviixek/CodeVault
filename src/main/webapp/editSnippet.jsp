<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.codevault.model.Snippet"%>

<%
Snippet snippet = (Snippet) request.getAttribute("snippet");
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Edit Snippet</title>

<style>

body{
    margin:0;
    background:#f4f4f4;
    font-family:Arial;
}

.container{

    width:700px;
    margin:40px auto;
    background:white;
    padding:30px;
    border-radius:10px;
    box-shadow:0 0 10px rgba(0,0,0,.2);

}

input,select,textarea{

    width:100%;
    padding:10px;
    margin-top:10px;
    margin-bottom:20px;
    box-sizing:border-box;

}

textarea{

    height:250px;
    resize:vertical;

}

button{

    padding:12px 25px;
    background:#2563eb;
    color:white;
    border:none;
    border-radius:5px;
    cursor:pointer;

}

button:hover{

    background:#1d4ed8;

}

</style>

</head>

<body>

<div class="container">

<h2>Edit Snippet</h2>

<form action="updateSnippet" method="post">

<input
type="hidden"
name="id"
value="<%= snippet.getId() %>">

<label>Title</label>

<input
type="text"
name="title"
value="<%= snippet.getTitle() %>"
required>

<label>Language</label>

<select name="language">

<option <%= snippet.getLanguage().equals("Java")?"selected":"" %>>
Java
</option>

<option <%= snippet.getLanguage().equals("Python")?"selected":"" %>>
Python
</option>

<option <%= snippet.getLanguage().equals("C++")?"selected":"" %>>
C++
</option>

<option <%= snippet.getLanguage().equals("JavaScript")?"selected":"" %>>
JavaScript
</option>

<option <%= snippet.getLanguage().equals("HTML")?"selected":"" %>>
HTML
</option>

<option <%= snippet.getLanguage().equals("CSS")?"selected":"" %>>
CSS
</option>

<option <%= snippet.getLanguage().equals("SQL")?"selected":"" %>>
SQL
</option>

</select>

<label>Description</label>

<input
type="text"
name="description"
value="<%= snippet.getDescription() %>">

<label>Code</label>

<textarea
name="code"
required><%= snippet.getCode() %></textarea>

<button type="submit">

Update Snippet

</button>

</form>

</div>

</body>

</html>