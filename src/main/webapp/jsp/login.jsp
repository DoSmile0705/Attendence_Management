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
String company = (String)request.getAttribute("company");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>トップ</title>
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
	    ポータルサイト利用開始
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
<br>
  <div class="mb-2">
    <label class="form-label" for="address">メールアドレス</label>
<%
  // メールアドレスがNULLの場合は空文字をセット
  if(mailaddress == null){
	  mailaddress = "";
  }
%>
    <input class="form-control" type="text" name="mailaddress" id="mailaddress" value="<%=mailaddress %>">
    会社に提出したEmailを入力してください
  </div>
<br>
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
<br>
  <div class="mb-2">
    <label class="form-label" for="name">会社識別番号</label>
<%
  // 会社識別番号がNULLの場合は空文字をセット
  if(company == null){
	  company = "";
  }
%>
    <input class="form-control" type="text" name="company" id="company" value="<%=company %>">
  </div>
<br>
  <div class="mb-2">
    <label class="form-label" for="name">社員番号</label>
<%
  // 社員番号がNULLの場合は空文字をセット
  if(loginid == null){
	  loginid = "";
  }
%>
    <input class="form-control" type="text" name="loginid" id="loginid" value="<%=loginid %>">
  </div>
<br>
  <div class="form-check">
  <button type="submit" class="btn btn-primary">利用開始</button>
    <input class="form-check-input" type="checkbox" id="save">
    <label class="form-check-label" for="save">保存</label>
  </div>
</form>
</body>
</html>