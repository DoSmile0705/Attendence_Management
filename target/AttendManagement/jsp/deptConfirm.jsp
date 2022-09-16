<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
// ***************************************************
// deptConfirm.jsp
// 2-1：出発確認、2-2：定時確認
// 出発、定時の打刻確認をする
// ***************************************************
%>
<%
/**サーブレット情報の受け取り**/
// ログイン情報の受け取り
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
// 前打刻日時の受け取り
String delStampTime = (String)request.getAttribute("delStampTime");
//打刻種別の受け取り
String stampFlag = (String)request.getAttribute("stampFlag");
// 出力メッセージ
String msg = null;
// ボタン出力メッセージ
String btnMsg = null;

// 打刻種別によって出力メッセージを変更
if(stampFlag.equals("0")){
	msg = "出発時刻";
	btnMsg = "出発";
} else if (stampFlag.equals("3")){
	msg = "定時連絡";
	btnMsg = "定時";
}

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
//DB登録用の日時を返す関数
private String GetFormatDate() {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSS");
	String datestr = dtf.format(nowDate.plusHours(9));
	return datestr;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=btnMsg%>確認</title>
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
<%
if(stampFlag.equals("0")){
%>
  <div class="container-fluid bg-success">
<%
} else if (stampFlag.equals("3")){
%>
  <div class="container-fluid bg-primary">
<%
}
%>
    	<br>
    	<font size="3"><%=msg%>を報告する</font><br>
    	<br>
    	<font size="6"><%=GetTime() %></font><br>
    	<br>
    	<font size="2">事務所に<%=msg%>を報告してもよろしいですか？</font>
    	<br><br>
  </div>
<br><br>
<form action="<%= request.getContextPath() %>/DeptExecute" method="post" accept-charset="UTF-8">
  <button class="btn btn-primary">
    <font size="4">はい（報告する）</font>
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
  <input type="hidden" value="<%=GetFormatDate() %>" name="stampDate">
  <input type="hidden" value="<%=stampFlag %>" name="stampFlag"><!-- 打刻種別 -->
</form>
<br><br><br>
<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <button class="btn btn-danger">
    <font size="4">しない（前の画面に戻る）</font>
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
  <input type="hidden" value="<%=GetFormatDate() %>" name="stampDate">
  <input type="hidden" value="<%=stampFlag %>" name="stampFlag"><!-- 打刻種別 -->
</form>
<%
// 5分以内の前打刻レコードがあった場合は削除ボタンを表示する
if(delStampTime != null){
%>
<br><br><br>
<form action="<%= request.getContextPath() %>/DeptExecute" method="post" accept-charset="UTF-8">
  <button class="btn btn-danger">
    <font size="4"><%=delStampTime.substring(11,16) %>&nbsp<%=btnMsg%>時刻を削除する</font>
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
  <input type="hidden" value="<%=delStampTime %>" name="delStampTime">
  <input type="hidden" value="<%=stampFlag %>" name="stampFlag"><!-- 打刻種別 -->
</form>
<%
}
%>

</body>
</html>