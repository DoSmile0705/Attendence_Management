<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
// ***************************************************
// shiftlist.jsp
// 3-1：現場確認
// ログインユーザーの直近のシフト一覧を表示する
// ***************************************************
%>

<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
List<ShiftInfo> listInfo = (List<ShiftInfo>)request.getAttribute("listInfo");

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
//DB登録用の日時を返す関数
private String GetFormatDate() {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSS");
	String datestr = dtf.format(nowDate.plusHours(9));
	return datestr;
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
// フォーマットを変更して時間を返す関数
private String GetFormatStampDate(String dateTime) {
	String datestr = null;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSSS");	
		Date date = sdFormat.parse(dateTime);
		sdFormat = new SimpleDateFormat("HH:mm");
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
<title>現場確認</title>
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
<%
for(int i = 0; i < listInfo.size(); i ++) {
%>
<form action="<%= request.getContextPath() %>/AttendDetail" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    <br>
    <%=GetFormatshiftHiduke(listInfo.get(i).shiftHiduke) %>&nbsp
    <br><br>
    <%=listInfo.get(i).bgnTime %>&nbsp～&nbsp
    <%=listInfo.get(i).endTime %>
    <br><br>
    <font size="5"><%=listInfo.get(i).kinmuBashoName %></font>
    <br><br>
    <%=listInfo.get(i).gyomuKubunName %>・<%=listInfo.get(i).kinmuKubunName %>・<%=listInfo.get(i).keiyakuKubunName %>
    <br><br>
    <!-- 2022.7.4 シフト一覧では打刻日時がどのシフトか判定できない為、上下番時刻を出さない
    <font size="5">上番</font>&nbsp
    <font size="7" color="black">--:--</font>&nbsp
    <font size="5">下番</font>&nbsp
    <font size="7" color="black">--:--</font>&nbsp
     -->
    上番報告&nbsp
<%
if(listInfo.get(i).bgnStampTime != null){
%>
	<%=GetFormatStampDate(listInfo.get(i).bgnStampTime) %>	
<%
} else {
%>
    --:--
<%
}
%>

&nbsp&nbsp

    下番報告&nbsp
<%
if(listInfo.get(i).endStampTime != null){
%>
	<%=GetFormatStampDate(listInfo.get(i).endStampTime) %>	
<%
} else {
%>
    --:--
<%
}
%>
    <br><br>
  </button>
  <!-- サーブレットパラメータ用に隠し項目に格納 -->
  <input type="hidden" value="<%=listInfo.get(i).shiftHiduke %>" name="shiftHiduke">
  <input type="hidden" value="<%=listInfo.get(i).bgnTime %>" name="bgnTime">
  <input type="hidden" value="<%=listInfo.get(i).bgnTimeDate %>" name="bgnTimeDate">
  <input type="hidden" value="<%=listInfo.get(i).endTime %>" name="endTime">
  <input type="hidden" value="<%=listInfo.get(i).endTimeDate %>" name="endTimeDate">
  <input type="hidden" value="<%=listInfo.get(i).gyomuKubunName %>" name="gyomuKubunName">
  <input type="hidden" value="<%=listInfo.get(i).keiyakuKubunName %>" name="keiyakuKubunName">
  <input type="hidden" value="<%=listInfo.get(i).kinmuBashoName %>" name="kinmuBashoName">
  <input type="hidden" value="<%=listInfo.get(i).kinmuKubunName %>" name="kinmuKubunName">
  <input type="hidden" value="<%=listInfo.get(i).workerId %>" name="workerId">
  <input type="hidden" value="<%=listInfo.get(i).keiyakuId %>" name="keiyakuId">
  <input type="hidden" value="<%=listInfo.get(i).bgnStampTime %>" name="bgnStampTime">
  <input type="hidden" value="<%=listInfo.get(i).endStampTime %>" name="endStampTime">
  <input type="hidden" value="<%=listInfo.get(i).adrPostNo %>" name="adrPostNo">
  <input type="hidden" value="<%=listInfo.get(i).adrMain %>" name="adrMain">
  <input type="hidden" value="<%=listInfo.get(i).adrSub %>" name="adrSub">
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
	
<%
}
%>

<form action="<%= request.getContextPath() %>/WorkStartConfirm" method="post" accept-charset="UTF-8">
  <button class="btn btn-warning">
    <font size="5">上番報告</font>
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
  <input type="hidden" value="1" name="stampFlag"><!-- 打刻種別 -->
</form>
<br><br>
<form action="<%= request.getContextPath() %>/WorkStartConfirm" method="post" accept-charset="UTF-8">
  <button class="btn btn-info">
    <font size="5">下番報告</font>
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
  <input type="hidden" value="2" name="stampFlag"><!-- 打刻種別 -->
</form>
<br><br><br>

<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <button class="btn btn-danger">最初に戻る
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
  <br><br>
</body>
</html>