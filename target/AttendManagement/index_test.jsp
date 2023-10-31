<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>

<%
LocalDateTime nowDate = LocalDateTime.now(ZoneId.of("Asia/Tokyo"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>何もしない</title>
</head>
<body>
<%=nowDate%>
</body>
</html>