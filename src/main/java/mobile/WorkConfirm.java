package mobile;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DataCheck;
import util.LoginInfo;

/**
 * Servlet implementation class WorkConfirm
 */
public class WorkConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WorkConfirm() {
        super();
        // TODO Auto-generated constructor stub
    }

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
        // 画面からの項目を受け取り
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
        // 遷移元のURLを取得
        String url					= request.getHeader("REFERER");
        // 打刻種別
        String stampFlag			= check.emptyOrNull(request.getParameter("stampFlag"));
        String stringDate			= check.emptyOrNull(request.getParameter("stringDate"));

        PrintWriter out = response.getWriter();

		// 上下番した直後の打刻をキャンセル
		if(url.endsWith("WorkStartExecute") || url.endsWith("WorkExecute")) {
            request.setAttribute("loginInfo", loginInfo);
            request.setAttribute("stampFlag", stampFlag);	// 打刻種別
            request.setAttribute("stringDate", stringDate);
    		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-7.jsp");
            dispatch.forward(request, response);
        } else {
            request.setAttribute("loginInfo", loginInfo);
            request.setAttribute("stampFlag", stampFlag);	// 打刻種別
    		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-3.jsp");
            dispatch.forward(request, response);
        }
	}

}
