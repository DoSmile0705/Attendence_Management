<!-- ログイン画面 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.LoginInfo" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.lang.Object" %>
<%@ page import="util.Constant" %>
<%
// ***************************************************
// login.jsp
// ログイン画面
// ***************************************************
%>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");

// サーブレットから「社員番号」を取得
String loginid = (String)request.getAttribute("loginid");
// サーブレットからの遷移でない場合はURLのパラメータ「社員番号」を取得
if(loginid == null){
	loginid = request.getParameter("loginid");
}

//サーブレットから「パスワード」を取得
String password1 = (String)request.getAttribute("password1");
//サーブレットからの遷移でない場合はURLのパラメータ「パスワード」を取得
if(password1 == null){
	password1 = request.getParameter("password1");
	System.out.println("password1:" + password1);
}

String password2 = (String)request.getAttribute("password2");

//サーブレットから「メールアドレス」を取得
String mailaddress = (String)request.getAttribute("mailaddress");
//サーブレットからの遷移でない場合はURLのパラメータ「メールアドレス」を取得
if(mailaddress == null){
	mailaddress = request.getParameter("mailaddress");
	System.out.println("mailaddress:" + mailaddress);
}
String dispMsg = (String)request.getAttribute("dispMsg");
// メッセージがNULLであれば空文字を設定
if(dispMsg == null){
	dispMsg = "";
}

//サーブレットから「会社識別番号」を取得
String companyCode = (String)request.getAttribute("companyCode");
//サーブレットからの遷移でない場合はURLのパラメータ「会社識別番号」を取得
if(companyCode == null){
	companyCode = request.getParameter("companyCode");
}

