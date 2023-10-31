<!-- お知らせ一覧ぺージ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.MessageData" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.Constant" %>

<%
// ***************************************************
// term-2.jsp
// 雇用契約書一覧を表示
// ***************************************************
%>

<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
// お知らせ一覧を取得※10件ずつ
List<MessageData> dspList = (List<MessageData>)request.getAttribute("dspList");
// ページ番号を取得
int pageCnt = (int)request.getAttribute("pageCnt");
// 全ページ数を取得
int pageNum = (int)request.getAttribute("pageNum");

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
          <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
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
          <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
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
  <main>
    <!-- ページタイトル -->
    <div class="inner news-ar">
      <section class="sec-ttl">
        <h1 class="m-ttl">
          雇用契約書一覧
        </h1>
      </section>
      <!-- お知らせ一覧 -->
      <section class="sec-contents">
        <div class="display">
          <span><%=pageCnt %></span>&nbsp;ページ
        </div>
        <ul class="news-archive">
<%
for(int i = 0; i < dspList.size(); i ++) {
%>
          <li class="news-item">
            <form action="<%= request.getContextPath() %>/InformationPageLink" method="post" accept-charset="UTF-8">
            <button>
              <span class="day"><%=GetFormatInfoDate(dspList.get(i).makeDate)%></span>
              <p class="n-ttl"><%=dspList.get(i).headerName%></p>
<%
    if(dspList.get(i).isRead.equals("既読")){
%>
              <span class="read-tag read"><%=dspList.get(i).isRead %></span>
<%
    }else{
%>
              <span class="read-tag"><%=dspList.get(i).isRead %></span>
<%
    }
%>
            </button>
              <input type="hidden" value="<%=dspList.get(i).id %>" name="DataId">
              <input type="hidden" value="<%=dspList.get(i).headerName %>" name="headerName">
              <input type="hidden" value="<%=dspList.get(i).makeDate %>" name="makeDate">
              <input type="hidden" value="<%=dspList.get(i).categoryCode %>" name="categoryCode">
              <input type="hidden" value="<%=dspList.get(i).returnDate %>" name="returnDate">
              <input type="hidden" value="<%=dspList.get(i).body1 %>" name="body1">
              <input type="hidden" value="<%=dspList.get(i).body2 %>" name="body2">
              <input type="hidden" value="<%=dspList.get(i).body3 %>" name="body3">
              <input type="hidden" value="<%=dspList.get(i).note %>" name="note">
              <input type="hidden" value="<%=dspList.get(i).messageBinaryFile_ID %>" name="messageBinaryFile_ID">
              <input type="hidden" value="<%=dspList.get(i).company_ID %>" name="company_ID">
              <input type="hidden" value="<%=dspList.get(i).workerIndex %>" name="workerIndex">
              <input type="hidden" value="<%=dspList.get(i).isRead %>" name="isRead">
              <input type="hidden" value="<%=dspList.get(i).answerText %>" name="answerText">
              <input type="hidden" value="<%=dspList.get(i).answerDate %>" name="answerDate">
              <input type="hidden" value="<%=dspList.get(i).readDate %>" name="readDate">
              <input type="hidden" value="<%=dspList.get(i).entryDate %>" name="entryDate">
              <input type="hidden" value="<%=dspList.get(i).keyCode1 %>" name="keyCode1">
              <input type="hidden" value="<%=dspList.get(i).keyCode2 %>" name="keyCode2">
              <input type="hidden" value="<%=dspList.get(i).messageBinaryFileId %>" name="messageBinaryFileId">
              <input type="hidden" value="<%=dspList.get(i).messageData_ID %>" name="messageData_ID">
              <input type="hidden" value="<%=dspList.get(i).guidKey %>" name="guidKey">
              <input type="hidden" value="<%=dspList.get(i).localFileName %>" name="localFileName">
              <input type="hidden" value="<%=dspList.get(i).localcategory %>" name="localcategory">
              <input type="hidden" value="<%=dspList.get(i).uploadDate %>" name="uploadDate">
              <input type="hidden" value="<%=dspList.get(i).uploadFileName %>" name="uploadFileName">
              <input type="hidden" value="<%=dspList.get(i).messageDataId %>" name="messageDataId">
              <input type="hidden" value="<%=dspList.get(i).messageWorkerDataId %>" name="messageWorkerDataId">
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
              <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
              <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
            </form>
          </li>
<%
}
%>
        </ul>
        <!-- 次へ進むボタン（currentでスタイル変更） -->
        <div class="nextnav">
          <form action="<%= request.getContextPath() %>/InformationList" method="post" accept-charset="UTF-8">
          <ul class="row">
