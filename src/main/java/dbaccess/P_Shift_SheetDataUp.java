package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.ShiftInfo;

public class P_Shift_SheetDataUp {
	// SQL Server接続文字列
	private static final String URL = "jdbc:sqlserver://sac.database.windows.net:1433;database=SAC_Data;user=dbadmin@sac;password=sac001SAC001;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
	// JDBCドライバ
	private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	/**
	   * selectメソッド
	   * P_Shift_SheetDataUpの検索結果を返す
	   * @param　loginid ログインID
	   * @return　検索結果
	   */
	public List<ShiftInfo> select(String loginid) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<ShiftInfo> listInfo = new ArrayList<>();


	    try {
	    	
	    	Class.forName(DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" SS.ShiftHiduke,");
	    	strBuf.append(" SS.BgnTimeDate,");
	    	strBuf.append(" FORMAT(SS.BgnTimeDate,'HH:mm') AS BgnTime,");
	    	strBuf.append(" SS.EndTimeDate,");
	    	strBuf.append(" FORMAT(SS.EndTimeDate,'HH:mm') AS EndTime,");
	    	strBuf.append(" MK.KinmuBashoName,");
	    	strBuf.append(" MK.Address_PostNo,");
	    	strBuf.append(" MK.Address_Main,");
	    	strBuf.append(" MK.Address_Sub,");
	    	strBuf.append(" MGYO.Name AS GyomuKubunName,");
	    	strBuf.append(" MKIM.Name AS KinmuKubunName,");
	    	strBuf.append(" MKEI.Name AS KeiyakuKubunName,");
	    	strBuf.append(" SS.Worker_ID,");
	    	strBuf.append(" SS.Keiyaku_ID");
	    	strBuf.append(" FROM P_Shift_SheetDataUp SS");
	    	strBuf.append(" LEFT OUTER JOIN P_MW_Worker MW");
	    	strBuf.append(" ON SS.Worker_ID = MW.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_Keiyaku MK");
	    	strBuf.append(" ON SS.Keiyaku_ID = MK.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_GyomuKubun MGYO");
	    	strBuf.append(" ON MK.GyomuKubun_ID = MGYO.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KinmuKubun MKIM");
	    	strBuf.append(" ON MK.KinmuKubun_ID = MKIM.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KeiyakuKubun MKEI");
	    	strBuf.append(" ON MK.KeiyakuKubun_ID = MKEI.Id");
	    	strBuf.append(" WHERE MW.Id = ");
	    	strBuf.append(loginid);
	    	// 日本時間を取得するため、開始時間を1日多く取得する
	    	strBuf.append(" AND SS.BgnTimeDate >= DATEADD(DAY,-1,GETDATE())");
	    	strBuf.append(" AND SS.EndTimeDate <= DATEADD(DAY,1,GETDATE())");
	    	strBuf.append(" ORDER BY SS.BgnTimeDate,");
	    	strBuf.append(" SS.EndTimeDate");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
			    // 検索結果格納用
				ShiftInfo shiftInfo = new ShiftInfo();
    		   	shiftInfo.shiftHiduke		= result.getString("ShiftHiduke");
    		   	shiftInfo.bgnTimeDate		= result.getString("BgnTimeDate");
    		   	shiftInfo.bgnTime			= result.getString("BgnTime");
    		   	shiftInfo.endTimeDate		= result.getString("EndTimeDate");
    		   	shiftInfo.endTime			= result.getString("EndTime");
    		   	shiftInfo.kinmuBashoName	= result.getString("KinmuBashoName");
    		   	shiftInfo.adrPostNo			= result.getString("Address_PostNo");
    		   	shiftInfo.adrMain			= result.getString("Address_Main");
    		   	shiftInfo.adrSub			= result.getString("Address_Sub");
    		   	shiftInfo.gyomuKubunName	= result.getString("GyomuKubunName");
    		   	shiftInfo.kinmuKubunName	= result.getString("KinmuKubunName");
    		   	shiftInfo.keiyakuKubunName	= result.getString("KeiyakuKubunName");
    		   	shiftInfo.workerId			= result.getString("Worker_ID");
    		   	shiftInfo.keiyakuId			= result.getString("Keiyaku_ID");
    		   	listInfo.add(shiftInfo);
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
    	return listInfo;
	}
	/**
	   * selectメソッド
	   * P_Shift_SheetDataUpの検索結果を返す
	   * @param　loginid	ログインID
	   * @param　startDate	上番時間
	   * @return　検索結果
	   */
	public ShiftInfo select(String loginid, String startDate) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    ShiftInfo shiftInfo = new ShiftInfo();
	    	
