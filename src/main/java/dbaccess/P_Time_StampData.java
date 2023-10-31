package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;

public class P_Time_StampData {

	/**
	   * insertメソッド
	   * P_Time_StampDataにデータを登録する
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
	    	strBuf.append("INSERT INTO P_Time_StampData");
	    	strBuf.append(" (StampFlag,StampTime,DeviceCode,GeoIdo,GeoKei,EditFlag,IsDeleteFlag,EntryDate,PassCode,PassCode2,Worker_ID,Keiyaku_ID,ShiftData_ID)");
	    	strBuf.append(" VALUES");
	    	strBuf.append(" (");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(3));
	    	strBuf.append(",");
	    	strBuf.append("''");
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(7));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(8));
	    	strBuf.append(",");
	    	strBuf.append("''");
	    	strBuf.append(",");
	    	strBuf.append("''");
	    	strBuf.append(",");
   			strBuf.append("DATEADD(HOUR, 9, GETDATE()),'','',");
	    	strBuf.append(workInfo.get(4));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(5));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(6));
	    	//▲▲▲ 2022.09.27 【改修】打刻データ改修 ▲▲▲
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
	   * updateメソッド
	   * P_Time_StampDataを更新する
	   * @param　	workInfo 登録情報
	   * @return	なし
	   */
	public void update(List workInfo) {
		
		// コネクション格納用
	    Connection conn = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("UPDATE P_Time_StampData");
	    	strBuf.append(" SET IsDeleteFlag = 1");
	    	strBuf.append(" WHERE StampFlag = " + workInfo.get(0));
	    	strBuf.append(" AND StampTime >= DATEADD(" + workInfo.get(1) + "," + workInfo.get(2) + "," + workInfo.get(3) + ")");
	    	strBuf.append(" AND IsDeleteFlag = 0");
	    	strBuf.append(" AND Worker_ID = " + workInfo.get(4));
	    	strBuf.append(" AND Keiyaku_ID = " + workInfo.get(5));
	    	strBuf.append(" AND ShiftData_ID = " + workInfo.get(6));

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
	 * selectメソッド
	 * P_Time_StampDataの検索結果を返す
	 * @param　	workInfo	パラメータリスト
	 * @return	stampTime	打刻時刻
	 */
	public String select(List workInfo) {
		// 件数取得用カウンタ
		String stampTime = null;
		// コネクション格納用
	    Connection conn = null;
	    String res = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT MAX(StampTime) AS StampTime");
	    	strBuf.append(" FROM P_Time_StampData");
	    	strBuf.append(" WHERE StampFlag = " + workInfo.get(0));
	    	strBuf.append(" AND StampTime >= DATEADD(" + workInfo.get(1) + "," + workInfo.get(2) + "," + workInfo.get(3) + ")");
	    	strBuf.append(" AND IsDeleteFlag = 0");
	    	strBuf.append(" AND Worker_ID = " + workInfo.get(4));
	    	strBuf.append(" AND Keiyaku_ID = " + workInfo.get(5));
	    	strBuf.append(" AND ShiftData_ID = " + workInfo.get(6));
		
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
		    	stampTime = result.getString("StampTime");
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
	    return stampTime;
	}
	/**
	   * deleteメソッド※削除フラグを立てる
	   * P_Time_StampDataを更新する
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
	    	strBuf.append("UPDATE P_Time_StampData");
	    	strBuf.append(" SET IsDeleteFlag = 1");
	    	strBuf.append(" WHERE StampFlag = " + workInfo.get(0));
	    	strBuf.append(" AND StampTime >= " + workInfo.get(3));
	    	strBuf.append(" AND IsDeleteFlag = 0");
	    	strBuf.append(" AND Worker_ID = " + workInfo.get(4));
	    	strBuf.append(" AND Keiyaku_ID = " + workInfo.get(5));
	    	strBuf.append(" AND ShiftData_ID = " + workInfo.get(6));

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
	   * selectメソッド
	   * P_Time_StampDataの検索結果を返す
	   * @param　	workInfo	パラメータリスト
	   * @return	stampTime	打刻時刻
	   */
	public String selectStamp(List workInfo) {
		// 件数取得用カウンタ
		String stampTime = null;
		// コネクション格納用
	    Connection conn = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT MAX(StampTime) AS StampTime");
	    	strBuf.append(" FROM P_Time_StampData");
	    	strBuf.append(" WHERE StampFlag = " + workInfo.get(0));
	    	strBuf.append(" AND IsDeleteFlag = 0");
	    	strBuf.append(" AND Worker_ID = " + workInfo.get(7));
	    	strBuf.append(" AND Keiyaku_ID = " + workInfo.get(8));
	    	strBuf.append(" AND ShiftData_ID = " + workInfo.get(9));
		
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
		    	stampTime = result.getString("StampTime");
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
	    return stampTime;
	}

	/**
	 * selectAlreadyメソッド
	 * P_Time_StampDataの打刻済の検索結果を返す
	 * @param　	workInfo	パラメータリスト
	 * @return	stampTime	打刻時刻
	 */
	public String selectFiveMinuteAfter(List workInfo) {
		// 件数取得用カウンタ
		String stampTime = null;
		// コネクション格納用
	    Connection conn = null;
	    String res = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT MAX(StampTime) AS StampTime");
	    	strBuf.append(" FROM P_Time_StampData");
	    	strBuf.append(" WHERE StampFlag = " + workInfo.get(0));
	    	strBuf.append(" AND DATEADD(HOUR,9,GETDATE()) >= DATEADD(MINUTE,5,StampTime)");
	    	strBuf.append(" AND IsDeleteFlag = 0");
	    	strBuf.append(" AND Worker_ID = " + workInfo.get(1));
	    	strBuf.append(" AND Keiyaku_ID = " + workInfo.get(2));
	    	strBuf.append(" AND ShiftData_ID = " + workInfo.get(3));
		
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
		    	stampTime = result.getString("StampTime");
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
	    return stampTime;
	}
	/**
	   * selectFreeStampメソッド
	   * シフトに関係ない上下番打刻を取得
	   * P_Time_StampDataの検索結果を返す
	   * @param　	workInfo	パラメータリスト
	   * @return	stampTime	打刻時刻
	   */
	public String selectFreeStamp(List workInfo) {
		// 件数取得用カウンタ
		String stampTime = null;
		// コネクション格納用
	    Connection conn = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT MAX(StampTime) AS StampTime");
	    	strBuf.append(" FROM P_Time_StampData");
	    	strBuf.append(" WHERE StampFlag = " + workInfo.get(0));
	    	strBuf.append(" AND StampTime >= DATEADD(" + workInfo.get(1) + "," + workInfo.get(2) + "," + workInfo.get(3) + ")");
	    	strBuf.append(" AND StampTime <= DATEADD(" + workInfo.get(4) + "," + workInfo.get(5) + "," + workInfo.get(6) + ")");
	    	strBuf.append(" AND IsDeleteFlag = 0");
	    	strBuf.append(" AND Worker_ID = " + workInfo.get(7));
	    	strBuf.append(" AND Keiyaku_ID = " + workInfo.get(8));
	    	strBuf.append(" AND ShiftData_ID = " + workInfo.get(9));
		
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
		    	stampTime = result.getString("StampTime");
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
	    return stampTime;
	}
	/**
	   * selectHistoryメソッド
	   * 20時間以内の打刻を取得する
	   * P_Time_StampDataの検索結果を返す
	   * @param　	workInfo	パラメータリスト
	   * @return	stampTime	打刻リスト
	   */
	public List selectHistory(List workInfo) {
		// 件数取得用カウンタ
		List stampTime = new ArrayList();;
		// コネクション格納用
	    Connection conn = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT StampTime");
	    	strBuf.append(" FROM P_Time_StampData");
	    	strBuf.append(" WHERE");
	    	strBuf.append(" StampTime >= DATEADD(HOUR,-20,DATEADD(HOUR,9,GETDATE()))");
	    	strBuf.append(" AND StampFlag = ");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" AND Worker_ID = ");
	    	strBuf.append(workInfo.get(1));
	    	strBuf.append(" AND IsDeleteFlag = 0");
	    	strBuf.append(" ORDER BY StampTime DESC");
		
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
		    	stampTime.add(result.getString("StampTime"));
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
	    return stampTime;
	}
	
	/**
	   * selectメソッド
	   * P_Time_StampDataの検索結果を返す
	   * @param　	workInfo	パラメータリスト
	   * @return	stampTime	打刻時刻
	   */
	public String selectCurrentStampData(List workInfo) {
		// 緯度、経度
		String gpsInfo = "";
		// コネクション格納用
	    Connection conn = null;
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT GeoIdo , GeoKei");
	    	strBuf.append(" FROM P_Time_StampData");
	    	strBuf.append(" WHERE Id = (SELECT MAX(Id) FROM P_Time_StampData");
	    	strBuf.append(" WHERE StampFlag = " + workInfo.get(0));
	    	strBuf.append(" AND IsDeleteFlag = 0");
	    	strBuf.append(" AND Worker_ID = " + workInfo.get(4) + ")");
		
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
	    		gpsInfo += result.getString("GeoIdo");
	    		gpsInfo += result.getString("GeoKei");
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
	    return gpsInfo;
	}
}