<%
// 現ページが1ページ目
if(pageCnt <= 1){
%>
  <%
  // 次が3ページ以上ある場合
  if(pageCnt + 2 < pageNum){
  %>
            <li class="previous">　</li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt + 1 %>"><%=pageCnt + 1 %></button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt + 2 %>"><%=pageCnt + 2 %></button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt + 3 %>"><%=pageCnt + 3 %></button></li>
            <li class="next"><button name="button1" value="次へ">次へ &#62;</button></li>
  <%
  // 次が2ページ以上ある場合
  }else if(pageCnt + 1 < pageNum){
  %>
            <li class="previous">　</li>
            <li class="nav-item">　</li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt + 1 %>"><%=pageCnt + 1 %></button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt + 2 %>"><%=pageCnt + 2 %></button></li>
            <li class="next"><button name="button1" value="次へ">次へ &#62;</button></li>
  <%
  // 現在が1ページかつ最後のページ
  }else if(pageCnt == pageNum) {
  %>

  <%
  // 次が2ページ目で最後の場合
  }else if(pageCnt + 1 == pageNum){
  %>
            <li class="previous">　</li>
            <li class="nav-item">　</li>
            <li class="nav-item">　</li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt + 1 %>"><%=pageCnt + 1 %></button></li>
            <li class="next"><button name="button1" value="次へ">次へ &#62;</button></li>
  <%
  // そのページが最後の場合
  }else{
  %>

  <%
  }
  %>
<%
}else{
%>
  <%
  // 次のページがある場合は
  if(pageCnt < pageNum){
%>
            <li class="previous"><button name="button1" value="前へ">&#60; 前へ</button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt - 1 %>"><%=pageCnt - 1 %></button></li>
            <li class="nav-item">　</li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt + 1 %>"><%=pageCnt + 1 %></button></li>
            <li class="next"><button name="button1" value="次へ">次へ &#62;</button></li>
<%
  // そのページが最後の場合
  }else{
	  // 前に3ページ以上
	  if(pageCnt > 3){
%>
            <li class="previous"><button name="button1" value="前へ">&#60; 前へ</button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt - 3 %>"><%=pageCnt - 3 %></button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt - 2 %>"><%=pageCnt - 2 %></button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt - 1 %>"><%=pageCnt - 1 %></button></li>
            <li class="next">　</li>
<%
	  // 前に2ページ以上
	  }else if(pageCnt > 2){
%>
            <li class="previous"><button name="button1" value="前へ">&#60; 前へ</button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt - 2 %>"><%=pageCnt - 2 %></button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt - 1 %>"><%=pageCnt - 1 %></button></li>
            <li class="nav-item">　</li>
            <li class="next">　</li>
<%
	  }else{
%>
            <li class="previous"><button name="button1" value="前へ">&#60; 前へ</button></li>
            <li class="nav-item"><button name="button1" value="<%=pageCnt - 1 %>"><%=pageCnt - 1 %></button></li>
            <li class="nav-item">　</li>
            <li class="nav-item">　</li>
            <li class="next">　</li>
<%
	  }
  }
}
%>
          </ul>
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
          <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </div>
      </section>
    </div>

    <!-- TOP画面に戻る -->
    <div class="btn mt-7">
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
//画面表示用のリアルタイム日付
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