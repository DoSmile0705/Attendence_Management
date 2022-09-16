<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
// ***************************************************
// stampRes.jsp
// 2-4：確定
// 出発・定時の打刻確定を表示する
// ***************************************************
%>

<%
// サーブレットからの値を受け取り
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
String message = (String)request.getAttribute("message");
//前打刻日時の受け取り
String delStampTime = (String)request.getAttribute("delStampTime");

// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="login.jsp" />
<%
}
%>
<%!
//日付を返す関数
private String GetDate() {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy年MM月dd日(E)");
	String datestr = dtf.format(nowDate.plusHours(9));
	return datestr;
}
//日付を返す関数
private String GetTime() {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("HH:mm");
	String timestr = dtf.format(nowDate.plusHours(9));
	return timestr;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>確定</title>
<!-- ブートストラップ呼び出し -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />
</head>
<body>
<!-- ブートストラップ呼び出し -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <div class="container-fluid bg-info">
    <%=loginInfo.companyName %>
  </div>
<br>
  <div class="container-fluid bg-info">
    <%=loginInfo.firstName_Value %>&nbsp<%=loginInfo.lastName_Value %>
  </div>
<br>
  <div class="container-fluid bg-secondary">
    <%=GetDate() %>
    <br>
    <%=GetTime() %>
  </div>
<br>
  <div class="container-fluid bg-light text-success">
    	<br>
    	<font size="3">事務所へ報告しました。</font><br>
    	<br>
<%
// 前打刻を削除した場合はその旨を表示する
if(delStampTime == null){
%>
    	<font size="6"><%=loginInfo.stampDate.substring(11,16) %></font><br>
<%
} else {
%>
    	<font size="6"><%=delStampTime.substring(11,16) %></font><br>
<%
}
%>
    	<br>
    	<font size="2"><%=message %></font>
    	<br><br>
  </div>
<br><br>
<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <button class="btn btn-primary">
    <font size="4">最初の画面に戻る</font>
  </button>
  <!-- サーブレットパラメータ用に隠し項目に格納 -->
<!-- ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼  -->
  <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
  <input type="hidden" value="<%=loginInfo.id %>" name="id">
<!-- ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲  -->
  <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
  <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
  <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
  <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
  <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
  <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
  <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
  <input type="hidden" value="<%=loginInfo.sessionId %>" name="sessionId">
  <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
  <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
</form>
</body>
</html>