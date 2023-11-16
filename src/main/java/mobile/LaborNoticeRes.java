package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dbaccess.P_MW_Worker;
import util.Authorization;
import util.DataCheck;
import util.LoginInfo;
import util.UtilConv;

/**
 * 労働通知書詳細からの戻りの処理
 */
public class LaborNoticeRes extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LaborNoticeRes() {
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
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
        // ログイン情報の受け取り
        LoginInfo loginInfo = new LoginInfo();
        // URLからパラメータを受け取り
        String id			= check.emptyOrNull(request.getParameter("id"));
        String key1			= check.emptyOrNull(request.getParameter("key1"));
        String key2			= check.emptyOrNull(request.getParameter("key2"));
        String key3			= check.emptyOrNull(request.getParameter("key3"));
        String workerId		= check.emptyOrNull(request.getParameter("workerId"));
        String companyId	= check.emptyOrNull(request.getParameter("companyId"));
        //セッション用
        String sessionId = null;
        // パラメータ用
        List workInfo =  new ArrayList();
        try {
        	// DBアクセスクラス
        	P_MW_Worker worker = new P_MW_Worker();
            /***パラメータからユーザー情報を取得***/
            // ログインIDをキーに警備員マスタを取得
	    	loginInfo = worker.selectAnother(workerId);
            //新しいセッションを取得
			HttpSession session = request.getSession(true);
			sessionId = session.getId();
        }catch(Exception e) {
        	e.printStackTrace();
        }
    	// セッションを暗号化して画面に渡す
        loginInfo.sessionId = utilConv.encrypt(sessionId);
        request.setAttribute("sessionId", loginInfo.sessionId);
        // ログイン情報を画面に渡す
        request.setAttribute("loginInfo", loginInfo);
        RequestDispatcher dispatch = request.getRequestDispatcher("term/term-1.jsp");
        dispatch.forward(request, response);
	}

}
