package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dbaccess.P_Kinmu_RequestData;
import dbaccess.P_Shift_SheetDataUp;
import util.DataCheck;
import util.LoginInfo;
import util.RequestData;
import util.ShiftInfo;
import util.UtilConv;

/**
 * Servlet implementation class ShiftPerformance
 */
public class ShiftPerformance extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShiftPerformance() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
	    // 検索結果格納用
        List<ShiftInfo> listInfo =  new ArrayList<>();
	    List<RequestData> requestList = new ArrayList<>();
        DataCheck check = new DataCheck();
        // 画面項目の受け取り
        LoginInfo loginInfo = new LoginInfo();
        //loginInfo.id				= check.emptyOrNull(request.getParameter("loginid"));
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
        // 一覧表示する対象月
        String nowDate				= check.emptyOrNull(request.getParameter("nowDate2"));
        String month				= check.emptyOrNull(request.getParameter("dt-num"));
        // データ変換クラス
        UtilConv utilConv = new UtilConv();
        // 押下したボタンを取得※
        String button1				= check.emptyOrNull(request.getParameter("button1"));
        // パラメータ用
        List workInfo =  new ArrayList();
        int addMonth				= 0;
        if(button1 != null) {
            if(button1.equals("forward") || button1.equals("next")) {
            	addMonth = 1;
            }else if(button1.equals("back") || button1.equals("prev")) {
            	addMonth = -1;
            }
        }
        // 対象月がNULLでなかった（シフト一覧画面から遷移した）場合、
        // シフト一覧を取得する為に対象月のフォーマットを変換
        if(month != null) {
        	nowDate = utilConv.GetForShiftList(month, addMonth);
        }
    	try {
    		/***1か月分のシフトを取得***/
    		// DBアクセスクラス
	    	P_Shift_SheetDataUp shift = new P_Shift_SheetDataUp();
            // ログインIDをキーに警備員マスタを取得
	    	listInfo = shift.getShiftList(loginInfo.id, nowDate);

    		/***1か月分の申請を取得***/
	        // 申請データアクセス用
	        P_Kinmu_RequestData pkrd	= new P_Kinmu_RequestData();
			workInfo.add(loginInfo.company_ID);
			workInfo.add(loginInfo.id);
			workInfo.add(utilConv.GetForRequestMin(nowDate));
			workInfo.add(utilConv.GetForRequestMax(nowDate));
            // 申請データを取得
			requestList = pkrd.selectMonthly(workInfo);

    	}catch(Exception e) {
        	e.printStackTrace();
	    }
        request.setAttribute("listInfo", listInfo);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("requestList", requestList);
        // 対象月※形式が2パターンあるので注意「yyyy-MM-dd」「yyyy-MM-dd HH:mm:ss.sssss」
        request.setAttribute("nowDate", nowDate);
		RequestDispatcher dispatch = request.getRequestDispatcher("work/work-1.jsp");
        dispatch.forward(request, response);
	}

}
