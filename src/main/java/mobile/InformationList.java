package mobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dbaccess.P_MSG_MessageData;
import util.DataCheck;
import util.LoginInfo;
import util.MessageData;
import util.UtilConv;

/**
 * Servlet implementation class InformationList
 */
public class InformationList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InformationList() {
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
		// リクエスト、レスポンスの文字コードセット
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        DataCheck check = new DataCheck();
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
        // ログイン情報の受け取り
        LoginInfo loginInfo = new LoginInfo();
        /** ▼▼▼2022/7/28 Id → WorkerIndexに変更▼▼▼ **/
        //loginInfo.id				= check.emptyOrNull(request.getParameter("loginid"));
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
        // 表示するページ
        int pageCnt					= check.nullToOne(request.getParameter("pageCnt"));
        // 全ページ数
        //double pageNum			= 0;
        int pageNum					= 0;
        // お知らせ一覧で押したボタン
        String button1				= check.emptyOrNull(request.getParameter("button1"));
        // 押されたボタンで表示するページを変える
        if(button1 == null) {
        	//nullだったら何もしない
        }else if(button1.equals("次へ")) {
        	// 次へだったら現ページ＋１
        	pageCnt = pageCnt + 1;
        }else if(button1.equals("前へ")) {
        	// 前へだったら現ページ－１
        	pageCnt = pageCnt - 1;
        }else {
        	// 押された番号を現ページに設定
        	pageCnt = Integer.parseInt(button1);
        }
        // 表示するページの件数
        int dspCnt					= pageCnt * 10;
        
        // お知らせ一覧検索結果格納用
        List<MessageData> msgInfo =  new ArrayList<>();
        // お知らせ一覧表示分格納用
        List<MessageData> dspList =  new ArrayList<>(10);

        try {
            /*** お知らせ一覧を取得する ***/
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
            
            
            
        }catch(Exception e) {
        	e.printStackTrace();
        }
        // ログイン情報を画面に渡す
        request.setAttribute("loginInfo", loginInfo);
        // お知らせ一覧を画面に渡す
        request.setAttribute("dspList", dspList);
        // 表示するページ番号を画面に返す
        request.setAttribute("pageCnt", pageCnt);
        // 全ページ数を画面に返す
        request.setAttribute("pageNum", pageNum);

        RequestDispatcher dispatch = request.getRequestDispatcher("news/news-1.jsp");
        dispatch.forward(request, response);
	}
}
