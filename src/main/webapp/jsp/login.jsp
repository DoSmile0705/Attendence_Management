<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.lang.Object" %>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
String loginid = (String)request.getAttribute("loginid");
String password1 = (String)request.getAttribute("password1");
String password2 = (String)request.getAttribute("password2");
String mailaddress = (String)request.getAttribute("mailaddress");
String dispMsg = (String)request.getAttribute("dispMsg");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ログイン</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />
</head>
<body>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<form action="<%= request.getContextPath() %>/Login" method="post">
<%
  if(dispMsg == null){
%>
	  <div class="container-fluid bg-info">
	    ログイン情報を入力してください
	  </div>
<%
  } else {
%>
	  <div class="container-fluid bg-danger">

<%= dispMsg%>

	  </div>
<%
  }
%>
  <div class="mb-2">
    <label class="form-label" for="name">ID</label>
<%
  // ログインIDがNULLの場合は空文字をセット
  if(loginid == null){
	  loginid = "";
  }
%>
    <input class="form-control" type="text" name="loginid" id="loginid" value="<%=loginid %>">
  </div>
  <div class="mb-2">
    <label class="form-label" for="address">パスワード</label>
<%
  // パスワード１がNULLの場合は空文字をセット
  if(password1 == null){
	  password1 = "";
  }
%>
    <input class="form-control" type="password" name="password1" id="password1" value="<%=password1 %>" autocomplete="off">
  </div>
  <div class="mb-2">
    <label class="form-label" for="address">メールアドレス</label>
<%
  // メールアドレスがNULLの場合は空文字をセット
  if(mailaddress == null){
	  mailaddress = "";
  }
%>
    <input class="form-control" type="text" name="mailaddress" id="mailaddress" value="<%=mailaddress %>">
  </div>
  <button type="submit" class="btn btn-primary">ログイン</button>  
</form>
</body>
</html>