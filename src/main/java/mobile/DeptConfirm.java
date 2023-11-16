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

/**
 * Servlet implementation class DeptConfirm
 */
public class DeptConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DeptConfirm() {
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
        // 画面からの項目を受け取り
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
        //前画面から取得した現在日時（stampDate）がnullだったらもう一方から取得
        if(loginInfo.stampDate == null) {
            loginInfo.stampDate			= check.emptyOrNull(request.getParameter("stampDate2"));
        }
        loginInfo.companyCode		= check.emptyOrNull(request.getParameter("companyCode"));
        loginInfo.companyName		= check.emptyOrNull(request.getParameter("companyName"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company_ID"));
        // 削除対象の前打刻
        String delStampTime			= check.emptyOrNull(request.getParameter("delStampTime"));
        // 打刻種別
        String stampFlag			= check.emptyOrNull(request.getParameter("stampFlag"));
        // P_Time_StampData検索のパラメータ用
        List workInfo =  new ArrayList();
		// DBアクセスクラス
		P_Time_StampData stamp = new P_Time_StampData();
		//打刻履歴リスト
		List historyList = new ArrayList();
        try {
    		// 削除対象の前打刻がない場合は5分前の打刻日時を取得※出発打刻キャンセルから前画面への遷移対応
    		if(delStampTime == null) {
    			
        		// 区分：出発をセット
        		// 5分以内の打刻データを取得する
                workInfo.add(stampFlag);
                workInfo.add("MINUTE");
                workInfo.add("-5");
                workInfo.add("'" + loginInfo.stampDate.substring(0,19) + "'");
                workInfo.add(loginInfo.id);
                workInfo.add(0);
                workInfo.add(0);

        		
        		// ５分以内に出発報告を行っていたか確認
        		delStampTime = stamp.select(workInfo);
    		}
    		//パラメータを初期化
            workInfo =  new ArrayList();
            workInfo.add(stampFlag);
            workInfo.add(loginInfo.id);
            //打刻履歴を取得
            historyList = stamp.selectHistory(workInfo);
            
    	}catch(Exception e) {
        	e.printStackTrace();
	    }

        PrintWriter out = response.getWriter();

        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("delStampTime", delStampTime);	// 削除対象の打刻データ
        request.setAttribute("stampFlag", stampFlag);		// 打刻種別
        request.setAttribute("historyList", historyList);		// 打刻履歴
		RequestDispatcher dispatch = request.getRequestDispatcher("repo/repo-1.jsp");
        dispatch.forward(request, response);
	}
}
