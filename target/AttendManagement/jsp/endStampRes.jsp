<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.ShiftInfo" %>

<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
ShiftInfo shiftInfo = (ShiftInfo)request.getAttribute("shiftInfo");
ShiftInfo nextShiftInfo = (ShiftInfo)request.getAttribute("nextShiftInfo");

// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="login.jsp" />
<%
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>下番打刻結果</title>
<!-- ブートストラップ呼び出し -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />
</head>
<body>
<!-- ブートストラップ呼び出し -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <div class="container-fluid bg-info">
    <%=loginInfo.firstName_Value %>&nbsp<%=loginInfo.lastName_Value %>
  </div>
  <p style="font-size:30px;">
    <span class="label label-primary">下番報告結果</span>
  </p>
  <div class="p-3 mb-2 bg-info text-white">
    <font size="5"><%=shiftInfo.kinmuBashoName %></font><br>
    <font size="3">
    <%=shiftInfo.keiyakuKubunName %>
    <%=shiftInfo.gyomuKubunName %>
    <%=shiftInfo.kinmuKubunName %>
    </font>
  </div>
    <br>
  <p style="font-size:30px;">
    <span class="label label-default">上番打刻</span>
<%
if(shiftInfo.bgnStampTime != null){
%>
    <span class="label label-light"><font color="black"><%=shiftInfo.bgnStampTime.substring(11,16) %></font></span>
<%
}else{
%>
    <span class="label label-light"><font color="black">--:--</font></span>
<%
}
%>
  </p>
<br><br>
<%
if(shiftInfo.endStampTime != null){
%>
  <p style="font-size:30px;">
    <span class="label label-light"><font color="black"><%=shiftInfo.endStampTime.substring(11,16) %></font></span>
  </p>
  <p style="font-size:30px;">
    <span class="label label-info">下番報告を行いました</span>
  </p>
<%
}else{
%>
  <p style="font-size:30px;">
    <span class="label label-warning">すでに下番報告済みです</span>
  </p>
<%
}
%>
    <div class="p-3 mb-2 bg-info text-white">
      <font size="5"><%=shiftInfo.kinmuBashoName %></font>（<%=shiftInfo.keiyakuKubunName %>)<br>
      <font size="3">
      <%=shiftInfo.bgnTime %>&nbsp-&nbsp
      <%=shiftInfo.endTime %>&nbsp<br>
      <%=shiftInfo.gyomuKubunName %>&nbsp
      <%=shiftInfo.kinmuKubunName %>
      </font>
    </div>
<br><br>
<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    <font size="5">トップ画面に戻る</font>
  </button>
  <!-- サーブレットパラメータ用に隠し項目に格納 -->
  <input type="hidden" value="<%=shiftInfo.shiftHiduke %>" name="shiftHiduke">
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