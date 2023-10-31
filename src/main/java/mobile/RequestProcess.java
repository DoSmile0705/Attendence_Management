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
import util.DataCheck;
import util.LoginInfo;
import util.RequestData;
import util.ShiftInfo;

/**
 * Servlet implementation class RequestProcess
 */
public class RequestProcess extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RequestProcess() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	/**
     * 画面からのリクエストを受け取る
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        // シフト情報パラメータ受け取り
        ShiftInfo shiftInfo = new ShiftInfo();
        shiftInfo.shiftHiduke		= check.emptyOrNull(request.getParameter("shiftHiduke"));
        shiftInfo.note				= check.emptyOrNull(request.getParameter("shiftNote"));
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
        shiftInfo.id				= check.emptyOrNull(request.getParameter("shiftDataId"));
        shiftInfo.timeFlag			= check.emptyOrNull(request.getParameter("timeFlag"));
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
        loginInfo.sessionId			= check.emptyOrNull(request.getParameter("sessionId"));
        loginInfo.companyCode		= check.emptyOrNull(request.getParameter("companyCode"));
        loginInfo.companyName		= check.emptyOrNull(request.getParameter("companyName"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company_ID"));
        // 申請データの受け取り
        RequestData requestData = new RequestData();
        requestData.kinmuHiduke		= check.emptyOrNull(request.getParameter("kinmuHiduke"));
        requestData.category		= check.emptyOrNull(request.getParameter("category"));
        requestData.timeValue		= check.emptyOrNull(request.getParameter("timeValue"));
        requestData.setTimeValue	= check.emptyOrNull(request.getParameter("setTimeValue"));
        requestData.value			= check.emptyOrNull(request.getParameter("value"));
        requestData.setValue		= check.emptyOrNull(request.getParameter("setValue"));
        requestData.note			= check.emptyOrNull(request.getParameter("note"));
        requestData.causeFlag		= check.emptyOrNull(request.getParameter("causeFlag"));
        requestData.certification	= check.emptyOrNull(request.getParameter("certification"));
        // 申請種類フラグ（1:早出、2:残業、11:交通費）
        String categoryFlag			= check.emptyOrNull(request.getParameter("categoryFlag"));
        String requestDate			= check.emptyOrNull(request.getParameter("requestDate"));
        String overtime_1			= check.emptyOrNull(request.getParameter("overtime-1"));
        String overtime_2			= check.emptyOrNull(request.getParameter("overtime-2"));
        String requestFlag			= check.emptyOrNull(request.getParameter("requestFlag"));
        String reason				= check.emptyOrNull(request.getParameter("reason"));
        String textarea				= check.emptyOrNull(request.getParameter("textarea"));
        String name					= check.emptyOrNull(request.getParameter("name"));
        // DB登録用に加工する
        textarea = check.stringForDB(textarea);
        // 申請データアクセス用
        P_Kinmu_RequestData pkrd	= new P_Kinmu_RequestData();
        // 申請データパラメータ用
        List workInfo =  new ArrayList();
        //勤務リクエストデータの認証が存在
        if(requestData.certification != null) {
        	//認証が「9」の場合
            if(requestData.certification.equals("9")) {
        		workInfo.add(loginInfo.company_ID);
        		workInfo.add(loginInfo.id);
        		workInfo.add(requestDate);		//KinmuHiduke
        		workInfo.add(categoryFlag);		//Category
        		workInfo.add(overtime_1);		//TimeValue
        		// 交通費・経費申請の場合は金額
        		if(categoryFlag.equals("11")) {
            		workInfo.add(name);			//Value
           		// 残業、早出申請の場合は時間
        		}else {
            		workInfo.add(overtime_2);	//Value
        		}
        		workInfo.add(textarea);			//Note
        		workInfo.add("0");				//Certification
        		
        		try {
            		pkrd.update(workInfo);
        		}catch(Exception e) {
                	e.printStackTrace();
        		}
        	//現状、勤務リクエストデータの認証が存在して「9」以外はありえない
            }
        //勤務リクエストデータの認証がない
        }else{
    		workInfo.add(loginInfo.company_ID);
    		workInfo.add(loginInfo.id);
    		workInfo.add(requestDate);		//KinmuHiduke
    		workInfo.add(categoryFlag);		//Category
    		workInfo.add(overtime_1);		//TimeValue
    		// 交通費・経費申請の場合は金額
    		if(categoryFlag.equals("11")) {
        		workInfo.add(name);			//Value
       		// 残業、早出申請の場合は時間
    		}else {
        		workInfo.add(overtime_2);	//Value
    		}
    		workInfo.add(textarea);			//Note
    		
    		try {
    			pkrd.insert(workInfo);
    		}catch(Exception e) {
            	e.printStackTrace();
    		}
        }

        request.setAttribute("shiftInfo", shiftInfo);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("requestData", requestData);
        request.setAttribute("categoryFlag", categoryFlag);
        request.setAttribute("requestFlag", requestFlag);
        
		RequestDispatcher dispatch = request.getRequestDispatcher("work/work-8.jsp");
        dispatch.forward(request, response);
	}
}
