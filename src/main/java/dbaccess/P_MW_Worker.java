package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import util.Constant;
import util.LoginInfo;
import util.UtilConv;

public class P_MW_Worker {
	
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
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);
	    	Statement stmt = conn.createStatement();
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT ");
	    	strBuf.append("WK.Id ");
	    	strBuf.append(",WK.WorkerIndex ");
	    	strBuf.append(",WK.WorkerCD ");
	    	strBuf.append(",WK.FirstName_Value ");
	    	strBuf.append(",WK.LastName_Value ");
	    	strBuf.append(",WK.FirstRubi_Value ");
	    	strBuf.append(",WK.LastRubi_Value ");
	    	strBuf.append(",WK.Email_Value ");
	    	strBuf.append(",WK.NushaDate_Value ");
	    	strBuf.append(",WK.RetireDate_Value ");
	    	strBuf.append(",WK.KoyoFlag ");
	    	strBuf.append(",WK.AdminLv ");
	    	strBuf.append(",WK.OrderFlag1 ");
	    	strBuf.append(",WK.OrderFlag2 ");
	    	strBuf.append(",WK.AspIdentityId ");
	    	strBuf.append(",WK.GeoIdo_Value ");
	    	strBuf.append(",WK.GeoKeido_Value ");
	    	strBuf.append(",WK.LoginInfo1_Value ");
	    	strBuf.append(",WK.LoginInfo2_Value ");
	    	strBuf.append(",WK.WorkerValue01 ");
	    	strBuf.append(",WK.WorkerValue02 ");
	    	strBuf.append(",WK.WorkerValue03 ");
	    	strBuf.append(",WK.WorkerValue04 ");
	    	strBuf.append(",WK.WorkerValue05 ");
	    	strBuf.append(",WK.WorkerValue06 ");
	    	strBuf.append(",WK.WorkerValue07 ");
	    	strBuf.append(",WK.WorkerValue08 ");
	    	strBuf.append(",WK.WorkerValue09 ");
	    	strBuf.append(",WK.WorkerValue10 ");
	    	strBuf.append(",WK.BranchCD ");
	    	strBuf.append(",WK.IsDeleteFlag ");
	    	strBuf.append(",CONVERT(VARCHAR(30), WK.EntryDate) AS EntryDate ");
	    	strBuf.append(",WK.PassCode ");
	    	strBuf.append(",WK.PassCode2 ");
	    	strBuf.append(",WK.Company_ID ");
	    	strBuf.append(",WK.Division_ID ");
	    	strBuf.append(",WK.ShozokuKubun_ID ");
	    	strBuf.append(",WK.AdminLv ");
	    	strBuf.append(",CO.CompanyCode ");
	    	strBuf.append(",CO.CompanyName ");
	    	strBuf.append("FROM P_MW_Worker WK ");
	    	strBuf.append("LEFT OUTER JOIN P_MC_Company CO ");
	    	strBuf.append("ON WK.Company_ID = CO.Id ");
	    	strBuf.append("WHERE WK.WorkerIndex = ");
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
		    	// パスワード２は当面使わないので復号化しない
		    	//loginInfo.loginInfo2_Value	= utilConv.decrypt(result.getString("LoginInfo2_Value"));
		    	loginInfo.loginInfo2_Value	= result.getString("LoginInfo2_Value");
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
		    	loginInfo.companyCode		= Integer.valueOf(result.getInt("CompanyCode")).toString();
		    	loginInfo.companyName		= result.getString("CompanyName");
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
	/**
	   * selectメソッド
	   * P_MW_Workerの検索結果を返す
	   * @param　loginid ログインID
	   * @return　検索結果
	   */
	public LoginInfo selectAnother(String loginid) {
		// コネクション格納用
	    Connection conn = null;
	    // 返却用ログイン情報コンテナクラス
	    LoginInfo loginInfo = new LoginInfo();
  	// 復号化するためのクラス
      UtilConv utilConv = new UtilConv();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);
	    	Statement stmt = conn.createStatement();
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT ");
	    	strBuf.append("WK.Id ");
	    	strBuf.append(",WK.WorkerIndex ");
	    	strBuf.append(",WK.WorkerCD ");
	    	strBuf.append(",WK.FirstName_Value ");
	    	strBuf.append(",WK.LastName_Value ");
	    	strBuf.append(",WK.FirstRubi_Value ");
	    	strBuf.append(",WK.LastRubi_Value ");
	    	strBuf.append(",WK.Email_Value ");
	    	strBuf.append(",WK.NushaDate_Value ");
	    	strBuf.append(",WK.RetireDate_Value ");
	    	strBuf.append(",WK.KoyoFlag ");
	    	strBuf.append(",WK.AdminLv ");
	    	strBuf.append(",WK.OrderFlag1 ");
	    	strBuf.append(",WK.OrderFlag2 ");
	    	strBuf.append(",WK.AspIdentityId ");
	    	strBuf.append(",WK.GeoIdo_Value ");
	    	strBuf.append(",WK.GeoKeido_Value ");
	    	strBuf.append(",WK.LoginInfo1_Value ");
	    	strBuf.append(",WK.LoginInfo2_Value ");
	    	strBuf.append(",WK.WorkerValue01 ");
	    	strBuf.append(",WK.WorkerValue02 ");
	    	strBuf.append(",WK.WorkerValue03 ");
	    	strBuf.append(",WK.WorkerValue04 ");
	    	strBuf.append(",WK.WorkerValue05 ");
	    	strBuf.append(",WK.WorkerValue06 ");
	    	strBuf.append(",WK.WorkerValue07 ");
	    	strBuf.append(",WK.WorkerValue08 ");
	    	strBuf.append(",WK.WorkerValue09 ");
	    	strBuf.append(",WK.WorkerValue10 ");
	    	strBuf.append(",WK.BranchCD ");
	    	strBuf.append(",WK.IsDeleteFlag ");
	    	strBuf.append(",CONVERT(VARCHAR(30), WK.EntryDate) AS EntryDate ");
	    	strBuf.append(",WK.PassCode ");
	    	strBuf.append(",WK.PassCode2 ");
	    	strBuf.append(",WK.Company_ID ");
	    	strBuf.append(",WK.Division_ID ");
	    	strBuf.append(",WK.ShozokuKubun_ID ");
	    	strBuf.append(",WK.AdminLv ");
	    	strBuf.append(",CO.CompanyCode ");
	    	strBuf.append(",CO.CompanyName ");
	    	strBuf.append("FROM P_MW_Worker WK ");
	    	strBuf.append("LEFT OUTER JOIN P_MC_Company CO ");
	    	strBuf.append("ON WK.Company_ID = CO.Id ");
	    	strBuf.append("WHERE WK.Id = ");
	    	strBuf.append(loginid);
	    	
	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
		    	//IDはユニークコードなので一意なハズ
		    	loginInfo.id				= Integer.valueOf(result.getInt("Id")).toString();
		    	loginInfo.workerIndex		= Integer.valueOf(result.getInt("WorkerIndex")).toString();
		    	loginInfo.workerCD			= Integer.valueOf(result.getInt("WorkerCD")).toString();
		    	loginInfo.firstName_Value	= result.getString("FirstName_Value");
		    	loginInfo.lastName_Value	= result.getString("LastName_Value");
		    	loginInfo.firstRubi_Value	= result.getString("FirstRubi_Value");
		    	loginInfo.lastRubi_Value	= result.getString("LastRubi_Value");
		    	loginInfo.email_Value		= result.getString("Email_Value");
		    	loginInfo.nushaDate_Value	= Integer.valueOf(result.getInt("NushaDate_Value")).toString();
		    	loginInfo.retireDate_Value	= Integer.valueOf(result.getInt("RetireDate_Value")).toString();
		    	loginInfo.koyoFlag			= Integer.valueOf(result.getInt("KoyoFlag")).toString();
		    	loginInfo.adminLv			= Integer.valueOf(result.getInt("AdminLv")).toString();
		    	loginInfo.orderFlag1		= Integer.valueOf(result.getInt("OrderFlag1")).toString();
		    	loginInfo.orderFlag2		= Integer.valueOf(result.getInt("OrderFlag2")).toString();
		    	loginInfo.aspIdentityId		= result.getString("AspIdentityId");
		    	loginInfo.geoIdo_Value		= result.getString("GeoIdo_Value");
		    	loginInfo.geoKeido_Value	= result.getString("GeoKeido_Value");
		    	loginInfo.loginInfo1_Value	= result.getString("LoginInfo1_Value");
		    	// パスワード２は当面使わないので復号化しない
		    	//loginInfo.loginInfo2_Value	= utilConv.decrypt(result.getString("LoginInfo2_Value"));
		    	loginInfo.loginInfo2_Value	= result.getString("LoginInfo2_Value");
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
		    	loginInfo.companyCode		= Integer.valueOf(result.getInt("CompanyCode")).toString();
		    	loginInfo.companyName		= result.getString("CompanyName");
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
