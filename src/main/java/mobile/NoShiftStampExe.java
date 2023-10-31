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
import util.UtilConv;

/**
 * Servlet implementation class NoShiftStampExe
 */
public class NoShiftStampExe extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoShiftStampExe() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
     * 画面からのリクエストを受け取る
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
        loginInfo.workerIndex		= check.emptyOrNull(request.getParameter("loginid"));
        loginInfo.id				= check.emptyOrNull(request.getParameter("id"));
        loginInfo.loginInfo1_Value	= check.emptyOrNull(request.getParameter("password1"));
        loginInfo.loginInfo2_Value	= check.emptyOrNull(request.getParameter("password2"));
        loginInfo.email_Value		= check.emptyOrNull(request.getParameter("mailaddress"));
        loginInfo.firstName_Value	= check.emptyOrNull(request.getParameter("firstName_Value"));
        loginInfo.lastName_Value	= check.emptyOrNull(request.getParameter("lastName_Value"));
        loginInfo.geoIdo_Value		= check.emptyOrNull(request.getParameter("geoIdo"));
        loginInfo.geoKeido_Value	= check.emptyOrNull(request.getParameter("geoKeido"));
    	// 共通部品のインスタンス化
        UtilConv utilConv = new UtilConv();
        // GPS情報の暗号化
        utilConv.setLoginInfoGpsEncrypt(loginInfo);
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

        // GPS情報
        String gpsInfo = "";
        
    	try {
            workInfo.add(stampFlag);
            workInfo.add("MINUTE");
            workInfo.add("-5");
            //workInfo.add("'" + stringDate.substring(0,19) + "'");
            workInfo.add("'" + stringDate + "'");
            workInfo.add(loginInfo.id);
            workInfo.add(0);
            workInfo.add(0);
            workInfo.add(check.stringForDB(loginInfo.geoIdo_Value));
            workInfo.add(check.stringForDB(loginInfo.geoKeido_Value));

            // DBアクセスクラス
    		P_Time_StampData stamp = new P_Time_StampData();
    		
       		// 新しい打刻レコードを登録
    		stamp.insert(workInfo);
    		// 打刻後のレコードを取得
    		gpsInfo = stamp.selectCurrentStampData(workInfo);
    		
	    }catch(Exception e) {
        	e.printStackTrace();
	    }

    	gpsInfo = check.emptyOrNull(gpsInfo);

        // GPS取得成功用のフラグ
        String gpsSuccessFlg = "";
    	// GPS情報が取得できた場合
    	if(gpsInfo != null) {
    		gpsSuccessFlg = "success";
    	// GPS情報が取得できない場合
    	} else {
    		gpsSuccessFlg = "error";
    	}
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("stampFlag", stampFlag);
        request.setAttribute("gpsSuccessFlg", gpsSuccessFlg);		// GPS取得成功フラグ
        request.setAttribute("stringDate", stringDate);
		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-10.jsp");
        dispatch.forward(request, response);
	}

}
