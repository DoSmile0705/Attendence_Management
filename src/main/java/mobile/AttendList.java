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
import javax.servlet.http.HttpSession;

import dbaccess.P_Shift_SheetDataUp;
import util.LoginInfo;
import util.ShiftInfo;

/**
 * Servlet implementation class AttendList
 */
public class AttendList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AttendList() {
        super();
        // TODO Auto-generated constructor stub
    }

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
    	String loginid = "1";
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        List<ShiftInfo> listInfo =  new ArrayList<>();
        // 画面項目の受け取り
        LoginInfo loginInfo = new LoginInfo();
        loginInfo.id = (String)request.getParameter("loginid");
        loginInfo.loginInfo1_Value = (String)request.getParameter("password1");
        loginInfo.loginInfo2_Value = (String)request.getParameter("password2");
        loginInfo.email_Value = (String)request.getParameter("mailaddress");

    	try {

    		// DBアクセスクラス
	    	P_Shift_SheetDataUp shift = new P_Shift_SheetDataUp();
            // ログインIDをキーに警備員マスタを取得
	    	listInfo = shift.select(loginInfo.id);

	    }catch(Exception e) {
        	e.printStackTrace();
	    }
        // 照合できた場合はセッションを取得してメニュー画面を表示する
		HttpSession session=request.getSession(true);
        request.setAttribute("listInfo", listInfo);
        request.setAttribute("loginInfo", loginInfo);
		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/shitflist.jsp");
        dispatch.forward(request, response);
	}

}
