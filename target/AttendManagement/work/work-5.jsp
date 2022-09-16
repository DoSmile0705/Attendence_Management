<!-- 現場詳細ページ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="util.RequestData" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%
// ***************************************************
// work-5.jsp
// 残業申請確認
// ***************************************************
%>
<%
LoginInfo loginInfo		= (LoginInfo)request.getAttribute("loginInfo");
ShiftInfo shiftInfo		= (ShiftInfo)request.getAttribute("shiftInfo");
RequestData requestData = (RequestData)request.getAttribute("requestData");
String categoryFlag		= (String)request.getAttribute("categoryFlag");
String requestDate		= (String)request.getAttribute("requestDate");
String overtime_1		= (String)request.getAttribute("overtime_1");
String overtime_2		= (String)request.getAttribute("overtime_2");
String requestFlag		= (String)request.getAttribute("requestFlag");
String reason			= (String)request.getAttribute("reason");
String textarea			= (String)request.getAttribute("textarea");
String deleteFlag		= (String)request.getAttribute("deleteFlag");


// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="login.jsp" />
<%
}
%>
<%!
//フォーマットを変更して日付を返す関数
private String ChangeshiftHiduke(String dateTime) {
	String datestr = null;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy年MM月dd日(E)");	
		Date date = sdFormat.parse(dateTime);
		DateFormatSymbols dfs = DateFormatSymbols.getInstance(Locale.JAPANESE);
		sdFormat = new SimpleDateFormat("yyyyMMdd", dfs);
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
private String GetTimeValue(String dateTime){
	int hour = Integer.parseInt(dateTime.substring(0, 2));
	hour = hour * 60;
	String resDate = String.valueOf(hour);
	resDate = resDate + dateTime.substring(3, 5);
	return resDate;
}
private String GetValue(String timeValue){
	String resDate = timeValue.substring(0, 2);
	resDate = resDate + timeValue.substring(3, 5);
	return resDate;
}
%>
<!DOCTYPE html>
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
  <link href="./assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!-- スタイルシート読み込み -->
  <link rel="stylesheet" href="./assets/css/style.css">

  <!-- Favicon
  -------------------------------------------------- -->
  <link rel="icon" type="image/png" href="./assets/images/favicon.png">

<script>
// 画面表示用のリアルタイム日付
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
    document.getElementById("realDate").innerHTML = dspDate;

    var nowHour		= ddigit(nowTime.getHours());
    var nowMinute	= ddigit(nowTime.getMinutes());
    var dspTime		= nowHour + ":" + nowMinute; 
    document.getElementById("realTime").innerHTML = dspTime;
}
setInterval('showDate()',60000);

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
// 選択した日時をリクエストのパラメータにセットする関数
function GetRequestDate(){
	var nowDate = document.getElementById('dt-num').value;
	var changeDate = nowDate.substring(0,4)
	               + nowDate.substring(5,7)
	               + nowDate.substring(8,10);
	document.getElementById('RequestDate').value = changeDate;
}
//ロード時に日時をリアルタイム表示する
window.onload = function(){
	showDate();
}
</script>


</head>
<body>
  <!-- ヘッダー部 -->
  <header>
    <!-- 固定ヘッダー -->
    <section class="fixed above u-layer">
      <div class="row">
        <div class="nav-item"><a href="#" onclick="history.back(-1);return false;">＜戻る</a></div>
        <div class="nav-item"><p id="realDate"></p></div>
        <div class="nav-item"><p id="realTime"></p></div>
      </div>
    </section>

    <!-- 固定フッター -->
    <section class="fixed bottom">
      <div class="row">
        <div class="ico mail">
        <form name="form1" action="<%= request.getContextPath() %>/InformationList" method="post">
          <button onclick="location.href='../news/news-1.html'">
            <img src="./assets/images/mail.png" alt="">
            <span class="num">123</span>
          </button>
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
        </div>
        <div class="ico">
        <form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
          <button onclick="location.href='../top.html'">
            <img src="./assets/images/home.png" alt="">
          </button>
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
        </div>
        <div class="ico">
          <button onclick="location.href='#'">
            <img src="./assets/images/top-arrow.png" alt="">
          </button>
        </div>
      </div>
    </section>
  </header>
  <!-- ヘッダー部end -->

  <!-- メインコンテンツ -->
  <main class="p-work">
    <section class="inner">
      <!-- ページタイトル -->
      <h1 class="m-ttl">
