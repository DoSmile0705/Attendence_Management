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
import dbaccess.P_Shift_Request;
import dbaccess.P_Shift_SheetDataUp;
import util.Authorization;
import util.DataCheck;
import util.LoginInfo;
import util.RequestData;
import util.ShiftInfo;
import util.ShiftRequest;
import util.UtilConv;

/**
 * Servlet implementation class ShiftInquiry
 */
public class ShiftInquiry extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShiftInquiry() {
        super();
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
        String nowDate				= check.emptyOrNull(request.getParameter("nowDate"));
        String nowDate3				= check.emptyOrNull(request.getParameter("nowDate3"));
        String month				= check.emptyOrNull(request.getParameter("dt-num"));
        // データ変換クラス
        UtilConv utilConv = new UtilConv();
        // 押下したボタンを取得※
        String button1				= check.emptyOrNull(request.getParameter("button1"));
        String subFlag				= check.emptyOrNull(request.getParameter("subFlag"));
	    //表示日付
	    String reqDay				= check.emptyOrNull(request.getParameter("reqDay"));
	    String reqDate				= check.emptyOrNull(request.getParameter("reqDate"));
	    String reqWeek				= check.emptyOrNull(request.getParameter("reqWeek"));
        // パラメータ用
        List workInfo =  new ArrayList();
        int addMonth				= 0;
	    List<ShiftRequest> shiftReq = new ArrayList<>();

        //シフト申請からの遷移用
        if(nowDate == null && nowDate3 != null) {
        	nowDate = nowDate3;
        }
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
        	//nowDate = utilConv.GetForShiftList(month);
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

			/***シフト申請データを取得***/
	        // 申請データアクセス用
	        P_Shift_Request psq	= new P_Shift_Request();
	        workInfo =  new ArrayList();
			workInfo.add(loginInfo.id);
			workInfo.add(utilConv.GetForRequestMin(nowDate));
			workInfo.add(utilConv.GetForRequestMax(nowDate));
			shiftReq = psq.selectMonthly(workInfo);
			
    	}catch(Exception e) {
        	e.printStackTrace();
	    }
        request.setAttribute("listInfo", listInfo);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("requestList", requestList);
        // 対象月※形式が2パターンあるので注意「yyyy-MM-dd」「yyyy-MM-dd HH:mm:ss.sssss」
        request.setAttribute("nowDate", nowDate);
        request.setAttribute("shiftReq", shiftReq);
        request.setAttribute("reqDate", reqDate);
        request.setAttribute("reqDay", reqDay);
        request.setAttribute("reqWeek", reqWeek);
        //シフト申請フラグが立っていた場合はシフト申請へ、nullの場合はシフト一覧へ
        if(subFlag == null) {
    		RequestDispatcher dispatch = request.getRequestDispatcher("work/work-1.jsp");
            dispatch.forward(request, response);
        }else {
    		RequestDispatcher dispatch = request.getRequestDispatcher("work/work-10.jsp");
            dispatch.forward(request, response);
        }
	}

}
