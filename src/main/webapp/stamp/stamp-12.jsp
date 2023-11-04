<!-- 上下番報告取り消し完了ページ（シフト無し） -->
<!-- 上下番報告取り消しページ（シフト無し） -->
<!-- 上下番報告ページ（シフト無し） -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%@ page import="util.Constant" %>
<%
// ***************************************************
// stamp-12.jsp
// シフトなしの上下番の打刻キャンセル完了
// ***************************************************
%>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
String stampFlag = (String)request.getAttribute("stampFlag");
//削除対象タイムスタンプ
String delStampTime = (String)request.getAttribute("delStampTime");

// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="/login.jsp" />
<%
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
        <div class="nav-item"><p id="realDate"></div>
        <div class="nav-item"><p id="realTime"></div>
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
  <main class="d-stamp no-site">

<%
if(stampFlag.equals("1")){
%>
    <div class="site-item mor">
      <div class="middle">
        <div class="stamp-time row">
          <div class="left"><span>出勤報告</span></div><div class="right">--:--<span>未</span></div>
        </div>
      </div>
    </div>
    
    <p class="m-txt mt-6">
      出勤報告を取り消しました。
    </p>
<%
}else{
%>
    <div class="site-item mor">
      <div class="middle">
        <div class="stamp-time row">
          <div class="left"><span>退勤報告</span></div><div class="right">--:--<span>未</span></div>
        </div>
      </div>
    </div>
    
    <p class="m-txt mt-6">
      退勤報告を取り消しました。
    </p>
<%
}
%>


    <!-- 現場選択に戻る -->
    <div class="btn mt-6">
      <form name="form1" action="<%= request.getContextPath() %>/AttendList" method="post">
      <button class="white">現場選択に戻る</button>
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

    <!-- トップ画面に戻る -->
    <div class="btn mt-6">
      <form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
      <button class="white">トップ画面に戻る</button>
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

	<jsp:include page="../loading.jsp" />
</body>
</html>