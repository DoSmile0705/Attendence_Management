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
import util.Authorization;
import util.DataCheck;
import util.LoginInfo;
import util.ShiftInfo;

/**
 * Servlet implementation class StampCancel
 */
public class WorkStampCancel extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WorkStampCancel() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
     * 画面からのリクエストを受け取る
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// セッションがなければログイン画面に遷移する。
		if(Authorization.isSessionValidChk(request) == false) {
			RequestDispatcher dispatch = request.getRequestDispatcher("login.jsp");
			dispatch.forward(request, response);
			return;
		}
		
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        // 打刻時刻受け取り
        String stringDate			= check.emptyOrNull(request.getParameter("stringDate"));
        // シフト情報パラメータ受け取り
        ShiftInfo shiftInfo = new ShiftInfo();
        shiftInfo.shiftHiduke		= check.emptyOrNull(request.getParameter("shiftHiduke"));
        shiftInfo.note				= check.emptyOrNull(request.getParameter("shiftNote"));
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
        shiftInfo.id				= check.emptyOrNull(request.getParameter("shiftDataId"));
        shiftInfo.timeFlag			= check.emptyOrNull(request.getParameter("timeFlag"));
        // ログイン情報の受け取り
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
        // 打刻種別
        String stampFlag			= check.emptyOrNull(request.getParameter("stampFlag"));

        PrintWriter out = response.getWriter();
        List workInfo =  new ArrayList();
        String stampTime = null;
        // 遷移元のURLを取得
        String url					= request.getHeader("REFERER");
        
		if(url.endsWith("StampCancel")) {
        	try {
        		// 上下番区分：上番をセット
        		// 5分以内の打刻データを取得する
                workInfo.add(stampFlag);
                workInfo.add("MINUTE");
                workInfo.add("0");
                if(stampFlag.equals("1")) {
                    workInfo.add("'" + shiftInfo.bgnStampTime.substring(0,19) + "'");
                }else if(stampFlag.equals("2")) {
                    workInfo.add("'" + shiftInfo.endStampTime.substring(0,19) + "'");
                }
                workInfo.add(shiftInfo.workerId);
                workInfo.add(shiftInfo.keiyakuId);
                workInfo.add(shiftInfo.id);
    
        		// DBアクセスクラス
        		P_Time_StampData stamp = new P_Time_StampData();
           		stamp.update(workInfo);
    	    }catch(Exception e) {
            	e.printStackTrace();
    	    }

       		request.setAttribute("shiftInfo", shiftInfo);
            request.setAttribute("loginInfo", loginInfo);
            request.setAttribute("stampFlag", stampFlag);
			RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-8.jsp");
            dispatch.forward(request, response);
		}else {
	   		request.setAttribute("shiftInfo", shiftInfo);
	        request.setAttribute("loginInfo", loginInfo);
	        request.setAttribute("stampFlag", stampFlag);
			RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-7.jsp");
	        dispatch.forward(request, response);
		}
	}
}
