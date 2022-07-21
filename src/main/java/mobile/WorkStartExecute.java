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
import util.ShiftInfo;

/**
 * Servlet implementation class WorkStartExecute
 */
public class WorkStartExecute extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WorkStartExecute() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        // 打刻時刻受け取り
        String stringDate			= check.emptyOrNull(request.getParameter("stringDate"));
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
        // 打刻種別
        String stampFlag			= check.emptyOrNull(request.getParameter("stampFlag"));

        PrintWriter out = response.getWriter();
        List workInfo =  new ArrayList();
        String stampTime = null;
        
    	try {
    		// 上下番区分をセット
    		// 5分以内の打刻データを取得する
            workInfo.add(stampFlag);
            workInfo.add("MINUTE");
            workInfo.add("-5");
            workInfo.add("'" + stringDate.substring(0,19) + "'");
            workInfo.add(shiftInfo.workerId);
            workInfo.add(shiftInfo.keiyakuId);

    		// DBアクセスクラス
    		P_Time_StampData stamp = new P_Time_StampData();
    		
    		// ５分以内に上番報告を行っていた場合は前レコードを取り消し
    		stampTime = stamp.select(workInfo);

    		if(stampTime != null) {
                // ログインIDをキーに警備員マスタを取得
        		stamp.update(workInfo);
            	/*** 2022.7.11 打刻があった場合に打刻しない処理をコメントアウト
           		// 新しい打刻レコードを登録
        		stamp.insert(workInfo);
            } else {
            	// 打刻レコードがなかった場合は登録する
            	if(shiftInfo.bgnStampTime == null) {
               		// 新しい打刻レコードを登録
            		stamp.insert(workInfo);
            		// 当日シフト一覧のコンテナに下番打刻時間をセット
            		shiftInfo.bgnStampTime = stringDate;
            	} else {
            		// すでに打刻済の場合は上番打刻時刻にnullをセット
            		shiftInfo.bgnStampTime = null;
            	}
           		// 新しい打刻レコードを登録
        		stamp.insert(workInfo);
        		// 当日シフト一覧のコンテナに下番打刻時間をセット
        		shiftInfo.bgnStampTime = stringDate;
            	2022.7.11 打刻があった場合に打刻しない処理をコメントアウト ***/
            }
       		// 新しい打刻レコードを登録
    		stamp.insert(workInfo);
    		if(stampFlag.equals("1")) {
        		// 当日シフト一覧のコンテナに上番打刻時間をセット
        		shiftInfo.bgnStampTime = stringDate;
    		} else {
        		// 当日シフト一覧のコンテナに上番打刻時間をセット
        		shiftInfo.endStampTime = stringDate;
    		}

	    }catch(Exception e) {
        	e.printStackTrace();
	    }

    	request.setAttribute("shiftInfo", shiftInfo);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("stampFlag", stampFlag);
		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/startStampRes.jsp");
        dispatch.forward(request, response);
	}
}
