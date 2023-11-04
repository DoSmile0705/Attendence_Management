<!-- 上番報告ページ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%@ page import="util.Constant" %>
<%
// ***************************************************
// stamp-3.jsp
// 上下番の打刻確認を行う
// ***************************************************
%>
<%
String stringDate = (String)request.getAttribute("stringDate");
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
ShiftInfo shiftInfo = (ShiftInfo)request.getAttribute("shiftInfo");
String stampFlag = (String)request.getAttribute("stampFlag");		// 打刻種別
//シフトフラグ
String shiftFlag = (String)request.getAttribute("shiftFlag");

// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="/login.jsp" />
<%
}
%>
<%!
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
		DateFormatSymbols dfs = DateFormatSymbols.getInstance(Locale.JAPANESE);
        String[] newWeek = {"","日","月","火","水","木","金","土"};
        dfs.setWeekdays(newWeek);		 
		sdFormat = new SimpleDateFormat("yyyy年MM月dd日(E)", dfs);
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
// カレンダーのシフトの色を返す
private String CalShiftCol(String kinmuKubunName){
	String shiftColor = null;
	switch(kinmuKubunName){
	  //0：昼　1：夜　2：昼夜　3：24勤務　4：その他
	  case "0":
	    shiftColor = "mor";
		break;
	  case "1":
		shiftColor = "eve";
		break;
	  case "2":
		shiftColor = "se";
		break;
	  case "3":
		shiftColor = "all";
		break;
	  case "4":
		shiftColor = "none";
		break;
	  default:
		shiftColor = "none";
		break;
	}
	return shiftColor;
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
  <link rel="stylesheet" href="./assets/css/style.css?<%=(new SimpleDateFormat("yyyyMMddHHmmssSSS")).format(new Date())%>">

  <!-- Favicon
  -------------------------------------------------- -->
  <link rel="icon" type="image/png" href="./assets/images/favicon.png">

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
          <button>
            <img src="./assets/images/mail.png" alt="">
            <span class="num"><%=Constant.UNREAD%></span>
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
            <input type="hidden" value="<%=stampFlag %>" name="stampFlag">
            <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </div>
        <div class="ico">
          <form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
          <button>
            <img src="./assets/images/home.png" alt="">
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
            <input type="hidden" value="<%=stampFlag %>" name="stampFlag">
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
  <main class="d-stamp">

<%
// シフト一覧から選択した場合
if(shiftInfo.shiftHiduke != null){
%>
    <!-- 現場(site-itemのclassでカラー変更＆アイコン画像の変更) -->
    <div class="site-item <%=CalShiftCol(shiftInfo.timeFlag)%>">
      <div class="item-inner">
        <div class="above row">
          <div class="left">
            <img src="./assets/images/<%=CalShiftCol(shiftInfo.timeFlag)%>.png" alt="">
          </div>
          <div class="right">
            <div class="item-ttl">
              <h2><%=shiftInfo.kinmuBashoName %></h2>
              <span class="sub"><%=shiftInfo.gyomuKubunName %>・<%=shiftInfo.kinmuKubunName %>・<%=shiftInfo.keiyakuKubunName %></span>
            </div>
            <div class="item-time">
              <span class="day"><%=GetFormatshiftHiduke(shiftInfo.shiftHiduke) %></span>
              <span class="time-zone"><%=shiftInfo.bgnTime %>～<%=shiftInfo.endTime %></span>
            </div>
          </div>
        </div>
        <!-- 現場詳細ボタン -->
        <!-- <div class="btn">
          <a class="white" href="#">現場の詳細</a>
        </div> -->
      </div>
    </div>
<%
}
%>
<%
if(stampFlag.equals("2")){
	if(shiftInfo != null && shiftInfo.bgnStampTime == null && shiftFlag == null){
%>
    <div class="caution">
      <p>【注意】上番打刻がありません。</p>
    </div>
<%
	 }
}
%>

    <div class="contents">
      <div class="t-confirm">
        <span class="day" id="realDate2"></span>
        <span class="time-zone" id="realTime2"></span>
      </div>

      <div class="c-txt row">
        <div class="left">
          <img src="./assets/images/go.png" alt="">
        </div>
        <div class="right">
<%
// 打刻種別：上番
if(stampFlag.equals("1")){
%>
          <p>
            上記の時間で<br>
            上番を報告します。<br>
            よろしいですか？<br>
          </p>
<%
// 打刻種別：下番
} else {
%>
          <p>
            上記の時間で<br>
            下番を報告します。<br>
            よろしいですか？<br>
          </p>
<%
}
%>
        </div>
      </div>
    
      <!-- 上番報告ボタン -->
      <div class="btn mt-6">
<%
// シフト一覧から選択した場合
if(shiftInfo.shiftHiduke != null){
%>
<form id="workStartExecute"  action="<%= request.getContextPath() %>/WorkStartExecute" method="post" accept-charset="UTF-8">
<%
}else{
%>
<form id="workExecute"  action="<%= request.getContextPath() %>/WorkExecute" method="post" accept-charset="UTF-8">
<%
}
%>
<%
// 打刻種別：上番
if(stampFlag.equals("1")){
%>
        <button type="button" onclick="doPreSubmit(this.form);">上番報告する</button>
<%
// 打刻種別：下番
} else {
%>
        <button type="button" onclick="doPreSubmit(this.form);">下番報告する</button>
<%
}
%>
          <input type="hidden" id="stringDate" name="stringDate">
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
          <input type="hidden" value="<%=shiftInfo.id %>" name="shiftDataId">
          <input type="hidden" value="<%=shiftInfo.timeFlag %>" name="timeFlag">
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
          <input type="hidden" value="<%=stampFlag %>" name="stampFlag">
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
        </form>
      </div>
    
    </div>


    <!-- 前の画面に戻る -->
    <div class="btn mt-8">
      <button class="white" onclick="history.back(-1);return false;">前の画面に戻る</button>
    </div>

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



   <!-- Script
  -------------------------------------------------- -->
  <!-- Jquery読み込み -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <!-- 共通部品JS読み込み -->
  <script src="./assets/js/script.js?<%=(new SimpleDateFormat("yyyyMMddHHmmssSSS")).format(new Date())%>"></script>
  <!-- bootstrap JS読み込み -->
  <script src="./assets/bootstrap/js/bootstrap.min.js"></script>

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
    document.getElementById("realDate2").innerHTML = dspDate;
    
    var nowHour		= ddigit(nowTime.getHours());
    var nowMinute	= ddigit(nowTime.getMinutes());
    var dspTime		= nowHour + ":" + nowMinute; 
    document.getElementById("realTime").innerHTML = dspTime;
    document.getElementById("realTime2").innerHTML = dspTime;
}
setInterval('showDate()',60000);

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
	document.getElementById('stringDate').value = dspDateTime;
}
setInterval('GetDateTime()',60000);
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
//ロード時に日時をリアルタイム表示する
window.onload = function(){
	showDate();
	GetDateTime();
}

//サブミット前に時刻情報とGPS情報を取得する
function doPreSubmit(frm){
	GetDateTime();
	getGpsData(frm);
}
</script>

	<jsp:include page="../loading.jsp" />
</body>
</html>