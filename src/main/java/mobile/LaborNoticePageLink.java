package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dbaccess.P_MC_Company;
import dbaccess.P_MSG_MessageData;
import dbaccess.P_Temp_PageConnect;
import util.Authorization;
import util.Company;
import util.DataCheck;
import util.LoginInfo;
import util.MessageData;
import util.UtilConv;

/**
 * Servlet implementation class LaborNoticePageLink
 */
public class LaborNoticePageLink extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LaborNoticePageLink() {
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
		
		// セッションがなければログイン画面に遷移する。
		if(Authorization.isSessionValidChk(request) == false) {
			RequestDispatcher dispatch = request.getRequestDispatcher("login.jsp");
			dispatch.forward(request, response);
			return;
		}
		
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        // データチェック
        DataCheck check = new DataCheck();
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
        //メッセージデータテーブル
        P_MSG_MessageData msg = new P_MSG_MessageData();
        //お知らせ一覧検索結果格納用
        List<MessageData> msgData =  new ArrayList<>();
        //パラメータ用
        List workInfo =  new ArrayList();
        workInfo.add(loginInfo.id);
        workInfo.add(11);			//労働通知書をセット
        try{
            //メッセージデータを取得
            msgData = msg.selectCategory(workInfo);
        }catch(Exception e) {
        	e.printStackTrace();
        }
        //メッセージがなかったら元のページに戻る
        if(msgData.size() > 0) {
        	// 復号化するためのクラス
            UtilConv utilConv = new UtilConv();
            //会社情報テーブル格納用
            Company company = new Company();
            P_MC_Company com = new P_MC_Company();

            /*** ページリンク用のGUID作成 ***/
            UUID sendUuid = UUID.randomUUID();
            UUID dummy1Uuid = UUID.randomUUID();
            UUID dummy2Uuid = UUID.randomUUID();
            // 送信用GUID
            String sendGUID = sendUuid.toString();
            // ダミー
            String dummy1GUID = dummy1Uuid.toString();
            String dummy2GUID = dummy2Uuid.toString();
            // 一時テーブル格納パラメータ用
            workInfo =  new ArrayList();
            workInfo.add(loginInfo.company_ID);									// CompanyId
            workInfo.add(loginInfo.id);											// WorkerId
            workInfo.add(msgData.get(0).id);									// DataId
            workInfo.add("'" + sendGUID + "'");									// GuidKey1
            workInfo.add("''");													// GuidKey2
            workInfo.add(0);													// ConnectPage※ページはないので「0」を設定
            workInfo.add("'" + utilConv.encrypt(loginInfo.workerIndex) + "'");	// ConnectKey1
        	// 連係情報を一時テーブルに保存
        	P_Temp_PageConnect temp = new P_Temp_PageConnect();
            try{
                temp.insert(workInfo);
                workInfo = new ArrayList();
                workInfo.add(loginInfo.companyCode);
                company = com.select(workInfo);
            }catch(Exception e) {
            	e.printStackTrace();
            }
            
            String url = company.passCode
            		+ "Messageview"
            		+ "?id="		+ msgData.get(0).id
            		+ "&key1="		+ sendGUID
            		+ "&key2="		+ dummy1GUID
            		+ "&key3="		+ dummy2GUID
            		+ "&workerId="	+ loginInfo.id
            		+ "&companyId="	+ loginInfo.company_ID
            		+ "&javaflag="	+ 1;
            		
    	    response.sendRedirect(url);
        }else{
            request.setAttribute("loginInfo", loginInfo);
    		RequestDispatcher dispatch = request.getRequestDispatcher("term/term-1.jsp");
            dispatch.forward(request, response);
        }
	}
}
