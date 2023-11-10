<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.MessageData" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<%
// サーブレットからの情報を受け取る
String sessionId = (String)request.getAttribute("sessionId");
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
List<MessageData> msgInfo = (List<MessageData>)request.getAttribute("msgInfo");
ShiftInfo shiftInfo = (ShiftInfo)request.getAttribute("shiftInfo");
// 出発報告
String deptStamp = (String)request.getAttribute("deptStamp");
// 定時報告
String onTimeStamp = (String)request.getAttribute("onTimeStamp");

// セッションがNULLだったらログイン画面を表示する
if(sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="jsp/login.jsp" />
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
// フォーマットを変更して時間を返す関数
private String GetFormatInfoDate(String dateTime) {
	String datestr = null;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSSS");	
		Date date = sdFormat.parse(dateTime);
		sdFormat = new SimpleDateFormat("MM月dd日");
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
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
%>
<html>
<head>
<meta charset="UTF-8">
<title>メインメニュー</title>

<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />
<script>
// 位置情報を取得する処理
window.onload = function() {
    navigator.geolocation.getCurrentPosition(test2);
}
function test2(position) {

    var geo_text = "緯度:" + position.coords.latitude + "\n";
    geo_text += "経度:" + position.coords.longitude + "\n";
    geo_text += "高度:" + position.coords.altitude + "\n";
    geo_text += "位置精度:" + position.coords.accuracy + "\n";
    geo_text += "高度精度:" + position.coords.altitudeAccuracy  + "\n";
    geo_text += "移動方向:" + position.coords.heading + "\n";
    geo_text += "速度:" + position.coords.speed + "\n";

    var date = new Date(position.timestamp);
    geo_text += "取得時刻:" + date.toLocaleString() + "\n";
    const formatDate = (date)=>{
        let formatted_date = date.getFullYear() + "年" + date.getMonth() + "月" + date.getDate() + "日" + "(" + [ "日", "月", "火", "水", "木", "金", "土" ][date.getDay()] + ")"
        return formatted_date;
    }
    geo_text += "取得時刻:" + formatDate(date) + "\n";
    geo_text += "取得時刻:" + date.getHours() + ":" + date.getMinutes() + "\n";


    //alert(geo_text);

    // 緯度経度を取得して隠し項目に格納
    document.forms['form1'].elements['geoIdo'].value = position.coords.latitude;
    document.forms['form1'].elements['geoKeido'].value = position.coords.longitude;
}
</script>
</head>
<body>
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
  <form name="form1" action="<%= request.getContextPath() %>/AttendList" method="post">
    <div align="center">
      <button class="btn btn-info"><font size="5">上下番報告</font></button>
    </div>
    <!-- ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼  -->
    <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.id %>" name="id">
    <!-- ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲  -->
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
  </form>
<br>
  <form name="form1" action="<%= request.getContextPath() %>/DeptConfirm" method="post">
    <div align="center">
<%
if(deptStamp == null){
%>
      <button class="btn btn-warning"><font size="5">出発報告&nbsp&nbsp未</font></button>
<%
}else{
%>
      <button class="btn btn-warning"><font size="5">出発報告&nbsp&nbsp済</font></button>
<%
}
%>
    </div>
    <!-- ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼  -->
    <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.id %>" name="id">
    <!-- ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲  -->
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
	<input type="hidden" value="<%=GetFormatDate() %>" name="stampDate">
	<input type="hidden" value="0" name="stampFlag"><!-- 打刻種別 -->
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
  </form>
<br>
  <form name="form1" action="<%= request.getContextPath() %>/DeptConfirm" method="post">
    <div align="center">
<%
if(onTimeStamp == null){
%>
      <button class="btn btn-info"><font size="5">定時報告&nbsp&nbsp未</font></button>
<%
}else{
%>
      <button class="btn btn-info"><font size="5">定時報告&nbsp&nbsp済</font></button>
<%
}
%>
    </div>
    <!-- ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼  -->
    <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.id %>" name="id">
    <!-- ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲  -->
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
	<input type="hidden" value="<%=GetFormatDate() %>" name="stampDate">
	<input type="hidden" value="3" name="stampFlag"><!-- 打刻種別 -->
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
  </form>
<br><br>
本日の現場
<br>
<%
if(shiftInfo.shiftHiduke != null){
%>
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
<%
}
%>
<br><br>
  <form name="form1" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
    <div align="center">
      <button class="btn btn-warning"><font size="5">&nbsp&nbsp予定を確認する&nbsp&nbsp</font></button>
    </div>
    <!-- ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼  -->
    <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.id %>" name="id">
    <!-- ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲  -->
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
	<input type="hidden" value="<%=GetFormatDate() %>" name="nowDate">
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
  </form>
<br><br>
<%
for(int i = 0; i < msgInfo.size(); i ++) {
%>
  <div class="container-fluid bg-info">
    <%=msgInfo.get(i).isRead %>
    <%=GetFormatInfoDate(msgInfo.get(i).makeDate)%>
    <%=msgInfo.get(i).headerName %>
  </div>
<%
}
%>
  <form name="form1" action="<%= request.getContextPath() %>/InformationList" method="post">
    <div align="center">
      <button class="btn btn-warning"><font size="5">お知らせ一覧</font></button>
    </div>
    <!-- ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼  -->
    <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.id %>" name="id">
    <!-- ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲  -->
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
  </form>
<br><br>
実績の参照
<br><br>
労働通知書雇用契約書確認
<br><br>
労働規約&nbsp&nbsp使い方&nbsp&nbspフッター&nbsp&nbsp初めに戻る
	<jsp:include page="loading.jsp" />
</html>