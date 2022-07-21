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

/**
 * Servlet implementation class WorkEndExecute
 */
public class WorkEndExecute extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WorkEndExecute() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
        // 時刻の受け取り
        String stringDate = request.getParameter("stringDate");
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

        PrintWriter out = response.getWriter();
        List workInfo =  new ArrayList();
        String stampTime = null;
        String res = null;
        // 次のシフト用にコンテナを用意する
        ShiftInfo nextShiftInfo = new ShiftInfo();
    	try {
    		// 上下番区分：下番をセット
    		// 5分以内の打刻データを取得する
            workInfo.add(2);
            workInfo.add("MINUTE");
            workInfo.add("-5");
            workInfo.add("'" + stringDate.substring(0,19) + "'");
            workInfo.add(shiftInfo.workerId);
            workInfo.add(shiftInfo.keiyakuId);

    		// DBアクセスクラス
    		P_Time_StampData stamp = new P_Time_StampData();
    		
    		// 5分以内に下番報告を行っていた場合は前レコードを取り消し
    		stampTime = stamp.select(workInfo);
    		if(stampTime != null) {
                // 5分以内のレコードの削除フラグを立てる
        		stamp.update(workInfo);        		
           		// 新しい打刻レコードを登録
        		stamp.insert(workInfo);
        		// 当日シフト一覧のコンテナに下番打刻時間をセット
        		shiftInfo.endStampTime = stringDate;
    		} else {
            	// 打刻レコードがなかった場合は登録する
            	if(shiftInfo.endStampTime == null) {
               		// 新しい打刻レコードを登録
            		stamp.insert(workInfo);
            		// 当日シフト一覧のコンテナに下番打刻時間をセット
            		shiftInfo.endStampTime = stringDate;
    			} else {
            		// すでに打刻済の場合は下番打刻日時にnullをセット
            		shiftInfo.endStampTime = null;
    			}
    		}

    		// DBアクセスクラス
	    	P_Shift_SheetDataUp shift = new P_Shift_SheetDataUp();
            // ログインIDをキーに警備員マスタを取得
	    	nextShiftInfo = shift.select(loginInfo.id, shiftInfo.bgnTimeDate);
    		
	    }catch(Exception e) {
        	e.printStackTrace();
        	res += e.getMessage();
	    }

    	request.setAttribute("shiftInfo", shiftInfo);
    	request.setAttribute("nextShiftInfo", nextShiftInfo);
        request.setAttribute("loginInfo", loginInfo);
		RequestDispatcher dispatch = request.getRequestDispatcher("jsp/endStampRes.jsp");
        dispatch.forward(request, response);
	}

}
