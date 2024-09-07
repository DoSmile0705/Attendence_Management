<!-- 現場詳細ページ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="util.RequestData" %>
<%@ page import="util.OtherGuard" %>
<%@ page import="util.Constant" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%
// ***************************************************
// work-2.jsp
// 現場の詳細を表示する
// ***************************************************
%>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
ShiftInfo shiftInfo = (ShiftInfo)request.getAttribute("shiftInfo");
RequestData requestOver = (RequestData)request.getAttribute("requestOver");
RequestData requestEarly = (RequestData)request.getAttribute("requestEarly");
RequestData requestTransport = (RequestData)request.getAttribute("requestTransport");
List<OtherGuard> otherGuardList = (List<OtherGuard>)request.getAttribute("otherGuardList");

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
//データがNULLだったら空白を表示する関数
private String NullForBlank(String data){
	String rtnStr = null;
	if(data == null || data.equals("0")){
		rtnStr = "";
	}else{
		rtnStr = data;
	}
	return rtnStr;
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
// フォーマットを変更して時間を返す関数
private String GetFormatGuardDate(String dateTime) {
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
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
        </form>
        </div>
        <div class="ico">
        <form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
          <button>
            <img src="./assets/images/home.png" alt="">
          </button>
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
        シフト情報<br>
        変更・申請依頼
      </h1>
    </section>

    <!-- 現場詳細 -->
    <div class="site-item <%=CalShiftCol(shiftInfo.timeFlag) %>">
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
      </div>
    </div>

    <section class="inner">
      <!-- 場所 -->
      <div class="w-box mt-6">
        <h2>場所</h2>
        <p>
          <%=shiftInfo.kinmuBashoName %><br>
          <%=NullForBlank(shiftInfo.adrPostNo) %><br>
          <%=NullForBlank(shiftInfo.adrMain) %><br>
          <%=NullForBlank(shiftInfo.adrSub) %>
        </p>
        <div class="btn mt-5">
          <button class="white" onclick="mapdisplay()">地図を開く</button>
        </div>
      </div>
<script>
function mapdisplay() {
  var address = '<%=NullForBlank(shiftInfo.adrPostNo) %>' + '<%=NullForBlank(shiftInfo.adrMain) %>' + '<%=NullForBlank(shiftInfo.adrSub) %>';
  var url = 'https://www.google.co.jp/maps/place/';
  var encodeUrl = encodeURI(url);
  // 別のウィンドウ
  open( url + address, "_blank" );
}
</script>

      <!-- 配置警備員 -->
      <div class="w-box mt-8">
        <h2>配置警備員</h2>
        <!-- ************************************** -->
        <!-- ▼▼▼未実装につきコメントアウト▼▼▼ -->
        <!-- ************************************** -->
        <ul class="member-archive">
<%
if(otherGuardList.size() > 0){
	for(int i = 0; i < otherGuardList.size(); i ++){
%>
          <li class="row"><span class="day"><%=GetFormatGuardDate(otherGuardList.get(i).bgnTimeDate) %>～<%=GetFormatGuardDate(otherGuardList.get(i).endTimeDate) %></span><span class="member"><%=otherGuardList.get(i).firstName %>　<%=otherGuardList.get(i).lastName %></span></li>
<%
	}
}
%>
        </ul>
        <!-- ************************************** -->
        <!-- ▲▲▲未実装につきコメントアウト▲▲▲ -->
        <!-- ************************************** -->
      </div>

      <!-- 現在の申請状況 -->
      <div class="w-box mt-8">
        <h2>現在の申請状況</h2>
        <ul class="status-archive">
      
<%
if(requestEarly.certification != null){
	switch(requestEarly.certification){
	    case "0":	// 申請
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag ac2"><span>申請中</span></li>
<%
			break;
	    case "1":	// 受理
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag ac1"><span>申請受理</span></li>
<%
			break;
	    case "2":	// 却下
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag red"><span>申請却下</span></li>
<%
			break;
	    case "3":	// 確定
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag ac1"><span>申請確定</span></li>
<%
			break;
	    default:
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag ac1"><span>未申請</span></li>
<%
			break;
	}
	
}else{
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag ac1"><span>未申請</span></li>
<%
}
%>

<%
if(requestOver.certification != null){
	switch(requestOver.certification){
	    case "0":	// 申請
%>
          <li class="row"><span class="ttl">残業申請</span><span class="tag ac2"><span>申請中</span></li>
<%
			break;
	    case "1":	// 受理
%>
          <li class="row"><span class="ttl">残業申請</span><span class="tag ac1"><span>申請受理</span></li>
<%
			break;
	    case "2":	// 却下
%>
          <li class="row"><span class="ttl">残業申請</span><span class="tag red"><span>申請却下</span></li>
<%
			break;
	    case "3":	// 確定
%>
          <li class="row"><span class="ttl">残業申請</span><span class="tag ac1"><span>申請確定</span></li>
<%
			break;
	    default:
%>
          <li class="row"><span class="ttl">残業申請</span><span class="tag ac1"><span>未申請</span></li>
<%
			break;
	}
	
}else{
%>
          <li class="row"><span class="ttl">残業申請</span><span class="tag ac1"><span>未申請</span></li>
<%
}
%>

<%
if(requestTransport.certification != null){
	switch(requestTransport.certification){
	    case "0":	// 申請
%>
          <li class="row"><span class="ttl">経費申請</span><span class="tag ac2"><span>申請中</span></li>
<%
			break;
	    case "1":	// 受理
%>
          <li class="row"><span class="ttl">経費申請</span><span class="tag ac1"><span>申請受理</span></li>
<%
			break;
	    case "2":	// 却下
%>
          <li class="row"><span class="ttl">経費申請</span><span class="tag red"><span>申請却下</span></li>
<%
			break;
	    case "3":	// 確定
%>
          <li class="row"><span class="ttl">経費申請</span><span class="tag ac1"><span>申請確定</span></li>
<%
			break;
	    default:
%>
          <li class="row"><span class="ttl">経費申請</span><span class="tag ac1"><span>未申請</span></li>
<%
			break;
	}
	
}else{
%>
          <li class="row"><span class="ttl">経費申請</span><span class="tag ac1"><span>未申請</span></li>
<%
}
%>

<%
if(requestTransport.certification != null){
	switch(requestTransport.certification){
	    case "0":	// 申請
%>
          <li class="row"><span class="ttl">交通費</span><span class="tag ac2"><span>申請中</span></li>
<%
			break;
	    case "1":	// 受理
%>
          <li class="row"><span class="ttl">交通費</span><span class="tag ac1"><span>申請受理</span></li>
<%
			break;
	    case "2":	// 却下
%>
          <li class="row"><span class="ttl">交通費</span><span class="tag red"><span>申請却下</span></li>
<%
			break;
	    case "3":	// 確定
%>
          <li class="row"><span class="ttl">交通費</span><span class="tag ac1"><span>申請確定</span></li>
<%
			break;
	    default:
%>
          <li class="row"><span class="ttl">交通費</span><span class="tag ac1"><span>未申請</span></li>
<%
			break;
	}
	
}else{
%>
          <li class="row"><span class="ttl">交通費</span><span class="tag ac1"><span>未申請</span></li>
<%
}
%>

        </ul>
      </div>
    </section>

    <hr class="mt-8 mb-10">

    <!-- ボタン -->
    <div class="term-con">
        <div class="btn">
          <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
          <button>早出申請</button>
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
  <% 
  //削除済も含めてDBにレコードがある場合は取得
  if(requestEarly.certification != null){
  %>
            <input type="hidden" value="<%=requestEarly.kinmuHiduke %>" name="kinmuHiduke">
            <input type="hidden" value="<%=requestEarly.category %>" name="category">
            <input type="hidden" value="<%=requestEarly.timeValue %>" name="timeValue">
            <input type="hidden" value="<%=requestEarly.setTimeValue %>" name="setTimeValue">
            <input type="hidden" value="<%=requestEarly.value %>" name="value">
            <input type="hidden" value="<%=requestEarly.setValue %>" name="setValue">
            <input type="hidden" value="<%=requestEarly.note %>" name="note">
            <input type="hidden" value="<%=requestEarly.causeFlag %>" name="causeFlag">
            <input type="hidden" value="<%=requestEarly.certification %>" name="certification">
  <% 
  }
  %>
            <input type="hidden" value="1" name="categoryFlag">
            <input type="hidden" value="0" name="requestFlag">
          </form>
        </div>
      </div>
      <div class="btn">
        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
        <button>残業申請</button>
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
<% 
//削除済も含めてDBにレコードがある場合は取得
if(requestOver.certification != null){
%>
          <input type="hidden" value="<%=requestOver.kinmuHiduke %>" name="kinmuHiduke">
          <input type="hidden" value="<%=requestOver.category %>" name="category">
          <input type="hidden" value="<%=requestOver.timeValue %>" name="timeValue">
          <input type="hidden" value="<%=requestOver.setTimeValue %>" name="setTimeValue">
          <input type="hidden" value="<%=requestOver.value %>" name="value">
          <input type="hidden" value="<%=requestOver.setValue %>" name="setValue">
          <input type="hidden" value="<%=requestOver.note %>" name="note">
          <input type="hidden" value="<%=requestOver.causeFlag %>" name="causeFlag">
          <input type="hidden" value="<%=requestOver.certification %>" name="certification">
<% 
}
%>
          <input type="hidden" value="2" name="categoryFlag">
          <input type="hidden" value="0" name="requestFlag">
        </form>
      </div>
      <div class="btn">
        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
        <button>経費申請</button>
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
<% 
//削除済も含めてDBにレコードがある場合は取得
if(requestTransport.certification != null){
%>
          <input type="hidden" value="<%=requestTransport.kinmuHiduke %>" name="kinmuHiduke">
          <input type="hidden" value="<%=requestTransport.category %>" name="category">
          <input type="hidden" value="<%=requestTransport.timeValue %>" name="timeValue">
          <input type="hidden" value="<%=requestTransport.setTimeValue %>" name="setTimeValue">
          <input type="hidden" value="<%=requestTransport.value %>" name="value">
          <input type="hidden" value="<%=requestTransport.setValue %>" name="setValue">
          <input type="hidden" value="<%=requestTransport.note %>" name="note">
          <input type="hidden" value="<%=requestTransport.causeFlag %>" name="causeFlag">
          <input type="hidden" value="<%=requestTransport.certification %>" name="certification">
<% 
}
%>
          <input type="hidden" value="11" name="categoryFlag">
          <input type="hidden" value="0" name="requestFlag">
        </form>
      </div>
      <div class="btn">
        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
        <button>交通費申請</button>
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
<% 
//削除済も含めてDBにレコードがある場合は取得
if(requestTransport.certification != null){
%>
          <input type="hidden" value="<%=requestTransport.kinmuHiduke %>" name="kinmuHiduke">
          <input type="hidden" value="<%=requestTransport.category %>" name="category">
          <input type="hidden" value="<%=requestTransport.timeValue %>" name="timeValue">
          <input type="hidden" value="<%=requestTransport.setTimeValue %>" name="setTimeValue">
          <input type="hidden" value="<%=requestTransport.value %>" name="value">
          <input type="hidden" value="<%=requestTransport.setValue %>" name="setValue">
          <input type="hidden" value="<%=requestTransport.note %>" name="note">
          <input type="hidden" value="<%=requestTransport.causeFlag %>" name="causeFlag">
          <input type="hidden" value="<%=requestTransport.certification %>" name="certification">
<% 
}
%>
          <input type="hidden" value="12" name="categoryFlag">
          <input type="hidden" value="0" name="requestFlag">
        </form>
      </div>
    
    <!-- シフト一覧に戻る -->
    <div class="btn mt-8">
    <!-- 前の画面に戻る -->
      <button class="white" onclick="history.back(-1);return false;">前の画面に戻る</button>
      <br><br>
      <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
    <!-- シフト一覧に戻る -->
      <button class="white">シフト一覧に戻る</button>
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
        <input type="hidden" id="nowDate" name="nowDate">
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
	document.getElementById('nowDate').value = dspDateTime;
}
setInterval('GetDateTime()',60000);
</script>

	<jsp:include page="../loading.jsp" />
</body>
</html>