<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
// ***************************************************
// shiftInquiry.jsp
// 5-1：シフト一覧
// 対象月（指定月）のシフト一覧を表示する
// ***************************************************
%>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
List<ShiftInfo> listInfo = (List<ShiftInfo>)request.getAttribute("listInfo");
// 対象月
String nowDate = (String)request.getAttribute("nowDate");

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
//現在年月を返す関数
private String GetYearMonth() {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy年MM月");
	String datestr = dtf.format(nowDate.plusHours(9));
	return datestr;
}
//現在年月からの指定年月を返す関数
private String GetSpecifyYearMonth(int SpecifyNo) {
	LocalDateTime nowDate = LocalDateTime.now();
	DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy年MM月");
	dtf.format(nowDate.plusHours(9));
	String datestr = dtf.format(nowDate.plusMonths(SpecifyNo));
	return datestr;
}
//引数の文字列（日時）を様式「yyyy年MM月」で返す関数
private String GetFormatYYYYMM(String nowDate){
	String datestr = nowDate.substring(0, 7);
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM");	
		Date date = sdFormat.parse(datestr);
		sdFormat = new SimpleDateFormat("yyyy年MM月");
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
//該当月の日数を返す
private int GetDayOfMonth(String date) {
	
	// 「GregorianCalendar」の開始は0からなので-1をする
	Calendar c = new GregorianCalendar(
			Integer.valueOf(date.substring(0, 4)), Integer.valueOf(date.substring(5, 7))-1, 1);
	int days = c.getActualMaximum(Calendar.DAY_OF_MONTH);

	return days;
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
// フォーマットを変更して曜日を返す
private String GetFormatE(String dateTime, int diff) {
	String datestr = null;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd");	
		Date date = sdFormat.parse(dateTime);
		Calendar calendar = Calendar.getInstance();
 		calendar.setTime(date);
 		// メニュー画面からの遷移用に常に月初を取得する
        int first = calendar.getActualMinimum(Calendar.DATE);
 		calendar.set(Calendar.DATE, first);
 		// 日数分日にちを取得する
 		calendar.add(Calendar.DAY_OF_MONTH, diff);
 		date = calendar.getTime();
 		// 曜日フォーマットを指定する
		sdFormat = new SimpleDateFormat("E");
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
<title>シフト一覧</title>
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
<br><br>
<form action="<%= request.getContextPath() %>/ShiftInquiry" method="post" accept-charset="UTF-8">
<div align="center">
<select name="month" id="selectMonth">
  <option><%=GetSpecifyYearMonth(-1)%></option>
  <option><%=GetYearMonth()%></option>
  <option><%=GetSpecifyYearMonth(1)%></option>
</select>
</div>
<script>
// ロード時に選択した年月を選択済みにする
var select = document.getElementById("selectMonth");
window.onload = function(){
  for (var i = 0 ; i < select.options.length ; i++){
	if('<%=GetFormatYYYYMM(nowDate)%>' == select.options[i].value){
	  select.options[i].selected = true;
	}
  }
  //ロード時に前の月を選択している場合は「前の月」ボタンを非活性化
  if('<%=GetFormatYYYYMM(nowDate)%>' == '<%=GetSpecifyYearMonth(-1)%>'){
	document.getElementById("back").disabled = true;
  //ロード時に次の月を選択している場合は「次の月」ボタンを非活性化
  }else if('<%=GetFormatYYYYMM(nowDate)%>' == '<%=GetSpecifyYearMonth(1)%>'){
    document.getElementById("forward").disabled = true;
  }
}
</script>
<br><br>
    <div align="center">
      <button class="btn btn-info" name="button1" value="back" id="back"><font size="5">&nbsp&nbsp前の月&nbsp&nbsp</font></button>
      <button class="btn btn-info" name="button1"><font size="5">&nbsp&nbsp予定&nbsp&nbsp</font></button>
      <button class="btn btn-info" name="button1" value="forward" id="forward"><font size="5">&nbsp&nbsp次の月&nbsp&nbsp</font></button>
    </div>
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
    <input type="hidden" name="geoIdo"><!-- 緯度情報 -->
    <input type="hidden" name="geoKeido"><!-- 軽度情報 -->
</form>
<br><br>
<%
for(int j = 0; j < GetDayOfMonth(GetFormatYYYYMM(nowDate)); j ++){
%>

    <div class="container">
      <div class="row">	
	    <div class="col-md-1 col-sm-1 col-xs-1">    <!-- 12分割中1を割り当て -->
          <font size="5">
          <%=String.format("%02d", j + 1) %>
          <%=GetFormatE(nowDate, j) %>
          <br>
          </font>
        </div>
        <div class="col-md-11 col-sm-11 col-xs-11">    <!-- 12分割中11を割り当て -->
          <%
          if(listInfo.size() > 0){
            // データ出力カウント
            int cnt = 0;
            for(int i = 0; i < listInfo.size(); i ++) {
            	
			  if(String.format("%02d", j + 1).equals(listInfo.get(i).bgnTimeDate.substring(8, 10))){
				// 出力データがあったらカウンタをインクリメント
				cnt ++;
			  %>
                <div class="container-fluid bg-info">
                  <br>
                <%=listInfo.get(i).bgnTime %>&nbsp～&nbsp
                <%=listInfo.get(i).endTime %>
                &nbsp&nbsp
                <%=listInfo.get(i).gyomuKubunName %>・<%=listInfo.get(i).kinmuKubunName %>・<%=listInfo.get(i).keiyakuKubunName %>
                <br>
                <font size="5"><%=listInfo.get(i).kinmuBashoName %></font>
                <br><br>
              </div>
              <br>
			  <%
			  // 出力がなかった場合
			  }else if(i == listInfo.size() - 1 && cnt == 0){
              %>
                <div class="container-fluid bg-danger">
                  <br>
                <font size="5">フリー</font>
                <br><br>
              </div>
              <br>
			  <%
              }
            }
          }else{
          %>
              <div class="container-fluid bg-danger">
                <br>
              <font size="5">フリー</font>
              <br><br>
            </div>
          <%
          }
          %>
        </div>
	  </div>
    </div>
  <br><br>
<%
}
%>
  <br><br>
<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <div align="center">
  <button class="btn btn-danger">最初に戻る
  </button>
  </div>
  <!-- サーブレットパラメータ用に隠し項目に格納 -->
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
  <input type="hidden" value="<%=GetFormatDate() %>" name="dspDate">
</form>
  <br><br>
</body>
</html>