package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.RequestKubun;

public class P_MK_RequestKubun {
	/**
	   * selectメソッド
	   * P_Shift_Requestの検索結果を返す
	   * @param　workInfo　パラメータ
	   * @return 検索結果
	   */
	public List<RequestKubun> select(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<RequestKubun> reqKubunList = new ArrayList<>();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" RequestFlag");
	    	strBuf.append(" ,RequestName");
	    	strBuf.append(" ,Note");
	    	strBuf.append(" ,TimeFlag");
	    	strBuf.append(" ,BackColorFlag");
	    	strBuf.append(" ,FontColorFlag");
	    	strBuf.append(" FROM P_MK_RequestKubun");
	    	strBuf.append(" WHERE");
	    	strBuf.append(" Company_ID = ");
	    	strBuf.append(workInfo.get(0));

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
		    while(result.next()){
		    	RequestKubun reqKubun = new RequestKubun();
		    	reqKubun.requestFlag	= Integer.valueOf(result.getInt("RequestFlag")).toString();
		    	reqKubun.requestName	= result.getString("RequestName");
		    	reqKubun.note			= result.getString("Note");
		    	reqKubun.timeFlag		= Integer.valueOf(result.getInt("TimeFlag")).toString();
		    	reqKubun.backColorFlag	= result.getString("BackColorFlag");
		    	reqKubun.fontColorFlag	= result.getString("FontColorFlag");
		    	reqKubunList.add(reqKubun);
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
	    return reqKubunList;
	}

}
