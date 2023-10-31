package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.SystemValue;

public class P_System_Value {
	/**
	   * selectメソッド
	   * P_System_Valueの検索結果を返す
	   * @return 検索結果
	   */
	public List<SystemValue> select() {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<SystemValue> systemValueList = new ArrayList<>();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" Id");
	    	strBuf.append(" ,SystemHeaderNo");
	    	strBuf.append(" ,SystemValueCD");
	    	strBuf.append(" ,SystemValueNum");
	    	strBuf.append(" ,SystemValueText");
	    	strBuf.append(" ,SystemNote");
	    	strBuf.append(" ,CompanyId");
	    	strBuf.append(" FROM P_System_Value");
	    	strBuf.append(" WHERE SystemHeaderNo = 101");
	    	strBuf.append(" ORDER BY SystemValueCD");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()){
		    	SystemValue systemValue = new SystemValue();
		    	systemValue.id				= Integer.valueOf(result.getInt("Id")).toString();
		    	systemValue.systemHeaderNo	= Integer.valueOf(result.getInt("SystemHeaderNo")).toString();
		    	systemValue.systemValueCD	= Integer.valueOf(result.getInt("SystemValueCD")).toString();
		    	systemValue.systemValueNum	= Integer.valueOf(result.getInt("SystemValueNum")).toString();
		    	systemValue.systemValueText	= result.getString("SystemValueText");
		    	systemValue.systemNote		= result.getString("SystemNote");
		    	systemValue.companyId		= Integer.valueOf(result.getInt("CompanyId")).toString();
		    	systemValueList.add(systemValue);
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
	    return systemValueList;
	}
}
