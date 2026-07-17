<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Add Snippet</title>

<style>

body{

    font-family:Arial;
    background:#f4f4f4;
    margin:0;

}

.container{

    width:700px;
    margin:40px auto;
    background:white;
    padding:30px;
    border-radius:10px;
    box-shadow:0px 0px 10px rgba(0,0,0,.2);

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

    padding:12px 30px;
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

<h2>Add New Snippet</h2>

<form action="addSnippet" method="post">

<label>

Title

</label>

<input
type="text"
name="title"
required>

<label>

Programming Language

</label>

<select name="language">

<option>Java</option>

<option>Python</option>

<option>C++</option>

<option>JavaScript</option>

<option>HTML</option>

<option>CSS</option>

<option>SQL</option>

</select>

<label>

Description

</label>

<input
type="text"
name="description">

<label>

Code

</label>

<textarea
name="code"
required>

</textarea>

<button>

Save Snippet

</button>

</form>

</div>

</body>

</html>