<%
switch(categoryFlag){
	case "1":
%>
        早出申請
<%
		break;
	case "2":
%>
        残業申請
<%
		break;
	case "11":
%>
        交通費・経費申請
<%
		break;
	default:
		break;
}
%>
      </h1>
    </section>

    <div class="w-box inner">
      <span class="dt">日時</span>
      <P><%=requestDate %></P>
    </div>


    <section class="inner">


      <!-- 各種申請 -->
      <div class="w-box mt-8">
        <h2>申請内容</h2>
        <!-- ボタン -->
        <form method="post" action="<%= request.getContextPath() %>/RequestProcess" method="post" accept-charset="UTF-8">

          <div class="overtime app-time">
            <label for="overtime-1">残業申請①：業務終了時刻</label>
            <p><%=overtime_1 %></p>
            
            <label for="overtime-2">残業申請②：総残業時間</label>
            <p><%=overtime_2 %></p>
          </div>


          <label for="reason">申請理由</label>
          <p>現場監督都合による延長</p>
    
          <label for="textarea">その他・申請内容</label>
          <p><%=textarea %></p>

        
<%
// 「申請」の場合
if(deleteFlag == null){
%>
          <div class="submit">
            <button type="submit">申請する</button>
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
              <input type="hidden" value="<%=requestData.kinmuHiduke %>" name="kinmuHiduke">
              <input type="hidden" value="<%=requestData.category %>" name="category">
              <input type="hidden" value="<%=requestData.timeValue %>" name="timeValue">
              <input type="hidden" value="<%=requestData.setTimeValue %>" name="setTimeValue">
              <input type="hidden" value="<%=requestData.value %>" name="value">
              <input type="hidden" value="<%=requestData.setValue %>" name="setValue">
              <input type="hidden" value="<%=requestData.note %>" name="note">
              <input type="hidden" value="<%=requestData.causeFlag %>" name="causeFlag">
              <input type="hidden" value="<%=requestData.certification %>" name="certification">
              <input type="hidden" value="<%=categoryFlag %>" name="categoryFlag">
              <input type="hidden" value="<%=ChangeshiftHiduke(requestDate) %>" name="requestDate">
              <input type="hidden" value="<%=GetTimeValue(overtime_1) %>" name="overtime-1">
              <input type="hidden" value="<%=GetValue(overtime_2) %>" name="overtime-2">
              <input type="hidden" value="<%=requestFlag %>" name="requestFlag">
              <input type="hidden" value="<%=reason %>" name="reason">
              <input type="hidden" value="<%=textarea %>" name="textarea">
          </div>
<%
}
%>
        </form>
      </div>

<%
if(deleteFlag != null){
%>
      <div class="btn mt-8">
        <form method="post" action="<%= request.getContextPath() %>/RequestUpdate" method="post" accept-charset="UTF-8">
        <button class="red" onclick="location.href='work-8.html'">申請を取り消す</button>
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
              <input type="hidden" value="<%=requestData.kinmuHiduke %>" name="kinmuHiduke">
              <input type="hidden" value="<%=requestData.category %>" name="category">
              <input type="hidden" value="<%=requestData.timeValue %>" name="timeValue">
              <input type="hidden" value="<%=requestData.setTimeValue %>" name="setTimeValue">
              <input type="hidden" value="<%=requestData.value %>" name="value">
              <input type="hidden" value="<%=requestData.setValue %>" name="setValue">
              <input type="hidden" value="<%=requestData.note %>" name="note">
              <input type="hidden" value="<%=requestData.causeFlag %>" name="causeFlag">
              <input type="hidden" value="<%=requestData.certification %>" name="certification">
              <input type="hidden" value="<%=categoryFlag %>" name="categoryFlag">
              <input type="hidden" value="<%=ChangeshiftHiduke(requestDate) %>" name="requestDate">
        </form>
      </div>
<%
}
%>
    </section>


    

    <!-- シフト一覧に戻る -->
    <div class="btn mt-8">
      <form action="<%= request.getContextPath() %>/AttendList" method="post" accept-charset="UTF-8">
      <button class="white" onclick="location.href='../work/work-1.html'">シフト一覧に戻る</button>
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
  <script src="./assets/bootstrap/js/bootstrap.min.js"></script>
  
</body>
</html>