	    try {
	    	
	    	Class.forName(DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" TOP (1)");
	    	strBuf.append(" SS.ShiftHiduke,");
	    	strBuf.append(" SS.BgnTimeDate,");
	    	strBuf.append(" FORMAT(SS.BgnTimeDate,'HH:mm') AS BgnTime,");
	    	strBuf.append(" SS.EndTimeDate,");
	    	strBuf.append(" FORMAT(SS.EndTimeDate,'HH:mm') AS EndTime,");
	    	strBuf.append(" MK.KinmuBashoName,");
	    	strBuf.append(" MK.Address_PostNo,");
	    	strBuf.append(" MK.Address_Main,");
	    	strBuf.append(" MK.Address_Sub,");
	    	strBuf.append(" MGYO.Name AS GyomuKubunName,");
	    	strBuf.append(" MKIM.Name AS KinmuKubunName,");
	    	strBuf.append(" MKEI.Name AS KeiyakuKubunName,");
	    	strBuf.append(" SS.Worker_ID,");
	    	strBuf.append(" SS.Keiyaku_ID");
	    	strBuf.append(" FROM P_Shift_SheetDataUp SS");
	    	strBuf.append(" LEFT OUTER JOIN P_MW_Worker MW");
	    	strBuf.append(" ON SS.Worker_ID = MW.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_Keiyaku MK");
	    	strBuf.append(" ON SS.Keiyaku_ID = MK.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_GyomuKubun MGYO");
	    	strBuf.append(" ON MK.GyomuKubun_ID = MGYO.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KinmuKubun MKIM");
	    	strBuf.append(" ON MK.KinmuKubun_ID = MKIM.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KeiyakuKubun MKEI");
	    	strBuf.append(" ON MK.KeiyakuKubun_ID = MKEI.Id");
	    	strBuf.append(" WHERE MW.Id = ");
	    	strBuf.append(loginid);
	    	// 次のシフトを取得する
	    	strBuf.append(" AND SS.BgnTimeDate > " + startDate);
	    	strBuf.append(" ORDER BY SS.BgnTimeDate DESC");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
    		   	shiftInfo.shiftHiduke		= result.getString("ShiftHiduke");
    		   	shiftInfo.bgnTimeDate		= result.getString("BgnTimeDate");
    		   	shiftInfo.bgnTime			= result.getString("BgnTime");
    		   	shiftInfo.endTimeDate		= result.getString("EndTimeDate");
    		   	shiftInfo.endTime			= result.getString("EndTime");
    		   	shiftInfo.kinmuBashoName	= result.getString("KinmuBashoName");
    		   	shiftInfo.adrPostNo			= result.getString("Address_PostNo");
    		   	shiftInfo.adrMain			= result.getString("Address_Main");
    		   	shiftInfo.adrSub			= result.getString("Address_Sub");
    		   	shiftInfo.gyomuKubunName	= result.getString("GyomuKubunName");
    		   	shiftInfo.kinmuKubunName	= result.getString("KinmuKubunName");
    		   	shiftInfo.keiyakuKubunName	= result.getString("KeiyakuKubunName");
    		   	shiftInfo.workerId			= result.getString("Worker_ID");
    		   	shiftInfo.keiyakuId			= result.getString("Keiyaku_ID");
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
	    return shiftInfo;
	}
	/**
	   * selectメソッド
	   * 利用者のシフト一覧を返す
	   * @param　loginid ログインID
	   * @param　nowDate シフト一覧する表示月
	   * @return　検索結果
	   */
	public List<ShiftInfo> getShiftList(String loginid, String subDate) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<ShiftInfo> listInfo = new ArrayList<>();


