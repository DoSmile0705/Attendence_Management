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

import dbaccess.P_Shift_SheetDataUp;
import dbaccess.P_Time_StampData;
import util.DataCheck;
import util.LoginInfo;
import util.ShiftInfo;
import util.UtilConv;

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

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

    /**
     * 画面からのリクエストを受け取る
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String loginid = "1";
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        List<ShiftInfo> listInfo =  new ArrayList<>();
        DataCheck check = new DataCheck();
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
        // 画面項目の受け取り
        LoginInfo loginInfo = new LoginInfo();
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
        loginInfo.companyCode		= check.emptyOrNull(request.getParameter("companyCode"));
        loginInfo.companyName		= check.emptyOrNull(request.getParameter("companyName"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company_ID"));
        //出退勤報告を行うフラグ
        String workFlag				= check.emptyOrNull(request.getParameter("workFlag"));
        // 打刻データ取得パラメータ用
        List workInfo =  new ArrayList();
        String stampTime = null;
        String attendStamp = null;	// シフト外上番打刻
        String leaveStamp = null;	// シフト外下番打刻
        String attendStampFive	= null;	// シフト外上番の5分後の打刻
        String leaveStampFive	= null;	// シフト外下番の5分後の打刻
    	try {

    		// シフト一覧取得
	    	P_Shift_SheetDataUp shift = new P_Shift_SheetDataUp();
    		// 打刻取得
    		P_Time_StampData stamp = new P_Time_StampData();
            // IDをキーに警備員マスタを取得
	    	listInfo = shift.select(loginInfo.id);

	    	String shiftBgnDate = "GETDATE()";	//シフト開始日時
	    	String shiftEndDate = "GETDATE()";	//シフト終了日時
	    	String keiyakuId    = "0";			//契約ID
	    	/*** シフト一覧に打刻を取得する処理 ***/
	    	for(int i = 0; i < listInfo.size(); i ++) {
	    		shiftBgnDate = "'" + utilConv.GetWhereDate(listInfo.get(i).bgnTimeDate) + "'";
	    		shiftEndDate = "'" + utilConv.GetWhereDate(listInfo.get(i).endTimeDate) + "'";
	    		keiyakuId    = listInfo.get(i).keiyakuId;
	    		// 上番時刻を取得※シフト開始日時の2時間前～シフト終了日時
	    		// 上下番区分：上番をセット
	    		workInfo = new ArrayList();
	            workInfo.add(1);
	            workInfo.add("HOUR");
                workInfo.add("-2");
                workInfo.add(shiftBgnDate);
                workInfo.add("HOUR");
                workInfo.add("0");
                workInfo.add(shiftEndDate);
	            workInfo.add(listInfo.get(i).workerId);
	            workInfo.add(listInfo.get(i).keiyakuId);
	            workInfo.add(listInfo.get(i).id);

	    		stampTime = stamp.selectStamp(workInfo);

	    		if(stampTime != null) {
	    			listInfo.get(i).bgnStampTime = stampTime;
	    		}

	    		// 下番時刻を取得※シフト開始日時～シフト終了日時の2時間後
	    		workInfo = new ArrayList();
	    		stamp = new P_Time_StampData();
	    		// 上下番区分：下番をセット
	            workInfo.add(2);
	            workInfo.add("HOUR");
                workInfo.add("0");
                workInfo.add(shiftBgnDate);
                workInfo.add("HOUR");
                workInfo.add("2");
                workInfo.add(shiftEndDate);
	            workInfo.add(listInfo.get(i).workerId);
	            workInfo.add(listInfo.get(i).keiyakuId);
	            workInfo.add(listInfo.get(i).id);

	            stampTime = stamp.selectStamp(workInfo);
	    		if(stampTime != null) {
	    			listInfo.get(i).endStampTime = stampTime;
	    		}
	    	}
	    		
    		//************************************************
	    	/***シフトに関係ない打刻を取得する***/
    		//************************************************
    		//16時間以内に上番打刻があったら上番時刻を取得する
    		workInfo = new ArrayList();
    		stamp = new P_Time_StampData();
    		// 上下番区分：上番をセット
            workInfo.add(1);
            workInfo.add("HOUR");
            workInfo.add("-16");
            workInfo.add("DATEADD(HOUR,9,GETDATE())");
            workInfo.add("MINUTE");
            workInfo.add("0");
            workInfo.add("DATEADD(HOUR,9,GETDATE())");
            workInfo.add(loginInfo.id);
            workInfo.add(0);
            workInfo.add(0);

            //打刻があるかどうか取得する処理
            attendStamp = stamp.selectFreeStamp(workInfo);
            if(attendStamp != null){
           		workInfo = new ArrayList();
                workInfo.add(1);
                workInfo.add(loginInfo.id);
                workInfo.add(0);
                workInfo.add(0);
        		//5分以降の打刻を取得
                attendStampFive = stamp.selectFiveMinuteAfter(workInfo);
            }

    		//16時間以内に下番打刻があったら下番時刻を取得する
    		workInfo = new ArrayList();
    		stamp = new P_Time_StampData();
    		// 上下番区分：下番をセット
            workInfo.add(2);
            workInfo.add("HOUR");
            workInfo.add("-16");
            workInfo.add("DATEADD(HOUR,9,GETDATE())");
            workInfo.add("MINUTE");
            workInfo.add("0");
            workInfo.add("DATEADD(HOUR,9,GETDATE())");
            workInfo.add(loginInfo.id);
            workInfo.add(0);
            workInfo.add(0);

            leaveStamp = stamp.selectFreeStamp(workInfo);
            //下番よりも上番の方が新しい場合⇒下番日時をクリア
            if(utilConv.dateComp(attendStamp, leaveStamp)) {
           		workInfo = new ArrayList();
                workInfo.add("2");
                workInfo.add("HOUR");
                workInfo.add("0");
                workInfo.add("'" + leaveStamp.subSequence(0, 19) + "'");
                workInfo.add(loginInfo.id);
                workInfo.add(0);
                workInfo.add(0);
                //取得した下番打刻を無効にする
        		stamp.update(workInfo);        		
        		//下番打刻をリセット
            	leaveStamp = null;
            }
            if(leaveStamp != null){
           		workInfo = new ArrayList();
                workInfo.add(2);
                workInfo.add(loginInfo.id);
                workInfo.add(0);
                workInfo.add(0);
        		//5分以降の打刻を取得
                leaveStampFive = stamp.selectFiveMinuteAfter(workInfo);
            }

	    }catch(Exception e) {
        	e.printStackTrace();
	    }
        request.setAttribute("listInfo", listInfo);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("attendStamp", attendStamp);
        request.setAttribute("leaveStamp", leaveStamp);
        request.setAttribute("attendStampFive", attendStampFive);
        request.setAttribute("leaveStampFive", leaveStampFive);
        //出退勤報告のみを行う場合は専用ページへ
        if(workFlag == null) {
    		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-1.jsp");
            dispatch.forward(request, response);
        }else{
    		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-13.jsp");
            dispatch.forward(request, response);
        }
	}

}
