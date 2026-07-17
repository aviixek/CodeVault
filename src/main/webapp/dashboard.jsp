<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.codevault.model.Snippet" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard - CodeVault</title>

<style>

body{
    margin:0;
    font-family:Arial,sans-serif;
    background:#f4f4f4;
}

.header{
    background:#1f2937;
    color:white;
    padding:20px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.container{
    width:90%;
    margin:30px auto;
}

.card{
    background:white;
    padding:25px;
    border-radius:10px;
    box-shadow:0 0 10px rgba(0,0,0,.1);
}

button{

    padding:12px 25px;

    border:none;

    border-radius:5px;

    background:#2563eb;

    color:white;

    cursor:pointer;

}

</style>

</head>

<body>

<div class="header">

<h2>CodeVault Dashboard</h2>

<a href="login.jsp" style="color:white;">
Logout
</a>

</div>

<div class="container">

<div class="card">

<h2>Welcome to CodeVault 🎉</h2>

<p>

Store all your programming snippets in one place.

</p>

<br>

<button
onclick="location.href='addSnippet.jsp'">

Add New Snippet

</button>
<hr>

<h2>My Snippets</h2>

<table border="1" cellpadding="10" cellspacing="0" width="100%">

<tr>
    <th>ID</th>
    <th>Title</th>
    <th>Language</th>
    <th>Description</th>
    <th>Action</th>
</tr>

<%
List<Snippet> snippets =
(List<Snippet>)request.getAttribute("snippets");

if(snippets != null){

    for(Snippet s : snippets){
%>

<tr>

<td><%= s.getId() %></td>

<td><%= s.getTitle() %></td>

<td><%= s.getLanguage() %></td>

<td><%= s.getDescription() %></td>

<td>

<a href="editSnippet?id=<%= s.getId() %>">
Edit
</a>

&nbsp;&nbsp;

<a href="deleteSnippet?id=<%= s.getId() %>"
onclick="return confirm('Delete this snippet?')">

Delete

</a>

</td>

</tr>

<%
    }

}
%>

</table>

</div>

</div>

</body>
</html>