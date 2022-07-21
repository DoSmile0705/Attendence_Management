package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import util.LoginInfo;
import util.UtilConv;

public class P_MW_Worker {
	
	// SQL Server接続文字列
	private static final String URL = "jdbc:sqlserver://sac.database.windows.net:1433;database=SAC_Data;user=dbadmin@sac;password=sac001SAC001;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
	// JDBCドライバ
	private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	/**
	   * selectメソッド
	   * P_MW_Workerの検索結果を返す
	   * @param　loginid ログインID
	   * @return　検索結果
	   */
	public LoginInfo select(String loginid) {
		// コネクション格納用
	    Connection conn = null;
	    // 返却用ログイン情報コンテナクラス
	    LoginInfo loginInfo = new LoginInfo();
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
	    try {
	    	
	    	Class.forName(DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(URL);
	    	Statement stmt = conn.createStatement();
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT ");
	    	strBuf.append("Id ");
	    	strBuf.append(",WorkerIndex ");
	    	strBuf.append(",WorkerCD ");
	    	strBuf.append(",FirstName_Value ");
	    	strBuf.append(",LastName_Value ");
	    	strBuf.append(",FirstRubi_Value ");
	    	strBuf.append(",LastRubi_Value ");
	    	strBuf.append(",Email_Value ");
	    	strBuf.append(",NushaDate_Value ");
	    	strBuf.append(",RetireDate_Value ");
	    	strBuf.append(",KoyoFlag ");
	    	strBuf.append(",AdminLv ");
	    	strBuf.append(",OrderFlag1 ");
	    	strBuf.append(",OrderFlag2 ");
	    	strBuf.append(",AspIdentityId ");
	    	strBuf.append(",GeoIdo_Value ");
	    	strBuf.append(",GeoKeido_Value ");
	    	strBuf.append(",LoginInfo1_Value ");
	    	strBuf.append(",LoginInfo2_Value ");
	    	strBuf.append(",WorkerValue01 ");
	    	strBuf.append(",WorkerValue02 ");
	    	strBuf.append(",WorkerValue03 ");
	    	strBuf.append(",WorkerValue04 ");
	    	strBuf.append(",WorkerValue05 ");
	    	strBuf.append(",WorkerValue06 ");
	    	strBuf.append(",WorkerValue07 ");
	    	strBuf.append(",WorkerValue08 ");
	    	strBuf.append(",WorkerValue09 ");
	    	strBuf.append(",WorkerValue10 ");
	    	strBuf.append(",BranchCD ");
	    	strBuf.append(",IsDeleteFlag ");
	    	strBuf.append(",CONVERT(VARCHAR(30), EntryDate) AS EntryDate ");
	    	strBuf.append(",PassCode ");
	    	strBuf.append(",PassCode2 ");
	    	strBuf.append(",Company_ID ");
	    	strBuf.append(",Division_ID ");
	    	strBuf.append(",ShozokuKubun_ID ");
	    	strBuf.append("FROM P_MW_Worker ");
	    	strBuf.append("WHERE Id = ");
	    	strBuf.append(loginid);
	    	
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	/*** 2022.07.05 バックアップ
	    	String sql = "SELECT * FROM P_MW_Worker WHERE Id = " + loginid;
	    	ResultSet result = stmt.executeQuery(sql);
	    	***/
	    	while(result.next()) {
		    	// IDはユニークコードなので一意なハズ
		    	loginInfo.id				= Integer.valueOf(result.getInt("Id")).toString();
		    	loginInfo.workerIndex		= Integer.valueOf(result.getInt("WorkerIndex")).toString();
		    	loginInfo.workerCD			= Integer.valueOf(result.getInt("WorkerCD")).toString();
		    	// 暗号化されている文字列は復号化
		    	loginInfo.firstName_Value	= utilConv.decrypt(result.getString("FirstName_Value"));
		    	loginInfo.lastName_Value	= utilConv.decrypt(result.getString("LastName_Value"));
		    	loginInfo.firstRubi_Value	= utilConv.decrypt(result.getString("FirstRubi_Value"));
		    	loginInfo.lastRubi_Value	= utilConv.decrypt(result.getString("LastRubi_Value"));
		    	loginInfo.email_Value		= utilConv.decrypt(result.getString("Email_Value"));
		    	loginInfo.nushaDate_Value	= Integer.valueOf(result.getInt("NushaDate_Value")).toString();
		    	loginInfo.retireDate_Value	= Integer.valueOf(result.getInt("RetireDate_Value")).toString();
		    	loginInfo.koyoFlag			= Integer.valueOf(result.getInt("KoyoFlag")).toString();
		    	loginInfo.adminLv			= Integer.valueOf(result.getInt("AdminLv")).toString();
		    	loginInfo.orderFlag1		= Integer.valueOf(result.getInt("OrderFlag1")).toString();
		    	loginInfo.orderFlag2		= Integer.valueOf(result.getInt("OrderFlag2")).toString();
		    	loginInfo.aspIdentityId		= result.getString("AspIdentityId");
		    	// 暗号化されている文字列は復号化
		    	loginInfo.geoIdo_Value		= utilConv.decrypt(result.getString("GeoIdo_Value"));
		    	loginInfo.geoKeido_Value	= utilConv.decrypt(result.getString("GeoKeido_Value"));
		    	loginInfo.loginInfo1_Value	= utilConv.decrypt(result.getString("LoginInfo1_Value"));
		    	loginInfo.loginInfo2_Value	= utilConv.decrypt(result.getString("LoginInfo2_Value"));
		    	loginInfo.workerValue01		= Integer.valueOf(result.getInt("WorkerValue01")).toString();
		    	loginInfo.workerValue02		= Integer.valueOf(result.getInt("WorkerValue02")).toString();
		    	loginInfo.workerValue03		= Integer.valueOf(result.getInt("WorkerValue03")).toString();
		    	loginInfo.workerValue04		= Integer.valueOf(result.getInt("WorkerValue04")).toString();
		    	loginInfo.workerValue05		= Integer.valueOf(result.getInt("WorkerValue05")).toString();
		    	loginInfo.workerValue06		= Integer.valueOf(result.getInt("WorkerValue06")).toString();
		    	loginInfo.workerValue07		= Integer.valueOf(result.getInt("WorkerValue07")).toString();
		    	loginInfo.workerValue08		= Integer.valueOf(result.getInt("WorkerValue08")).toString();
		    	loginInfo.workerValue09		= Integer.valueOf(result.getInt("WorkerValue09")).toString();
		    	loginInfo.workerValue10		= Integer.valueOf(result.getInt("WorkerValue10")).toString();
		    	loginInfo.branchCD			= Integer.valueOf(result.getInt("BranchCD")).toString();
		    	loginInfo.isDeleteFlag		= Integer.valueOf(result.getInt("IsDeleteFlag")).toString();
		    	loginInfo.entryDate			= result.getString("EntryDate");
		    	loginInfo.passCode			= result.getString("PassCode");
		    	loginInfo.passCode2			= result.getString("PassCode2");
		    	loginInfo.company_ID		= Integer.valueOf(result.getInt("Company_ID")).toString();
		    	loginInfo.division_ID		= Integer.valueOf(result.getInt("Division_ID")).toString();
		    	loginInfo.shozokuKubun_ID	= Integer.valueOf(result.getInt("ShozokuKubun_ID")).toString();
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
	    // 検索結果を返却
	    return loginInfo;
	}

}
