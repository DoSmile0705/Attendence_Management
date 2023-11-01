<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.Object" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.IvParameterSpec" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>

<%
// ***************************************************
// index.jsp
// 0-0：テスト用ドライバ画面
// ***************************************************
%>
<%
String loginid = (String)request.getAttribute("loginid");
String password1 = (String)request.getAttribute("password1");
String password2 = (String)request.getAttribute("password2");
String mailaddress = (String)request.getAttribute("mailaddress");
String requestDate = "2022年08月30日(火)";
String overtime_1		= "22:30";
String time		= "0830";
String ango		= "Afqe5TN6/BgfZeEkKHA4vw==";
%>
<%!
//フォーマットを変更して日付を返す関数
private String ChangeshiftHiduke(String dateTime) {
	String datestr = null;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy年MM月dd日(E)");	
		Date date = sdFormat.parse(dateTime);
		DateFormatSymbols dfs = DateFormatSymbols.getInstance(Locale.JAPANESE);
		sdFormat = new SimpleDateFormat("yyyyMMdd", dfs);
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
private String GetTimeValue(String dateTime){
	int hour = Integer.parseInt(dateTime.substring(0, 2));
	hour = hour * 60;
	String resDate = String.valueOf(hour);
	resDate = resDate + dateTime.substring(3, 5);
	return resDate;
	
}
//申請データの総残業時間を変換
private String GetValue(String dateTime){
	String resTime = null;
	if(dateTime.equals("0")){
		resTime = "00:00";
	}else{
		int calcTime = Integer.parseInt(dateTime);
		resTime = String.format("%04d", calcTime);
		resTime = resTime.substring(0, 2) + ":" + dateTime.substring(2, 4);
	}
	return resTime;
}
//復号化メソッド
public String decrypt (String text) {
	// 文字列暗号化用
	final String ENCRYPT_KEY	= "oP3feFoWLoEwaa12";
	final String ENCRYPT_IV		= "eF20TGd0kdfe5Ye9";
	// 文字コード
	final String CHARSET		= "UTF-8";
	// 暗号方式
	final String CRYRTOGRAPHY	= "AES";
	final String CIPHERTEXT		= "AES/CBC/PKCS5Padding";

	String decodeText = null;
	//パラメータがnullだったら処理しない
	if(text != null) {
		try {
			// 暗号化キーと初期化ベクトルをバイト配列へ変換
			byte[] byteKey = ENCRYPT_KEY.getBytes(CHARSET);
			byte[] byteIv  = ENCRYPT_IV.getBytes(CHARSET);
			// 復号化キーと初期化ベクトルのオブジェクト生成
			SecretKeySpec key = new SecretKeySpec(byteKey, CRYRTOGRAPHY);
			IvParameterSpec iv = new IvParameterSpec(byteIv);
			// Cipherオブジェクト生成
			Cipher cipher = Cipher.getInstance(CIPHERTEXT);
			// Cipherオブジェクトの初期化
			cipher.init(Cipher.DECRYPT_MODE, key, iv);
			// 復号化の結果格納
			byte[] byteResult = cipher.doFinal(Base64.getDecoder().decode(text));
			// デコード
			decodeText = new String(byteResult, CHARSET);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	return decodeText;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ドライバ画面</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<link href="assets/css/mobile.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />

</head>
<body>
<%=request.getParameter("loginid") %>
<%=request.getParameter("password1") %>
<%=request.getParameter("password2") %>
<%=request.getParameter("mailaddress") %>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="assets/js/script.js?<%=(new SimpleDateFormat("yyyyMMddHHmmssSSS")).format(new Date())%>"></script>
<form action="<%= request.getContextPath() %>/Driver" method="post">
  <div class="container-fluid bg-info">
    ポータルサイト利用開始
  </div>
<br>
  <button type="submit" class="btn btn-primary">ログイン画面へ</button>
</form>
<br>
暗号：<%=ango %><br>
復号：[<%=decrypt(ango) %>]<br>
<br>
<form action="<%= request.getContextPath() %>/InformationPageLink" method="post" accept-charset="UTF-8">
  <button data-id="sample10" type="submit" class="btn btn-primary">TEMP登録テスト</button>
    <input type="hidden" value="93" name="DataId">
    <input type="hidden" value="3" name="id">
    <input type="hidden" value="1" name="pageCnt">
    <input type="hidden" value="1001" name="company_ID">
    <input type="hidden" value="3" name="loginid">
</form>

<%=overtime_1 %><br>
<%=requestDate %><br>
<%=ChangeshiftHiduke(requestDate) %><br>
<%=GetTimeValue(overtime_1) %><br>
<%=time %><br>
<%=GetValue(time) %><br>
<br>
<a href="/AttendManagement/InformationPageLink">TEMP登録テスト</a>
<br><br>
<a href="http://localhost:8080/AttendManagement/MessageList?id=93&key1=b7f8806a-592b-41be-bc54-b87080e8f7ef&key2=aaa&key3=bbb&workerId=3&companyId=1001">お知らせ詳細からの戻りテスト</a>
<br>
          <table width="500px">
            <tr>
              <th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th><th>日</th>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#1'"><span>1</button></span></td><td class="none"><button onclick="location.href='#2'"><span>2</button></span></td><td class="none"><button onclick="location.href='#3'"><span>3</button></span></td><td class="none"><button onclick="location.href='#4'"><span>4</button></span></td><td class="none"><button onclick="location.href='#5'"><span>5</button></span></td><td class="mor current"><button onclick="location.href='#6'"><span>6</span></button></td><td class="eve"><button onclick="location.href='#7'"><span>7</button></span></td>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#8'"><span>8</button></span></td><td class="se"><button onclick="location.href='#9'"><span>9</button></span></td><td class="mor"><button onclick="location.href='#10'"><span>10</span></button></td><td class="eve"><button onclick="location.href='#11'"><span>11</span></button></td><td class="mor"><button onclick="location.href='#12'"><span>12</span></button></td><td class="all"><button onclick="location.href='#13'"><span>13</span></button></td><td class="none"><button onclick="location.href='#14'"><span>14</span></button></td>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#15'"><span>15</span></button></td><td class="none"><button onclick="location.href='#16'"><span>16</span></button></td><td class="none"><button onclick="location.href='#17'"><span>17</span></button></td><td class="none"><button onclick="location.href='#18'"><span>18</span></button></td><td class="none"><button onclick="location.href='#19'"><span>19</span></button></td><td class="none"><button onclick="location.href='#20'"><span>20</span></button></td><td class="none"><button onclick="location.href='#21'"><span>21</span></button></td>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#22'"><span>22</span></button></td><td class="none"><button onclick="location.href='#23'"><span>23</span></button></td><td class="none"><button onclick="location.href='#24'"><span>24</span></button></td><td class="none"><button onclick="location.href='#25'"><span>25</span></button></td><td class="none"><button onclick="location.href='#26'"><span>26</span></button></td><td class="none"><button onclick="location.href='#27'"><span>27</span></button></td><td class="none"><button onclick="location.href='#28'"><span>28</span></button></td>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#29'"><span>29</span></button></td><td class="none"><button onclick="location.href='#30'"><span>30</span></button></td><td class="none"><button onclick="location.href='#31'"><span>31</span></button></td><td class="none"><button onclick="location.href='#1'"><span>1</button></span></td><td class="none"><button onclick="location.href='#2'"><span>2</button></span></td><td class="none"><button onclick="location.href='#3'"><span>3</button></span></td><td class="none"><button onclick="location.href='#4'"><span>4</button></span></td>
            </tr>
          </table>

<!-- ローディング処理 -->
 <div id="sample01" class="loading">
 </div>
 <div id="sample10" class="loading">
 	<div class="load-circle"></div>
	<div class="load-text load-blink load-absolute">表示中です</div>
</div>

<!-- URLパラメータで自動ログインするサンプル -->
<form name="form2" action="<%= request.getContextPath() %>/Login" method="post">
  <input type="hidden" id="loginid" name="loginid">
</form>

<script>
// 位置情報を取得する処理
window.onload = function() {
    //URLのパラメータで自動ログインするサンプル
    if(location.search != null){
        //URLパラメータをリクエストにセットする
        document.getElementById("loginid").value = "あああ";
    	//document.forms["form2"].submit();
    }
	//alert("スリープ");
	//sleep(3000);
	//alert("３秒経過");
    navigator.geolocation.getCurrentPosition(test2);
    showDate();
}
function sleep(waitMsec) {
	var startMsec = new Date();
	// 指定ミリ秒間だけループさせる（CPUは常にビジー状態）
	while (new Date() - startMsec < waitMsec);
}
function test2(position) {

    var geo_text = "緯度:" + position.coords.latitude + "\n";
    geo_text += "経度:" + position.coords.longitude + "\n";
    geo_text += "高度:" + position.coords.altitude + "\n";
    geo_text += "位置精度:" + position.coords.accuracy + "\n";
    geo_text += "高度精度:" + position.coords.altitudeAccuracy  + "\n";
    geo_text += "移動方向:" + position.coords.heading + "\n";
    geo_text += "速度:" + position.coords.speed + "\n";

    var date = new Date(position.timestamp);
    geo_text += "取得時刻:" + date.toLocaleString() + "\n";
    const formatDate = (date)=>{
        let formatted_date = date.getFullYear() + "年" + date.getMonth() + "月" + date.getDate() + "日" + "(" + [ "日", "月", "火", "水", "木", "金", "土" ][date.getDay()] + ")"
        return formatted_date;
    }
    geo_text += "取得時刻:" + formatDate(date) + "\n";
    geo_text += "取得時刻:" + date.getHours() + ":" + date.getMinutes() + "\n";
}
</script>
</body>
</html>