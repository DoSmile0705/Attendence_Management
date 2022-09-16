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

import dbaccess.P_Shift_SheetDataUp;
import dbaccess.P_Time_StampData;
import util.DataCheck;
import util.LoginInfo;
import util.ShiftInfo;
import util.UtilConv;

/**
 * Servlet implementation class AttendList
 */
public class AttendList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AttendList() {
        super();
        // TODO Auto-generated constructor stub
    }

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
    	String loginid = "1";
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        List<ShiftInfo> listInfo =  new ArrayList<>();
        DataCheck check = new DataCheck();
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
        // 画面項目の受け取り
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
        // 打刻データ取得パラメータ用
        List workInfo =  new ArrayList();
        String stampTime = null;
        // ▼▼▼ 2022.08.19 HTML→JSP変換対応 ▼▼▼
        String attendStamp = null;	// シフト外上番打刻
        String leaveStamp = null;	// シフト外下番打刻
        // ▲▲▲ 2022.08.19 HTML→JSP変換対応 ▲▲▲
    	try {

    		// シフト一覧取得
	    	P_Shift_SheetDataUp shift = new P_Shift_SheetDataUp();
    		// 打刻取得
    		P_Time_StampData stamp = new P_Time_StampData();
            // IDをキーに警備員マスタを取得
	    	listInfo = shift.select(loginInfo.id);

	    	/*** シフト一覧に打刻を取得する処理 ***/
	    	for(int i = 0; i < listInfo.size(); i ++) {
	    		// 1時間以内に上番打刻があったら上番時刻を取得する処理
	    		// 上下番区分：上番をセット
	            workInfo.add(1);
	            workInfo.add("HOUR");
	            workInfo.add("-1");
	            workInfo.add("DATEADD(HOUR,9,GETDATE())");
	            workInfo.add(listInfo.get(i).workerId);
	            workInfo.add(listInfo.get(i).keiyakuId);

	    		stampTime = stamp.select(workInfo);

	    		if(stampTime != null) {
	    			listInfo.get(i).bgnStampTime = stampTime;
	    		}

	    		// 1時間以内に下番打刻があったら下番時刻を取得する
	    		workInfo = new ArrayList();
	    		stamp = new P_Time_StampData();
	    		// 上下番区分：下番をセット
	            workInfo.add(2);
	            workInfo.add("HOUR");
	            workInfo.add("-1");
	            workInfo.add("DATEADD(HOUR,9,GETDATE())");
	            workInfo.add(listInfo.get(i).workerId);
	            workInfo.add(listInfo.get(i).keiyakuId);

	            stampTime = stamp.select(workInfo);
	    		if(stampTime != null) {
	    			listInfo.get(i).endStampTime = stampTime;
	    		}
	    	}
	    		
	    	// ▼▼▼ 2022.08.19 HTML→JSP変換対応 ▼▼▼
	    	/***シフトに関係ない打刻を取得する***/
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
            // ▲▲▲ 2022.08.19 HTML→JSP変換対応 ▲▲▲

	    	// 緯度を暗号化する
	    	if(loginInfo.geoIdo_Value != null) {
	    		loginInfo.geoIdo_Value = utilConv.encrypt(loginInfo.geoIdo_Value);
	    	}
	    	// 経度を暗号化する
	    	if(loginInfo.geoKeido_Value != null) {
	    		loginInfo.geoKeido_Value = utilConv.encrypt(loginInfo.geoKeido_Value);
	    	}

	    }catch(Exception e) {
        	e.printStackTrace();
	    }
        request.setAttribute("listInfo", listInfo);
        request.setAttribute("loginInfo", loginInfo);
        // ▼▼▼ 2022.08.19 HTML→JSP変換対応 ▼▼▼
        request.setAttribute("attendStamp", attendStamp);
        request.setAttribute("leaveStamp", leaveStamp);
        // ▲▲▲ 2022.08.19 HTML→JSP変換対応 ▲▲▲
        // ▼▼▼ 2022.08.16 HTML→JSP変換対応 ▼▼▼
		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/shiftlist.jsp");
		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-1.jsp");
        // ▲▲▲ 2022.08.16 HTML→JSP変換対応 ▲▲▲
        dispatch.forward(request, response);
	}

}
