<!-- 上下番報告取り消し完了ページ -->
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
// stamp-8.jsp
// 3-13：キャンセル確定
// 上下番のキャンセル確定を表示する
// ***************************************************
%>
<%
String stringDate = (String)request.getAttribute("stringDate");
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
ShiftInfo shiftInfo = (ShiftInfo)request.getAttribute("shiftInfo");
//打刻種別
String stampFlag = (String)request.getAttribute("stampFlag");

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
  <link rel="stylesheet" href="./assets/css/style.css">

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
            <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </div>
        <div class="ico">
          <form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
          <button>
            <img src="./assets/images/home.png" alt="">
          </button>
<%
// シフト情報がある場合は出力
if(shiftInfo != null){
%>
            <input type="hidden" value="<%=shiftInfo.shiftHiduke %>" name="shiftHiduke">
            <input type="hidden" value="<%=shiftInfo.note %>" name="shiftNote">
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
  <main class="d-stamp">

<%
// シフト情報がある場合は出力
if(shiftInfo != null){
%>
    <div class="site-item <%=CalShiftCol(shiftInfo.timeFlag)%>">
<%
}else{
%>
    <!-- 現場(site-itemのclassでカラー変更＆アイコン画像の変更) -->
    <div class="site-item mor">
<%
}
// シフト情報がある場合は出力
if(shiftInfo != null){
%>
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
          <a class="white" href="../top.html">現場の詳細</a>
        </div> -->
      </div>
<%
}
// 上番
if(stampFlag.equals("1")){
%>
      <div class="middle">
        <div class="stamp-time row">
          <div class="left"><span>上番報告</span></div><div class="right">--:--<span>未</span></div>
        </div>
      </div>
    </div>
    
    <p class="m-txt mt-6">
      上番報告を取り消しました。
    </p>
<%
} else {
%>
      <div class="middle">
        <div class="stamp-time row">
          <div class="left"><span>下番報告</span></div><div class="right">--:--<span>未</span></div>
        </div>
      </div>
    </div>
    
    <p class="m-txt mt-6">
      下番報告を取り消しました。
    </p>
<%
}
%>

    <!-- 現場選択に戻る -->
    <div class="btn mt-6">
      <form name="form1" action="<%= request.getContextPath() %>/AttendList" method="post">
      <button class="white">現場選択に戻る</button>
<%
// シフト情報がある場合は出力
if(shiftInfo != null){
%>
        <input type="hidden" value="<%=shiftInfo.shiftHiduke %>" name="shiftHiduke">
        <input type="hidden" value="<%=shiftInfo.note %>" name="shiftNote">
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
        <input type="hidden" value="<%=loginInfo.companyCode %>" name="companyCode">
        <input type="hidden" value="<%=loginInfo.companyName %>" name="companyName">
        <input type="hidden" value="<%=loginInfo.sessionId %>" name="sessionId">
        <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
        <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
        <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
      </form>
    </div>

    <!-- トップ画面に戻る -->
    <div class="btn mt-6">
      <form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
      <button class="white">トップ画面に戻る</button>
<%
// シフト情報がある場合は出力
if(shiftInfo != null){
%>
        <input type="hidden" value="<%=shiftInfo.shiftHiduke %>" name="shiftHiduke">
        <input type="hidden" value="<%=shiftInfo.note %>" name="shiftNote">
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

    var nowHour		= ddigit(nowTime.getHours());
    var nowMinute	= ddigit(nowTime.getMinutes());
    var dspTime		= nowHour + ":" + nowMinute; 
    document.getElementById("realTime").innerHTML = dspTime;
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
//ロード時に日時をリアルタイム表示する
window.onload = function(){
	showDate();
}
</script>

</body>
</html>