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

import dbaccess.P_Time_StampData;
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
        // シフト情報パラメータ受け取り
        ShiftInfo shiftInfo = new ShiftInfo();
        shiftInfo.shiftHiduke = request.getParameter("shiftHiduke");
        shiftInfo.bgnTimeDate = request.getParameter("bgnTimeDate");
        shiftInfo.bgnTime = request.getParameter("bgnTime");
        shiftInfo.endTimeDate = request.getParameter("endTimeDate");
        shiftInfo.endTime = request.getParameter("endTime");
        shiftInfo.kinmuBashoName = request.getParameter("kinmuBashoName");
        shiftInfo.gyomuKubunName = request.getParameter("gyomuKubunName");
        shiftInfo.kinmuKubunName = request.getParameter("kinmuKubunName");
        shiftInfo.keiyakuKubunName = request.getParameter("keiyakuKubunName");
        shiftInfo.workerId = request.getParameter("workerId");
        shiftInfo.keiyakuId = request.getParameter("keiyakuId");
        // ログイン情報の受け取り
        LoginInfo loginInfo = new LoginInfo();
        loginInfo.id = (String)request.getParameter("loginid");
        loginInfo.loginInfo1_Value = (String)request.getParameter("password1");
        loginInfo.loginInfo2_Value = (String)request.getParameter("password2");
        loginInfo.email_Value = (String)request.getParameter("mailaddress");
        // 打刻時間取得パラメータ用
        List workInfo =  new ArrayList();
        String stampTime = null;
        PrintWriter out = response.getWriter();

    	try {
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

	    }catch(Exception e) {
        	e.printStackTrace();
	    }
        request.setAttribute("shiftInfo", shiftInfo);
        request.setAttribute("loginInfo", loginInfo);
		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/shiftselect.jsp");
        dispatch.forward(request, response);
 	}
}
