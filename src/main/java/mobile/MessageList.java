package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dbaccess.P_MSG_MessageData;
import dbaccess.P_MW_Worker;
import dbaccess.P_Temp_PageConnect;
import util.Authorization;
import util.Constant;
import util.DataCheck;
import util.LoginInfo;
import util.MessageData;
import util.PageConnect;
import util.UtilConv;

/**
 * MessageListクラス
 * メッセージ詳細からの戻りの処理を行う
 */
public class MessageList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MessageList() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
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
        DataCheck check = new DataCheck();
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
        // ログイン情報の受け取り
        LoginInfo loginInfo = new LoginInfo();
        // URLからパラメータを受け取り
        String id				= check.emptyOrNull(request.getParameter("id"));
        String key1				= check.emptyOrNull(request.getParameter("key1"));
        String key2				= check.emptyOrNull(request.getParameter("key2"));
        String key3				= check.emptyOrNull(request.getParameter("key3"));
        String workerId			= check.emptyOrNull(request.getParameter("workerId"));
        String companyId		= check.emptyOrNull(request.getParameter("companyId"));
        //セッション用
        String sessionId = null;
        // パラメータ用
        List workInfo =  new ArrayList();

    	// DBアクセスクラス
    	P_MW_Worker worker = new P_MW_Worker();
        // お知らせ一覧検索結果格納用
        List<MessageData> msgInfo =  new ArrayList<>();
        // お知らせ一覧表示分格納用
        List<MessageData> dspList =  new ArrayList<>(10);
        //一時テーブル格納用
    	PageConnect pageCon = new PageConnect();
    	// DBアクセスクラス
    	P_Temp_PageConnect temp = new P_Temp_PageConnect();
    	//パラメータ格納用
        // 表示するページの件数
        int dspCnt 	= 0;
        // 全ページ数※（想定しにくいが）全ページ数が0だった場合の対処として初期値を1にしておく
        int pageNum	= 1;
        // ページ数※（想定しにくいが）ページ数が0だった場合の対処として初期値を1にしておく
        int pageCnt	= 1;

        try {
            /***パラメータからユーザー情報を取得***/
            // ログインIDをキーに警備員マスタを取得
	    	loginInfo = worker.selectAnother(workerId);

            /***パラメータからTempテーブルから情報を取得***/
	    	workInfo.add(companyId);
	    	workInfo.add(workerId);
	    	workInfo.add(id);
	    	workInfo.add(key1);

	    	pageCon = temp.select(workInfo);
	        // 表示するページの件数
	    	if(pageCon.connectPage != null) {
	    		pageCnt	= Integer.parseInt(pageCon.connectPage);
		        dspCnt	= pageCnt * 10;
	    	}

            // メッセージテーブルアクセスクラス
            P_MSG_MessageData msg = new P_MSG_MessageData();
            // ログインIDをキーにメッセージを取得
            msgInfo = msg.select(loginInfo.id);
            // お知らせ一覧のページ数を取得する
            if(msgInfo.size() > 0) {
            	// お知らせ一覧の総数を1ページ当たりの表示件数(10件)で除した数(切り上げ)
            	//pageNum = Math.ceil(msgInfo.size() / 10);
            	pageNum = (msgInfo.size() + 10 - 1) / 10;
            	
            	// ループの最大値の調整
            	int maxCnt = dspCnt;
            	if(msgInfo.size() < maxCnt) {
            		maxCnt = msgInfo.size();
            	}
            	
                /*** お知らせ一覧を取得する処理 ***/
                for(int i = dspCnt - 10; i < maxCnt; i ++) {
                	MessageData msgData = new MessageData();
                	msgData.id					= msgInfo.get(i).id;
                	msgData.headerName			= msgInfo.get(i).headerName;
                	msgData.makeDate			= msgInfo.get(i).makeDate;
                	msgData.categoryCode		= msgInfo.get(i).categoryCode;
                	msgData.returnDate			= msgInfo.get(i).returnDate;
                	msgData.body1				= msgInfo.get(i).body1;
                	msgData.body2				= msgInfo.get(i).body2;
                	msgData.body3				= msgInfo.get(i).body3;
                	msgData.note				= msgInfo.get(i).note;
                	msgData.messageBinaryFile_ID= msgInfo.get(i).messageBinaryFile_ID;
                	msgData.company_ID			= msgInfo.get(i).company_ID;
                	msgData.workerIndex			= msgInfo.get(i).workerIndex;
                	msgData.isRead				= msgInfo.get(i).isRead;
                	msgData.answerText			= msgInfo.get(i).answerText;
                	msgData.answerDate			= msgInfo.get(i).answerDate;
                	msgData.readDate			= msgInfo.get(i).readDate;
                	msgData.entryDate			= msgInfo.get(i).entryDate;
                	msgData.keyCode1			= msgInfo.get(i).keyCode1;
                	msgData.keyCode2			= msgInfo.get(i).keyCode2;
                	msgData.messageBinaryFileId	= msgInfo.get(i).messageBinaryFileId;
                	msgData.messageData_ID		= msgInfo.get(i).messageData_ID;
                	msgData.guidKey				= msgInfo.get(i).guidKey;
                	msgData.localFileName		= msgInfo.get(i).localFileName;
                	msgData.localcategory		= msgInfo.get(i).localcategory;
                	msgData.uploadDate			= msgInfo.get(i).uploadDate;
                	msgData.uploadFileName		= msgInfo.get(i).uploadFileName;
                	msgData.messageDataId		= msgInfo.get(i).messageDataId;
                	msgData.messageWorkerDataId	= msgInfo.get(i).messageWorkerDataId;
                	dspList.add(msgData);
                }
            }
            // ログインIDをキーに未読メッセージを取得
            Constant.UNREAD = msg.selectIsRead(loginInfo.id);

            //新しいセッションを取得
			HttpSession session = request.getSession(true);
			sessionId = session.getId();

        }catch(Exception e) {
        	e.printStackTrace();
        }
    	// セッションを暗号化して画面に渡す
        loginInfo.sessionId = utilConv.encrypt(sessionId);
        request.setAttribute("sessionId", loginInfo.sessionId);
        // ログイン情報を画面に渡す
        request.setAttribute("loginInfo", loginInfo);
        // お知らせ一覧を画面に渡す
        request.setAttribute("dspList", dspList);
        // 表示するページ番号を画面に返す
        request.setAttribute("pageCnt", pageCnt);
        // 全ページ数を画面に返す
        request.setAttribute("pageNum", pageNum);
        // お知らせ一覧を画面に渡す
        RequestDispatcher dispatch = request.getRequestDispatcher("news/news-1.jsp");
        dispatch.forward(request, response);
	}

}
