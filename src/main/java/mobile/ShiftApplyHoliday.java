package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dbaccess.P_MK_RequestKubun;
import util.DataCheck;
import util.LoginInfo;
import util.RequestKubun;
import util.ShiftRequest;

/**
 * Servlet implementation class ShiftApplyHoliday
 */
public class ShiftApplyHoliday extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShiftApplyHoliday() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
     * 画面からのリクエストを受け取る
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        LoginInfo loginInfo = new LoginInfo();
        loginInfo.workerIndex		= check.emptyOrNull(request.getParameter("loginid"));
        loginInfo.id				= check.emptyOrNull(request.getParameter("id"));
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
	    ShiftRequest shiftReq = new ShiftRequest();
	    shiftReq.id					= check.emptyOrNull(request.getParameter("req_ID"));
	    shiftReq.worker_ID			= check.emptyOrNull(request.getParameter("worker_ID"));
	    shiftReq.hiduke				= check.emptyOrNull(request.getParameter("hiduke"));
	    shiftReq.requestFlag		= check.emptyOrNull(request.getParameter("requestFlag"));
	    shiftReq.requestName		= check.emptyOrNull(request.getParameter("requestName"));
	    shiftReq.note				= check.emptyOrNull(request.getParameter("note"));
	    shiftReq.timeFlag			= check.emptyOrNull(request.getParameter("timeFlag"));
	    shiftReq.backColorFlag		= check.emptyOrNull(request.getParameter("backColorFlag"));
	    shiftReq.fontColorFlag		= check.emptyOrNull(request.getParameter("fontColorFlag"));
	    //表示日付
	    String reqDay				= check.emptyOrNull(request.getParameter("reqDay"));
	    String reqDate				= check.emptyOrNull(request.getParameter("reqDate"));
	    String reqWeek				= check.emptyOrNull(request.getParameter("reqWeek"));
	    String nowDate				= check.emptyOrNull(request.getParameter("nowDate"));
		/***リクエスト区分を取得***/
	    List<RequestKubun> reqKubunList = new ArrayList<>();
        // パラメータ用
        List workInfo =  new ArrayList();
        //リクエストデータアクセス用
		P_MK_RequestKubun pmkq	= new P_MK_RequestKubun();
        workInfo =  new ArrayList();
        workInfo.add(loginInfo.company_ID);
        try {
            reqKubunList = pmkq.select(workInfo);
        }catch(Exception e) {
        	e.printStackTrace();
        }
        request.setAttribute("reqKubunList", reqKubunList);
        request.setAttribute("shiftReq", shiftReq);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("reqDate", reqDate);
        request.setAttribute("reqDay", reqDay);
        request.setAttribute("reqWeek", reqWeek);
        request.setAttribute("nowDate", nowDate);
        //画面項目をそのまま返す
   		RequestDispatcher dispatch = request.getRequestDispatcher("work/work-11.jsp");
   		dispatch.forward(request, response);
	}

}
