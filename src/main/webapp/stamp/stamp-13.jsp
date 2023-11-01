<!-- 上下番報告　現場選択ページ -->
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%@ page import="util.Constant" %>

<%
// ***************************************************
// stamp-13.jsp
// 出勤・退勤報告のみ登録する画面
// ***************************************************
%>

<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
// シフトなし上番打刻
String attendStamp = (String)request.getAttribute("attendStamp");
// シフトなし下番打刻
String leaveStamp = (String)request.getAttribute("leaveStamp");
// シフトなし上番打刻5分後
String attendStampFive = (String)request.getAttribute("attendStampFive");
// シフトなし下番打刻5分後
String leaveStampFive = (String)request.getAttribute("leaveStampFive");

// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="/login.jsp" />
<%
}
%>
<%!
// フォーマットを変更して時間を返す関数
private String GetFormatStampDate(String dateTime) {
	String datestr = null;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
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
          <input type="hidden" value="1" name="stampFlag"><!-- 打刻種別 -->
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
  <main class="p-stamp">
    <section class="inner">
      <!-- ページタイトル -->
      <h1 class="m-ttl">
        出勤・退勤報告
      </h1>

      <div class="n-site mt-5">
        <ul class="site-archive">

          <!-- 上番 -->
          <li class="site-item ac2">
            <form action="<%= request.getContextPath() %>/WorkStartConfirm" method="post" accept-charset="UTF-8">
            <button>
              <div class="above row">
                <div class="left">
                  <img src="./assets/images/go-w.png" alt="">
                </div>
                <div class="right">
                  <div class="item-ttl">
                    <h2><span>出勤報告する</span></h2>
                  </div>
                </div>
              </div>
              <div class="middle">
<%
//退勤報告の打刻あるなしで打刻時間を表示
if(attendStamp == null){
%>
                <div class="stamp-time row">
                  <div class="left"><span>出勤報告</span></div>
                  <div class="right">--:--<span>未</span></div>
                </div>
<%
}else{
%>
                <div class="stamp-time row done">
                  <div class="left"><span>出勤報告</span></div>
                  <div class="right"><%=GetFormatStampDate(attendStamp) %><span>済</span></div>
                </div>
              </div>
<%
}
%>
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
              <input type="hidden" value="1" name="stampFlag"><!-- 打刻種別 -->
              <input type="hidden" value="<%=attendStamp %>" name="attendStamp">
              <input type="hidden" value="<%=leaveStamp %>" name="leaveStamp">
              <input type="hidden" value="0" name="shiftFlag"><!-- シフトなし -->
              <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
              <input type="hidden" value="<%=attendStampFive %>" name="attendStampFive">
              <input type="hidden" value="<%=leaveStampFive %>" name="leaveStampFive">
            </form>
          </li>

          <!-- 下番 -->
          <li class="site-item ac3">
            <form action="<%= request.getContextPath() %>/WorkStartConfirm" method="post" accept-charset="UTF-8">
            <button>
              <div class="above row">
                <div class="left">
                  <img src="./assets/images/leave-w.png" alt="">
                </div>
                <div class="right">
                  <div class="item-ttl">
                    <h2><span>退勤報告する</span></h2>
                  </div>
                </div>
              </div>
              <div class="middle">
<%
//退勤報告の打刻あるなしで打刻時間を表示
if(leaveStamp == null){
%>
                <div class="stamp-time row">
                  <div class="left"><span>退勤報告</span></div>
                  <div class="right">--:--<span>未</span></div>
                </div>
              </div>
<%
}else{
%>
                <div class="stamp-time row done">
                  <div class="left"><span>退勤報告</span></div>
                  <div class="right"><%=GetFormatStampDate(leaveStamp) %><span>済</span></div>
                </div>
              </div>
<%
}
%>
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
              <input type="hidden" value="2" name="stampFlag"><!-- 打刻種別 -->
              <input type="hidden" value="<%=attendStamp %>" name="attendStamp">
              <input type="hidden" value="<%=leaveStamp %>" name="leaveStamp">
              <input type="hidden" value="0" name="shiftFlag"><!-- シフトなし -->
              <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
              <input type="hidden" value="<%=attendStampFive %>" name="attendStampFive">
              <input type="hidden" value="<%=leaveStampFive %>" name="leaveStampFive">
            </form>
          </li>
        </ul>

      </div>
    </section>




    <!-- トップ画面に戻る -->
    <div class="btn mt-8">
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