package mobile;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dbaccess.P_MW_Worker;
import util.DataCheck;
import util.LoginInfo;
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
		response.getWriter().append("Served at: ").append(request.getContextPath());
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
        String company		= check.emptyOrNull(request.getParameter("company"));
        String sessionId	= check.emptyOrNull(request.getParameter("sessionId"));
        String url			= request.getHeader("REFERER");
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
        2022.7.11 試しに判定を変えてみる***/
        if (!url.endsWith("azurewebsites.net") && !url.endsWith("AttendManagement/") && !url.endsWith("Login") && !url.endsWith("Driver")){
        	password1	= utilConv.decrypt(password1);
        	mailaddress	= utilConv.decrypt(mailaddress);
        	sessionId	= utilConv.decrypt(sessionId);
        }
        PrintWriter out = response.getWriter();

	    try {

	    	// DBアクセスクラス
	    	P_MW_Worker worker = new P_MW_Worker();
            // ログインIDをキーに警備員マスタを取得
	    	loginInfo = worker.select(loginid);
	    	
            // 入力されたメールアドレスが照合できなかったらエラー
            if(mailaddress == null || !mailaddress.equals(loginInfo.email_Value)) {
                request.setAttribute("dispMsg", "メールアドレスを正しく入力してください");
                request.setAttribute("loginid", loginid);
                request.setAttribute("password1", password1);
                request.setAttribute("company", company);
        		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
                dispatch.forward(request, response);
            }
            // メールアドレスを暗号化する
            loginInfo.email_Value =utilConv.encrypt(mailaddress);
            
            // 入力されたパスワードが照合できなかったらエラー
            if(password1 == null || !password1.equals(loginInfo.loginInfo1_Value)) {
                request.setAttribute("dispMsg", "パスワードを正しく入力してください");
                request.setAttribute("loginid", loginid);
                request.setAttribute("mailaddress", mailaddress);
                request.setAttribute("company", company);
        		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
                dispatch.forward(request, response);
            }
            // パスワードを暗号化する
            loginInfo.loginInfo1_Value =utilConv.encrypt(password1);

            // 会社識別番号が未入力の場合はエラー
            if(company == null || !company.equals(loginInfo.company_ID)) {
                request.setAttribute("dispMsg", "会社識別番号を正しく入力してください");
                request.setAttribute("loginid", loginid);
                request.setAttribute("password1", password1);
                request.setAttribute("mailaddress", mailaddress);
        		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
                dispatch.forward(request, response);
            }
	    	// 社員番号が未入力の場合はエラー
            if(loginid == null) {
                request.setAttribute("dispMsg", "社員番号を正しく入力してください");
                request.setAttribute("password1", password1);
                request.setAttribute("mailaddress", mailaddress);
                request.setAttribute("company", company);
        		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
                dispatch.forward(request, response);
            }

        }catch(Exception e) {
        	e.printStackTrace();
        }

	    if(sessionId == null) {
		    // 照合できた場合はセッションを取得
			HttpSession session = request.getSession(true);
			sessionId = session.getId();
	    }
	    loginInfo.sessionId = utilConv.encrypt(sessionId);
		// セッションを暗号化して画面に渡す
        request.setAttribute("sessionId", loginInfo.sessionId);
        // ログイン情報を画面に渡す
        request.setAttribute("loginInfo", loginInfo);
		//RequestDispatcher dispatch = request.getRequestDispatcher("/index.jsp");
		RequestDispatcher dispatch = request.getRequestDispatcher("/index2.jsp");
        dispatch.forward(request, response);
	}
}
