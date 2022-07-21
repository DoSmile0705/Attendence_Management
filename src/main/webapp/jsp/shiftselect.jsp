<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
ShiftInfo shiftInfo = (ShiftInfo)request.getAttribute("shiftInfo");

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
<title>現場選択</title>
<!-- ブートストラップ呼び出し -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />
</head>
<body>
<!-- ブートストラップ呼び出し -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <div class="container-fluid bg-info">
    <%=loginInfo.firstName_Value %>&nbsp<%=loginInfo.lastName_Value %>
  </div>
<br>
  <div class="container-fluid bg-info">
    会社名
  </div>
<br>
  <div class="container-fluid bg-info">
    <%=GetDate() %>
    <br>
    <%=GetTime() %>
  </div>
<br>
  <div class="p-3 mb-2 bg-success">
<br><br>
    <%=GetFormatshiftHiduke(shiftInfo.shiftHiduke) %>&nbsp
    <br>
    <%=shiftInfo.bgnTime %>&nbsp～&nbsp
    <%=shiftInfo.endTime %>
    <br>
    <font size="5"><%=shiftInfo.kinmuBashoName %></font>
    <br>
    <%=shiftInfo.gyomuKubunName %>・<%=shiftInfo.kinmuKubunName %>・<%=shiftInfo.keiyakuKubunName %>
    <br><br><br>
  </div>
<br>
<form action="<%= request.getContextPath() %>/WorkStartConfirm" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    <font size="5">上番報告します</font>
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
  <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
  <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
  <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
  <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
  <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
  <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
  <input type="hidden" value="<%=loginInfo.company_ID %>" name="company">
  <input type="hidden" value="<%=loginInfo.sessionId %>" name="sessionId">
  <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
  <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
  <input type="hidden" value="1" name="stampFlag"><!-- 打刻種別 -->
</form>
<br>
<form action="<%= request.getContextPath() %>/WorkStartConfirm" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    <font size="5">下番報告します</font>
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
  <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
  <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
  <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
  <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
  <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
  <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
  <input type="hidden" value="<%=loginInfo.company_ID %>" name="company">
  <input type="hidden" value="<%=loginInfo.sessionId %>" name="sessionId">
  <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
  <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
  <input type="hidden" value="2" name="stampFlag"><!-- 打刻種別 -->
</form>
<br><br><br>
  <p style="font-size:10px;">
    <span class="label label-default">
  上番報告
<%
if(shiftInfo.bgnStampTime != null){
%>
    <%=GetFormatStampDate(shiftInfo.bgnStampTime) %>
<%
}else{
%>
    --:--
<%
}
%>
    </span>
  </p>

  <p style="font-size:10px;">
  <span class="label label-default">
  下番報告
<%
if(shiftInfo.endStampTime != null){
%>
    <%=GetFormatStampDate(shiftInfo.endStampTime) %>
<%
}else{
%>
    --:--
<%
}
%>
  </span>
  </p>



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
  <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
  <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
  <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
  <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
  <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
  <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
  <input type="hidden" value="<%=loginInfo.company_ID %>" name="company">
  <input type="hidden" value="<%=loginInfo.sessionId %>" name="sessionId">
  <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
  <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
</form>
</body>
</html>