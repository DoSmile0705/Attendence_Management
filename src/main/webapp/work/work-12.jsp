<!-- 現場詳細ページ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Locale" %>
<%@ page import="util.SafetyInfo" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.RequestKubun" %>
<%@ page import="util.Constant" %>
<%
// ***************************************************
// work-12.jsp
// 安否確認通知を行う
// ***************************************************
%>
<%
LoginInfo loginInfo			= (LoginInfo)request.getAttribute("loginInfo");
List<SafetyInfo> safetyList	= (List<SafetyInfo>)request.getAttribute("safetyList");
SafetyInfo safety			= (SafetyInfo)request.getAttribute("safety");

// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="/login.jsp" />
<%
}
%>
<%!
//文字列にNULLが入っているかチェック
String GetTextData(String text){
	String resText = text;
	if(resText == null || resText.equals("null")){
		resText = "";
	}
	return resText;
}
//日付の文字列を変換
String GetSafetyDate(String safetyDate){
	String resDate = null;
	if(safetyDate != null){
		try{
			SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = sdFormat.parse(safetyDate);
			sdFormat = new SimpleDateFormat("yyyy年MM月dd日(E) HH:mm", Locale.JAPANESE);
			resDate = sdFormat.format(date);
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
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

</head>
<body>
  <!-- ヘッダー部 -->
  <header>
    <!-- 固定ヘッダー -->
    <section class="fixed above u-layer">
      <div class="row">
        <div class="nav-item">
    <form name="form2" onclick="GetDateTime()" action="<%= request.getContextPath() %>/Login" method="post">
        <a href="javascript:form2.submit()">＜戻る</a>
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
        <div class="nav-item"><p id="realDate"></p></div>
        <div class="nav-item"><p id="realTime"></p></div>
      </div>
    </section>

    <!-- 固定フッター -->
    <section class="fixed bottom">
      <div class="row">
        <div class="ico mail">
          <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/InformationList" method="post">
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
            <input type="hidden" id="dspDate" name="dspDate">
            <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </div>
        <div class="ico">
          <form onclick="GetDateTime()" action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
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
            <input type="hidden" id="dspDate" name="dspDate">
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
        安否通知確認
      </h1>
    </section>

    <div class="btn">
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/Login" method="post">
      <button >戻る</button>
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
<%
if(safety.id != null){
%>
    <div class="w-box inner">
      <P align="center"><%=GetSafetyDate(safety.entryDate) %></P>
      <P align="center"><b>【<%=safety.safetyName %>】</b></P>
      <P align="center">事務所伝達事項</P>
      <P align="center"><b><%=GetTextData(safety.note) %></b></P>
      <P align="center">選択済み</P>
    </div>
<%
}
%>
    <div class="w-box mt-8">
      <span>状況選択／変更</span>
      <select name="dt-num" id="dt-num">
<%
//安否確認通知リストにデータがある場合
if(safetyList != null){
	for(int i = 0; i < safetyList.size(); i ++){
%>
        <option value="<%=safetyList.get(i).id %>/<%=safetyList.get(i).safetyFlag %>/<%=safetyList.get(i).safetyName %>/<%=safetyList.get(i).note %>/<%=safetyList.get(i).safetyLv %>/<%=safetyList.get(i).isDeleteFlag %>/<%=safetyList.get(i).backColor %>/<%=safetyList.get(i).fontColor %>"><%=safetyList.get(i).safetyName %></option>
<%
	}
}
%>
      </select>


    </div>
    <div class="w-box mt-8">
    <div class="row">
    <label for="textarea">伝達事項</label>
    <textarea name="textarea" id="textarea"></textarea>
    </div>
    </div>

    <!-- フォームはここまで -->

<br><br>

    <!-- 安否確認通知ボタン -->
    <div class="btn">
    <form name="form1" onclick="GetSafetyDate()" action="<%= request.getContextPath() %>/SafetyContact" method="post">
      <button onclick="window.close();">安否確認通知</button>
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
      <input type="hidden" id="safetySelect" name="safetySelect">
      <input type="hidden" id="safetyText" name="safetyText">
    </form>
    </div>

    <!-- 閉じるボタン -->
    <div class="btn">
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/Login" method="post">
      <button>戻る</button>
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

window.onload = function(){
  //画面の日時表示
  GetDateTime();
  showDate();
}
/* ▲▲▲ 2022.08.14 HTML→JSP変換対応 ▲▲▲ */
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
	document.getElementById('dspDate').value = dspDateTime;
}
setInterval('GetDateTime()',60000);
//画面表示用のリアルタイム日付
function showDate() {
    var nowTime		= new Date();
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
//選択した日時をリクエストのパラメータにセットする関数
function GetSafetyDate(){
	var temp = document.getElementById('dt-num').value;
	var text = document.getElementById('textarea').value;
	document.getElementById('safetySelect').value = temp;
	document.getElementById('safetyText').value = text;
}
</script>

</body>
</html>