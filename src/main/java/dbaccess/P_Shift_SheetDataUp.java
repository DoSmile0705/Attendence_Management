package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.OtherGuard;
import util.ShiftInfo;
import util.UtilConv;

public class P_Shift_SheetDataUp {
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
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	//翌日のシフトを極力出力しないようにする
	    	//strBuf.append(" TOP (2)");
	    	strBuf.append(" SS.Id,");
	    	strBuf.append(" SS.ShiftHiduke,");
	    	strBuf.append(" SS.Note,");
	    	strBuf.append(" SS.BgnTimeDate,");
	    	strBuf.append(" FORMAT(SS.BgnTimeDate,'HH:mm') AS BgnTime,");
	    	strBuf.append(" SS.EndTimeDate,");
	    	strBuf.append(" FORMAT(SS.EndTimeDate,'HH:mm') AS EndTime,");
	    	strBuf.append(" MK.KinmuBashoName,");
	    	strBuf.append(" MK.Address_PostNo,");
	    	strBuf.append(" MK.Address_Main,");
	    	strBuf.append(" MK.Address_Sub,");
	    	strBuf.append(" MK.TimeFlag,");
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
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KintaiKubun MKIN");
	    	strBuf.append(" ON MK.KintaiKubun_ID = MKIN.Id");
	    	strBuf.append(" WHERE MW.Id = ");
	    	strBuf.append(loginid);
	    	//現在日時の丸1日前～翌日0時
	    	strBuf.append(" AND SS.BgnTimeDate >= DATEADD(DAY,DATEDIFF(DAY,0, DATEADD(HOUR,9,GETDATE())),-0.5)");
	    	strBuf.append(" AND SS.EndTimeDate <= DATEADD(DAY,DATEDIFF(DAY,0, DATEADD(HOUR,9,GETDATE())),1.5)");
	    	strBuf.append(" ORDER BY SS.BgnTimeDate,");
	    	strBuf.append(" SS.EndTimeDate");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
			    // 検索結果格納用
				ShiftInfo shiftInfo = new ShiftInfo();
    		   	shiftInfo.shiftHiduke		= result.getString("ShiftHiduke");
    		   	shiftInfo.note				= result.getString("Note");
    		   	shiftInfo.bgnTimeDate		= result.getString("BgnTimeDate");
    		   	shiftInfo.bgnTime			= result.getString("BgnTime");
    		   	shiftInfo.endTimeDate		= result.getString("EndTimeDate");
    		   	shiftInfo.endTime			= result.getString("EndTime");
    		   	shiftInfo.kinmuBashoName	= result.getString("KinmuBashoName");
    		   	shiftInfo.adrPostNo			= result.getString("Address_PostNo");
    		   	shiftInfo.adrMain			= result.getString("Address_Main");
    		   	shiftInfo.adrSub			= result.getString("Address_Sub");
    		   	shiftInfo.timeFlag			= Integer.valueOf(result.getInt("TimeFlag")).toString();
    		   	shiftInfo.gyomuKubunName	= result.getString("GyomuKubunName");
    		   	shiftInfo.kinmuKubunName	= result.getString("KinmuKubunName");
    		   	shiftInfo.keiyakuKubunName	= result.getString("KeiyakuKubunName");
    		   	shiftInfo.workerId			= result.getString("Worker_ID");
    		   	shiftInfo.keiyakuId			= result.getString("Keiyaku_ID");
    		   	shiftInfo.id				= Integer.valueOf(result.getInt("Id")).toString();
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
	public ShiftInfo selectNextShift(String loginid, String startDate) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    ShiftInfo shiftInfo = new ShiftInfo();
	    	
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" TOP (1)");
	    	strBuf.append(" SS.Id,");
	    	strBuf.append(" SS.ShiftHiduke,");
	    	strBuf.append(" SS.Note,");
	    	strBuf.append(" SS.BgnTimeDate,");
	    	strBuf.append(" FORMAT(SS.BgnTimeDate,'HH:mm') AS BgnTime,");
	    	strBuf.append(" SS.EndTimeDate,");
	    	strBuf.append(" FORMAT(SS.EndTimeDate,'HH:mm') AS EndTime,");
	    	strBuf.append(" MK.KinmuBashoName,");
	    	strBuf.append(" MK.Address_PostNo,");
	    	strBuf.append(" MK.Address_Main,");
	    	strBuf.append(" MK.Address_Sub,");
	    	strBuf.append(" MK.TimeFlag,");
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
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KintaiKubun MKIN");
	    	strBuf.append(" ON MK.KintaiKubun_ID = MKIN.Id");
	    	strBuf.append(" WHERE MW.Id = ");
	    	strBuf.append(loginid);
	    	// 次のシフトを取得する
	    	strBuf.append(" AND SS.BgnTimeDate > " + startDate);
	    	strBuf.append(" ORDER BY SS.BgnTimeDate");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
    		   	shiftInfo.shiftHiduke		= result.getString("ShiftHiduke");
    		   	shiftInfo.note				= result.getString("Note");
    		   	shiftInfo.bgnTimeDate		= result.getString("BgnTimeDate");
    		   	shiftInfo.bgnTime			= result.getString("BgnTime");
    		   	shiftInfo.endTimeDate		= result.getString("EndTimeDate");
    		   	shiftInfo.endTime			= result.getString("EndTime");
    		   	shiftInfo.kinmuBashoName	= result.getString("KinmuBashoName");
    		   	shiftInfo.adrPostNo			= result.getString("Address_PostNo");
    		   	shiftInfo.adrMain			= result.getString("Address_Main");
    		   	shiftInfo.adrSub			= result.getString("Address_Sub");
    		   	shiftInfo.timeFlag			= Integer.valueOf(result.getInt("TimeFlag")).toString();
    		   	shiftInfo.gyomuKubunName	= result.getString("GyomuKubunName");
    		   	shiftInfo.kinmuKubunName	= result.getString("KinmuKubunName");
    		   	shiftInfo.keiyakuKubunName	= result.getString("KeiyakuKubunName");
    		   	shiftInfo.workerId			= result.getString("Worker_ID");
    		   	shiftInfo.keiyakuId			= result.getString("Keiyaku_ID");
    		   	shiftInfo.id				= Integer.valueOf(result.getInt("Id")).toString();
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
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" SS.Id,");
	    	strBuf.append(" SS.ShiftHiduke,");
	    	strBuf.append(" SS.Note,");
	    	strBuf.append(" SS.BgnTimeDate,");
	    	strBuf.append(" FORMAT(SS.BgnTimeDate,'HH:mm') AS BgnTime,");
	    	strBuf.append(" SS.EndTimeDate,");
	    	strBuf.append(" FORMAT(SS.EndTimeDate,'HH:mm') AS EndTime,");
	    	strBuf.append(" MK.KinmuBashoName,");
	    	strBuf.append(" MK.Address_PostNo,");
	    	strBuf.append(" MK.Address_Main,");
	    	strBuf.append(" MK.Address_Sub,");
	    	strBuf.append(" MK.TimeFlag,");
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
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KintaiKubun MKIN");
	    	strBuf.append(" ON MK.KintaiKubun_ID = MKIN.Id");
	    	strBuf.append(" WHERE MW.Id = ");
	    	strBuf.append(loginid);
	    	// 該当月のシフトを取得する
	    	strBuf.append(" AND FORMAT(SS.BgnTimeDate,'yyyy-MM-dd HH:mm:ss.sss') <= EOMONTH('" + subDate + "')");
	    	strBuf.append(" AND FORMAT(SS.BgnTimeDate,'yyyy-MM-dd HH:mm:ss.sss') >= DATEADD(dd, 1, EOMONTH ('" + subDate + "' , -1))");
	    	strBuf.append(" ORDER BY SS.BgnTimeDate");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
			    // 検索結果格納用
				ShiftInfo shiftInfo = new ShiftInfo();
				shiftInfo.shiftHiduke		= result.getString("ShiftHiduke");
				shiftInfo.note				= result.getString("Note");
  		   		shiftInfo.bgnTimeDate		= result.getString("BgnTimeDate");
  		   		shiftInfo.bgnTime			= result.getString("BgnTime");
  		   		shiftInfo.endTimeDate		= result.getString("EndTimeDate");
  		   		shiftInfo.endTime			= result.getString("EndTime");
  		   		shiftInfo.kinmuBashoName	= result.getString("KinmuBashoName");
  		   		shiftInfo.adrPostNo			= result.getString("Address_PostNo");
  		   		shiftInfo.adrMain			= result.getString("Address_Main");
  		   		shiftInfo.adrSub			= result.getString("Address_Sub");
    		   	shiftInfo.timeFlag			= Integer.valueOf(result.getInt("TimeFlag")).toString();
  		   		shiftInfo.gyomuKubunName	= result.getString("GyomuKubunName");
  		   		shiftInfo.kinmuKubunName	= result.getString("KinmuKubunName");
  		   		shiftInfo.keiyakuKubunName	= result.getString("KeiyakuKubunName");
  		   		shiftInfo.workerId			= result.getString("Worker_ID");
  		   		shiftInfo.keiyakuId			= result.getString("Keiyaku_ID");
    		   	shiftInfo.id				= Integer.valueOf(result.getInt("Id")).toString();
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
	   * 本日のシフトを取得する
	   * P_Shift_SheetDataUpの検索結果を返す
	   * @param　loginid	ログインID
	   * @return　検索結果
	   */
	public ShiftInfo todaysShift(String loginid) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    ShiftInfo shiftInfo = new ShiftInfo();
	    	
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" TOP (1)");
	    	strBuf.append(" SS.Id,");
	    	strBuf.append(" SS.ShiftHiduke,");
	    	strBuf.append(" SS.Note,");
	    	strBuf.append(" SS.BgnTimeDate,");
	    	strBuf.append(" FORMAT(SS.BgnTimeDate,'HH:mm') AS BgnTime,");
	    	strBuf.append(" SS.EndTimeDate,");
	    	strBuf.append(" FORMAT(SS.EndTimeDate,'HH:mm') AS EndTime,");
	    	strBuf.append(" MK.KinmuBashoName,");
	    	strBuf.append(" MK.Address_PostNo,");
	    	strBuf.append(" MK.Address_Main,");
	    	strBuf.append(" MK.Address_Sub,");
	    	strBuf.append(" MK.TimeFlag,");
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
	    	strBuf.append(" LEFT OUTER JOIN P_MK_KintaiKubun MKIN");
	    	strBuf.append(" ON MK.KintaiKubun_ID = MKIN.Id");
	    	strBuf.append(" WHERE MW.Id = ");
	    	strBuf.append(loginid);
	    	// 本日のシフトを取得する
	    	strBuf.append(" AND SS.BgnTimeDate >= DATEADD(DAY,DATEDIFF(DAY,0, DATEADD(HOUR,9,GETDATE())),0)");
	    	strBuf.append(" AND SS.BgnTimeDate <= DATEADD(DAY,DATEDIFF(DAY,0, DATEADD(HOUR,9,GETDATE())),1)");
	    	strBuf.append(" ORDER BY SS.EndTimeDate DESC");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
		    	shiftInfo.shiftHiduke		= result.getString("ShiftHiduke");
		    	shiftInfo.note				= result.getString("Note");
  		   		shiftInfo.bgnTimeDate		= result.getString("BgnTimeDate");
  		   		shiftInfo.bgnTime			= result.getString("BgnTime");
  		   		shiftInfo.endTimeDate		= result.getString("EndTimeDate");
  		   		shiftInfo.endTime			= result.getString("EndTime");
  		   		shiftInfo.kinmuBashoName	= result.getString("KinmuBashoName");
  		   		shiftInfo.adrPostNo			= result.getString("Address_PostNo");
  		   		shiftInfo.adrMain			= result.getString("Address_Main");
  		   		shiftInfo.adrSub			= result.getString("Address_Sub");
  		   		shiftInfo.timeFlag			= Integer.valueOf(result.getInt("TimeFlag")).toString();
  		   		shiftInfo.gyomuKubunName	= result.getString("GyomuKubunName");
  		   		shiftInfo.kinmuKubunName	= result.getString("KinmuKubunName");
  		   		shiftInfo.keiyakuKubunName	= result.getString("KeiyakuKubunName");
  		   		shiftInfo.workerId			= result.getString("Worker_ID");
  		   		shiftInfo.keiyakuId			= result.getString("Keiyaku_ID");
  		   		shiftInfo.id				= Integer.valueOf(result.getInt("Id")).toString();
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
	   * 他の配置警備員を取得
	   * P_Shift_SheetDataUpの検索結果を返す
	   * @param		workInfo	パラメータセット
	   * @return	検索結果
	   */
	public List<OtherGuard> selectOtherGuard(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<OtherGuard> otherGuardList = new ArrayList<>();
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
	    	
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT DISTINCT D.BgnTimeDate, D.EndTimeDate,W.FirstName_Value,W.LastName_Value");
	    	strBuf.append(" FROM");
	    	strBuf.append(" P_Shift_SheetKeiyaku K,");
	    	strBuf.append(" P_Shift_SheetDataUp D,");
	    	strBuf.append(" P_MW_Worker W,");
	    	strBuf.append(" (SELECT DISTINCT K.ShiftSheet_ID");
	    	strBuf.append(" FROM");
	    	strBuf.append(" P_Shift_SheetKeiyaku K,");
	    	strBuf.append(" P_Shift_SheetDataUp D");
	    	strBuf.append(" WHERE D.Keiyaku_ID = K.Keiyaku_ID");
	    	strBuf.append(" AND D.ShiftHiduke = ");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" AND D.Keiyaku_ID = ");
	    	strBuf.append(workInfo.get(1));
	    	strBuf.append(") S");
	    	strBuf.append(" WHERE D.Keiyaku_ID = K.Keiyaku_ID");
	    	strBuf.append(" AND D.ShiftHiduke = ");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" AND K.ShiftSheet_ID = S.ShiftSheet_ID");
	    	strBuf.append(" AND D.Worker_ID = W.Id");
	    	strBuf.append(" ORDER BY D.BgnTimeDate,D.EndTimeDate");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	
		    while(result.next()){
		    	OtherGuard otherGuard = new OtherGuard();
		    	otherGuard.bgnTimeDate	= result.getString("BgnTimeDate");
		    	otherGuard.endTimeDate	= result.getString("EndTimeDate");
		    	otherGuard.firstName	= utilConv.decrypt(result.getString("FirstName_Value"));
		    	otherGuard.lastName		= utilConv.decrypt(result.getString("LastName_Value"));
		    	otherGuardList.add(otherGuard);
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
	    return otherGuardList;
	}
}
