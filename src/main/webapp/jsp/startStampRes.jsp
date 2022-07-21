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
String stampFlag = (String)request.getAttribute("stampFlag");
String stringDate = (String)request.getAttribute("stringDate");

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
<title>打刻報告確定</title>
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
<%
// シフト情報がある場合は出力（ここから）
if(shiftInfo != null){
%>
	
    <%=GetFormatshiftHiduke(shiftInfo.shiftHiduke) %>&nbsp
    <br>
    <%=shiftInfo.bgnTime %>&nbsp～&nbsp
    <%=shiftInfo.endTime %>
    <br>
    <font size="5"><%=shiftInfo.kinmuBashoName %></font>
    <br>
    <%=shiftInfo.gyomuKubunName %>・<%=shiftInfo.kinmuKubunName %>・<%=shiftInfo.keiyakuKubunName %>
    <br><br>
	<%
	// 上番報告
	if(stampFlag.equals("1")){
	%>
    <%=GetFormatStampDate(shiftInfo.bgnStampTime) %>
    <br><br>
    上番報告しました
    <br><br><br>
  </div>
<br>
	<%
	} else {
	%>
    <%=GetFormatStampDate(shiftInfo.endStampTime) %>
    <br><br>
    下番報告しました
    <br><br><br>
  </div>
<br>
<form action="<%= request.getContextPath() %>/NextWorkPlace" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    次の現場を表示する
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
  <input type="hidden" value="<%=stampFlag %>" name="stampFlag"><!-- 打刻種別 -->
</form>
<br><br><br>
	<%
	}
	%>
<%
//シフト情報がある場合は出力（中間）
}else{
%>
    <%=GetFormatStampDate(stringDate) %>
	<%
	// 上番報告
	if(stampFlag.equals("1")){
	%>
    <br><br>
    上番報告しました
    <br><br><br>
  </div>
<br>
	<%
	} else {
	%>
    <br><br>
    下番報告しました
    <br><br><br>
  </div>
<br><br>
	<%
	}
	%>
<%
//シフト情報がある場合は出力（ここまで）
}
%>


<%
// シフト情報がある場合は出力（ここから）
if(shiftInfo != null){
%>
<form action="<%= request.getContextPath() %>/WorkStampCancel" method="post" accept-charset="UTF-8">
<%
//シフト情報がある場合は出力（中間）
}else{
%>
<form action="<%= request.getContextPath() %>/WorkCancel" method="post" accept-charset="UTF-8">
<%
// シフト情報がある場合は出力（ここまで）
}
%>
  <button class="btn btn-danger">
    報告を間違えたのでキャンセルする
  </button>
<%
// シフト情報がある場合は出力（ここから）
if(shiftInfo != null){
%>
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
<%
// シフト情報がある場合は出力（ここまで）
}
%>
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
  <input type="hidden" value="<%=stampFlag %>" name="stampFlag"><!-- 打刻種別 -->
  <input type="hidden" value="<%=stringDate %>" name="stringDate">
</form>
<br><br><br>
<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    最初に戻る
  </button>
<%
//シフト情報がある場合は出力（ここから）
if(shiftInfo != null){
%>
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
<%
//シフト情報がある場合は出力（ここまで）
}
%>
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