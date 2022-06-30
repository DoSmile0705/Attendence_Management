package mobile;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dbaccess.P_MW_Worker;
import util.LoginInfo;

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
        // ログイン情報のコンテナを定義
        LoginInfo loginInfo = new LoginInfo();
        // 画面入力情報の取得
        String loginid = request.getParameter("loginid");
        String password1 = request.getParameter("password1");
        String password2 = request.getParameter("password2");
        String mailaddress = request.getParameter("mailaddress");

	    try {

	    	// DBアクセスクラス
	    	P_MW_Worker worker = new P_MW_Worker();
            // ログインIDをキーに警備員マスタを取得
	    	loginInfo = worker.select(loginid);

            // 
            if(loginid.isBlank() || loginInfo.id.isBlank()) {
                request.setAttribute("dispMsg", "IDを正しく入力してください");
                request.setAttribute("password1", password1);
                request.setAttribute("mailaddress", mailaddress);
        		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
                dispatch.forward(request, response);
            }
            // 入力されたパスワードが照合できなかったらエラー
            if(password1.isBlank() || !password1.equals(loginInfo.loginInfo1_Value)) {
                request.setAttribute("dispMsg", "パスワード１を正しく入力してください");
                request.setAttribute("loginid", loginid);
                request.setAttribute("mailaddress", mailaddress);
        		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
                dispatch.forward(request, response);
            }
            // 入力されたメールアドレスが照合できなかったらエラー
            if(mailaddress.isBlank() || !mailaddress.equals(loginInfo.email_Value)) {
                request.setAttribute("dispMsg", "メールアドレスを正しく入力してください");
                request.setAttribute("loginid", loginid);
                request.setAttribute("password1", password1);
        		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/login.jsp");
                dispatch.forward(request, response);
            }

        }catch(Exception e) {
        	e.printStackTrace();
        }
        // 照合できた場合はセッションを取得
		HttpSession session=request.getSession(true);
        request.setAttribute("sessionId", session.getId());
        // ログイン情報を画面に渡す
        request.setAttribute("loginInfo", loginInfo);
		RequestDispatcher dispatch = request.getRequestDispatcher("/index.jsp");
        dispatch.forward(request, response);

	}
}
