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
 * Servlet implementation class WorkStartExecute
 */
public class WorkStartExecute extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public WorkStartExecute() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
     * 画面からのリクエストを受け取る
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
    	// 共通部品のインスタンス化
        UtilConv utilConv = new UtilConv();
        // GPS情報の暗号化
        utilConv.setLoginInfoGpsEncrypt(loginInfo);
        loginInfo.sessionId			= check.emptyOrNull(request.getParameter("sessionId"));
        loginInfo.companyCode		= check.emptyOrNull(request.getParameter("companyCode"));
        loginInfo.companyName		= check.emptyOrNull(request.getParameter("companyName"));
        loginInfo.company_ID		= check.emptyOrNull(request.getParameter("company_ID"));
        // 打刻種別
        String stampFlag			= check.emptyOrNull(request.getParameter("stampFlag"));

        PrintWriter out = response.getWriter();
        List workInfo =  new ArrayList();
        String stampTime = null;
        // シフト情報パラメータ受け取り
        ShiftInfo nextShiftInfo = new ShiftInfo();

        // GPS情報
        String gpsInfo = "";
        
    	try {
    		// 上下番区分をセット
    		// 5分以内の打刻データを取得する
            workInfo.add(stampFlag);
            workInfo.add("MINUTE");
            workInfo.add("-5");
            workInfo.add("'" + stringDate.substring(0,19) + "'");
            workInfo.add(shiftInfo.workerId);
            workInfo.add(shiftInfo.keiyakuId);
            workInfo.add(shiftInfo.id);

    		// DBアクセスクラス
    		P_Time_StampData stamp = new P_Time_StampData();
    		
    		// ５分以内に上番報告を行っていた場合は前レコードを取り消し
    		stampTime = stamp.select(workInfo);

    		if(stampTime != null) {
                // ログインIDをキーに警備員マスタを取得
        		stamp.update(workInfo);
            }
            workInfo.set(3,"'" + stringDate + "'");
            workInfo.add(check.stringForDB(loginInfo.geoIdo_Value));
            workInfo.add(check.stringForDB(loginInfo.geoKeido_Value));
       		// 新しい打刻レコードを登録
    		stamp.insert(workInfo);
    		// 打刻後のレコードを取得
    		gpsInfo = stamp.selectCurrentStampData(workInfo);
    		if(stampFlag.equals("1")) {
        		// 当日シフト一覧のコンテナに上番打刻時間をセット
        		shiftInfo.bgnStampTime = stringDate;
    		} else {
        		// 当日シフト一覧のコンテナに上番打刻時間をセット
        		shiftInfo.endStampTime = stringDate;
    		}
    		if(stampFlag.equals("2")) {
        		P_Shift_SheetDataUp pssdu = new P_Shift_SheetDataUp();
        		nextShiftInfo = pssdu.selectNextShift(shiftInfo.workerId, "'" + stringDate.substring(0,19) + "'");
    		}

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
    	request.setAttribute("shiftInfo", shiftInfo);
        request.setAttribute("loginInfo", loginInfo);
        request.setAttribute("stampFlag", stampFlag);
        request.setAttribute("gpsSuccessFlg", gpsSuccessFlg);		// GPS取得成功フラグ
        request.setAttribute("nextShiftInfo", nextShiftInfo);
		RequestDispatcher dispatch = request.getRequestDispatcher("stamp/stamp-4.jsp");
        dispatch.forward(request, response);
	}
}
