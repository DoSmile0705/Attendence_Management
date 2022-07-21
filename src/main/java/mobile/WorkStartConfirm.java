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

import util.DataCheck;
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
        DataCheck check = new DataCheck();
        // 画面からの項目を受け取り
        // シフト情報パラメータ受け取り
        ShiftInfo shiftInfo = new ShiftInfo();
        shiftInfo.shiftHiduke		= check.emptyOrNull(request.getParameter("shiftHiduke"));
        shiftInfo.bgnTimeDate		= check.emptyOrNull(request.getParameter("bgnTimeDate"));
        shiftInfo.bgnTime			= check.emptyOrNull(request.getParameter("bgnTime"));
        shiftInfo.endTimeDate		= check.emptyOrNull(request.getParameter("endTimeDate"));
        shiftInfo.endTime			= check.emptyOrNull(request.getParameter("endTime"));
        shiftInfo.kinmuBashoName	= check.emptyOrNull(request.getParameter("kinmuBashoName"));
        shiftInfo.gyomuKubunName	= check.emptyOrNull(request.getParameter("gyomuKubunName"));
        shiftInfo.kinmuKubunName	= check.emptyOrNull(request.getParameter("kinmuKubunName"));
        shiftInfo.keiyakuKubunName	= check.emptyOrNull(request.getParameter("keiyakuKubunName"));
        shiftInfo.workerId			= check.emptyOrNull(request.getParameter("workerId"));
        shiftInfo.keiyakuId			= check.emptyOrNull(request.getParameter("keiyakuId"));
        shiftInfo.bgnStampTime		= check.emptyOrNull(request.getParameter("bgnStampTime"));
        shiftInfo.endStampTime		= check.emptyOrNull(request.getParameter("endStampTime"));
        shiftInfo.adrPostNo			= check.emptyOrNull(request.getParameter("adrPostNo"));
        shiftInfo.adrMain			= check.emptyOrNull(request.getParameter("adrMain"));
        shiftInfo.adrSub			= check.emptyOrNull(request.getParameter("adrSub"));
        // ログイン情報の受け取り
        LoginInfo loginInfo = new LoginInfo();
        loginInfo.id				= check.emptyOrNull(request.getParameter("loginid"));
        loginInfo.loginInfo1_Value	= check.emptyOrNull(request.getParameter("password1"));
        loginInfo.loginInfo2_Value	= check.emptyOrNull(request.getParameter("password2"));
        loginInfo.email_Value		= check.emptyOrNull(request.getParameter("mailaddress"));
        loginInfo.firstName_Value	= check.emptyOrNull(request.getParameter("firstName_Value"));
        loginInfo.lastName_Value	= check.emptyOrNull(request.getParameter("lastName_Value"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company"));
        loginInfo.geoIdo_Value		= check.emptyOrNull(request.getParameter("geoIdo"));
        loginInfo.geoKeido_Value	= check.emptyOrNull(request.getParameter("geoKeido"));
        loginInfo.sessionId			= check.emptyOrNull(request.getParameter("sessionId"));
        // 遷移元のURLを取得
        String url					= request.getHeader("REFERER");
        // 打刻種別
        String stampFlag			= check.emptyOrNull(request.getParameter("stampFlag"));

        PrintWriter out = response.getWriter();

        /*** 現在日時を取得し9時間足す処理 ***/
		// 現在時刻を取得
		LocalDateTime nowDate = LocalDateTime.now();
		DateTimeFormatter dtf =DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSS");
		String stringDate = dtf.format(nowDate.plusHours(9));

		// 上下番した直後の打刻をキャンセル
		if(url.endsWith("WorkStartExecute")) {
            request.setAttribute("stringDate", stringDate);	// 現在日時※多分使ってない
            request.setAttribute("shiftInfo", shiftInfo);
            request.setAttribute("loginInfo", loginInfo);
            request.setAttribute("stampFlag", stampFlag);	// 打刻種別
    		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/cancelConfirm.jsp");
            dispatch.forward(request, response);
        } else {
            request.setAttribute("stringDate", stringDate);	// 現在日時※多分使ってない
            request.setAttribute("shiftInfo", shiftInfo);
            request.setAttribute("loginInfo", loginInfo);
            request.setAttribute("stampFlag", stampFlag);	// 打刻種別
    		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/startConfirm.jsp");
            dispatch.forward(request, response);
        }
		
	}

}
