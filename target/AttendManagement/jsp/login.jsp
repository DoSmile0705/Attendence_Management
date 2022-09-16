<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.lang.Object" %>
<%
// ***************************************************
// login.jsp
// 1-1：ログイン
// ログイン画面
// ***************************************************
%>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");

// サーブレットから「社員番号」を取得
String loginid = (String)request.getAttribute("loginid");
// サーブレットからの遷移でない場合はURLのパラメータ「社員番号」を取得
if(loginid == null){
	loginid = request.getParameter("loginid");
}

//サーブレットから「パスワード」を取得
String password1 = (String)request.getAttribute("password1");
//サーブレットからの遷移でない場合はURLのパラメータ「パスワード」を取得
if(password1 == null){
	password1 = request.getParameter("password1");
}

String password2 = (String)request.getAttribute("password2");

//サーブレットから「メールアドレス」を取得
String mailaddress = (String)request.getAttribute("mailaddress");
//サーブレットからの遷移でない場合はURLのパラメータ「メールアドレス」を取得
if(mailaddress == null){
	mailaddress = request.getParameter("mailaddress");
}
String dispMsg = (String)request.getAttribute("dispMsg");

//サーブレットから「会社識別番号」を取得
String companyCode = (String)request.getAttribute("companyCode");
//サーブレットからの遷移でない場合はURLのパラメータ「会社識別番号」を取得
if(companyCode == null){
	companyCode = request.getParameter("companyCode");
}
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

<script>
// ブラウザに保存されているログイン情報を呼び出す
window.onload = function(){
	if(localStorage.getItem('loginid') != null){
		document.getElementById("loginid").value = localStorage.getItem('loginid');
	}
	if(localStorage.getItem('password1') != null){
		document.getElementById("password1").value = localStorage.getItem('password1');
	}
	if(localStorage.getItem('companyCode') != null){
		document.getElementById("companyCode").value = localStorage.getItem('companyCode');
	}
	if(localStorage.getItem('mailaddress') != null){
		document.getElementById("mailaddress").value = localStorage.getItem('mailaddress');
	}
}
</script>
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
  if(companyCode == null){
	  companyCode = "";
  }
%>
    <input class="form-control" type="text" name="companyCode" id="companyCode" value="<%=companyCode %>">
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
  <button type="submit" class="btn btn-primary" onclick="saveItem()">利用開始</button>
    <input class="form-check-input" type="checkbox" id="save">
    <label class="form-check-label" for="save">保存</label>
  </div>
</form>
<script>
// 保存にチェックを入れた場合、ブラウザにログイン情報をセットする
function saveItem(){
	if(document.getElementById("save").checked){
		localStorage.setItem('loginid', document.getElementById("loginid").value);
		localStorage.setItem('password1', document.getElementById("password1").value);
		localStorage.setItem('companyCode', document.getElementById("companyCode").value);
		localStorage.setItem('mailaddress', document.getElementById("mailaddress").value);
	}
}
</script>
</body>
</html>