	    try {
	    	
	    	Class.forName(DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" SS.ShiftHiduke,");
	    	strBuf.append(" SS.BgnTimeDate,");
	    	strBuf.append(" FORMAT(SS.BgnTimeDate,'HH:mm') AS BgnTime,");
	    	strBuf.append(" SS.EndTimeDate,");
	    	strBuf.append(" FORMAT(SS.EndTimeDate,'HH:mm') AS EndTime,");
	    	strBuf.append(" MK.KinmuBashoName,");
	    	strBuf.append(" MK.Address_PostNo,");
	    	strBuf.append(" MK.Address_Main,");
	    	strBuf.append(" MK.Address_Sub,");
	    	strBuf.append(" MGYO.Name AS GyomuKubunName,");
	    	strBuf.append(" MKIM.Name AS KinmuKubunName,");
	    	strBuf.append(" MKEI.Name AS KeiyakuKubunName,");
	    	strBuf.append(" SS.Worker_ID,");
	    	strBuf.append(" SS.Keiyaku_ID");
	    	strBuf.append(" FROM P_Shift_SheetDataUp SS");
	    	strBuf.append(" LEFT OUTER JOIN P_MW_Worker MW");
	    	strBuf.append(" ON SS.Worker_ID = MW.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_Keiyaku MK");
	    	strBuf.append(" ON SS.Keiyaku_ID = MK.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_GyomuKubun MGYO");
	    	strBuf.append(" ON MK.GyomuKubun_ID = MGYO.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KinmuKubun MKIM");
	    	strBuf.append(" ON MK.KinmuKubun_ID = MKIM.Id");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KeiyakuKubun MKEI");
	    	strBuf.append(" ON MK.KeiyakuKubun_ID = MKEI.Id");
	    	strBuf.append(" WHERE MW.Id = ");
	    	strBuf.append(loginid);
	    	// 該当月のシフトを取得する
	    	strBuf.append(" AND SS.BgnTimeDate <= EOMONTH('" + subDate + "')");
	    	strBuf.append(" AND SS.BgnTimeDate >= DATEADD(dd, 1, EOMONTH ('" + subDate + "' , -1))");
	    	strBuf.append(" ORDER BY SS.BgnTimeDate");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
			    // 検索結果格納用
				ShiftInfo shiftInfo = new ShiftInfo();
  		   	shiftInfo.shiftHiduke		= result.getString("ShiftHiduke");
  		   	shiftInfo.bgnTimeDate		= result.getString("BgnTimeDate");
  		   	shiftInfo.bgnTime			= result.getString("BgnTime");
  		   	shiftInfo.endTimeDate		= result.getString("EndTimeDate");
  		   	shiftInfo.endTime			= result.getString("EndTime");
  		   	shiftInfo.kinmuBashoName	= result.getString("KinmuBashoName");
  		   	shiftInfo.adrPostNo			= result.getString("Address_PostNo");
  		   	shiftInfo.adrMain			= result.getString("Address_Main");
  		   	shiftInfo.adrSub			= result.getString("Address_Sub");
  		   	shiftInfo.gyomuKubunName	= result.getString("GyomuKubunName");
  		   	shiftInfo.kinmuKubunName	= result.getString("KinmuKubunName");
  		   	shiftInfo.keiyakuKubunName	= result.getString("KeiyakuKubunName");
  		   	shiftInfo.workerId			= result.getString("Worker_ID");
  		   	shiftInfo.keiyakuId			= result.getString("Keiyaku_ID");
  		   	listInfo.add(shiftInfo);
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
  	return listInfo;
	}
}
