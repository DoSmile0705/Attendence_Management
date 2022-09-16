package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import util.Company;
import util.Constant;
import util.UtilConv;

public class P_MC_Company {
	/**
	   * selectメソッド
	   * P_MW_Workerの検索結果を返す
	   * @param　loginid ログインID
	   * @return　検索結果
	   */
	public Company select(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 会社情報コンテナクラス
	    Company company = new Company();
  	// 復号化するためのクラス
      UtilConv utilConv = new UtilConv();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);
	    	Statement stmt = conn.createStatement();
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" Id ");
	    	strBuf.append(",CompanyCode ");
	    	strBuf.append(",CompanyName ");
	    	strBuf.append(",CompanyShortNM ");
	    	strBuf.append(",PassWord ");
	    	strBuf.append(",PassWordB ");
	    	strBuf.append(",PassWordE ");
	    	strBuf.append(",DefaultShozokuIndex ");
	    	strBuf.append(",DefaultDivisionIndex ");
	    	strBuf.append(",IsDeleteFlag ");
	    	strBuf.append(",EntryDate ");
	    	strBuf.append(",PassCode ");
	    	strBuf.append(",PassCode2 ");
	    	strBuf.append(" FROM P_MC_Company ");
	    	strBuf.append(" WHERE CompanyCode = ");
	    	strBuf.append(workInfo.get(0));
	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	while(result.next()) {
	    		company.id						= Integer.valueOf(result.getInt("Id")).toString();
	    		company.companyCode				= Integer.valueOf(result.getInt("CompanyCode")).toString();
	    		company.companyName				= result.getString("CompanyName");
	    		company.companyShortNM			= result.getString("CompanyShortNM");
	    		company.passWord				= result.getString("PassWord");
	    		company.passWordB				= result.getString("PassWordB");
	    		company.passWordE				= result.getString("PassWordE");
	    		company.defaultShozokuIndex		= Integer.valueOf(result.getInt("DefaultShozokuIndex")).toString();
	    		company.defaultDivisionIndex	= Integer.valueOf(result.getInt("DefaultDivisionIndex")).toString();
	    		company.isDeleteFlag			= Integer.valueOf(result.getInt("IsDeleteFlag")).toString();
	    		company.passCode				= result.getString("PassCode");
	    		company.passCode2				= result.getString("PassCode2");
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
	    return company;
		
	}
}
