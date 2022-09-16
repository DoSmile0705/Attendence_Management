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
import util.DataCheck;
import util.LoginInfo;

/**
 * Servlet implementation class DeptExecute
 */
public class DeptExecute extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeptExecute() {
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
        // 打刻時刻受け取り
        String stringDate			= check.emptyOrNull(request.getParameter("stringDate"));
        // ログイン情報の受け取り
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
        loginInfo.stampDate			= check.emptyOrNull(request.getParameter("stampDate"));
        loginInfo.companyCode		= check.emptyOrNull(request.getParameter("companyCode"));
        loginInfo.companyName		= check.emptyOrNull(request.getParameter("companyName"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company_ID"));
        // 5分以内の前打刻日時
        String delStampTime			= check.emptyOrNull(request.getParameter("delStampTime"));
        // 遷移元のURLを取得
        String url					= request.getHeader("REFERER");
        // 打刻種別
        String stampFlag			= check.emptyOrNull(request.getParameter("stampFlag"));

        PrintWriter out = response.getWriter();
        // P_Time_StampDataのパラメータ用
        List workInfo =  new ArrayList();
        String stampTime = null;
        String res = null;
        // 画面表示するメッセージ
        String message = "事務所に出発時刻を報告しました。気をつけて現場に向かってください。";
        
		// DBアクセスクラス
		P_Time_StampData stamp = new P_Time_StampData();

		// 5分以内の前レコードが存在し、確認画面からの遷移の場合はキャンセル確認を表示
		if(delStampTime != null && url.endsWith("DeptConfirm")) {
	        request.setAttribute("stampFlag", stampFlag);		// 打刻種別
	        request.setAttribute("loginInfo", loginInfo);
	        request.setAttribute("delStampTime", delStampTime);
	        // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
			//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/deptCancel.jsp");
			RequestDispatcher dispatch = request.getRequestDispatcher("repo/repo-4.jsp");
	        // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
	        dispatch.forward(request, response);
   		// 5分以内の前打刻が存在し、出発取消確認画面からの遷移の場合は前打刻を削除
		}else if(delStampTime != null && url.endsWith("DeptExecute")) {
    		// 打刻種別、削除条件をセット※流用の弊害で空きを作らないといけない
            workInfo.add(stampFlag);
            workInfo.add(null);
            workInfo.add(null);
            workInfo.add("'" + delStampTime + "'");
            workInfo.add(loginInfo.id);
            workInfo.add(0);
        	try {
        		// 前打刻を削除
        		stamp.delete(workInfo);
    	    }catch(Exception e) {
            	e.printStackTrace();
    	    }
    		// 削除した前打刻を画面に渡す
	        request.setAttribute("delStampTime", delStampTime);
	        request.setAttribute("loginInfo", loginInfo);
	        request.setAttribute("message", message);
	        request.setAttribute("stampFlag", stampFlag);		// 打刻種別
	        // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
			//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/stampRes.jsp");
			RequestDispatcher dispatch = request.getRequestDispatcher("repo/repo-3.jsp");
	        // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
	        dispatch.forward(request, response);

    	// 時刻を登録する
		} else {
            // 打刻種別、登録情報をセット※流用の弊害で空きを作らないといけない
            workInfo.add(stampFlag);
            workInfo.add(null);
            workInfo.add(null);
            workInfo.add("'" + loginInfo.stampDate + "'");
            workInfo.add(loginInfo.id);
            workInfo.add(0);
        	try {
        		// 新しい打刻レコードを登録
        		stamp.insert(workInfo);
    	    }catch(Exception e) {
            	e.printStackTrace();
    	    }
            request.setAttribute("loginInfo", loginInfo);
            request.setAttribute("message", message);
            request.setAttribute("stampFlag", stampFlag);		// 打刻種別
            // ▼▼▼ 2022.08.15 HTML→JSP変換対応 ▼▼▼
    		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/stampRes.jsp");
    		RequestDispatcher dispatch = request.getRequestDispatcher("repo/repo-3.jsp");
            // ▲▲▲ 2022.08.15 HTML→JSP変換対応 ▲▲▲
            dispatch.forward(request, response);
		}
	}
}
