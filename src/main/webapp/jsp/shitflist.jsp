<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="util.LoginInfo" %>


<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
List<ShiftInfo> listInfo = (List<ShiftInfo>)request.getAttribute("listInfo");
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
    container
  </div>
<%
for(int i = 0; i < listInfo.size(); i ++) {
%>
<form action="<%= request.getContextPath() %>/AttendDetail" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    <font size="5"><%=listInfo.get(i).kinmuBashoName %></font>（<%=listInfo.get(i).keiyakuKubunName %>）<br>
    <%=listInfo.get(i).bgnTime %>&nbsp-&nbsp
    <%=listInfo.get(i).endTime %>&nbsp
    <%=listInfo.get(i).gyomuKubunName %>&nbsp
    <%=listInfo.get(i).kinmuKubunName %><br>
    <font size="5">上番</font>&nbsp
    <font size="7" color="black">--:--</font>&nbsp
    <font size="5">下番</font>&nbsp
    <font size="7" color="black">--:--</font>
  </button>
  <!-- サーブレットパラメータ用に隠し項目に格納 -->
  <input type="hidden" value="<%=listInfo.get(i).shiftHiduke %>" name="shiftHiduke">
  <input type="hidden" value="<%=listInfo.get(i).bgnTime %>" name="bgnTime">
  <input type="hidden" value="<%=listInfo.get(i).bgnTimeDate %>" name="bgnTimeDate">
  <input type="hidden" value="<%=listInfo.get(i).endTime %>" name="endTime">
  <input type="hidden" value="<%=listInfo.get(i).endTimeDate %>" name="endTimeDate">
  <input type="hidden" value="<%=listInfo.get(i).gyomuKubunName %>" name="gyomuKubunName">
  <input type="hidden" value="<%=listInfo.get(i).keiyakuKubunName %>" name="keiyakuKubunName">
  <input type="hidden" value="<%=listInfo.get(i).kinmuBashoName %>" name="kinmuBashoName">
  <input type="hidden" value="<%=listInfo.get(i).kinmuKubunName %>" name="kinmuKubunName">
  <input type="hidden" value="<%=listInfo.get(i).workerId %>" name="workerId">
  <input type="hidden" value="<%=listInfo.get(i).keiyakuId %>" name="keiyakuId">
  <input type="hidden" value="<%=loginInfo.id %>" name="loginid">
  <input type="hidden" value="<%=loginInfo.loginInfo1_Value %>" name="password1">
  <input type="hidden" value="<%=loginInfo.loginInfo2_Value %>" name="password2">
  <input type="hidden" value="<%=loginInfo.email_Value %>" name="mailaddress">
</form>
  <br><br>
	
<%
}
%>
</body>
</html>