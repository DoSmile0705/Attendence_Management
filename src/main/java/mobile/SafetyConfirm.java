package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dbaccess.P_SF_Safety;
import util.DataCheck;
import util.LoginInfo;
import util.SafetyInfo;

/**
 * 安否確認
 */
public class SafetyConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SafetyConfirm() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
     * 画面からのリクエストを受け取る
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        LoginInfo loginInfo = new LoginInfo();
        loginInfo.workerIndex		= check.emptyOrNull(request.getParameter("loginid"));
        loginInfo.id				= check.emptyOrNull(request.getParameter("id"));
        loginInfo.loginInfo1_Value	= check.emptyOrNull(request.getParameter("password1"));
        loginInfo.loginInfo2_Value	= check.emptyOrNull(request.getParameter("password2"));
        loginInfo.email_Value		= check.emptyOrNull(request.getParameter("mailaddress"));
        loginInfo.firstName_Value	= check.emptyOrNull(request.getParameter("firstName_Value"));
        loginInfo.lastName_Value	= check.emptyOrNull(request.getParameter("lastName_Value"));
        loginInfo.geoIdo_Value		= check.emptyOrNull(request.getParameter("geoIdo"));
        loginInfo.geoKeido_Value	= check.emptyOrNull(request.getParameter("geoKeido"));
        loginInfo.sessionId			= check.emptyOrNull(request.getParameter("sessionId"));
        loginInfo.companyCode		= check.emptyOrNull(request.getParameter("companyCode"));
        loginInfo.companyName		= check.emptyOrNull(request.getParameter("companyName"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company_ID"));
        //安否確認通知データ格納用
        List<SafetyInfo> safetyList = new ArrayList<>();
        //安否確認通知テーブル
        P_SF_Safety SF = new P_SF_Safety();
        //安否確認通知データ格納用
        SafetyInfo safety = new SafetyInfo();
        //安否確認通知データ取得パラメータ用
        List workInfo =  new ArrayList();
        try {
        	//パラメータをセット
            workInfo.add(loginInfo.company_ID);
            //状況選択のリストを取得
            safetyList = SF.selectList(workInfo);
            //安否確認通知データ取得パラメータ用
            workInfo =  new ArrayList();
            //パラメータをセット
            workInfo.add(loginInfo.id);
            //登録した安否確認通知を取得
            safety = SF.select(workInfo);

        }catch(Exception e) {
        	e.printStackTrace();
        }

        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("safetyList", safetyList);
        request.setAttribute("safety", safety);
		RequestDispatcher dispatch = request.getRequestDispatcher("work/work-12.jsp");
		dispatch.forward(request, response);
	}
}
