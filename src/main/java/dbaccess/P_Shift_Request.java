package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.ShiftRequest;

public class P_Shift_Request {

	/**
	   * selectメソッド
	   * P_Shift_Requestの検索結果を返す
	   * @param　workInfo　パラメータ
	   * @return 検索結果
	   */
	public List<ShiftRequest> selectMonthly(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<ShiftRequest> shiftReq = new ArrayList<>();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" PSR.Id");
	    	strBuf.append(",PSR.Worker_ID");
	    	strBuf.append(",PSR.Hiduke");
	    	strBuf.append(",PSR.RequestFlag");
	    	strBuf.append(",PSR.Note");
	    	strBuf.append(",PRK.RequestName");
	    	strBuf.append(",PRK.TimeFlag");
	    	strBuf.append(",PRK.BackColorFlag");
	    	strBuf.append(",PRK.FontColorFlag");
	    	strBuf.append(" FROM P_Shift_Request PSR");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_RequestKubun PRK");
	    	strBuf.append(" ON PSR.RequestFlag = PRK.RequestFlag");
	    	strBuf.append(" WHERE PSR.Worker_ID = ");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" AND PSR.Hiduke >= ");
	    	strBuf.append(workInfo.get(1));
	    	strBuf.append(" AND PSR.Hiduke <= ");
	    	strBuf.append(workInfo.get(2));
	    	strBuf.append(" AND PSR.RequestFlag <> 99");
	    	strBuf.append(" AND PRK.TimeFlag <> 99");
	    	strBuf.append(" ORDER BY PSR.Hiduke");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
		    while(result.next()){
		    	ShiftRequest request = new ShiftRequest();
		    	request.id				= Integer.valueOf(result.getInt("Id")).toString();
		    	request.worker_ID		= Integer.valueOf(result.getInt("Worker_ID")).toString();
		    	request.hiduke			= Integer.valueOf(result.getInt("Hiduke")).toString();
		    	request.requestFlag		= Integer.valueOf(result.getInt("RequestFlag")).toString();
		    	request.requestName		= result.getString("RequestName");
		    	request.note			= result.getString("Note");
		    	request.timeFlag		= Integer.valueOf(result.getInt("TimeFlag")).toString();
		    	request.backColorFlag	= result.getString("BackColorFlag");
		    	request.fontColorFlag	= result.getString("FontColorFlag");
		    	shiftReq.add(request);
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
	    return shiftReq;
	}
	/**
	   * selectメソッド
	   * P_Shift_Requestの検索結果を返す
	   * @param　workInfo　パラメータ
	   * @return 検索結果
	   */
	public ShiftRequest select(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    ShiftRequest shiftReq = new ShiftRequest();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" PSR.Id");
	    	strBuf.append(",PSR.Worker_ID");
	    	strBuf.append(",PSR.Hiduke");
	    	strBuf.append(",PSR.RequestFlag");
	    	strBuf.append(",PSR.Note");
	    	strBuf.append(",PRK.RequestName");
	    	strBuf.append(",PRK.TimeFlag");
	    	strBuf.append(",PRK.BackColorFlag");
	    	strBuf.append(",PRK.FontColorFlag");
	    	strBuf.append(" FROM P_Shift_Request PSR");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_RequestKubun PRK");
	    	strBuf.append(" ON PSR.RequestFlag = PRK.RequestFlag");
	    	strBuf.append(" WHERE PSR.Worker_ID = ");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" AND PSR.Hiduke = ");
	    	strBuf.append(workInfo.get(1));
	    	strBuf.append(" AND PSR.RequestFlag <> 99");
	    	strBuf.append(" AND PRK.TimeFlag <> 99");
	    	strBuf.append(" ORDER BY PRK.TimeFlag");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
		    while(result.next()){
		    	shiftReq.id				= Integer.valueOf(result.getInt("Id")).toString();
		    	shiftReq.worker_ID		= Integer.valueOf(result.getInt("Worker_ID")).toString();
		    	shiftReq.hiduke			= Integer.valueOf(result.getInt("Hiduke")).toString();
		    	shiftReq.requestFlag	= Integer.valueOf(result.getInt("RequestFlag")).toString();
		    	shiftReq.requestName	= result.getString("RequestName");
		    	shiftReq.note			= result.getString("Note");
		    	shiftReq.timeFlag		= Integer.valueOf(result.getInt("TimeFlag")).toString();
		    	shiftReq.backColorFlag	= result.getString("BackColorFlag");
		    	shiftReq.fontColorFlag	= result.getString("FontColorFlag");
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
	    return shiftReq;
	}
    /**
    * insertメソッド
    * P_Shift_Requestにデータを登録する
    * @param　	workInfo 登録情報
    * @return	なし
    */
	public void insert(List workInfo) {
		
		// コネクション格納用
	    Connection conn = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    

	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("INSERT INTO P_Shift_Request");
	    	strBuf.append(" (Worker_ID,Hiduke,RequestFlag,Note,EntryDate)");
	    	strBuf.append(" VALUES");
	    	strBuf.append(" (");
	    	strBuf.append(workInfo.get(0));				//Worker_ID
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(1));				//Hiduke
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(2));				//RequestFlag
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(3));				//Note
	    	strBuf.append(",");
	    	strBuf.append("DATEADD(HOUR,9,GETDATE())");	//EntryDate
	    	strBuf.append(")");

	    	stmt.executeUpdate(strBuf.toString());
	    	
	    	// 接続をクローズ
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
	}
	/**
	   * deleteメソッド
	   * P_Shift_Requestを更新する
	   * @param　	workInfo 登録情報
	   * @return	なし
	   */
	public void delete(List workInfo) {
		
		// コネクション格納用
	    Connection conn = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("DELETE P_Shift_Request");
	    	strBuf.append(" WHERE Id = " + workInfo.get(0));

	    	stmt.executeUpdate(strBuf.toString());
	    	
	    	// 接続をクローズ
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
	}
	/**
	   * deleteメソッド
	   * P_Shift_Requestを削除する
	   * 新規インストール時にレコード上はDELETE扱いがあった場合の対応
	   * @param　	workInfo 登録情報
	   * @return	なし
	   */
	public void deleteNewInsert(List workInfo) {
		
		// コネクション格納用
	    Connection conn = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("DELETE P_Shift_Request");
	    	strBuf.append(" WHERE Worker_ID = " + workInfo.get(0));
	    	strBuf.append(" AND Hiduke = " + workInfo.get(1));
	    	strBuf.append(" AND RequestFlag = 99");

	    	stmt.executeUpdate(strBuf.toString());
	    	
	    	// 接続をクローズ
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
	}
}
