package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.RequestData;

public class P_Kinmu_RequestData {
    /**
    * insertメソッド
    * P_Kinmu_RequestDataにデータを登録する
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
	    	strBuf.append("INSERT INTO P_Kinmu_RequestData");
	    	strBuf.append(" (CompanyId, WorkerId, KinmuHiduke, Category, TimeValue, SetTimeValue, Value, SetValue, Note, CauseFlag, Certification, EntryDate, UpdateDate,UpKinmuDataId)");
	    	strBuf.append(" VALUES");
	    	strBuf.append(" (");
	    	strBuf.append(workInfo.get(0));				//CompanyId
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(1));				//WorkerId
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(2));				//KinmuHiduke
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(3));				//Category
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(4));				//TimeValue
	    	strBuf.append(",0,");						//SetTimeValue
	    	strBuf.append(workInfo.get(5));				//Value
	    	strBuf.append(",0,");						//SetValue
	    	strBuf.append(workInfo.get(6));				//Note
	    	strBuf.append(",0");						//CauseFlag
	    	strBuf.append(",0");						//Certification
	    	strBuf.append(",DATEADD(HOUR,9,GETDATE())");//EntryDate
	    	strBuf.append(",DATEADD(HOUR,9,GETDATE())");//UpdateDate
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(1));				//UpKinmuDataId(WorkerId)
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
    * selectメソッド
    * P_Kinmu_RequestDataの検索結果を返す
    * @param　	workInfo	パラメータリスト
    * @return	requestData	検索結果
    */
	public RequestData select(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    String res = null;
	    RequestData requestData = new RequestData();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT KinmuHiduke, Category, TimeValue, SetTimeValue, Value, SetValue, Note, CauseFlag, Certification");
	    	strBuf.append(" FROM P_Kinmu_RequestData");
	    	strBuf.append(" WHERE CompanyId = " + workInfo.get(0));
	    	strBuf.append(" AND WorkerId = " + workInfo.get(1));
	    	strBuf.append(" AND KinmuHiduke = " + workInfo.get(2));
	    	strBuf.append(" AND Category = " + workInfo.get(3));
	    	strBuf.append(" AND UpKinmuDataId = "	+ workInfo.get(1));
		
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
	    		requestData.kinmuHiduke		= Integer.valueOf(result.getInt("KinmuHiduke")).toString();
	    		requestData.category		= Integer.valueOf(result.getInt("Category")).toString();
	    		requestData.timeValue		= Integer.valueOf(result.getInt("TimeValue")).toString();
	    		requestData.setTimeValue	= Integer.valueOf(result.getInt("SetTimeValue")).toString();
	    		requestData.value			= Integer.valueOf(result.getInt("Value")).toString();
	    		requestData.setValue		= Integer.valueOf(result.getInt("SetValue")).toString();
	    		requestData.note			= result.getString("Note");
	    		requestData.causeFlag		= Integer.valueOf(result.getInt("CauseFlag")).toString();
	    		requestData.certification	= Integer.valueOf(result.getInt("Certification")).toString();
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
	    return requestData;
	}
	/**
	   * updateメソッド
	   * P_Kinmu_RequestDataを更新する
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
	    	strBuf.append("UPDATE P_Kinmu_RequestData");
	    	strBuf.append(" SET TimeValue = "		+ workInfo.get(4));
	    	strBuf.append(" ,Value = "				+ workInfo.get(5));
	    	strBuf.append(" ,Note = "				+ workInfo.get(6));
	    	strBuf.append(" ,UpdateDate = DATEADD(HOUR,9,GETDATE())");
	    	strBuf.append(" WHERE CompanyId = "		+ workInfo.get(0));
	    	strBuf.append(" AND WorkerId = "		+ workInfo.get(1));
	    	strBuf.append(" AND KinmuHiduke = "		+ workInfo.get(2));
	    	strBuf.append(" AND Category = "		+ workInfo.get(3));
	    	strBuf.append(" AND UpKinmuDataId = "	+ workInfo.get(1));

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
	   * 利用者のシフト一覧を返す
	   * @param　loginid ログインID
	   * @param　nowDate シフト一覧する表示月
	   * @return　検索結果
	   */
	public List<RequestData> selectMonthly(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<RequestData> requestList = new ArrayList<>();


	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT KinmuHiduke, Category, TimeValue, SetTimeValue, Value, SetValue, Note, CauseFlag, Certification");
	    	strBuf.append(" FROM P_Kinmu_RequestData");
	    	strBuf.append(" WHERE CompanyId = " + workInfo.get(0));
	    	strBuf.append(" AND WorkerId = " + workInfo.get(1));
	    	strBuf.append(" AND KinmuHiduke >= " + workInfo.get(2));
	    	strBuf.append(" AND KinmuHiduke <= " + workInfo.get(3));
	    	strBuf.append(" AND UpKinmuDataId = "	+ workInfo.get(1));
	    	strBuf.append(" ORDER BY KinmuHiduke, Category");
		
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
			    // 検索結果格納用
		    	RequestData requestData = new RequestData();
	    		requestData.kinmuHiduke		= Integer.valueOf(result.getInt("KinmuHiduke")).toString();
	    		requestData.category		= Integer.valueOf(result.getInt("Category")).toString();
	    		requestData.timeValue		= Integer.valueOf(result.getInt("TimeValue")).toString();
	    		requestData.setTimeValue	= Integer.valueOf(result.getInt("SetTimeValue")).toString();
	    		requestData.value			= Integer.valueOf(result.getInt("Value")).toString();
	    		requestData.setValue		= Integer.valueOf(result.getInt("SetValue")).toString();
	    		requestData.note			= result.getString("Note");
	    		requestData.causeFlag		= Integer.valueOf(result.getInt("CauseFlag")).toString();
	    		requestData.certification	= Integer.valueOf(result.getInt("Certification")).toString();
	    		requestList.add(requestData);
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
	return requestList;
	}
}
