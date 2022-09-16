package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dbaccess.P_Kinmu_RequestData;
import dbaccess.P_Time_StampData;
import util.DataCheck;
import util.LoginInfo;
import util.RequestData;
import util.ShiftInfo;

/**
 * Servlet implementation class AttendDetail
 */
public class AttendDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AttendDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        // シフト情報パラメータ受け取り
        ShiftInfo shiftInfo = new ShiftInfo();
        shiftInfo.shiftHiduke		= check.emptyOrNull(request.getParameter("shiftHiduke"));
        shiftInfo.bgnTimeDate		= check.emptyOrNull(request.getParameter("bgnTimeDate"));
        shiftInfo.bgnTime			= check.emptyOrNull(request.getParameter("bgnTime"));
        shiftInfo.endTimeDate		= check.emptyOrNull(request.getParameter("endTimeDate"));
        shiftInfo.endTime			= check.emptyOrNull(request.getParameter("endTime"));
        shiftInfo.kinmuBashoName	= check.emptyOrNull(request.getParameter("kinmuBashoName"));
        shiftInfo.gyomuKubunName	= check.emptyOrNull(request.getParameter("gyomuKubunName"));
        shiftInfo.kinmuKubunName	= check.emptyOrNull(request.getParameter("kinmuKubunName"));
        shiftInfo.keiyakuKubunName	= check.emptyOrNull(request.getParameter("keiyakuKubunName"));
        shiftInfo.workerId			= check.emptyOrNull(request.getParameter("workerId"));
        shiftInfo.keiyakuId			= check.emptyOrNull(request.getParameter("keiyakuId"));
        shiftInfo.bgnStampTime		= check.emptyOrNull(request.getParameter("bgnStampTime"));
        shiftInfo.endStampTime		= check.emptyOrNull(request.getParameter("endStampTime"));
        shiftInfo.adrPostNo			= check.emptyOrNull(request.getParameter("adrPostNo"));
        shiftInfo.adrMain			= check.emptyOrNull(request.getParameter("adrMain"));
        shiftInfo.adrSub			= check.emptyOrNull(request.getParameter("adrSub"));
        // ログイン情報の受け取り
        LoginInfo loginInfo = new LoginInfo();
        /** ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼ **/
        //loginInfo.id				= check.emptyOrNull(request.getParameter("loginid"));
        loginInfo.workerIndex		= check.emptyOrNull(request.getParameter("loginid"));
        loginInfo.id				= check.emptyOrNull(request.getParameter("id"));
        /** ▲▲▲2022/7/28 Id → WorkerIndexに変更▲▲▲ **/
        loginInfo.loginInfo1_Value	= check.emptyOrNull(request.getParameter("password1"));
        loginInfo.loginInfo2_Value	= check.emptyOrNull(request.getParameter("password2"));
        loginInfo.email_Value		= check.emptyOrNull(request.getParameter("mailaddress"));
        loginInfo.firstName_Value	= check.emptyOrNull(request.getParameter("firstName_Value"));
        loginInfo.lastName_Value	= check.emptyOrNull(request.getParameter("lastName_Value"));
        loginInfo.geoIdo_Value		= check.emptyOrNull(request.getParameter("geoIdo"));
        loginInfo.geoKeido_Value	= check.emptyOrNull(request.getParameter("geoKeido"));
        loginInfo.sessionId			= check.emptyOrNull(request.getParameter("sessionId"));
        loginInfo.companyCode		= check.emptyOrNull(request.getParameter("companyCode"));
        loginInfo.companyName		= check.emptyOrNull(request.getParameter("companyName"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company_ID"));
        // 「現場の詳細」の要求を示すフラグ
        String linkFlg				= check.emptyOrNull(request.getParameter("linkFlg"));
        String shiftFlag			= check.emptyOrNull(request.getParameter("shiftFlag"));

        // 打刻時間取得パラメータ用
        List workInfo =  new ArrayList();
        String stampTime = null;
        String attendStamp = null;	// シフト外上番打刻
        String leaveStamp = null;	// シフト外下番打刻
        // 申請データ取得用
        RequestData requestOver = new RequestData();		// 残業
        RequestData requestEarly = new RequestData();		// 早出
        RequestData requestTransport = new RequestData();	// 交通費経費

    	try {
    		/*** 2022.7.11 シフト一覧で取得するので削除***/

    		// 12時間以内に上番打刻があったら上番時刻を取得する処理
    		// 上下番区分：上番をセット
            workInfo.add(1);
            workInfo.add("HOUR");
            workInfo.add("-1");
            workInfo.add("DATEADD(HOUR,9,GETDATE())");
            workInfo.add(shiftInfo.workerId);
            workInfo.add(shiftInfo.keiyakuId);

    		// DBアクセスクラス
    		P_Time_StampData stamp = new P_Time_StampData();

    		stampTime = stamp.select(workInfo);
    		if(stampTime != null) {
    	        shiftInfo.bgnStampTime = stampTime;
    		}else {
    	        shiftInfo.bgnStampTime = null;
    		}

    		// 12時間以内に下番打刻があったら下番時刻を取得する
    		workInfo = new ArrayList();
    		stamp = new P_Time_StampData();
    		// 上下番区分：下番をセット
            workInfo.add(2);
            workInfo.add("HOUR");
            workInfo.add("-1");
            workInfo.add("DATEADD(HOUR,9,GETDATE())");
            workInfo.add(shiftInfo.workerId);
            workInfo.add(shiftInfo.keiyakuId);

            stampTime = stamp.select(workInfo);
    		if(stampTime != null) {
    	        shiftInfo.endStampTime = stampTime;
    		}else {
    	        shiftInfo.endStampTime = null;
    		}

    		/***2022.7.11 シフト一覧で取得するので削除 ***/

    		/***▼▼▼シフトに関係ない打刻を取得する▼▼▼***/
    		// 1時間以内に上番打刻があったら上番時刻を取得する
    		workInfo = new ArrayList();
    		stamp = new P_Time_StampData();
    		// 上下番区分：上番をセット
            workInfo.add(1);
            workInfo.add("HOUR");
            workInfo.add("-1");
            workInfo.add("DATEADD(HOUR,9,GETDATE())");
            workInfo.add(loginInfo.id);
            workInfo.add(0);

            attendStamp = stamp.select(workInfo);

    		// 1時間以内に下番打刻があったら下番時刻を取得する
    		workInfo = new ArrayList();
    		stamp = new P_Time_StampData();
    		// 上下番区分：下番をセット
            workInfo.add(2);
            workInfo.add("HOUR");
            workInfo.add("-1");
            workInfo.add("DATEADD(HOUR,9,GETDATE())");
            workInfo.add(loginInfo.id);
            workInfo.add(0);

            leaveStamp = stamp.select(workInfo);
    		/***▲▲▲シフトに関係ない打刻を取得する▲▲▲***/
            
            // 現場の詳細に遷移する場合は申請データを取得
    		/***▼▼▼2022.09.01 現場の詳細に申請処理を加える▼▼▼***/
            //if(linkFlg != null) {
        		workInfo = new ArrayList();
                workInfo.add(loginInfo.company_ID);
                workInfo.add(loginInfo.id);
                workInfo.add(shiftInfo.shiftHiduke);
                workInfo.add("1");
                
                P_Kinmu_RequestData pkrd = new P_Kinmu_RequestData();
                // 早出の申請データを取得
                requestEarly = pkrd.select(workInfo);
                
                // 残業の申請データを取得
                workInfo.set(3, "2");
                requestOver = pkrd.select(workInfo);

                // 経費・交通費の申請データを取得
                workInfo.set(3, "11");
                requestTransport = pkrd.select(workInfo);
            //}
    		/***▲▲▲2022.09.01 現場の詳細に申請処理を加える▲▲▲***/


	    }catch(Exception e) {
        	e.printStackTrace();
	    }
        request.setAttribute("shiftInfo", shiftInfo);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("attendStamp", attendStamp);
        request.setAttribute("leaveStamp", leaveStamp);
        request.setAttribute("requestEarly", requestEarly);
        request.setAttribute("requestOver", requestOver);
        request.setAttribute("requestTransport", requestTransport);
        // ▼▼▼ 2022.08.20 HTML→JSP変換対応 ▼▼▼
        // フラグによってシフトの詳細か現場の詳細を表示する
        if(linkFlg == null) {
    		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/shiftselect.jsp");
    		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-2.jsp");
            dispatch.forward(request, response);
        }else {
    		RequestDispatcher dispatch = request.getRequestDispatcher("work/work-2.jsp");
            dispatch.forward(request, response);
        }
        // ▲▲▲ 2022.08.20 HTML→JSP変換対応 ▲▲▲
 	}
}
