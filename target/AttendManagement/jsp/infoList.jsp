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

<%
// ***************************************************
// infoList.jsp
// 3-1：現場確認
// ログインユーザーの直近のシフト一覧を表示する
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
	<jsp:forward page="login.jsp" />
<%
}
%>
<%!
//現在日付を返す関数
private String GetDate() {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy年MM月dd日(E)");
	String datestr = dtf.format(nowDate.plusHours(9));
	return datestr;
}
//日付を返す関数
private String GetTime() {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("HH:mm");
	String timestr = dtf.format(nowDate.plusHours(9));
	return timestr;
}
//DB登録用の日時を返す関数
private String GetFormatDate() {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSS");
	String datestr = dtf.format(nowDate.plusHours(9));
	return datestr;
}
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
		sdFormat = new SimpleDateFormat("yyyy年MM月dd日(E)");
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
// フォーマットを変更して時間を返す関数
private String GetFormatInfoDate(String dateTime) {
	String datestr = null;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSSS");	
		Date date = sdFormat.parse(dateTime);
		sdFormat = new SimpleDateFormat("MM月dd日");
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>お知らせ一覧</title>
</head>
<!-- ブートストラップ呼び出し -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />
</head>
<body>
<!-- ブートストラップ呼び出し -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <div class="container-fluid bg-info">
    <%=loginInfo.companyName %>
  </div>
<br>
  <div class="container-fluid bg-info">
    <%=loginInfo.firstName_Value %>&nbsp<%=loginInfo.lastName_Value %>
  </div>
<br>
  <div class="container-fluid bg-info">
    <%=GetDate() %>
    <br>
    <%=GetTime() %>
  </div>
<br>
<%
for(int i = 0; i < dspList.size(); i ++) {
%>
<form action="<%= request.getContextPath() %>/InformationPageLink" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    <%=dspList.get(i).isRead %>
    <%=GetFormatInfoDate(dspList.get(i).makeDate)%>
    <%=dspList.get(i).headerName %>
  </button>
</form>
  <input type="hidden" value="<%=dspList.get(i).id %>" name="id">
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
<br><br>
<%
}
%>
<br><br>
<form action="<%= request.getContextPath() %>/InformationList" method="post" accept-charset="UTF-8">
<br>
<%
// 現ページが1ページ目
if(pageCnt <= 1){
%>
  <%
  // 次が2ページ以上ある場合
  if(pageCnt + 1 < pageNum){
  %>
    <button class="btn btn-info" name="button1" value="前へ" disabled>前へ</button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt %>" disabled><%=pageCnt %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 1 %>"><%=pageCnt + 1 %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 2 %>"><%=pageCnt + 2 %></button>
    <button class="btn btn-info" name="button1" value="次へ">次へ</button>
    <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
<!-- ▼▼▼ 2022.8.10.現在が1ページかつ最後のページ対応 ▼▼▼ -->
  <%
  // 現在が1ページかつ最後のページ
  }else if(pageCnt > pageNum) {
  %>
    <button class="btn btn-info" name="button1" value="前へ" disabled>前へ</button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt %>" disabled><%=pageCnt %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 1 %>" disabled><%=pageCnt + 1 %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 2 %>" disabled><%=pageCnt + 2 %></button>
    <button class="btn btn-info" name="button1" value="次へ" disabled>次へ</button>
    <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
<!-- ▲▲▲ 2022.8.10.現在が1ページかつ最後のページ対応 ▲▲▲ -->
  <%
  // 次が1ページの場合
  }else if(pageCnt + 1 >= pageNum){
  %>
    <button class="btn btn-info" name="button1" value="前へ" disabled>前へ</button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt %>" disabled><%=pageCnt %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 1 %>"><%=pageCnt + 1 %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 2 %>" disabled><%=pageCnt + 2 %></button>
    <button class="btn btn-info" name="button1" value="次へ">次へ</button>
    <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
  <%
  // そのページが最後の場合
  }else{
  %>
    <button class="btn btn-info" name="button1" value="前へ" disabled>前へ</button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt %>" disabled><%=pageCnt %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 1 %>" disabled><%=pageCnt + 1 %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 2 %>" disabled><%=pageCnt + 2 %></button>
    <button class="btn btn-info" name="button1" value="次へ" disabled>次へ</button>
    <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
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
    <button class="btn btn-info" name="button1" value="前へ">前へ</button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt - 1 %>"><%=pageCnt - 1 %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt %>"><%=pageCnt %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 1 %>"><%=pageCnt + 1 %></button>
    <button class="btn btn-info" name="button1" value="次へ">次へ</button>
    <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
  <%
  // そのページが最後の場合
  }else{
  %>
    <button class="btn btn-info" name="button1" value="前へ">前へ</button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt - 1 %>"><%=pageCnt - 1 %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt %>"><%=pageCnt %></button>
    <button class="btn btn-info" name="button1" value="<%=pageCnt + 1 %>" disabled><%=pageCnt + 1 %></button>
    <button class="btn btn-info" name="button1" value="次へ" disabled>次へ</button>
    <input type="hidden" value="<%=pageCnt %>" name="pageCnt">
  <%
  }
  %>
<%
}
%>
<!-- ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼  -->
  <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
  <input type="hidden" value="<%=loginInfo.id %>" name="id">
<!-- ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲  -->
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
</form>


<br><br>
<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <button class="btn btn-danger">最初に戻る
  </button>
<!-- ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼  -->
  <input type="hidden" value="<%=loginInfo.workerIndex %>" name="loginid">
  <input type="hidden" value="<%=loginInfo.id %>" name="id">
<!-- ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲  -->
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
</form>
</body>
</html>