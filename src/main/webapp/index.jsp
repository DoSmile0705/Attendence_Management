<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<!DOCTYPE html>
<%
// サーブレットからの情報を受け取る
String sessionId = (String)request.getAttribute("sessionId");
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
// セッションがNULLだったらログイン画面を表示する
if(sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="jsp/login.jsp" />
<%
}
%>
<html>
<head>
<meta charset="UTF-8">
<title>メインメニュー</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />
<script>
window.onload = function() {
  // URLを取得
  let url = new URL(window.location.href);

  if(!url){
		// URLSearchParamsオブジェクトを取得
		let params = url.searchParams;

		// getメソッド
		alert(params.get('id')); // 5
		alert(params.get('mode')); // read

		// getAllメソッド
		alert(params.getAll('mode'));
		// (3) ["read", "premium", "testuser"]

		// forEachメソッド
		params.forEach(function(value,key){
			alert(key + " => " + value);
		});

		// entriesメソッド
		let entries = params.entries();
		for(let entry of entries) {
			alert(entry[0] + " => " + entry[1]);
		}

		// keysメソッド
		let keys = params.keys();
		for(let key of keys) {
			alert(key);
		}

		// valuesメソッド
		let values = params.values();
		for(let value of values) {
			alert(value);
		}
  }else{
	  //alert("パラメータなし");
  }
}
</script>
</head>
<body>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<div class="center-block">
  <div class="container-fluid bg-info">
    container
  </div>
  <form action="<%= request.getContextPath() %>/AttendList" method="post">
    <button class="btn btn-success"><font size="5">上下番報告</font></button>
    <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
  </form>
<br>
  <button class="btn btn-success"><font size="5">出発報告</font></button>
<br><br>
  <button class="btn btn-success"><font size="5">定時報告</font></button>
</div>
</html>