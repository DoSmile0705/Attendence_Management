package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.MessageData;

public class P_MSG_MessageData {

	/**
	   * selectメソッド
	   * P_MSG_MessageDataの検索結果を返す
	   * @param		id ログインID
	   * @return	検索結果
	   */
	public List<MessageData> select(String id) {
		
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<MessageData> msgInfo = new ArrayList<>();

	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" PMMD.Id");
	    	strBuf.append(",PMMD.HeaderName");
	    	strBuf.append(",PMMD.MakeDate");
	    	strBuf.append(",PMMD.CategoryCode");
	    	strBuf.append(",PMMD.ReturnDate");
	    	strBuf.append(",PMMD.Body1");
	    	strBuf.append(",PMMD.Body2");
	    	strBuf.append(",PMMD.Body3");
	    	strBuf.append(",PMMD.Note");
	    	strBuf.append(",PMMD.MessageBinaryFile_ID");
	    	strBuf.append(",PMMD.Company_ID");
	    	strBuf.append(",PMMW.WorkerIndex");
	    	strBuf.append(",PMMW.IsRead");
	    	strBuf.append(",PMMW.AnswerText");
	    	strBuf.append(",PMMW.AnswerDate");
	    	strBuf.append(",PMMW.ReadDate");
	    	strBuf.append(",PMMW.EntryDate");
	    	strBuf.append(",PMMW.KeyCode1");
	    	strBuf.append(",PMMW.KeyCode2");
	    	strBuf.append(",PMMW.MessageBinaryFileId");
	    	strBuf.append(",PMMW.MessageData_ID");
	    	strBuf.append(",PMMBF.GuidKey");
	    	strBuf.append(",PMMBF.LocalFileName");
	    	strBuf.append(",PMMBF.Localcategory");
	    	strBuf.append(",PMMBF.UploadDate");
	    	strBuf.append(",PMMBF.UploadFileName");
	    	strBuf.append(",PMMBF.MessageDataId");
	    	strBuf.append(",PMMBF.MessageWorkerDataId");
	    	strBuf.append(" FROM P_MSG_MessageData PMMD");
	    	strBuf.append(" LEFT OUTER JOIN P_MSG_MessageWorker PMMW");
	    	strBuf.append(" ON PMMD.Id = PMMW.MessageData_ID");
	    	strBuf.append(" LEFT OUTER JOIN P_MSG_MessageBinaryFile PMMBF");
	    	strBuf.append(" ON PMMD.MessageBinaryFile_ID = PMMBF.Id");
	    	strBuf.append(" AND PMMW.MessageBinaryFileId = PMMBF.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MW_Worker PMW");
	    	strBuf.append(" ON PMMW.Worker_Id = PMW.Id");
	    	strBuf.append(" WHERE PMMD.CategoryCode < 10");
	    	strBuf.append(" AND PMMW.IsDeleteFlag = 0");
	    	strBuf.append(" AND PMW.Id = ");
	    	strBuf.append(id);
	    	strBuf.append(" ORDER BY PMMD.MakeDate DESC");
	    	
	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
			    // 検索結果格納用
		    	MessageData msgData = new MessageData();
		    	msgData.id						= result.getString("Id");
		    	msgData.headerName				= result.getString("HeaderName");
		    	msgData.makeDate				= result.getString("MakeDate");
		    	msgData.categoryCode			= result.getString("CategoryCode");
		    	msgData.returnDate				= result.getString("ReturnDate");
		    	msgData.body1					= result.getString("Body1");
		    	msgData.body2					= result.getString("Body2");
		    	msgData.body3					= result.getString("Body3");
		    	msgData.note					= result.getString("Note");
		    	msgData.messageBinaryFile_ID	= result.getString("MessageBinaryFile_ID");
		    	msgData.company_ID				= result.getString("Company_ID");
		    	msgData.workerIndex				= result.getString("WorkerIndex");
		    	msgData.isRead					= result.getString("IsRead");
		    	/*** 未読か既読かを設定 ***/
		    	if(msgData.isRead != null) {
		    		if(msgData.isRead.equals("1")) {
		    			msgData.isRead = "既読";
		    		}else {
		    			msgData.isRead = "未読";
		    		}
		    	}
		    	msgData.answerText				= result.getString("AnswerText");
		    	msgData.answerDate				= result.getString("AnswerDate");
		    	msgData.readDate				= result.getString("ReadDate");
		    	msgData.entryDate				= result.getString("EntryDate");
		    	msgData.keyCode1				= result.getString("KeyCode1");
		    	msgData.keyCode2				= result.getString("KeyCode2");
		    	msgData.messageBinaryFileId		= result.getString("MessageBinaryFileId");
		    	msgData.messageData_ID			= result.getString("MessageData_ID");
		    	msgData.guidKey					= result.getString("GuidKey");
		    	msgData.localFileName			= result.getString("LocalFileName");
		    	msgData.localcategory			= result.getString("Localcategory");
		    	msgData.uploadDate				= result.getString("UploadDate");
		    	msgData.uploadFileName			= result.getString("UploadFileName");
		    	msgData.messageDataId			= result.getString("MessageDataId");
		    	msgData.messageWorkerDataId		= result.getString("MessageWorkerDataId");
		    	msgInfo.add(msgData);
		    }
	    	// 接続をクローズ
	    	result.close();
	    	stmt.close();

	    }catch (SQLException e){
	    	e.printStackTrace();
	    }catch (Exception e){
	    	e.printStackTrace();
	    }finally{
	    	try{
	    		if (conn != null){
	    			conn.close();
	    		}
	    	}catch (SQLException e){
		    	e.printStackTrace();
	    	}
	    }
  	return msgInfo;
	}
	/**
	   * selectメソッド
	   * P_MSG_MessageDataの検索結果を返す
	   * カテゴリーコードを指定
	   * @param		workInfo パラメータリスト
	   * @return	検索結果
	   */
	public List<MessageData> selectCategory(List workInfo) {
		
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<MessageData> msgInfo = new ArrayList<>();

	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" PMMD.Id");
	    	strBuf.append(",PMMD.HeaderName");
	    	strBuf.append(",PMMD.MakeDate");
	    	strBuf.append(",PMMD.CategoryCode");
	    	strBuf.append(",PMMD.ReturnDate");
	    	strBuf.append(",PMMD.Body1");
	    	strBuf.append(",PMMD.Body2");
	    	strBuf.append(",PMMD.Body3");
	    	strBuf.append(",PMMD.Note");
	    	strBuf.append(",PMMD.MessageBinaryFile_ID");
	    	strBuf.append(",PMMD.Company_ID");
	    	strBuf.append(",PMMW.WorkerIndex");
	    	strBuf.append(",PMMW.IsRead");
	    	strBuf.append(",PMMW.AnswerText");
	    	strBuf.append(",PMMW.AnswerDate");
	    	strBuf.append(",PMMW.ReadDate");
	    	strBuf.append(",PMMW.EntryDate");
	    	strBuf.append(",PMMW.KeyCode1");
	    	strBuf.append(",PMMW.KeyCode2");
	    	strBuf.append(",PMMW.MessageBinaryFileId");
	    	strBuf.append(",PMMW.MessageData_ID");
	    	strBuf.append(",PMMBF.GuidKey");
	    	strBuf.append(",PMMBF.LocalFileName");
	    	strBuf.append(",PMMBF.Localcategory");
	    	strBuf.append(",PMMBF.UploadDate");
	    	strBuf.append(",PMMBF.UploadFileName");
	    	strBuf.append(",PMMBF.MessageDataId");
	    	strBuf.append(",PMMBF.MessageWorkerDataId");
	    	strBuf.append(" FROM P_MSG_MessageData PMMD");
	    	strBuf.append(" LEFT OUTER JOIN P_MSG_MessageWorker PMMW");
	    	strBuf.append(" ON PMMD.Id = PMMW.MessageData_ID");
	    	strBuf.append(" LEFT OUTER JOIN P_MSG_MessageBinaryFile PMMBF");
	    	strBuf.append(" ON PMMD.MessageBinaryFile_ID = PMMBF.Id");
	    	strBuf.append(" AND PMMW.MessageBinaryFileId = PMMBF.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MW_Worker PMW");
	    	strBuf.append(" ON PMMW.Worker_Id = PMW.Id");
	    	strBuf.append(" WHERE PMMW.IsDeleteFlag = 0");
	    	strBuf.append(" AND PMW.Id = ");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" AND PMMD.CategoryCode = ");
	    	strBuf.append(workInfo.get(1));
	    	strBuf.append(" ORDER BY PMMD.MakeDate DESC");
	    	
	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
			    // 検索結果格納用
		    	MessageData msgData = new MessageData();
		    	msgData.id						= result.getString("Id");
		    	msgData.headerName				= result.getString("HeaderName");
		    	msgData.makeDate				= result.getString("MakeDate");
		    	msgData.categoryCode			= result.getString("CategoryCode");
		    	msgData.returnDate				= result.getString("ReturnDate");
		    	msgData.body1					= result.getString("Body1");
		    	msgData.body2					= result.getString("Body2");
		    	msgData.body3					= result.getString("Body3");
		    	msgData.note					= result.getString("Note");
		    	msgData.messageBinaryFile_ID	= result.getString("MessageBinaryFile_ID");
		    	msgData.company_ID				= result.getString("Company_ID");
		    	msgData.workerIndex				= result.getString("WorkerIndex");
		    	msgData.isRead					= result.getString("IsRead");
		    	/*** 未読か既読かを設定 ***/
		    	if(msgData.isRead != null) {
		    		if(msgData.isRead.equals("1")) {
		    			msgData.isRead = "既読";
		    		}else {
		    			msgData.isRead = "未読";
		    		}
		    	}
		    	msgData.answerText				= result.getString("AnswerText");
		    	msgData.answerDate				= result.getString("AnswerDate");
		    	msgData.readDate				= result.getString("ReadDate");
		    	msgData.entryDate				= result.getString("EntryDate");
		    	msgData.keyCode1				= result.getString("KeyCode1");
		    	msgData.keyCode2				= result.getString("KeyCode2");
		    	msgData.messageBinaryFileId		= result.getString("MessageBinaryFileId");
		    	msgData.messageData_ID			= result.getString("MessageData_ID");
		    	msgData.guidKey					= result.getString("GuidKey");
		    	msgData.localFileName			= result.getString("LocalFileName");
		    	msgData.localcategory			= result.getString("Localcategory");
		    	msgData.uploadDate				= result.getString("UploadDate");
		    	msgData.uploadFileName			= result.getString("UploadFileName");
		    	msgData.messageDataId			= result.getString("MessageDataId");
		    	msgData.messageWorkerDataId		= result.getString("MessageWorkerDataId");
		    	msgInfo.add(msgData);
		    }
	    	// 接続をクローズ
	    	result.close();
	    	stmt.close();

	    }catch (SQLException e){
	    	e.printStackTrace();
	    }catch (Exception e){
	    	e.printStackTrace();
	    }finally{
	    	try{
	    		if (conn != null){
	    			conn.close();
	    		}
	    	}catch (SQLException e){
		    	e.printStackTrace();
	    	}
	    }
	return msgInfo;
	}
	/**
	   * selectメソッド
	   * P_MSG_MessageDataの未読結果を返す
	   * @param		id ログインID
	   * @return	検索結果
	   */
	public int selectIsRead(String id) {
		
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    int unread = 0;

	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" COUNT(PMMW.IsRead) AS UnRead");
	    	strBuf.append(" FROM P_MSG_MessageData PMMD");
	    	strBuf.append(" LEFT OUTER JOIN P_MSG_MessageWorker PMMW");
	    	strBuf.append(" ON PMMD.Id = PMMW.MessageData_ID");
	    	strBuf.append(" LEFT OUTER JOIN P_MSG_MessageBinaryFile PMMBF");
	    	strBuf.append(" ON PMMD.MessageBinaryFile_ID = PMMBF.Id");
	    	strBuf.append(" AND PMMW.MessageBinaryFileId = PMMBF.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MW_Worker PMW");
	    	strBuf.append(" ON PMMW.Worker_Id = PMW.Id");
	    	strBuf.append(" WHERE PMMD.CategoryCode < 10");
	    	strBuf.append(" AND PMMW.IsDeleteFlag = 0");
	    	strBuf.append(" AND PMMW.IsRead = 0");
	    	strBuf.append(" AND PMW.Id = ");
	    	strBuf.append(id);
	    	
	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
		    	//未読件数を取得
		    	unread	= result.getInt("UnRead");
		    }
	    	// 接続をクローズ
	    	result.close();
	    	stmt.close();

	    }catch (SQLException e){
	    	e.printStackTrace();
	    }catch (Exception e){
	    	e.printStackTrace();
	    }finally{
	    	try{
	    		if (conn != null){
	    			conn.close();
	    		}
	    	}catch (SQLException e){
		    	e.printStackTrace();
	    	}
	    }
	return unread;
	}
}
