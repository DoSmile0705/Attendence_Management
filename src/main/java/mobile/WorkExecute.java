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
 * Servlet implementation class WorkExecute
 */
public class WorkExecute extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WorkExecute() {
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
        // 打刻種別
        String stampFlag			= check.emptyOrNull(request.getParameter("stampFlag"));

        PrintWriter out = response.getWriter();
        // P_Time_StampDataのパラメータ用
        List workInfo =  new ArrayList();
        String stampTime = null;
        
    	try {
            workInfo.add(stampFlag);
            workInfo.add("MINUTE");
            workInfo.add("-5");
            workInfo.add("'" + stringDate.substring(0,19) + "'");
            workInfo.add(loginInfo.id);
            workInfo.add(0);

            // DBアクセスクラス
    		P_Time_StampData stamp = new P_Time_StampData();
    		
    		// 5分以内に下番報告を行っていた場合は前レコードを取り消し
    		stampTime = stamp.select(workInfo);
    		if(stampTime != null) {
                // 5分以内のレコードの削除フラグを立てる
        		stamp.update(workInfo);        		
    		}
       		// 新しい打刻レコードを登録
    		stamp.insert(workInfo);
    		
	    }catch(Exception e) {
        	e.printStackTrace();
	    }

        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("stampFlag", stampFlag);		// 打刻種別
        request.setAttribute("stringDate", stringDate);
        // ▼▼▼ 2022.08.21 HTML→JSP変換対応 ▼▼▼
		//RequestDispatcher dispatch = request.getRequestDispatcher("jsp/startStampRes.jsp");
		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-4.jsp");
        // ▲▲▲ 2022.08.21 HTML→JSP変換対応 ▲▲▲
        dispatch.forward(request, response);
	}

}
