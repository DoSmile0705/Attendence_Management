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
<%@ page import="util.Constant" %>

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
	<jsp:forward page="/login.jsp" />
<%
}
%>
<%!
// フォーマットを変更して時間を返す関数
private String GetFormatInfoDate(String dateTime) {
	String datestr = null;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = sdFormat.parse(dateTime);
		sdFormat = new SimpleDateFormat("yyyy年MM月dd日");
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
  <link rel="stylesheet" href="assets/css/style.css?<%=(new SimpleDateFormat("yyyyMMddHHmmssSSS")).format(new Date())%>">

  <!-- Favicon
  -------------------------------------------------- -->
  <link rel="icon" type="image/png" href="assets/images/favicon.png">

<!-- ************ -->
<!-- カメラテスト -->
<!-- ************
<style>
  canvas, video{
    border: 1px solid gray;
  }
</style>
************ -->
<!-- カメラテスト -->
<!-- ************ -->

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
            <span class="num"><%=Constant.UNREAD%></span>
          </button>
          <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
          <input type="hidden" value="<%=loginInfo.id %>" name="id">
          <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
          <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
          <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
          <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
          <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
          <input type="hidden" value="<%=sessionId %>" name="sessionId">
          <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
          <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
          <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
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
          <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
          <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
          <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
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
        <button class="ac1">上下番報告</button>
        <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
        <input type="hidden" value="<%=loginInfo.id %>" name="id">
        <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
        <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
        <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
        <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
        <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
        <input type="hidden" value="<%=sessionId %>" name="sessionId">
        <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
        <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
        <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
        <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
        <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
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
    <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.id %>" name="id">
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
	<input type="hidden" id="stampDate" name="stampDate">
	<input type="hidden" value="0" name="stampFlag"><!-- 打刻種別 -->
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
    <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
    <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
    <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
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
    <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
    <input type="hidden" value="<%=loginInfo.id %>" name="id">
    <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
    <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
    <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
    <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
    <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
    <input type="hidden" value="<%=sessionId %>" name="sessionId">
	<input type="hidden" id="stampDate2" name="stampDate2">
	<input type="hidden" value="3" name="stampFlag"><!-- 打刻種別 -->
    <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
    <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
    <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
    <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
    <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
  </form>
        </div>

      </div>
    </section>

    <!-- シフト一覧ボタン -->
    <div class="btn">
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
      <button>シフト一覧</button>
      <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
      <input type="hidden" value="<%=loginInfo.id %>" name="id">
      <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
      <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
      <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
      <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
      <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
      <input type="hidden" value="<%=sessionId %>" name="sessionId">
	  <input type="hidden" id="nowDate" name="nowDate">
      <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
      <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
      <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
      <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
      <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
    </form>
    </div>

    <!-- シフト申請ボタン -->
    <div class="btn">
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
      <button>シフト申請</button>
      <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
      <input type="hidden" value="<%=loginInfo.id %>" name="id">
      <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
      <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
      <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
      <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
      <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
      <input type="hidden" value="<%=sessionId %>" name="sessionId">
	  <input type="hidden" id="nowDate3" name="nowDate3">
      <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
      <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
      <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
      <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
      <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
      <!-- シフト申請から遷移したことを示すフラグ -->
      <input type="hidden" value="1" name="subFlag">
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
	  <input type="hidden" id="nowDate2" name="nowDate2">
      <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
      <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
      <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
      <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
      <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
    </form>
    </div>

    <!-- 線 -->
    <hr class="mt-5">

    <!-- お知らせ -->
    <section class="news">
      <h2>お知らせ</h2>
      <ul class="news-archive">
<%
if(msgInfo.size() > 0){
	//表示する最大件数をセット
	int maxcnt = 10;
	//メッセージリストが10件より少なかったらリストの最大値をセット
	if(msgInfo.size() < 10){
		maxcnt = msgInfo.size();
	}
	for(int i = 0; i < maxcnt; i ++) {
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
          <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo1">
          <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido1">
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </li>
<%
	}
}
%>
      </ul>
      <div class="link">
      <form name="form1" action="<%= request.getContextPath() %>/InformationList" method="post">
        <button>お知らせ一覧へ<img src="assets/images/arrow.png" alt=""></button>
          <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
          <input type="hidden" value="<%=loginInfo.id %>" name="id">
          <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
          <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
          <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
          <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
          <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
          <input type="hidden" value="<%=sessionId %>" name="sessionId">
          <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
          <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
          <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
      </form>
      </div>
    </section>

    <!-- 線 -->
    <hr class="mt-5">

    <!-- 労働規約ボタン -->
    <div class="btn">
    <form name="form1" action="<%= request.getContextPath() %>/LaborNoticeShow" method="post">
      <button>労働/雇用契約書</button>
      <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
      <input type="hidden" value="<%=loginInfo.id %>" name="id">
      <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
      <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
      <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
      <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
      <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
      <input type="hidden" value="<%=sessionId %>" name="sessionId">
      <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
      <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
      <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
      <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
      <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
    </form>
    </div>

    <!-- 安否確認通知ボタン -->
    <div class="btn">
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/SafetyConfirm" method="post">
      <button>安否確認通知</button>
      <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
      <input type="hidden" value="<%=loginInfo.id %>" name="id">
      <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
      <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
      <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
      <input type="hidden" value="<%=loginInfo.firstName_Value %>" name="firstName_Value">
      <input type="hidden" value="<%=loginInfo.lastName_Value %>" name="lastName_Value">
      <input type="hidden" value="<%=sessionId %>" name="sessionId">
      <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
      <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
      <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
      <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
      <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
    </form>
    </div>

    <!-- 労働規約ボタン -->
<%
if(Constant.KIYAKUBTN != null){
	if(!Constant.KIYAKUBTN.equals("未設定")){
%>

    <div class="btn">
      <button onclick="window.open('<%=Constant.KIYAKUURL%>', '_blank')"><%=Constant.KIYAKUBTN%></button>
    </div>
<%
	}
}
%>

<!-- ************ -->
<!-- カメラテスト -->
<!-- ************
<video id="camera" width="300" height="200"></video>
<canvas id="picture" width="300" height="200"></canvas>
<form>
  <button type="button" id="shutter">シャッター</button>
</form>

<audio id="se" preload="auto">
  <source src="camera-shutter1.mp3" type="audio/mp3">
</audio>

<script>
//window.onload = () => {
//  const video  = document.querySelector("#camera");
//  const canvas = document.querySelector("#picture");
//  const se     = document.querySelector('#se');

  /** カメラ設定 */
//  const constraints = {
//    audio: false,
//    video: {
//      width: 300,
//      height: 200,
	  // フロントカメラを利用する
      //facingMode: "user"
      // リアカメラを利用する場合
//      facingMode: { exact: "environment" }
//    }
//  };

  /**
   * カメラを<video>と同期
   */
//  navigator.mediaDevices.getUserMedia(constraints)
//  .then( (stream) => {
//    video.srcObject = stream;
//    video.onloadedmetadata = (e) => {
//      video.play();
//    };
//  })
//  .catch( (err) => {
//    console.log(err.name + ": " + err.message);
//  });

  /**
   * シャッターボタン
   */
//   document.querySelector("#shutter").addEventListener("click", () => {
//    const ctx = canvas.getContext("2d");

    // 演出的な目的で一度映像を止めてSEを再生する
//    video.pause();  // 映像を停止
//    se.play();      // シャッター音
//    setTimeout( () => {
//      video.play();    // 0.5秒後にカメラ再開
//    }, 500);

    // canvasに画像を貼り付ける
//    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
//  });
//};
</script>
************ -->
<!-- カメラテスト -->
<!-- ************ -->


  </main>
  <!-- メインコンテンツend -->

  <!-- フッター部 -->
  <footer>
    <ul>
<%
if(Constant.RIYOBTN != null){
	if(!Constant.RIYOBTN.equals("未設定")){
%>
      <li><button onclick="window.open('<%=Constant.RIYOURL%>', '_blank')"><%=Constant.RIYOBTN%></button></li>
<%
	}
}
%>
<%
if(Constant.GAIYOBTN != null){
	if(!Constant.GAIYOBTN.equals("未設定")){
%>
      <li><button onclick="window.open('<%=Constant.GAIYOURL%>', '_blank')"><%=Constant.GAIYOBTN%></button></li>
<%
	}
}
%>
      <li>
        <form action="<%= request.getContextPath() %>/Logout" method="post" accept-charset="UTF-8">
        <button>ログアウト</button>
        </form>
      </li>
    </ul>
  </footer>
  <!-- フッター部end -->

<div id="loader">
    <div class="spinner">
      <div class="cube1"></div>
      <div class="cube2"></div>
    </div>
</div>

   <!-- Script
  -------------------------------------------------- -->
  <!-- Jquery読み込み -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <!-- bootstrap JS読み込み -->
  <script src="assets/bootstrap/js/bootstrap.min.js"></script>
<script>
window.onload = function() {
    showDate();
}

//画面表示用のリアルタイム日付
function showDate() {
    var nowTime		= new Date();
    // 時間を9時間進ませる
    var nowYear		= nowTime.getFullYear();
    var nowMonth	= nowTime.getMonth() + 1;
    var nowDate		= nowTime.getDate();
    var nowDay		= nowTime.getDay();
    var dayname		= ['日','月','火','水','木','金','土'];
    var dspDate		= nowYear + "年" + nowMonth + "月" + nowDate + "日" + "(" + dayname[nowDay] + ")" ;
    var nowHour		= ddigit(nowTime.getHours());
    var nowMinute	= ddigit(nowTime.getMinutes());
    var dspTime		= nowHour + ":" + nowMinute; 
    document.getElementById("realTime").innerHTML = dspTime;
    document.getElementById("realDate").innerHTML = dspDate;
}
setInterval('showDate()',60000);

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
	document.getElementById('nowDate3').value = dspDateTime;
}
setInterval('GetDateTime()',60000);
</script>

</body>
</html>