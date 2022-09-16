<!-- トップ画面 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.MessageData" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormatSymbols" %>

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
    <!-- ▼▼▼ 2022.08.14 HTML→JSP変換対応 ▼▼▼ -->
	<jsp:forward page="/login.jsp" />
	<!-- ▲▲▲ 2022.08.14 HTML→JSP変換対応 ▲▲▲ -->
<%
}
%>
<%!
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
%>
<html lang="ja">
<head>

  <!-- Basic Page Needs
  -------------------------------------------------- -->
  <meta charset="utf-8">
  <title>警備業ポータルサイト</title>
  <meta name="description" content="">
  <meta name="format-detection" content="telephone=no">

  <!-- Mobile Specific Metas
  -------------------------------------------------- -->
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- CSS
  -------------------------------------------------- -->
  <!-- フォント読み込み -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
  <!-- bootstrap CSS読み込み -->
  <link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!-- スタイルシート読み込み -->
  <link rel="stylesheet" href="assets/css/style.css">

  <!-- Favicon
  -------------------------------------------------- -->
  <link rel="icon" type="image/png" href="assets/images/favicon.png">


<script>
// 位置情報を取得する処理
window.onload = function() {
    navigator.geolocation.getCurrentPosition(test2);
    showDate();
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
//画面表示用のリアルタイム日付
function showDate() {
    var nowTime		= new Date();
    // 時間を9時間進ませる
    //nowTime.setHours(nowTime.getHours() + 9);
    var nowYear		= nowTime.getFullYear();
    var nowMonth	= nowTime.getMonth() + 1;
    var nowDate		= nowTime.getDate();
    var nowDay		= nowTime.getDay();
    var dayname		= ['日','月','火','水','木','金','土'];
    var dspDate		= nowYear + "年" + nowMonth + "月" + nowDate + "日" + "(" + dayname[nowDay] + ")" ;
    //▼▼▼2022.09.05 リアルタイム表示が重いので処理をひとつにする▼▼▼
    var nowHour		= ddigit(nowTime.getHours());
    var nowMinute	= ddigit(nowTime.getMinutes());
    var dspTime		= nowHour + ":" + nowMinute; 
    document.getElementById("realTime").innerHTML = dspTime;
    //▲▲▲2022.09.05 リアルタイム表示が重いので処理をひとつにする▲▲▲
    document.getElementById("realDate").innerHTML = dspDate;
}
setInterval('showDate()',60000);

//▼▼▼2022.09.05 リアルタイム表示が重いので処理をひとつにする▼▼▼
//画面表示用のリアルタイム時間
/***
function showTime() {
    var nowTime		= new Date();
    // 時間を9時間進ませる
    //nowTime.setHours(nowTime.getHours() + 9);
    var nowHour		= ddigit(nowTime.getHours());
    var nowMinute	= ddigit(nowTime.getMinutes());
    var dspTime		= nowHour + ":" + nowMinute; 
    document.getElementById("realTime").innerHTML = dspTime;
}
setInterval('showTime()',1000);
***/
//▲▲▲2022.09.05 リアルタイム表示が重いので処理をひとつにする▲▲▲
//0合わせの為の関数
function ddigit(num) {
	var dd;
	if( num < 10 ) {
		dd = '0' + num;
	}else{
		dd = num;
	}
	return dd;
}
//パラメータ用のリアルタイム時間
function GetDateTime() {
    var nowDateTime		= new Date();
    var nowYear			= ddigit(nowDateTime.getFullYear());
    var nowMonth		= ddigit(nowDateTime.getMonth() + 1);
    var nowDate			= ddigit(nowDateTime.getDate());
    var nowHours		= ddigit(nowDateTime.getHours());
    var nowMinites		= ddigit(nowDateTime.getMinutes());
    var nowSrconds		= ddigit(nowDateTime.getSeconds());
    var nowMilliseconds	= ddigit(nowDateTime.getMilliseconds());
    var dspDateTime		= nowYear + "-" + nowMonth + "-" + nowDate + " " + nowHours + ":" + nowMinites + ":" + nowSrconds + "." + nowMilliseconds; 
	document.getElementById('stampDate').value = dspDateTime;
	//同じ名前にすると認識されないので別名を付ける
	document.getElementById('stampDate2').value = dspDateTime;
	document.getElementById('nowDate').value = dspDateTime;
	//同じ名前にすると認識されないので別名を付ける
	document.getElementById('nowDate2').value = dspDateTime;
}
setInterval('GetDateTime()',60000);
</script>

</head>
<body>
  <!-- ヘッダー部 -->
  <header>
    <!-- 固定ヘッダー -->
    <section class="fixed above">
      <h1><%=loginInfo.companyName %></h1>
    </section>

    <!-- 固定フッター -->
    <section class="fixed bottom">
      <div class="row">
        <div class="ico mail">
          <form name="form1" action="<%= request.getContextPath() %>/InformationList" method="post">
          <button>
            <img src="assets/images/mail.png" alt="">
            <span class="num">123</span>
          </button>
          <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
          <input type="hidden" value="<%=loginInfo.id %>" name="id">
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
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </div>
        <div class="ico">
          <form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
          <button>
            <img src="assets/images/home.png" alt="">
          </button>
          <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
          <input type="hidden" value="<%=loginInfo.id %>" name="id">
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
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </div>
        <div class="ico arrow">
          <button onclick="location.href='#'">
            <img src="assets/images/top-arrow.png" alt="">
          </button>
        </div>
      </div>
    </section>
  </header>
  <!-- ヘッダー部end -->

  <!-- メインコンテンツ -->
  <main>
    <!-- 現在時刻 -->
    <section class="time">
      <h2>現在時刻</h2>
      <span id="realDate"></span>
      <div><p id="realTime"></p></div>
    </section>

    <!-- 本日の現場 -->
    <section class="today">
      <h2>本日の現場</h2>
      <div class="topic">
<%
if(shiftInfo.shiftHiduke != null){
%>
        <span class="time-zone"><%=shiftInfo.bgnTime %>-<%=shiftInfo.endTime %></span>
        <span class="place"><%=shiftInfo.kinmuBashoName %></span>
<%
// 本日の現場が存在しない場合は表示しない※画面が崩れるので
}else{
%>
        <span class="time-zone"></span>
        <span class="place"></span>
<%
}
%>
      </div>
      <div class="btn mt-25">
        <form name="form1" action="<%= request.getContextPath() %>/AttendList" method="post">
          <!-- ▼▼▼ 202208.11 HTML → JSPに伴いコメントアウト ▼▼▼
        <button class="ac1" onclick="location.href='stamp/stamp-1.html'">上下番報告</button>
        ▲▲▲ 202208.11 HTML → JSPに伴いコメントアウト ▲▲▲ -->
        <button class="ac1">上下番報告</button>
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
        <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
      </form>
      </div>
      <div class="row">
        <div class="btn">
  <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/DeptConfirm" method="post">
<%
if(deptStamp == null){
%>
          <button class="ac2">
            出発報告
            <span class="red">未</span>
          </button>
<%
}else{
%>
          <button class="ac2">
            出発報告
            <span class="black">済</span>
          </button>
<%
}
%>
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
	<input type="hidden" id="stampDate" name="stampDate">
	<input type="hidden" value="0" name="stampFlag"><!-- 打刻種別 -->
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
    <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
  </form>
        </div>

        <div class="btn">
  <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/DeptConfirm" method="post">
<%
if(onTimeStamp == null){
%>
          <button class="ac3">
            定時報告
            <span class="red">未</span>
          </button>
<%
}else{
%>
          <button class="ac3">
            定時報告
            <span class="black">済</span>
          </button>
<%
}
%>
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
	<input type="hidden" id="stampDate2" name="stampDate2">
	<input type="hidden" value="3" name="stampFlag"><!-- 打刻種別 -->
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
    <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
  </form>
        </div>

      </div>
    </section>

    <!-- シフト一覧ボタン -->
    <div class="btn">
    <!--▼▼▼2022.9.13 ログイン時に「シフト一覧」即押下でNullPointerException発生回避▼▼▼-->
    <!--<form name="form1" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">-->
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
    <!--▲▲▲2022.9.13 ログイン時に「シフト一覧」即押下でNullPointerException発生回避▲▲▲-->
      <button>シフト一覧</button>
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
	  <input type="hidden" id="nowDate" name="nowDate">
      <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
      <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
      <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
    </form>
    </div>

    <!-- 実績一覧ボタン -->
    <div class="btn">
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/ShiftPerformance" method="post">
      <button>実績一覧</button>
      <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
      <input type="hidden" value="<%=loginInfo.id %>" name="id">
      <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
      <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
      <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
      <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
      <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
      <input type="hidden" value="<%=sessionId %>" name="sessionId">
      <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
      <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
	  <input type="hidden" id="nowDate2" name="nowDate2">
      <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
      <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
      <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
    </form>
    </div>

    <!-- 線 -->
    <hr class="mt-5">

    <!-- お知らせ -->
    <section class="news">
      <h2>お知らせ</h2>
      <ul class="news-archive">
<%
for(int i = 0; i < msgInfo.size(); i ++) {
%>
        <li class="news-item">
          <form action="<%= request.getContextPath() %>/InformationPageLink" method="post" accept-charset="UTF-8">
          <button>
            <span class="day"><%=GetFormatInfoDate(msgInfo.get(i).makeDate)%></span>
            <p class="n-ttl"><%=msgInfo.get(i).headerName %></p>
<%
    if(msgInfo.get(i).isRead.equals("既読")){
%>
            <span class="read-tag read"><%=msgInfo.get(i).isRead %></span>
<%
    }else{
%>
            <span class="read-tag"><%=msgInfo.get(i).isRead %></span>
<%
    }
%>
          </button>
          <input type="hidden" value="<%=msgInfo.get(i).id %>" name="DataId">
          <input type="hidden" value="<%=msgInfo.get(i).headerName %>" name="headerName">
          <input type="hidden" value="<%=msgInfo.get(i).makeDate %>" name="makeDate">
          <input type="hidden" value="<%=msgInfo.get(i).categoryCode %>" name="categoryCode">
          <input type="hidden" value="<%=msgInfo.get(i).returnDate %>" name="returnDate">
          <input type="hidden" value="<%=msgInfo.get(i).body1 %>" name="body1">
          <input type="hidden" value="<%=msgInfo.get(i).body2 %>" name="body2">
          <input type="hidden" value="<%=msgInfo.get(i).body3 %>" name="body3">
          <input type="hidden" value="<%=msgInfo.get(i).note %>" name="note">
          <input type="hidden" value="<%=msgInfo.get(i).messageBinaryFile_ID %>" name="messageBinaryFile_ID">
          <input type="hidden" value="<%=msgInfo.get(i).company_ID %>" name="company_ID">
          <input type="hidden" value="<%=msgInfo.get(i).workerIndex %>" name="workerIndex">
          <input type="hidden" value="<%=msgInfo.get(i).isRead %>" name="isRead">
          <input type="hidden" value="<%=msgInfo.get(i).answerText %>" name="answerText">
          <input type="hidden" value="<%=msgInfo.get(i).answerDate %>" name="answerDate">
          <input type="hidden" value="<%=msgInfo.get(i).readDate %>" name="readDate">
          <input type="hidden" value="<%=msgInfo.get(i).entryDate %>" name="entryDate">
          <input type="hidden" value="<%=msgInfo.get(i).keyCode1 %>" name="keyCode1">
          <input type="hidden" value="<%=msgInfo.get(i).keyCode2 %>" name="keyCode2">
          <input type="hidden" value="<%=msgInfo.get(i).messageBinaryFileId %>" name="messageBinaryFileId">
          <input type="hidden" value="<%=msgInfo.get(i).messageData_ID %>" name="messageData_ID">
          <input type="hidden" value="<%=msgInfo.get(i).guidKey %>" name="guidKey">
          <input type="hidden" value="<%=msgInfo.get(i).localFileName %>" name="localFileName">
          <input type="hidden" value="<%=msgInfo.get(i).localcategory %>" name="localcategory">
          <input type="hidden" value="<%=msgInfo.get(i).uploadDate %>" name="uploadDate">
          <input type="hidden" value="<%=msgInfo.get(i).uploadFileName %>" name="uploadFileName">
          <input type="hidden" value="<%=msgInfo.get(i).messageDataId %>" name="messageDataId">
          <input type="hidden" value="<%=msgInfo.get(i).messageWorkerDataId %>" name="messageWorkerDataId">
          <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
          <input type="hidden" value="<%=loginInfo.id %>" name="id">
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
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </li>
<%
}
%>
      </ul>
      <div class="link">
      <form name="form1" action="<%= request.getContextPath() %>/InformationList" method="post">
        <button>お知らせ一覧へ<img src="assets/images/arrow.png" alt=""></button>
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
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
      </form>
      </div>
    </section>

    <!-- 線 -->
    <hr class="mt-5">

    <!-- 労働規約ボタン -->
    <div class="btn">
      <button onclick="location.href='term/term.html'">労働規約</button>
    </div>

  </main>
  <!-- メインコンテンツend -->

  <!-- フッター部 -->
  <footer>
    <ul>
      <li><button onclick="location.href='#'">使い方</button></li>
      <li><button onclick="location.href='#'">会社概要</button></li>
      <li>
        <form action="<%= request.getContextPath() %>/Logout" method="post" accept-charset="UTF-8">
        <button>ログアウト</button>
        </form>
      </li>
    </ul>
  </footer>
  <!-- フッター部end -->



   <!-- Script
  -------------------------------------------------- -->
  <!-- Jquery読み込み -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <!-- bootstrap JS読み込み -->
  <script src="assets/bootstrap/js/bootstrap.min.js"></script>
  
</body>
</html>