<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="util.RequestData" %>
<%@ page import="util.Constant" %>
<%@ page import="util.RequestMasterData" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%
// ***************************************************
// work-4-1.jsp
// 早出申請を行う
// ***************************************************
%>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
ShiftInfo shiftInfo = (ShiftInfo)request.getAttribute("shiftInfo");
RequestData requestData = (RequestData)request.getAttribute("requestData");
String requestFlag = (String)request.getAttribute("requestFlag");
List<RequestMasterData> requestMasterList = (List<RequestMasterData>)request.getAttribute("requestMasterList");

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
// フォーマットを変更して曜日を返す
private String GetFormatAddMonth(String dateTime, int diff) {
	String datestr = dateTime.substring(0, 4);
	datestr += "/";
	datestr += dateTime.substring(4, 6);
	datestr += "/";
	datestr += dateTime.substring(6, 8);
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy/MM/dd");	
		Date date = sdFormat.parse(datestr);
		Calendar calendar = Calendar.getInstance();
 		calendar.setTime(date);
 		calendar.add(Calendar.DATE, diff);
 		date = calendar.getTime();
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
//申請データの業務終了時刻を変換
private String GetTimeValue(String dateTime){
	String resTime = null;
	if(dateTime.equals("0")){
		resTime = "00:00";
	}else{
		int calcTime = Integer.parseInt(dateTime.substring(0, dateTime.length() -2));
		calcTime = calcTime / 60;
		resTime = String.format("%02d", calcTime);
		resTime = resTime + ":" + dateTime.substring(dateTime.length() -2, dateTime.length());
	}
	return resTime;
}
//申請データの総残業時間を変換
private String GetValue(String dateTime){
	String resTime = null;
	if(dateTime.equals("0")){
		resTime = "00:00";
	}else{
		int calcTime = Integer.parseInt(dateTime);
		resTime = String.format("%04d", calcTime);
		resTime = resTime.substring(0, 2) + ":" + resTime.substring(2, 4);
	}
	return resTime;
}
//申請の可否を判断
private boolean JudgeRequest(RequestData requestData){
	//申請判定用フラグ
	boolean judgeFlag = false;

	//未申請の場合
	if(requestData.certification == null){
		//申請可
		judgeFlag = true;
	//申請済みの場合
	}else{
		//「申請時刻」「申請値」「メモ」がリセット＝申請削除の場合
		if(requestData.timeValue.equals("0") && requestData.value.equals("0") && requestData.note == null){
			//申請可
			judgeFlag = true;
		}
	}
	return judgeFlag;
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
        早出申請
      </h1>
    </section>

    <div class="w-box inner">
      <span class="dt">日時</span>
      <select name="dt-num" id="dt-num" disabled>
        <option value="<%=GetFormatshiftHiduke(requestData.kinmuHiduke) %>"><%=GetFormatshiftHiduke(requestData.kinmuHiduke) %></option>
      </select>
    </div>

    <hr class="mt-6">

    <section class="inner">

      <!-- 現在の申請状況 -->
      <div class="w-box mt-8">
        <h2>現在の申請状況</h2>
        <ul class="status-archive">
<%
if(requestData.certification != null){
	switch(requestData.certification){
		case "0":
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag ac2"><span>申請中</span></li>
<%
			break;
		case "1":
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag ac1"><span>申請受理</span></li>
<%
			break;
		case "2":
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag red"><span>申請却下</span></li>
<%
			break;
		case "3":
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
%>
<%
}else{
%>
          <li class="row"><span class="ttl">早出申請</span><span class="tag ac1"><span>未申請</span></li>
<%
}
%>
        </ul>
      </div>

      <!-- 各種申請 -->
      <div class="w-box mt-8">
        <h2>申請内容</h2>
        <!-- ボタン -->
        <form method="post" onclick="GetRequestDate()" action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">

          <div class="overtime app-time">
            <label for="overtime-1">早出申請①：業務開始時刻</label>
<%
if(requestData.timeValue != null){
	//認証が「9」の場合※削除UPDATE済みのデータ
	if(requestData.certification.equals("9")){
		//当日のシフトの終了時刻が存在
		if(shiftInfo.endTime != null){
%>
			<input type="time"  name="overtime-1" id="overtime-1" value="<%=shiftInfo.bgnTime%>" required>
<%
		//当日のシフトが未存在
		}else{
%>
			<input type="time"  name="overtime-1" id="overtime-1" value="00:00" required>
<%
		}
	//勤務リクエストデータが登録済
	}else{
%>
		<input type="time"  name="overtime-1" id="overtime-1" value="<%=GetTimeValue(requestData.timeValue) %>" disabled="disabled"disabled="disabled" >
<%
	}
}else{
	if(shiftInfo.bgnTime != null){
			//早出申請を初期値：シフト終了時刻で表示
%>
			<input type="time"  name="overtime-1" id="overtime-1" value="<%=shiftInfo.bgnTime%>" required>
<%
	}else{
			//早出申請を初期値：00:00で表示
%>
			<input type="time"  name="overtime-1" id="overtime-1" value="00:00" required>
<%
	}
}
%>
            <label for="overtime-2">早出申請②：総早出時間</label>
<%
//勤務リクエストデータの時刻がNULLでない
if(requestData.value != null){
	//認証が「9」の場合※削除UPDATE済みのデータ
	if(requestData.certification.equals("9")){
%>
			<input type="time" list="time-list" name="overtime-2" id="overtime-2" value="00:00" min="00:00" max="12:00" step="60" required>
<%
	//勤務リクエストデータが登録済
	}else{
%>
			<input type="time" list="time-list" name="overtime-2" id="overtime-2" value="<%=GetValue(requestData.value)%>" disabled="disabled">
<%
	}
//総早出時間を初期値00:00、1分単位で表示
}else{
			//総早出時間を初期値00:00、1分単位で表示
%>
			<input type="time" list="time-list" name="overtime-2" id="overtime-2" value="00:00" min="00:00" max="12:00" step="60" required>
<%
}
%>
			<datalist id="time-list">
			</datalist>
          </div>


          <label for="reason">申請理由</label>
          <select name="reason" id="reason">
<%
//リクエストマスタデータを申請理由に出力
if(requestMasterList.size() > 0){
	for(int i = 0; i < requestMasterList.size(); i ++){
		//区分コードが0を選択済み
		if(requestMasterList.get(i).kubunCD.equals("0")){
%>
            <option value="<%=requestMasterList.get(i).kubunName%>" selected><%=requestMasterList.get(i).kubunName%></option>
<%
		}else{
%>
            <option value="<%=requestMasterList.get(i).kubunName%>"><%=requestMasterList.get(i).kubunName%></option>
		
<%
		}
	}
}
%>
          </select>
    
          <label for="textarea">その他・申請内容</label>
<%
if(requestData.note != null){
%>
          <textarea name="textarea" id="textarea" disabled="disabled" ><%=requestData.note %></textarea>
<%
}else{
%>
          <textarea name="textarea" id="textarea"></textarea>
<%
}
%>

<%
//申請可の場合
if(JudgeRequest(requestData)){
%>
          <div class="submit">
            <button type="submit">申請確認画面へ</button>
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
              <input type="hidden" value="<%=requestData.kinmuHiduke %>" name="kinmuHiduke">
              <input type="hidden" value="<%=requestData.category %>" name="category">
              <input type="hidden" value="<%=requestData.timeValue %>" name="timeValue">
              <input type="hidden" value="<%=requestData.setTimeValue %>" name="setTimeValue">
              <input type="hidden" value="<%=requestData.value %>" name="value">
              <input type="hidden" value="<%=requestData.setValue %>" name="setValue">
              <input type="hidden" value="<%=requestData.note %>" name="note">
              <input type="hidden" value="<%=requestData.causeFlag %>" name="causeFlag">
              <input type="hidden" value="<%=requestData.certification %>" name="certification">
              <input type="hidden" value="1" name="categoryFlag">
              <input type="hidden" id="overtime-1" name="overtime-1">
              <input type="hidden" id="overtime-2" name="overtime-2">
              <input type="hidden" id="requestDate" name="requestDate">
              <input type="hidden" value="1" name="requestFlag">
              <input type="hidden" id="reason" name="reason">
              <input type="hidden" id="textarea" name="textarea">
          </div>
<%
}
%>
        </form>
      </div>

<%
//申請不可かつ「申請中」の場合、申請削除
if(!JudgeRequest(requestData) && requestData.certification.equals("0")){
%>
      <div class="btn mt-8">
        <form method="post" onclick="GetRequestDate()" action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
        <button class="red">申請削除</button>
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
              <input type="hidden" value="<%=requestData.kinmuHiduke %>" name="kinmuHiduke">
              <input type="hidden" value="<%=requestData.category %>" name="category">
              <input type="hidden" value="<%=requestData.timeValue %>" name="timeValue">
              <input type="hidden" value="<%=requestData.setTimeValue %>" name="setTimeValue">
              <input type="hidden" value="<%=requestData.value %>" name="value">
              <input type="hidden" value="<%=requestData.setValue %>" name="setValue">
              <input type="hidden" value="<%=requestData.note %>" name="note">
              <input type="hidden" value="<%=requestData.causeFlag %>" name="causeFlag">
              <input type="hidden" value="<%=requestData.certification %>" name="certification">
              <input type="hidden" value="1" name="categoryFlag">
              <input type="hidden" id="requestDate" name="requestDate">
              <input type="hidden" value="1" name="requestFlag">
              <input type="hidden" value="1" name="deleteFlag">
              <input type="hidden" value="<%=GetTimeValue(requestData.timeValue) %>" name="overtime-1">
              <input type="hidden" value="<%=GetValue(requestData.value) %>" name="overtime-2">
              <input type="hidden" id="reason" name="reason">
              <input type="hidden" value="<%=requestData.note %>" name="textarea">
        </form>
      </div>
<%
}
%>
    </section>

    <!-- 前の画面に戻る -->
    <div class="btn mt-8 mb-10">
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
// 選択した日時をリクエストのパラメータにセットする関数
function GetRequestDate(){
	var nowDate = document.getElementById('dt-num').value;
	document.getElementById('requestDate').value = nowDate;
}
//ロード時に日時をリアルタイム表示する
window.onload = function(){
	showDate();
}
</script>

</body>
</html>