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
import dbaccess.P_System_Value;
import dbaccess.P_Time_StampData;
import util.Constant;
import util.DataCheck;
import util.LoginInfo;
import util.MessageData;
import util.ShiftInfo;
import util.SystemValue;
import util.UtilConv;

/**
 * Servlet implementation class Login
 */
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
     * 画面からのリクエストを受け取る
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
        String geoIdo		= check.emptyOrNull(request.getParameter("geoIdo"));
        String geoKeido		= check.emptyOrNull(request.getParameter("geoKeido"));
        //お知らせ一覧格納用
        List<MessageData> msgInfo =  new ArrayList<>();
        //システムバリュー格納用
        List<SystemValue> systemValueList = new ArrayList<>();
        // 本日のシフト
        ShiftInfo shiftInfo = new ShiftInfo();
        String deptStamp = null;
        String onTimeStamp = null;

        //変換クラス
        UtilConv conv = new UtilConv();
        // 入力されたパスワードがnullだったら空文字を設定
        if(password1 == null) {
        	password1 = "";
        }
        // 入力されたメールアドレスがnullだったら空文字を設定
        if(mailaddress == null) {
        	mailaddress = "";
        }
        // 遷移元を判定する
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
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            dispatch.forward(request, response);

        // ログインできないユーザー
        }else if(!loginInfo.adminLv.equals("2")) {
            request.setAttribute("dispMsg", "ログインできないユーザーです");
            request.setAttribute("loginid", loginid);
            request.setAttribute("password1", password1);
            request.setAttribute("companyCode", companyCode);
            request.setAttribute("mailaddress", mailaddress);
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            dispatch.forward(request, response);

        // メールアドレスが未入力もしくは照合できない場合はエラー
        }else if(mailaddress == null) {
            request.setAttribute("dispMsg", "メールアドレスを入力してください");
            request.setAttribute("loginid", loginid);
            request.setAttribute("password1", password1);
            request.setAttribute("companyCode", companyCode);
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            dispatch.forward(request, response);
        }else if(!mailaddress.equals(loginInfo.email_Value)) {
            request.setAttribute("dispMsg", "メールアドレスを正しく入力してください");
            request.setAttribute("loginid", loginid);
            request.setAttribute("password1", password1);
            request.setAttribute("companyCode", companyCode);
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            dispatch.forward(request, response);
        // パスワードが未入力もしくは照合できない場合はエラー
        }else if(password1 == null || !password1.equals(loginInfo.loginInfo1_Value)) {
           	password1 = null;
            request.setAttribute("dispMsg", "パスワードを正しく入力してください");
            request.setAttribute("loginid", loginid);
            request.setAttribute("mailaddress", mailaddress);
            request.setAttribute("companyCode", companyCode);
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
            dispatch.forward(request, response);

        // 会社識別番号が未入力もしくは照合できない場合はエラー
        }else if(companyCode == null || !companyCode.equals(loginInfo.companyCode)) {
            request.setAttribute("dispMsg", "会社識別番号を正しく入力してください");
            request.setAttribute("loginid", loginid);
            request.setAttribute("password1", password1);
            request.setAttribute("mailaddress", mailaddress);
    		RequestDispatcher dispatch = request.getRequestDispatcher("/login.jsp");
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
                // ログインIDをキーに未読メッセージを取得
                Constant.UNREAD = msg.selectIsRead(loginInfo.id);
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
                workInfo.add("-12");
	            workInfo.add("DATEADD(HOUR,9,GETDATE())");
                workInfo.add(loginInfo.id);
                workInfo.add(0);
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
                workInfo.add("-12");
	            workInfo.add("DATEADD(HOUR,9,GETDATE())");
                workInfo.add(loginInfo.id);
                workInfo.add(0);
                workInfo.add(0);

                onTimeStamp = stamp.select(workInfo);

                if(sessionId == null) {
        		    // 照合できた場合はセッションを取得
        			HttpSession session = request.getSession(true);
        			sessionId = session.getId();
        	    }
    	    	/*** 定時報告の未／済を取得する ***/
                P_System_Value PSV = new P_System_Value();
                systemValueList = PSV.select();

                Constant.RIYOBTN	= "未設定";
                Constant.GAIYOBTN	= "未設定";
                Constant.KIYAKUBTN	= "未設定";
                if(systemValueList.size() > 0) {
                	for(int i = 0; i < systemValueList.size(); i ++) {
                		switch(systemValueList.get(i).systemValueCD) {
                			case "1":
                                Constant.RIYOURL	= systemValueList.get(i).systemValueText;
                                Constant.RIYOBTN	= systemValueList.get(i).systemNote;
                				break;
                			case "2":
                                Constant.GAIYOURL	= systemValueList.get(i).systemValueText;
                                Constant.GAIYOBTN	= systemValueList.get(i).systemNote;
                				break;
                			case "3":
                                Constant.KIYAKUURL	= systemValueList.get(i).systemValueText;
                                Constant.KIYAKUBTN	= systemValueList.get(i).systemNote;
                				break;
                			default:
                				break;
                		}
                	}
                }

    	    }catch(Exception e) {
            	e.printStackTrace();
            }
        	/***位置情報がすでに暗号化されているか確認***/
        	//暗号化していなかったら暗号化、していたらそのままセット
        	if(!utilConv.isAlpha(geoIdo)) {
        		// 端末から取得した緯度を暗号化
            	loginInfo.geoIdo_Value = utilConv.encrypt(geoIdo);
        	}else {
            	loginInfo.geoIdo_Value = geoIdo;
        	}
        	//暗号化していなかったら暗号化、していたらそのままセット
        	if(!utilConv.isAlpha(geoKeido)) {
        		// 端末から取得した経度を暗号化
            	loginInfo.geoKeido_Value = utilConv.encrypt(geoKeido);
        	}else {
            	loginInfo.geoKeido_Value = geoKeido;
        	}
        	/***位置情報がすでに暗号化されているか確認***/
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
            /***デバッグ用切り替え***/
            RequestDispatcher dispatch = request.getRequestDispatcher("/index.jsp");
            //RequestDispatcher dispatch = request.getRequestDispatcher("/index2.jsp");
            dispatch.forward(request, response);
        }
	}
}
