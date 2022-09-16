<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
// ***************************************************
// shiftInfo.jsp
// 3-8：シフト情報
// 下番報告後の次のシフト情報を表示する
// ***************************************************
%>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
ShiftInfo shiftInfo = (ShiftInfo)request.getAttribute("shiftInfo");
// 次のシフト情報
ShiftInfo nextShiftInfo = (ShiftInfo)request.getAttribute("nextShiftInfo");

// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="login.jsp" />
<%
}
%>
<%!
//現在日付を返す関数
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
//フォーマットを変更して日付を返す関数
private String GetFormatshiftHiduke(String dateTime) {
	String datestr = dateTime.substring(0, 4);
	datestr += "/";
	datestr += dateTime.substring(4, 6);
	datestr += "/";
	datestr += dateTime.substring(6, 8);
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy/MM/dd");	
		Date date = sdFormat.parse(datestr);
		sdFormat = new SimpleDateFormat("yyyy年MM月dd日(E)");
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>シフト情報</title>
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
  <div class="container-fluid bg-info">
    <%=GetDate() %>
    <br>
    <%=GetTime() %>
  </div>
<br>
  <div class="container-fluid bg-info">
<br>
  	日時
<br><br>
  	<%=GetFormatshiftHiduke(nextShiftInfo.shiftHiduke) %>
<br><br>
    <%=nextShiftInfo.bgnTime %>&nbsp～&nbsp<%=nextShiftInfo.endTime %>
<br><br><br>
    <form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  	場所
      <button class="btn btn-info">地図を開く（未実装）</button>
      <!-- サーブレットパラメータ用に隠し項目に格納 -->
      <input type="hidden" value="<%=shiftInfo.shiftHiduke %>" name="shiftHiduke">
      <input type="hidden" value="<%=shiftInfo.bgnTime %>" name="bgnTime">
      <input type="hidden" value="<%=shiftInfo.bgnTimeDate %>" name="bgnTimeDate">
      <input type="hidden" value="<%=shiftInfo.endTime %>" name="endTime">
      <input type="hidden" value="<%=shiftInfo.endTimeDate %>" name="endTimeDate">
      <input type="hidden" value="<%=shiftInfo.gyomuKubunName %>" name="gyomuKubunName">
      <input type="hidden" value="<%=shiftInfo.keiyakuKubunName %>" name="keiyakuKubunName">
      <input type="hidden" value="<%=shiftInfo.kinmuBashoName %>" name="kinmuBashoName">
      <input type="hidden" value="<%=shiftInfo.kinmuKubunName %>" name="kinmuKubunName">
      <input type="hidden" value="<%=shiftInfo.workerId %>" name="workerId">
      <input type="hidden" value="<%=shiftInfo.keiyakuId %>" name="keiyakuId">
      <input type="hidden" value="<%=shiftInfo.bgnStampTime %>" name="bgnStampTime">
      <input type="hidden" value="<%=shiftInfo.endStampTime %>" name="endStampTime">
      <input type="hidden" value="<%=shiftInfo.adrPostNo %>" name="adrPostNo">
      <input type="hidden" value="<%=shiftInfo.adrMain %>" name="adrMain">
      <input type="hidden" value="<%=shiftInfo.adrSub %>" name="adrSub">
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
<br><br>
  	<%=shiftInfo.kinmuBashoName %>
<br><br>
  	<%=shiftInfo.adrPostNo %>
<br><br>
  	<%=shiftInfo.adrMain %>
<br><br>
  	<%=shiftInfo.adrSub %>
<br><br>
    <%=shiftInfo.gyomuKubunName %>・<%=shiftInfo.kinmuKubunName %>・<%=shiftInfo.keiyakuKubunName %>
<br><br>
  </div>
<br><br>
<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <button class="btn btn-danger">最初に戻る
  </button>
  <!-- サーブレットパラメータ用に隠し項目に格納 -->
  <input type="hidden" value="<%=shiftInfo.shiftHiduke %>" name="shiftHiduke">
  <input type="hidden" value="<%=shiftInfo.bgnTime %>" name="bgnTime">
  <input type="hidden" value="<%=shiftInfo.bgnTimeDate %>" name="bgnTimeDate">
  <input type="hidden" value="<%=shiftInfo.endTime %>" name="endTime">
  <input type="hidden" value="<%=shiftInfo.endTimeDate %>" name="endTimeDate">
  <input type="hidden" value="<%=shiftInfo.gyomuKubunName %>" name="gyomuKubunName">
  <input type="hidden" value="<%=shiftInfo.keiyakuKubunName %>" name="keiyakuKubunName">
  <input type="hidden" value="<%=shiftInfo.kinmuBashoName %>" name="kinmuBashoName">
  <input type="hidden" value="<%=shiftInfo.kinmuKubunName %>" name="kinmuKubunName">
  <input type="hidden" value="<%=shiftInfo.workerId %>" name="workerId">
  <input type="hidden" value="<%=shiftInfo.keiyakuId %>" name="keiyakuId">
  <input type="hidden" value="<%=shiftInfo.bgnStampTime %>" name="bgnStampTime">
  <input type="hidden" value="<%=shiftInfo.endStampTime %>" name="endStampTime">
  <input type="hidden" value="<%=shiftInfo.adrPostNo %>" name="adrPostNo">
  <input type="hidden" value="<%=shiftInfo.adrMain %>" name="adrMain">
  <input type="hidden" value="<%=shiftInfo.adrSub %>" name="adrSub">
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