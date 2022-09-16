package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dbaccess.P_Time_StampData;
import util.DataCheck;
import util.LoginInfo;

/**
 * Servlet implementation class NoShiftStampCancel
 */
public class NoShiftStampCancel extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoShiftStampCancel() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        // 打刻時刻受け取り
        String stringDate			= check.emptyOrNull(request.getParameter("stringDate"));
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
        String delStampTime			= check.emptyOrNull(request.getParameter("delStampTime"));

        List workInfo =  new ArrayList();
        String stampTime = null;
        
		// 上下番区分：上番をセット
		// 5分以内の打刻データを取得する
        workInfo.add(stampFlag);
        workInfo.add("MINUTE");
        workInfo.add("0");
        workInfo.add("'" + delStampTime.substring(0,19) + "'");
        workInfo.add(loginInfo.id);
        workInfo.add(0);

		// DBアクセスクラス
		P_Time_StampData stamp = new P_Time_StampData();
		
    	try {
    		stamp.update(workInfo);
	    }catch(Exception e) {
        	e.printStackTrace();
	    }

        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("stampFlag", stampFlag);
        request.setAttribute("delStampTime", delStampTime);
		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-12.jsp");
        dispatch.forward(request, response);

	}

}
