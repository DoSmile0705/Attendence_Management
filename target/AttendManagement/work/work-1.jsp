<!-- 現場詳細ページ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Locale" %>
<%@ page import="util.ShiftInfo" %>
<%@ page import="util.LoginInfo" %>
<%@ page import="util.RequestData" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.Constant" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%
// ***************************************************
// work-1.jsp
// 対象月（指定月）のシフト一覧を表示する
// ***************************************************
%>
<%
LoginInfo loginInfo = (LoginInfo)request.getAttribute("loginInfo");
List<ShiftInfo> listInfo = (List<ShiftInfo>)request.getAttribute("listInfo");
List<RequestData> requestList = (List<RequestData>)request.getAttribute("requestList");
// 対象月
String nowDate = (String)request.getAttribute("nowDate");
// セッションがNULLだったらログイン画面を表示する
if(loginInfo.sessionId == null){
	// ログイン画面を表示する
%>
	<jsp:forward page="/login.jsp" />
<%
}
%>
<%!
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
		sdFormat = new SimpleDateFormat("E", Locale.JAPANESE);
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
//引数の文字列（日時）を様式「yyyy.M」で返す関数
private String GetFormatYYYYM(String nowDate){
	String datestr = nowDate.substring(0, 7);
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM");	
		Date date = sdFormat.parse(datestr);
		sdFormat = new SimpleDateFormat("yyyy.M");
		datestr = sdFormat.format(date);
		
	}catch(Exception e){
		e.printStackTrace();
	}
	return datestr;
}
//月初の曜日を数値で返す
//月：2、火：3、水：4、木：5、金：6、土：7、日：1
private int GetMonthFirstE(String dateTime) {
	int firstDate = 0;
	try{
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd");	
		Date date = sdFormat.parse(dateTime);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(Calendar.DATE, 1);
		firstDate = calendar.get( Calendar.DAY_OF_WEEK );
	}catch(Exception e){
		e.printStackTrace();
	}
	return firstDate;
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
          <form name="form1" onclick="GetDateTime()" action="<%= request.getContextPath() %>/InformationList" method="post">
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
            <input type="hidden" id="dspDate" name="dspDate">
            <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          </form>
        </div>
        <div class="ico">
          <form onclick="GetDateTime()" action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
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
            <input type="hidden" id="dspDate" name="dspDate">
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
        シフト一覧
      </h1>
    </section>

    <section class="inner stay" style="background-color : #FFFFFF">

      <!-- 月選択 -->
      <div class="w-box mt-4">
        <form name="form1" id="form1" action="<%=request.getContextPath() %>/ShiftInquiry" method="post">
        <select name="dt-num" id="dt-num" onChange="screenChange()">
          <option value="<%=GetSpecifyYearMonth(-13)%>"><%=GetSpecifyYearMonth(-13)%></option>
          <option value="<%=GetSpecifyYearMonth(-12)%>"><%=GetSpecifyYearMonth(-12)%></option>
          <option value="<%=GetSpecifyYearMonth(-11)%>"><%=GetSpecifyYearMonth(-11)%></option>
          <option value="<%=GetSpecifyYearMonth(-10)%>"><%=GetSpecifyYearMonth(-10)%></option>
          <option value="<%=GetSpecifyYearMonth(-9)%>"><%=GetSpecifyYearMonth(-9)%></option>
          <option value="<%=GetSpecifyYearMonth(-8)%>"><%=GetSpecifyYearMonth(-8)%></option>
          <option value="<%=GetSpecifyYearMonth(-7)%>"><%=GetSpecifyYearMonth(-7)%></option>
          <option value="<%=GetSpecifyYearMonth(-6)%>"><%=GetSpecifyYearMonth(-6)%></option>
          <option value="<%=GetSpecifyYearMonth(-5)%>"><%=GetSpecifyYearMonth(-5)%></option>
          <option value="<%=GetSpecifyYearMonth(-4)%>"><%=GetSpecifyYearMonth(-4)%></option>
          <option value="<%=GetSpecifyYearMonth(-3)%>"><%=GetSpecifyYearMonth(-3)%></option>
          <option value="<%=GetSpecifyYearMonth(-2)%>"><%=GetSpecifyYearMonth(-2)%></option>
          <option value="<%=GetSpecifyYearMonth(-1)%>"><%=GetSpecifyYearMonth(-1)%></option>
          <option value="<%=GetYearMonth()%>"><%=GetYearMonth()%></option>
          <option value="<%=GetSpecifyYearMonth(1)%>"><%=GetSpecifyYearMonth(1)%></option>
        </select>
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
          <input type="hidden" name="dt-num">
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
          <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
        </form>
      </div>

    </section>
    <section class="inner" style="background-color : #FFFFFF">

      <!-- カレンダー -->
      <div class="w-box cal mt-4">
        <form name="form1" id="form2" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
        <div class="cal-month row mt-5">
          <span class="arrow"><button name="button1" value="prev" id="prev" onclick="monthChange()">&#60;</button></span>
          <span class="ym"><h2><%=GetFormatYYYYM(nowDate) %></h2></span>
          <span class="arrow r"><button name="button1" value="next" id="next" onclick="monthChange()">&#62;</button></span>
        </div>
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
          <input type="hidden" value="<%=GetFormatYYYYMM(nowDate) %>" name="dt-num">
          <input type="hidden" name="button1">
          <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
          <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
          <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
        </form>
        <div class="cal-contents mt-3">
          <table>
            <tr>
              <th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th><th>日</th>
            </tr>
            <!-- ▼▼▼第1週▼▼▼ -->
            <tr>
<%
//日付表示用
int days = 1;
//第1週目のループ
for(int i = days; i < 8; i ++){
	// 月曜日(2)始まりにつき＋１、空きマスを埋める
	if(i + 1 < GetMonthFirstE(nowDate)){
%>
              <td class="none"></td>
<%
	}else{
		// 日(1)の場合
		if(GetMonthFirstE(nowDate) == 1){
            //日曜日までループを回す
			if(i == 7){
				//リストがある場合
				if(listInfo.size() > 0){
					if(String.format("%02d", days).equals(listInfo.get(0).bgnTimeDate.substring(8, 10))){
%>
                        <td class="<%=CalShiftCol(listInfo.get(0).timeFlag)%>"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
					}else{
%>
                        <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
					}
				}else{
%>
                    <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
				}
				//日付をインクリメント
	            days++;
			}else{
%>
		            <td class="none"></td>
<%
			}
		}else{
		    //シフトを表示する
            if(listInfo.size() > 0){
            	int j = 0;
	        	while(j < listInfo.size()){
                    if(String.format("%02d", days).equals(listInfo.get(j).bgnTimeDate.substring(8, 10))){
%>
                    <td class="<%=CalShiftCol(listInfo.get(j).timeFlag)%>"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
						days ++;
						break;
                    }else{
                    	// ループが最後まで回った（データがなかった）ら空埋め
                    	if(j == listInfo.size() - 1	){
%>
                            <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
							days ++;
                    	}
                    }
                    j ++;
                }
            }else{
%>
              <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
              days ++;
            }
		}
	}
}
%>
            </tr>
            <!-- ▲▲▲第1週▲▲▲ -->

            <!-- ▼▼▼第2週▼▼▼ -->
            <tr>
<%
//第2週目のループ
for(int i = 1; i < 8; i ++){
	//シフトを表示する
	if(listInfo.size() > 0){
		int j = 0;
		while(j < listInfo.size()){
			if(String.format("%02d", days).equals(listInfo.get(j).bgnTimeDate.substring(8, 10))){
%>
                <td class="<%=CalShiftCol(listInfo.get(j).timeFlag)%>"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
				days ++;
				break;
			}else{
				// ループが最後まで回った（データがなかった）ら空埋め
				if(j == listInfo.size() - 1	){
%>
                        <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
						days ++;
				}
			}
			j ++;
		}
	}else{
%>
              <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days %></span></button></td>
<%
		days ++;
	}
}
%>
            </tr>
            <!-- ▲▲▲第2週▲▲▲ -->

            <!-- ▼▼▼第3週▼▼▼ -->
            <tr>
<%
//第3週目のループ
for(int i = 1; i < 8; i ++){
	if(listInfo.size() > 0){
		int j = 0;
		while(j < listInfo.size()){
			if(String.format("%02d", days).equals(listInfo.get(j).bgnTimeDate.substring(8, 10))){
%>
                <td class="<%=CalShiftCol(listInfo.get(j).timeFlag)%>"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
				days ++;
				break;
			}else{
				// ループが最後まで回った（データがなかった）ら空埋め
				if(j == listInfo.size() - 1	){
%>
                        <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
					days ++;
				}
			}
			j ++;
		}
	}else{
%>
              <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days %></span></button></td>
<%
		days ++;
	}
}
%>
            </tr>
            <!-- ▲▲▲第3週▲▲▲ -->

            <!-- ▼▼▼第4週▼▼▼ -->
            <tr>
<%
//第4週目のループ
for(int i = 1; i < 8; i ++){
	//月の最終日以降はマス埋め
	if(days > GetDayOfMonth(nowDate)){
%>
        <td class="none"></td>
<%
        days ++;
	}else{
		//シフトを表示する
		if(listInfo.size() > 0){
		int j = 0;
			while(j < listInfo.size()){
				if(String.format("%02d", days).equals(listInfo.get(j).bgnTimeDate.substring(8, 10))){
%>
                    <td class="<%=CalShiftCol(listInfo.get(j).timeFlag)%>"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
					days ++;
					break;
				}else{
					// ループが最後まで回った（データがなかった）ら空埋め
					if(j == listInfo.size() - 1	){
%>
                            <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
						days ++;
					}
				}
				j ++;
			}
		}else{
%>
	              <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days %></span></button></td>
<%
			days ++;
		}
	}
}
%>
            </tr>
            <!-- ▲▲▲第4週▲▲▲ -->

            <!-- ▼▼▼第5週▼▼▼ -->
            <tr>
<%
//第5週目のループ
for(int i = 1; i < 8; i ++){
	//月の最終日以降はマス埋め
	if(days > GetDayOfMonth(nowDate)){
%>
        <td class="none"></td>
<%
        days ++;
	}else{
		//シフトを表示する
		if(listInfo.size() > 0){
			int j = 0;
			while(j < listInfo.size()){
				if(String.format("%02d", days).equals(listInfo.get(j).bgnTimeDate.substring(8, 10))){
%>
                    <td class="<%=CalShiftCol(listInfo.get(j).timeFlag)%>"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
					days ++;
					break;
				}else{
					// ループが最後まで回った（データがなかった）ら空埋め
					if(j == listInfo.size() - 1	){
%>
                            <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
						days ++;
					}
				}
				j ++;
			}
		}else{
	%>
	              <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days %></span></button></td>
	<%
			days ++;
		}
	}
}
%>
            </tr>
            <!-- ▲▲▲第5週▲▲▲ -->

            <!-- ▼▼▼第6週▼▼▼ -->
<%
//月の日付が残っている場合は第6週を表示
if(days <= GetDayOfMonth(nowDate)){
%>
            <tr>
<%
	//第6週目のループ
	for(int i = 1; i < 8; i ++){
		//月の最終日以降はマス埋め
		if(days > GetDayOfMonth(nowDate)){
%>
        <td class="none"></td>
<%
	        days ++;
		}else{
			//シフトを表示する
			if(listInfo.size() > 0){
				int j = 0;
				while(j < listInfo.size()){
                    if(String.format("%02d", days).equals(listInfo.get(j).bgnTimeDate.substring(8, 10))){
%>
                    <td class="<%=CalShiftCol(listInfo.get(j).timeFlag)%>"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
					days ++;
					break;
					}else{
						// ループが最後まで回った（データがなかった）ら空埋め
						if(j == listInfo.size() - 1	){
%>
                            <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days%></span></button></td>
<%
						days ++;
						}
					}
					j ++;
				}
			}else{
	%>
	              <td class="none"><button onclick="scrollCorrection('<%=days%>')"><span><%=days %></span></button></td>
	<%
			days ++;
			}
		}
	}
%>
            </tr>
<%
//月の日付が残っている場合は第6週を表示
}
%>
            <!-- ▲▲▲第6週▲▲▲ -->

          </table>
        </div>

        <!-- 凡例を表示 -->
        <div class="cal-contents mt-3">
          <table>
            <tr>
              <td class="mor">　</td><td><p align="left">昼勤務　</p></td>
              <td class="eve">　</td><td><p align="left">夜勤務　</p></td>
              <td class="se">　</td><td><p align="left">昼夜勤務</p></td>
              <td class="all">　</td><td><p align="left">２４勤務</p></td>
              <td class="none">　</td><td><p align="left">その他</p></td>
            </tr>
          </table>
        </div>

    </section>

      <!-- 日ごとカレンダー -->
      <div class="w-box dcal mt-5">
        <form name="form1" id="form2" action="<%= request.getContextPath() %>/ShiftInquiry" method="post">
        <div class="cal-month row mt-5">
          <span class="arrow"><button name="button1" value="back" id="back" onclick="monthChange()">&#60; 前の月</button></span>
          <span class="arrow"><button name="button1" value="forward" id="forward" onclick="monthChange()">次の月 &#62;</button></span>
        </div>
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
            <input type="hidden" value="<%=GetFormatYYYYMM(nowDate) %>" name="dt-num">
            <input type="hidden" name="button1">
            <input type="hidden" value="<%=loginInfo.company_ID %>" name="company_ID">
            <input type="hidden" value="<%=loginInfo.geoIdo_Value %>" name="geoIdo">
            <input type="hidden" value="<%=loginInfo.geoKeido_Value %>" name="geoKeido">
          </form>
        <ul class="dcal-archive">

<%
/****************/
/***日毎の出力***/
/****************/
for(int j = 0; j < GetDayOfMonth(GetFormatYYYYMM(nowDate)); j ++){
%>
          <!-- 一日分 -->
          <div class="ankar" id="<%=j + 1%>"></div>
          <li class="dcal-item">
            <div class="left">
              <span class="d"><%=String.format("%02d", j + 1) %></span>
              <span class="dow">(<%=GetFormatE(nowDate, j) %>)</span>
            </div>
            <div class="right">
              <ul class="work-archive">
<%
	/***************************/
	/***シフト一覧を出力START***/
	/***************************/
    if(listInfo.size() > 0){
        // データ出力カウント
        int cnt = 0;

        for(int i = 0; i < listInfo.size(); i ++) {
            	
            if(String.format("%02d", j + 1).equals(listInfo.get(i).bgnTimeDate.substring(8, 10))){
				// 出力データがあったらカウンタをインクリメント
				cnt ++;
%>
              <!-- シフト表示 -->
                <li class="work-item <%=CalShiftCol(listInfo.get(i).timeFlag)%>">
                  <form action="<%= request.getContextPath() %>/AttendDetail" method="post" accept-charset="UTF-8">
                  <button id="<%=j+1 %>">
                    <div class="w-sub"><span class="d"><%=listInfo.get(i).bgnTime %>～<%=listInfo.get(i).endTime %></span><span class="cat"><%=listInfo.get(i).gyomuKubunName %></span></div>
                    <div class="w-ttl"><%=listInfo.get(i).kinmuBashoName %><%=listInfo.get(i).gyomuKubunName %><%=listInfo.get(i).kinmuKubunName %><%=listInfo.get(i).keiyakuKubunName %></div>
                    <div class="w-ttl"><%=listInfo.get(i).note %></div>
                  </button>
                    <input type="hidden" value="<%=listInfo.get(i).shiftHiduke %>" name="shiftHiduke">
                    <input type="hidden" value="<%=listInfo.get(i).note %>" name="shiftNote">
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
                    <input type="hidden" value="<%=listInfo.get(i).bgnStampTime %>" name="bgnStampTime">
                    <input type="hidden" value="<%=listInfo.get(i).endStampTime %>" name="endStampTime">
                    <input type="hidden" value="<%=listInfo.get(i).adrPostNo %>" name="adrPostNo">
                    <input type="hidden" value="<%=listInfo.get(i).adrMain %>" name="adrMain">
                    <input type="hidden" value="<%=listInfo.get(i).adrSub %>" name="adrSub">
                    <input type="hidden" value="<%=listInfo.get(i).id %>" name="shiftDataId">
                    <input type="hidden" value="<%=listInfo.get(i).timeFlag %>" name="timeFlag">
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
                    <input type="hidden" value="1" name="linkFlg">
                  </form>
                </li>
          <!-- 一日分end -->
<!--****************************-->
<!--申請出力処理の元あったところ-->
<!--****************************-->
<%
	        // 出力がなかった場合
	        }else if(i == listInfo.size() - 1 && cnt == 0){
%>
                <li class="work-item red">
                  <button disabled>
                    <div class="w-ttl">フリー</div>
                  </button>
                </li>
<%
            }
        }
        /*************************/
        /***シフト一覧を出力END***/
        /*************************/
%>
<!--****************************-->
<!--申請出力処理ここに入れてみる-->
<!--****************************-->
<%
		//**************************
		//***申請の出力処理 START***
		//**************************
		if(requestList.size() > 0){
			for(int k = 0; k < requestList.size(); k ++) {
            	
				if(String.format("%02d", j + 1).equals(requestList.get(k).kinmuHiduke.substring(6, 8))){
					switch(requestList.get(k).category){

						//***早出申請 START***
						case "1":	//早出申請

							//承認が「9」の場合は削除済
							if(!requestList.get(k).certification.equals("9")){
									
								switch(requestList.get(k).certification){
									case "0":	//申請中
%>
                <li class="work-item ac2">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">早出申請　申請中</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="1" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "1":	//受理
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">早出申請　受理申請</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="1" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "2":	//却下
%>
                <li class="work-item red">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">早出申請　申請却下</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="1" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "3":	//確定
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">早出申請　申請確定</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="1" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									default:	//未申請
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">早出申請　未申請</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="1" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									}
								}
							break;
						//***早出申請 END***

						//***残業申請 START***
						case "2":	//残業申請

							//承認が「9」の場合は削除済
							if(!requestList.get(k).certification.equals("9")){

								switch(requestList.get(k).certification){
									case "0":	//申請中
%>
                <li class="work-item ac2">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">残業申請　申請中</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="2" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "1":	//受理
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">残業申請　受理申請</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="2" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "2":	//却下
%>
                <li class="work-item red">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">残業申請　申請却下</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="2" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "3":	//確定
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">残業申請　申請確定</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="2" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									default:	//申請中
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">残業申請　未申請</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="2" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									}
								}
							break;
						//***残業申請 END***

						//***交通費・経費申請 START***
						case "11":	//交通費・経費申請

							//承認が「9」の場合は削除済
							if(!requestList.get(k).certification.equals("9")){

								switch(requestList.get(k).certification){
									case "0":	//申請中
%>
                <li class="work-item ac2">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">交通費・経費申請　申請中</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="11" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "1":	//受理
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">交通費・経費申請　受理申請</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="11" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "2":	//却下
%>
                <li class="work-item red">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">交通費・経費申請　申請却下</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="11" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									case "3":	//確定
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">交通費・経費申請　申請確定</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="11" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">
		        </form>
                </li>
<%
										break;
									default:	//申請中
%>
                <li class="work-item ac1">
		        <form action="<%= request.getContextPath() %>/RequestConfirm" method="post" accept-charset="UTF-8">
                  <button>
                    <div class="w-ttl">交通費・経費申請　未申請</div>
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
                    <input type="hidden" value="<%=requestList.get(k).kinmuHiduke %>" name="kinmuHiduke">
                    <input type="hidden" value="<%=requestList.get(k).category %>" name="category">
                    <input type="hidden" value="<%=requestList.get(k).timeValue %>" name="timeValue">
                    <input type="hidden" value="<%=requestList.get(k).setTimeValue %>" name="setTimeValue">
                    <input type="hidden" value="<%=requestList.get(k).value %>" name="value">
                    <input type="hidden" value="<%=requestList.get(k).setValue %>" name="setValue">
                    <input type="hidden" value="<%=requestList.get(k).note %>" name="note">
                    <input type="hidden" value="<%=requestList.get(k).causeFlag %>" name="causeFlag">
                    <input type="hidden" value="<%=requestList.get(k).certification %>" name="certification">
                    <input type="hidden" value="11" name="categoryFlag">
                    <input type="hidden" value="0" name="requestFlag">

		        </form>
                </li>
<%
										break;
									}
								}
							break;
	//***交通費・経費申請 END***
						default:
							break;
					}
				}
			}
		}
		//************************
		//***申請の出力処理 END***
		//************************
%>
<%
     }else{
%>
                <li class="work-item red">
                  <button disabled>
                    <div class="w-ttl">フリー</div>
                  </button>
                </li>
<%
     }
%>
              </ul>
            </div>
          </li>
<%
}
%>
        </ul>
      </div>

    <!-- トップ画面に戻る -->
    <div class="btn mt-8">
      <form onclick="GetDateTime()" action="<%=request.getContextPath()%>/Login" method="post" accept-charset="UTF-8">
      <button class="white">トップ画面に戻る</button>
        <!-- サーブレットパラメータ用に隠し項目に格納 -->
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
        <input type="hidden" id="dspDate" name="dspDate">
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
// 画面表示用のリアルタイム日付
function showDate() {
    var nowTime		= new Date();
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

window.onload = function(){
  // ロード時に選択した年月を選択済みにする
  var select = document.getElementById("dt-num");
  for (var i = 0 ; i < select.options.length ; i++){
    if('<%=GetFormatYYYYMM(nowDate)%>' == select.options[i].value){
	  select.options[i].selected = true;
	}
  }
  //ロード時に前の月を選択している場合は「前の月」ボタンを非活性化
  if('<%=GetFormatYYYYMM(nowDate)%>' <= '<%=GetSpecifyYearMonth(-13)%>'){
	document.getElementById("back").disabled = true;
	document.getElementById("prev").disabled = true;
  //ロード時に次の月を選択している場合は「次の月」ボタンを非活性化
  }else if('<%=GetFormatYYYYMM(nowDate)%>' == '<%=GetSpecifyYearMonth(1)%>'){
    document.getElementById("forward").disabled = true;
    document.getElementById("next").disabled = true;
  }
  //画面の日時表示
  showDate();
  GetDateTime();
}
// 対象月のプルダウンを選択した際にサーブレットを呼び出す
function screenChange(){
	document.getElementById("form1").submit();
}
//「前の月」「次の月」際にサーブレットを呼び出す
function monthChange(value){
	document.getElementById("form2").submit();
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
	document.getElementById('dspDate').value = dspDateTime;
}
setInterval('GetDateTime()',60000);

//********************************************
//スクロールした際に年月を表示させるための対応
//********************************************
//***ここから下はいらないけど保留
var 	id 			= null;
const 	INTERVAL	= 300;

const onEnded = function() {
	// 処理
	window.scrollTo(0, window.scrollY - 50);
	id = null;
}

const onScroll = function() {
	clearTimeout( id );
	id = setTimeout( onEnded, INTERVAL );
}

//スクロールの際に作動
//window.addEventListener( 'scroll', onScroll );

function GoToScroll(num){
	window.scrollTo( 0, (110 * num) + 420);
}


//スクロールの際に作動
window.onscroll = scrollWindow;

//スクロールした時に呼ばれる
function scrollWindow() {
	//***ジャンプした位置が分かないとできない！！
	//var elem = document.getElementById(mmm);
	//var rect = elem.getBoundingClientRect();
	//alert(rect.top);
	//alert(window.innerHeight);
	//alert(window.pageYOffset);
	if(flag == 1){
		//window.scrollTo(0, rect.top - 50);
		//flag = 0;
	}
}
//***ここから上はいらないけど保留

//カレンダーをクリックするスクロール（ジャンプ）位置を補正
function scrollCorrection(num){
	//ジャンプしたスクロール位置を取得
	var elem = document.getElementById(num);
	var rect = elem.getBoundingClientRect();
	//カレンダーでクリックされた日付までスクロール
	location.href = "#" + num;
	//29日以前の場合は頭に出した年月のスペース分補正
	if(num < 30){
		//スクロール位置を補正
		window.scrollTo(0, rect.top - 50);
	}
}
//********************************************
//スクロールした際に年月を表示させるための対応
//********************************************
</script>

	<jsp:include page="../loading.jsp" />
</body>
</html>