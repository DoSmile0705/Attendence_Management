package mobile;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dbaccess.P_MSG_MessageData;
import dbaccess.P_MW_Worker;
import dbaccess.P_Shift_SheetDataUp;
import dbaccess.P_Time_StampData;
import util.DataCheck;
import util.LoginInfo;
import util.MessageData;
import util.ShiftInfo;
import util.UtilConv;

/**
 * Servlet implementation class Login
 */
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        // ログイン情報のコンテナを定義
        LoginInfo loginInfo = new LoginInfo();
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
        // 画面入力情報の取得
        String loginid		= check.emptyOrNull(request.getParameter("loginid"));
        String password1	= check.emptyOrNull(request.getParameter("password1"));
        String password2	= check.emptyOrNull(request.getParameter("password2"));
        String mailaddress	= check.emptyOrNull(request.getParameter("mailaddress"));
        String sessionId	= check.emptyOrNull(request.getParameter("sessionId"));
        String url			= request.getHeader("REFERER");
        String companyCode	= check.emptyOrNull(request.getParameter("companyCode"));
        String companyName	= check.emptyOrNull(request.getParameter("companyName"));
        // お知らせ一覧格納用
        List<MessageData> msgInfo =  new ArrayList<>();
        // 本日のシフト
        ShiftInfo shiftInfo = new ShiftInfo();
        String deptStamp = null;
        String onTimeStamp = null;
        // ▼▼▼ 2022.8.10.パスワードに空文字が設定されている場合の対応 ▼▼▼
        // 入力されたパスワードがnullだったら空文字を設定
        if(password1 == null) {
        	password1 = "";
        }
        // ▲▲▲ 2022.8.10.パスワードに空文字が設定されている場合の対応 ▲▲▲
        // ▼▼▼ 2022.9.8.メールアドレスに空文字が設定されている場合の対応 ▼▼▼
        // 入力されたメールアドレスがnullだったら空文字を設定
        if(mailaddress == null) {
        	mailaddress = "";
        }
        // ▲▲▲ 2022.9.8.メールアドレスに空文字が設定されている場合の対応 ▲▲▲

        // 遷移元を判定する
        /***2022.7.11 試しに判定を変えてみる
        if (url.endsWith("AttendDetail")
        		|| url.endsWith("AttendList")
        		|| url.endsWith("DeptConfirm")
        		|| url.endsWith("DeptExecute")
        		|| url.endsWith("WorkStartConfirm")
        		|| url.endsWith("WorkStartExecute")
        		|| url.endsWith("WorkEndConfirm")
        		|| url.endsWith("WorkEndExecute")) {
        2022.7.11 試しに判定を変えてみる
        //if (!url.endsWith("azurewebsites.net") && !url.endsWith("AttendManagement/") && !url.endsWith("Login") && !url.endsWith("Driver")){
        2022.8.5 セッションがなかったらに変更***/
        if (sessionId != null){
        	password1	= utilConv.decrypt(password1);
        	mailaddress	= utilConv.decrypt(mailaddress);
        	sessionId	= utilConv.decrypt(sessionId);
        }
        PrintWriter out = response.getWriter();

    	// DBアクセスクラス
    	P_MW_Worker worker = new P_MW_Worker();

    	try {
            // ログインIDをキーに警備員マスタを取得
	    	loginInfo = worker.select(loginid);

	    }catch(Exception e) {
        	e.printStackTrace();
        }
	    	
        /*** ログインハンドリング ***/
    	// 社員番号が未入力もしくは照合できない場合はエラー
        if(loginid == null || loginInfo.id == null) {
            request.setAttribute("dispMsg", "社員番号を正しく入力してください");
            request.setAttribute("password1", password1);
            request.setAttribute("mailaddress", mailaddress);
            request.setAttribute("companyCode", companyCode);
            // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
    		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
            dispatch.forward(request, response);

        // ログインできないユーザー
        }else if(!loginInfo.adminLv.equals("2")) {
            request.setAttribute("dispMsg", "ログインできないユーザーです");
            request.setAttribute("loginid", loginid);
            request.setAttribute("password1", password1);
            request.setAttribute("companyCode", companyCode);
            request.setAttribute("mailaddress", mailaddress);
            // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
    		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
            dispatch.forward(request, response);

        // メールアドレスが未入力もしくは照合できない場合はエラー
        }else if(mailaddress == null) {
            request.setAttribute("dispMsg", "メールアドレスを入力してください");
            request.setAttribute("loginid", loginid);
            request.setAttribute("password1", password1);
            request.setAttribute("companyCode", companyCode);
            // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
    		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
            dispatch.forward(request, response);
        }else if(!mailaddress.equals(loginInfo.email_Value)) {
            request.setAttribute("dispMsg", "メールアドレスを正しく入力してください");
            request.setAttribute("loginid", loginid);
            request.setAttribute("password1", password1);
            request.setAttribute("companyCode", companyCode);
            // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
    		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
            dispatch.forward(request, response);
        // パスワードが未入力もしくは照合できない場合はエラー
        }else if(password1 == null || !password1.equals(loginInfo.loginInfo1_Value)) {
            // ▼▼▼ 2022.8.10.パスワードに空文字が設定されている場合の対応 ▼▼▼
            // 入力されたパスワードが空文字、かつエラーの場合はnullを設定
           	password1 = null;
            // ▲▲▲ 2022.8.10.パスワードに空文字が設定されている場合の対応 ▲▲▲
            request.setAttribute("dispMsg", "パスワードを正しく入力してください");
            request.setAttribute("loginid", loginid);
            request.setAttribute("mailaddress", mailaddress);
            request.setAttribute("companyCode", companyCode);
            // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
    		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
            dispatch.forward(request, response);

        // 会社識別番号が未入力もしくは照合できない場合はエラー
        }else if(companyCode == null || !companyCode.equals(loginInfo.companyCode)) {
            request.setAttribute("dispMsg", "会社識別番号を正しく入力してください");
            request.setAttribute("loginid", loginid);
            request.setAttribute("password1", password1);
            request.setAttribute("mailaddress", mailaddress);
            // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
    		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
            dispatch.forward(request, response);

        // ログイン成功
        }else {
        	try {
                // メールアドレスを暗号化する
                loginInfo.email_Value =utilConv.encrypt(mailaddress);
                // パスワードを暗号化する
                loginInfo.loginInfo1_Value =utilConv.encrypt(password1);
                
                /*** お知らせ一覧を取得する ***/
                // メッセージテーブルアクセスクラス
                P_MSG_MessageData msg = new P_MSG_MessageData();
                // ログインIDをキーにメッセージを取得
                msgInfo = msg.select(loginInfo.id);
                /*** 本日のシフトを取得する ***/
        		// DBアクセスクラス
    	    	P_Shift_SheetDataUp shift = new P_Shift_SheetDataUp();
                // ログインIDをキー本日のシフトを取得
    	    	shiftInfo = shift.todaysShift(loginInfo.id);

    	    	/*** 出勤報告の未／済を取得する ***/
    	        // P_Time_StampData検索のパラメータ用
    	        List workInfo =  new ArrayList();
                workInfo.add(0);
                workInfo.add("HOUR");
                // 1時間以内に打刻があったら「済」
                workInfo.add("-1");
                workInfo.add("DATEADD(HOUR,9,GETDATE())");
                workInfo.add(loginInfo.id);
                workInfo.add(0);

        		// DBアクセスクラス
        		P_Time_StampData stamp = new P_Time_StampData();
           		// 打刻情報を取得
           		deptStamp = stamp.select(workInfo);

    	    	/*** 定時報告の未／済を取得する ***/
    	        // P_Time_StampData検索のパラメータ用
    	        workInfo =  new ArrayList();
                workInfo.add(3);
                workInfo.add("HOUR");
                // 1時間以内に打刻があったら「済」
                workInfo.add("-1");
                workInfo.add("DATEADD(HOUR,9,GETDATE())");
                workInfo.add(loginInfo.id);
                workInfo.add(0);

                onTimeStamp = stamp.select(workInfo);

                if(sessionId == null) {
        		    // 照合できた場合はセッションを取得
        			HttpSession session = request.getSession(true);
        			sessionId = session.getId();
        	    }
    	    }catch(Exception e) {
            	e.printStackTrace();
            }
    		// セッションを暗号化して画面に渡す
            loginInfo.sessionId = utilConv.encrypt(sessionId);
            request.setAttribute("sessionId", loginInfo.sessionId);
            // ログイン情報を画面に渡す
            request.setAttribute("loginInfo", loginInfo);
            // お知らせ一覧を画面に渡す
            request.setAttribute("msgInfo", msgInfo);
            // 本日のシフトを画面に渡す
            request.setAttribute("shiftInfo", shiftInfo);
            // 出発報告を画面に渡す
            request.setAttribute("deptStamp", deptStamp);
            // 定時報告を画面に渡す
            request.setAttribute("onTimeStamp", onTimeStamp);
            RequestDispatcher dispatch = request.getRequestDispatcher("/index.jsp");
            //RequestDispatcher dispatch = request.getRequestDispatcher("/index2.jsp");
            dispatch.forward(request, response);
        }
	}
}
