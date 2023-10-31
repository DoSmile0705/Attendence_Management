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
import dbaccess.P_MK_RequestKubun;
import dbaccess.P_Shift_Request;
import dbaccess.P_Shift_SheetDataUp;
import util.DataCheck;
import util.LoginInfo;
import util.RequestData;
import util.RequestKubun;
import util.ShiftInfo;
import util.ShiftRequest;
import util.UtilConv;

/**
 * Servlet implementation class ShiftApplyExecute
 */
public class ShiftApplyExecute extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShiftApplyExecute() {
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
	    ShiftRequest shiftReq = new ShiftRequest();
	    shiftReq.id					= check.emptyOrNull(request.getParameter("req_ID"));
	    shiftReq.worker_ID			= check.emptyOrNull(request.getParameter("worker_ID"));
	    shiftReq.hiduke				= check.emptyOrNull(request.getParameter("hiduke"));
	    //クリックしたボタンによってフラグが変わる
	    shiftReq.requestFlag		= check.emptyOrNull(request.getParameter("requestFlag"));
	    shiftReq.requestName		= check.emptyOrNull(request.getParameter("requestName"));
	    shiftReq.note				= check.emptyOrNull(request.getParameter("note"));
	    shiftReq.timeFlag			= check.emptyOrNull(request.getParameter("timeFlag"));
	    shiftReq.backColorFlag		= check.emptyOrNull(request.getParameter("backColorFlag"));
	    shiftReq.fontColorFlag		= check.emptyOrNull(request.getParameter("fontColorFlag"));
	    //表示日付
	    String reqDay				= check.emptyOrNull(request.getParameter("reqDay"));
	    String reqDate				= check.emptyOrNull(request.getParameter("reqDate"));
	    String reqWeek				= check.emptyOrNull(request.getParameter("reqWeek"));
	    String nowDate				= check.emptyOrNull(request.getParameter("nowDate"));
	    //登録/削除フラグ
	    String reqFlag				= check.emptyOrNull(request.getParameter("reqFlag"));
	    String textarea				= check.emptyOrNull(request.getParameter("textarea"));
	    //備考をDBに合わせて加工
	    textarea = check.stringForDB(textarea);
	    //DB登録用の日付を作成
	    String hiduke = reqDate + reqDay;
	    //数字以外を削除
	    hiduke = hiduke.replaceAll("[^0-9]", "");
        
	    // SQLパラメータ用
        List workInfo =  new ArrayList();
        //シフト申請テーブル
        P_Shift_Request PSR = new P_Shift_Request();
	    List<RequestKubun> reqKubunList = new ArrayList<>();
        List<ShiftInfo> listInfo =  new ArrayList<>();
	    List<RequestData> requestList = new ArrayList<>();
	    List<ShiftRequest> shiftReqList = new ArrayList<>();
        // データ変換クラス
        UtilConv utilConv = new UtilConv();
        try {
            //登録
            if(reqFlag == null) {
            	//新規登録の場合はINSERT
            	if(shiftReq.id == null) {
            		//SQLパラメータをセット
                    workInfo.add(loginInfo.id);
                    workInfo.add(hiduke);
                    workInfo.add(shiftReq.requestFlag);
                    workInfo.add(textarea);
                    //新規インストールする前に「99」のレコードを削除
                    PSR.deleteNewInsert(workInfo);
                    //シフト申請を新規登録
                    PSR.insert(workInfo);
               	//変更の場合はDELETE⇒INSERT
            	}else{
            		//SQLパラメータをセット
                    workInfo.add(shiftReq.id);
                    //変更対象のレコードを削除
                    PSR.delete(workInfo);
                    //パラメータをリセット
                    workInfo =  new ArrayList();
                    workInfo.add(loginInfo.id);
                    workInfo.add(hiduke);
                    workInfo.add(shiftReq.requestFlag);
                    workInfo.add(textarea);
                    //シフト申請を変更
                    PSR.insert(workInfo);
            	}
            //削除の場合はDELETE⇒INSERT（TimeFlag：99）
            }else {
                workInfo.add(shiftReq.id);
                PSR.delete(workInfo);
                workInfo =  new ArrayList();
                workInfo.add(loginInfo.id);
                workInfo.add(hiduke);
                workInfo.add(99);
                workInfo.add(textarea);
                PSR.insert(workInfo);
            }
    		/***リクエスト区分を取得***/
            // パラメータ用
            workInfo =  new ArrayList();
            //リクエストデータアクセス用
    		P_MK_RequestKubun pmkq	= new P_MK_RequestKubun();
            workInfo =  new ArrayList();
            workInfo.add(loginInfo.company_ID);
            reqKubunList = pmkq.select(workInfo);

            // 申請データアクセス用
	        P_Kinmu_RequestData pkrd	= new P_Kinmu_RequestData();
			workInfo.add(loginInfo.company_ID);
			workInfo.add(loginInfo.id);
			workInfo.add(utilConv.GetForRequestMin(nowDate));
			workInfo.add(utilConv.GetForRequestMax(nowDate));
            // 申請データを取得
			requestList = pkrd.selectMonthly(workInfo);

			workInfo =  new ArrayList();
			workInfo.add(loginInfo.id);
			workInfo.add(utilConv.GetForRequestMin(nowDate));
			workInfo.add(utilConv.GetForRequestMax(nowDate));
            // シフト申請を取得
			shiftReqList = PSR.selectMonthly(workInfo);

			//****************
    		//シフト一覧を取得
			//****************
	    	P_Shift_SheetDataUp shift = new P_Shift_SheetDataUp();
            // ログインIDをキーに警備員マスタを取得
	    	listInfo = shift.getShiftList(loginInfo.id, nowDate);

        }catch(Exception e) {
        	e.printStackTrace();
        }
        request.setAttribute("requestList", requestList);
	    request.setAttribute("shiftReq", shiftReqList);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("reqDate", reqDate);
        request.setAttribute("reqDay", reqDay);
        request.setAttribute("reqWeek", reqWeek);
        request.setAttribute("nowDate", nowDate);
        request.setAttribute("listInfo", listInfo);
        //画面項目をそのまま返す
   		RequestDispatcher dispatch = request.getRequestDispatcher("work/work-10.jsp");
   		dispatch.forward(request, response);
	}
}
