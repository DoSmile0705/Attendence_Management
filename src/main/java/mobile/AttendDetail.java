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

import util.DataCheck;
import util.LoginInfo;
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
        loginInfo.id				= check.emptyOrNull(request.getParameter("loginid"));
        loginInfo.loginInfo1_Value	= check.emptyOrNull(request.getParameter("password1"));
        loginInfo.loginInfo2_Value	= check.emptyOrNull(request.getParameter("password2"));
        loginInfo.email_Value		= check.emptyOrNull(request.getParameter("mailaddress"));
        loginInfo.firstName_Value	= check.emptyOrNull(request.getParameter("firstName_Value"));
        loginInfo.lastName_Value	= check.emptyOrNull(request.getParameter("lastName_Value"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company"));
        loginInfo.geoIdo_Value		= check.emptyOrNull(request.getParameter("geoIdo"));
        loginInfo.geoKeido_Value	= check.emptyOrNull(request.getParameter("geoKeido"));
        loginInfo.sessionId			= check.emptyOrNull(request.getParameter("sessionId"));
        // 打刻時間取得パラメータ用
        List workInfo =  new ArrayList();
        String stampTime = null;
        PrintWriter out = response.getWriter();

    	try {
    		/*** 2022.7.11 シフト一覧で取得するので削除

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
    		}

    		2022.7.11 シフト一覧で取得するので削除 ***/

	    }catch(Exception e) {
        	e.printStackTrace();
	    }
        request.setAttribute("shiftInfo", shiftInfo);
        request.setAttribute("loginInfo", loginInfo);
		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/shiftselect.jsp");
        dispatch.forward(request, response);
 	}
}