//サーブレットから「ログアウトフラグ」を取得
String logOutFlg = (String)request.getAttribute("logOutFlg");
//ログアウトフラグがNULLであれば空文字を設定
if(logOutFlg == null){
	logOutFlg = "";
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
  <link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!-- スタイルシート読み込み -->
  <link rel="stylesheet" href="assets/css/style.css?<%=(new SimpleDateFormat("yyyyMMddHHmmssSSS")).format(new Date())%>">

   <!-- Script
  -------------------------------------------------- -->
  <!-- Jquery読み込み -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <!-- bootstrap JS読み込み -->
  <script src="assets/bootstrap/js/bootstrap.min.js"></script>

  <!-- Favicon
  -------------------------------------------------- -->
  <link rel="icon" type="image/png" href="assets/images/favicon.png">


</head>
<body class="login">

  <!-- タイトル部 -->
  <section class="l-ttl">
    <img src="assets/images/guard-ico.png" alt="">
    <h1>警備業ポータルサイト</h1>
  </section>

  <!-- ログインフォーム -->
  <section class="l-form">
<%
if(dispMsg != null){
%>
	<div align="center">
    <font color="red"><b><%=dispMsg%></b></font>
    </div>
<%
}
%>
    <div class="inner">
      <form action="<%= request.getContextPath() %>/Login" method="post">

        <label for="email">メールアドレス</label>
<%
  // メールアドレスがNULLの場合は空文字をセット
  if(mailaddress == null){
	  mailaddress = "";
  }
%>
        <input class="txt" type="email" name="mailaddress" id="mailaddress" value="<%=mailaddress %>">
        <p>会社に提出したEメールアドレスを入力してください</p>

        <label for="password">パスワード</label>
<%
  // パスワード１がNULLの場合は空文字をセット
  if(password1 == null){
	  password1 = "";
  }
%>
        <input class="txt" type="password" name="password1" id="password1" value="<%=password1 %>" autocomplete="off">

        <label for="com-num">会社識別番号</label>
<%
  // 会社識別番号がNULLの場合は空文字をセット
  if(companyCode == null){
	  companyCode = "";
  }
%>
        <input class="txt" type="text" name="companyCode" id="companyCode" value="<%=companyCode %>">

        <label for="num">社員番号</label>
<%
  // 社員番号がNULLの場合は空文字をセット
  if(loginid == null){
	  loginid = "";
  }
%>
        <input class="txt" type="text" name="loginid" id="loginid" value="<%=loginid %>">

        <ul>
          <li><input type="checkbox" name="check" value="ログイン情報を保存する" id="save">ログイン情報を保存する</li>
        </ul>


        <div class="submit">
          <button type="submit" id="submitId" onclick="saveItem()">利用開始</button>
        </div>

        <input type="hidden" id="loginTransitionFlg" name="loginTransitionFlg" value="true"><!-- 初回ログインフラグ -->
        <input type="hidden" id="logOutFlg" name="logOutFlg" value="<%=logOutFlg %>"><!-- ログアウトフラグ -->
        <input type="hidden" id="dispMsg" name="dispMsg" value="<%=dispMsg %>"><!-- 表示メッセージ -->
        <input type="hidden" id="geoIdo" name="geoIdo"><!-- 緯度情報 -->
        <input type="hidden" id="geoKeido" name="geoKeido"><!-- 軽度情報 -->
      </form>
  </div>
  </section>

<script>
// ブラウザに保存されているログイン情報を呼び出す
function test2(position) {

    var latitude  = position.coords.latitude;
    var longitude = position.coords.longitude;


    // 緯度経度を取得して隠し項目に格納
    document.getElementById("geoIdo").value = latitude;
    document.getElementById("geoKeido").value = longitude;
}
// 保存にチェックを入れた場合、ブラウザにログイン情報をセットする
function saveItem(){
	if(document.getElementById("save").checked){
		localStorage.setItem('loginid', document.getElementById("loginid").value);
		localStorage.setItem('password1', document.getElementById("password1").value);
		localStorage.setItem('companyCode', document.getElementById("companyCode").value);
		localStorage.setItem('mailaddress', document.getElementById("mailaddress").value);
	}
}

function removeStorage(){
	localStorage.removeItem('loginid');
	localStorage.removeItem('password1');
	localStorage.removeItem('companyCode');
	localStorage.removeItem('mailaddress');
	alert("ストレージ削除");
}

$(document).ready(function(){

	// ログイン失敗時には以降の処理を実施市内
	if(document.getElementById("dispMsg").value != ""){
		return false;
	}
	
	// リンクから送られてきた値が全て入っている場合、ログイン情報を保存するチェックボックスにチェックを入れる
	if(document.getElementById("loginid").value != "" && document.getElementById("password1").value != "" 
		&& document.getElementById("companyCode").value != "" && document.getElementById("mailaddress").value != "" ){
		document.getElementById("save").checked = true;
	}
	
	if(document.getElementById("loginid").value == "" && localStorage.getItem('loginid') != null){
		document.getElementById("loginid").value = localStorage.getItem('loginid');
	}
	if(document.getElementById("password1").value == "" && localStorage.getItem('password1') != null){
		document.getElementById("password1").value = localStorage.getItem('password1');
	}
	if(document.getElementById("companyCode").value == "" && localStorage.getItem('companyCode') != null){
		document.getElementById("companyCode").value = localStorage.getItem('companyCode');
	}
	if(document.getElementById("mailaddress").value == "" && localStorage.getItem('mailaddress') != null){
		document.getElementById("mailaddress").value = localStorage.getItem('mailaddress');
	}
	// 位置情報を取得する処理
    navigator.geolocation.getCurrentPosition(test2);

	if(document.getElementById("logOutFlg").value != ""){
		return false;
	}
    
    if(document.getElementById("loginid").value != "" && document.getElementById("password1").value != ""
        && document.getElementById("companyCode").value != "" && document.getElementById("mailaddress").value != ""){
    	document.getElementById("submitId").click();
    }

});
</script>
  
	<jsp:include page="loading.jsp" />
</body>
</html>