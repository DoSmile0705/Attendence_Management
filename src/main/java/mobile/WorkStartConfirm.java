package mobile;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.LoginInfo;
import util.ShiftInfo;

/**
 * Servlet implementation class WorkStartConfirm
 */
public class WorkStartConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WorkStartConfirm() {
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
        // 画面からの項目を受け取り
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

        /*** 現在日時を取得し9時間足す処理 ***/
		// 現在時刻を取得
		LocalDateTime nowDate = LocalDateTime.now();
		DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSS");
		String stringDate = dtf.format(nowDate.plusHours(9));

        // 照合できた場合はセッションを取得してメニュー画面を表示する
		HttpSession session=request.getSession(true);
        request.setAttribute("sessionID", session.getId());
        request.setAttribute("stringDate", stringDate);
        request.setAttribute("shiftInfo", shiftInfo);
        request.setAttribute("loginInfo", loginInfo);
		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/startConfirm.jsp");
        dispatch.forward(request, response);
	}

}
