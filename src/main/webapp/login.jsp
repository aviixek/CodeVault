<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - CodeVault</title>

<style>

body{
    margin:0;
    padding:0;
    font-family:Arial,sans-serif;
    background:#f4f4f4;
}

.container{
    width:400px;
    margin:80px auto;
    background:white;
    padding:30px;
    border-radius:10px;
    box-shadow:0 0 10px rgba(0,0,0,.2);
}

h2{
    text-align:center;
}

input{
    width:100%;
    padding:10px;
    margin-top:10px;
    margin-bottom:20px;
    box-sizing:border-box;
}

button{
    width:100%;
    padding:12px;
    background:#28a745;
    color:white;
    border:none;
    border-radius:5px;
    cursor:pointer;
    font-size:16px;
}

button:hover{
    background:#1e7e34;
}

p{
    text-align:center;
}

a{
    text-decoration:none;
}

</style>

</head>

<body>

<div class="container">

<h2>CodeVault Login</h2>

<form action="login" method="post">

<input
type="email"
name="email"
placeholder="Enter Email"
required>

<input
type="password"
name="password"
placeholder="Enter Password"
required>

<button type="submit">

Login

</button>

</form>

<p>

Don't have an account?

<a href="register.jsp">

Register

</a>

</p>

</div>

</body>
</html>