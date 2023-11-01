<!-- 現場詳細ページ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Locale" %>
<%@ page import="util.ShiftRequest" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.RequestKubun" %>
<%@ page import="util.Constant" %>
<%
// ***************************************************
// work-11.jsp
// シフト申請を行う
// ***************************************************
%>
<%
LoginInfo loginInfo				= (LoginInfo)request.getAttribute("loginInfo");
ShiftRequest shiftReq			= (ShiftRequest)request.getAttribute("shiftReq");
String reqDay					= (String)request.getAttribute("reqDay");
String reqDate					= (String)request.getAttribute("reqDate");
String reqWeek					= (String)request.getAttribute("reqWeek");
List<RequestKubun> reqKubunList	= (List<RequestKubun>)request.getAttribute("reqKubunList");
// 対象月
String nowDate = (String)request.getAttribute("nowDate");
// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="/login.jsp" />
<%
}
%>
<%!
String GetBlankORNull(String text){
	String res = null;
	if(text == null){
		res = "";
	}else{
		res = text;
	}
	return res;
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
        <div class="nav-item">
    <form name="form2" onclick="GetDateTime()" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
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
      <!-- シフト申請から遷移したことを示すフラグ -->
      <input type="hidden" value="1" name="subFlag">
      <input type="hidden" value="<%=reqDay %>" name="reqDay">
      <input type="hidden" value="<%=reqWeek%>" name="reqWeek">
      <input type="hidden" value="<%=reqDate%>" name="reqDate">
      <input type="hidden" value="<%=nowDate%>" name="nowDate">
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
        シフト申請
      </h1>
    </section>

    <div class="btn">
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
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
      <input type="hidden" value="1" name="subFlag">
      <input type="hidden" value="<%=reqDay %>" name="reqDay">
      <input type="hidden" value="<%=reqWeek%>" name="reqWeek">
      <input type="hidden" value="<%=reqDate%>" name="reqDate">
      <input type="hidden" value="<%=nowDate%>" name="nowDate">
    </form>
    </div>

      <div class="w-box dcal mt-5">
        <ul class="dcal-archive">
          <li class="dcal-item">
            <div class="left">
              <span class="d"><%=reqDay %></span>
              <span class="dow">(<%=reqWeek %>)</span>
            </div>
            <div class="right">
              <ul class="work-archive">
              <!-- シフト表示 -->
<%
if(shiftReq.backColorFlag == null){
%>
                <li class="work-item gray">
                  <button disabled>
                  <p align="center">未申請
                  </button>
                </li>
<%
}else{
%>
                <li class="work-item" style=background-color:<%=shiftReq.backColorFlag %>>
                  <button disabled>
                  <p align="center"><%=shiftReq.requestName %>
                  </button>
                </li>
<%
}
%>
              </ul>
<%
if(shiftReq.note != null){
	//空じゃない
	if(!shiftReq.note.isEmpty()){
%>
              <P align="center">備考（申請理由など）</P>
              <P align="center"><b><%=GetBlankORNull(shiftReq.note) %></b></P>
<%
	}
}
%>
            </div>
          </li>
        </ul>
      </div>


     <form action="<%= request.getContextPath() %>/ShiftApplyExecute" method="post" accept-charset="UTF-8">
<%
for(int i = 0; i < reqKubunList.size(); i ++){
%>
    <div class="btn">
      <button name="button1" value="<%=reqKubunList.get(i).requestName %>" style=background-color:<%=reqKubunList.get(i).backColorFlag %> onclick="GetRequestFlag(<%=reqKubunList.get(i).requestFlag %>)"><%=reqKubunList.get(i).requestName %></button>
    </div>
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
      <input type="hidden" value="<%=shiftReq.id %>" name=req_ID>
      <input type="hidden" value="<%=shiftReq.worker_ID %>" name=worker_ID>
      <input type="hidden" value="<%=shiftReq.hiduke %>" name="hiduke">
      <input type="hidden" value="<%=shiftReq.requestName %>" name="requestName">
      <input type="hidden" value="<%=shiftReq.note %>" name="note">
      <input type="hidden" value="<%=shiftReq.backColorFlag %>" name="backColorFlag">
      <input type="hidden" value="<%=shiftReq.fontColorFlag %>" name="fontColorFlag">
      <input type="hidden" value="<%=reqDay %>" name="reqDay">
      <input type="hidden" value="<%=reqWeek %>" name="reqWeek">
      <input type="hidden" value="<%=reqDate %>" name="reqDate">
      <input type="hidden" value="<%=nowDate %>" name="nowDate">
      <input type="hidden" id="requestFlag" name="requestFlag">
<%
}
%>

    <div class="w-box mt-8">
    <div class="row">
    <label for="textarea">備考（申請理由など）</label>
    <textarea name="textarea" id="textarea"></textarea>
      <input type="hidden" id="textarea" name="textarea">
    </div>
    </div>
    </form>
    <!-- フォームはここまで -->

    <div class="btn">
    <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
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
      <!-- シフト申請から遷移したことを示すフラグ -->
      <input type="hidden" value="1" name="subFlag">
      <input type="hidden" value="<%=reqDay %>" name="reqDay">
      <input type="hidden" value="<%=reqWeek%>" name="reqWeek">
      <input type="hidden" value="<%=reqDate%>" name="reqDate">
      <input type="hidden" value="<%=nowDate%>" name="nowDate">
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

function GetButtonName(){
	document.getElementById("reqFlag").value = 1;
}
function GetRequestFlag(requestFlag){
	document.getElementById("requestFlag").value = requestFlag;
}
</script>

</body>
</html>