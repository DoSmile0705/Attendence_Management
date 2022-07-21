<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
      <button class="btn btn-success"><font size="5">上下番報告</font></button>
    </div>
    <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=loginInfo.company_ID %>" name="company">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
  </form>
<br>
  <form name="form1" action="<%= request.getContextPath() %>/DeptConfirm" method="post">
    <div align="center">
      <button class="btn btn-warning"><font size="5">&nbsp&nbsp出発報告&nbsp&nbsp</font></button>
    </div>
    <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=loginInfo.company_ID %>" name="company">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
	<input type="hidden" value="<%=GetFormatDate() %>" name="stampDate">
	<input type="hidden" value="0" name="stampFlag"><!-- 打刻種別 -->
  </form>
<br>
  <form name="form1" action="<%= request.getContextPath() %>/DeptConfirm" method="post">
    <div align="center">
      <button class="btn btn-info"><font size="5">&nbsp&nbsp定時報告&nbsp&nbsp</font></button>
    </div>
    <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=loginInfo.company_ID %>" name="company">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
	<input type="hidden" value="<%=GetFormatDate() %>" name="stampDate">
	<input type="hidden" value="3" name="stampFlag"><!-- 打刻種別 -->
  </form>
<br><br>
お知らせを開く
<br><br>
  <form name="form1" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
    <div align="center">
      <button class="btn btn-warning"><font size="5">&nbsp&nbsp予定を確認する&nbsp&nbsp</font></button>
    </div>
    <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=loginInfo.company_ID %>" name="company">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
	<input type="hidden" value="<%=GetFormatDate() %>" name="nowDate">
  </form>
<br><br>
実績の参照
<br><br>
労働通知書雇用契約書確認
<br><br>
労働規約&nbsp&nbsp使い方&nbsp&nbspフッター&nbsp&nbsp初めに戻る  
  
  
</html>