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
import util.LoginInfo;
import util.ShiftInfo;

/**
 * Servlet implementation class WorkStartExecute
 */
public class WorkStartExecute extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WorkStartExecute() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String stringDate = request.getParameter("stringDate");
        // シフト情報パラメータ受け取り
        ShiftInfo shiftInfo = new ShiftInfo();
        shiftInfo.shiftHiduke = request.getParameter("shiftHiduke");
        shiftInfo.bgnTimeDate = request.getParameter("bgnTimeDate");
        shiftInfo.bgnTime = request.getParameter("bgnTime");
        shiftInfo.endTimeDate = request.getParameter("endTimeDate");
        shiftInfo.endTime = request.getParameter("endTime");
        shiftInfo.kinmuBashoName = request.getParameter("kinmuBashoName");
        shiftInfo.gyomuKubunName = request.getParameter("gyomuKubunName");
        shiftInfo.kinmuKubunName = request.getParameter("kinmuKubunName");
        shiftInfo.keiyakuKubunName = request.getParameter("keiyakuKubunName");
        shiftInfo.workerId = request.getParameter("workerId");
        shiftInfo.keiyakuId = request.getParameter("keiyakuId");
        shiftInfo.bgnStampTime = request.getParameter("bgnStampTime");
        shiftInfo.endStampTime = request.getParameter("endStampTime");
        // ログイン情報の受け取り
        LoginInfo loginInfo = new LoginInfo();
        loginInfo.id = (String)request.getParameter("loginid");
        loginInfo.loginInfo1_Value = (String)request.getParameter("password1");
        loginInfo.loginInfo2_Value = (String)request.getParameter("password2");
        loginInfo.email_Value = (String)request.getParameter("mailaddress");

        PrintWriter out = response.getWriter();
        List workInfo =  new ArrayList();
        String stampTime = null;
        String res = null;
        
    	try {
    		// 上下番区分：上番をセット
            workInfo.add(1);
            workInfo.add("MINUTE");
            workInfo.add("-5");
            workInfo.add("'" + stringDate.substring(0,19) + "'");
            workInfo.add(shiftInfo.workerId);
            workInfo.add(shiftInfo.keiyakuId);

    		// DBアクセスクラス
    		P_Time_StampData stamp = new P_Time_StampData();
    		
    		// ５分以内に上番報告を行っていた場合は前レコードを取り消し
    		stampTime = stamp.select(workInfo);
    		if(stampTime != null) {
                // ログインIDをキーに警備員マスタを取得
        		stamp.update(workInfo);
    		}

       		// ログインIDをキーに警備員マスタを取得
    		stamp.insert(workInfo);
    		// 当日シフト一覧のコンテナに上番打刻時間をセット
    		shiftInfo.bgnStampTime = stringDate;

	    }catch(Exception e) {
        	e.printStackTrace();
        	res += e.getMessage();
	    }

    	request.setAttribute("shiftInfo", shiftInfo);
        request.setAttribute("loginInfo", loginInfo);
		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/startStampRes.jsp");
        dispatch.forward(request, response);
	}
}
