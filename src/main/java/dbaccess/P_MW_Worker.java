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
	    	String sql = "SELECT * FROM P_MW_Worker WHERE Id = " + loginid;
	    	ResultSet result = stmt.executeQuery(sql);
	    	while(result.next()) {
		    	// IDはユニークコードなので一意なハズ
		    	loginInfo.id				= Integer.valueOf(result.getInt("Id")).toString();
		    	loginInfo.workerIndex		= Integer.valueOf(result.getInt("workerIndex")).toString();
		    	loginInfo.workerCD			= Integer.valueOf(result.getInt("workerCD")).toString();
		    	// 暗号化されている文字列は復号化
		    	loginInfo.firstName_Value	= utilConv.decrypt(result.getString("firstName_Value"));
		    	loginInfo.lastName_Value	= utilConv.decrypt(result.getString("lastName_Value"));
		    	loginInfo.firstRubi_Value	= utilConv.decrypt(result.getString("firstRubi_Value"));
		    	loginInfo.lastRubi_Value	= utilConv.decrypt(result.getString("lastRubi_Value"));
		    	loginInfo.email_Value		= utilConv.decrypt(result.getString("email_Value"));
		    	loginInfo.nushaDate_Value	= Integer.valueOf(result.getInt("nushaDate_Value")).toString();
		    	loginInfo.retireDate_Value	= Integer.valueOf(result.getInt("retireDate_Value")).toString();
		    	loginInfo.koyoFlag			= Integer.valueOf(result.getInt("koyoFlag")).toString();
		    	loginInfo.adminLv			= Integer.valueOf(result.getInt("adminLv")).toString();
		    	loginInfo.orderFlag1		= Integer.valueOf(result.getInt("orderFlag1")).toString();
		    	loginInfo.orderFlag2		= Integer.valueOf(result.getInt("orderFlag2")).toString();
		    	loginInfo.aspIdentityId		= result.getString("aspIdentityId");
		    	// 暗号化されている文字列は復号化
		    	loginInfo.geoIdo_Value		= utilConv.decrypt(result.getString("geoIdo_Value"));
		    	loginInfo.geoKeido_Value	= utilConv.decrypt(result.getString("geoKeido_Value"));
		    	loginInfo.loginInfo1_Value	= utilConv.decrypt(result.getString("loginInfo1_Value"));
		    	loginInfo.loginInfo2_Value	= utilConv.decrypt(result.getString("loginInfo2_Value"));
		    	loginInfo.workerValue01		= Integer.valueOf(result.getInt("workerValue01")).toString();
		    	loginInfo.workerValue02		= Integer.valueOf(result.getInt("workerValue02")).toString();
		    	loginInfo.workerValue03		= Integer.valueOf(result.getInt("workerValue03")).toString();
		    	loginInfo.workerValue04		= Integer.valueOf(result.getInt("workerValue04")).toString();
		    	loginInfo.workerValue05		= Integer.valueOf(result.getInt("workerValue05")).toString();
		    	loginInfo.workerValue06		= Integer.valueOf(result.getInt("workerValue06")).toString();
		    	loginInfo.workerValue07		= Integer.valueOf(result.getInt("workerValue07")).toString();
		    	loginInfo.workerValue08		= Integer.valueOf(result.getInt("workerValue08")).toString();
		    	loginInfo.workerValue09		= Integer.valueOf(result.getInt("workerValue09")).toString();
		    	loginInfo.workerValue10		= Integer.valueOf(result.getInt("workerValue10")).toString();
		    	loginInfo.branchCD			= Integer.valueOf(result.getInt("branchCD")).toString();
		    	loginInfo.isDeleteFlag		= Integer.valueOf(result.getInt("isDeleteFlag")).toString();
		    	loginInfo.entryDate			= Integer.valueOf(result.getInt("entryDate")).toString();
		    	loginInfo.passCode			= result.getString("passCode");
		    	loginInfo.passCode2			= result.getString("passCode2");
		    	loginInfo.company_ID		= Integer.valueOf(result.getInt("company_ID")).toString();
		    	loginInfo.division_ID		= Integer.valueOf(result.getInt("division_ID")).toString();
		    	loginInfo.shozokuKubun_ID	= Integer.valueOf(result.getInt("shozokuKubun_ID")).toString();
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
