package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.RequestMasterData;
import util.UtilConv;

public class P_MK_RequestData {

	/**
	   * selectメソッド
	   * P_Kinmu_Dataの検索結果を返す
	   * @param　loginid ログインID
	   * @return　検索結果
	   */
	public List<RequestMasterData> select(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 返却用ログイン情報コンテナクラス
	    List<RequestMasterData> requestMasterList = new ArrayList<>();
	    // 復号化するためのクラス
	    UtilConv utilConv = new UtilConv();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);
	    	Statement stmt = conn.createStatement();
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" Id");
	    	strBuf.append(" ,KubunCD");
	    	strBuf.append(" ,CompanyId");
	    	strBuf.append(" ,KubunName");
	    	strBuf.append(" ,OrderFlag");
	    	strBuf.append(" FROM P_MK_RequestData");
	    	strBuf.append(" WHERE CompanyId = ");
	    	strBuf.append(workInfo.get(0));

	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
	    		RequestMasterData requestMaster = new RequestMasterData();
	    		requestMaster.id		= Integer.valueOf(result.getInt("Id")).toString();
	    		requestMaster.kubunCD	= Integer.valueOf(result.getInt("KubunCD")).toString();
	    		requestMaster.companyId	= Integer.valueOf(result.getInt("CompanyId")).toString();
	    		requestMaster.kubunName	= result.getString("KubunName");
	    		requestMaster.orderFlag	= Integer.valueOf(result.getInt("OrderFlag")).toString();
	    		requestMasterList.add(requestMaster);
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
	    return requestMasterList;
	}
}
