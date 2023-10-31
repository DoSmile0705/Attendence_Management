package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.SafetyInfo;

public class P_SF_Safety {
    /**
    * insertメソッド
    * P_SF_Safetyにデータを登録する
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
	    	strBuf.append("INSERT INTO P_SF_Safety");
	    	strBuf.append(" (WorkerID,CompanyId,SafetyFlag,Note,EntryDate)");
	    	strBuf.append(" VALUES");
	    	strBuf.append(" (");
	    	strBuf.append(workInfo.get(0));				//WorkerID
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(1));				//CompanyId
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(2));				//SafetyFlag
	    	strBuf.append(",");
	    	strBuf.append("'" + workInfo.get(3) + "'");	//Note
	    	strBuf.append(",");
	    	strBuf.append("DATEADD(HOUR,9,GETDATE())");	//EntryDate
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
	   * P_SF_Safetyの検索結果を返す
	   * @param　workInfo　パラメータ
	   * @return 検索結果
	   */
	public SafetyInfo select(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    SafetyInfo safety = new SafetyInfo();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" TOP(1)");
	    	strBuf.append(" SF.Id");
	    	strBuf.append(",SF.SafetyFlag");
	    	strBuf.append(",SF.Note");
	    	strBuf.append(",SF.EntryDate");
	    	strBuf.append(",MK.SafetyName");
	    	strBuf.append(",MK.SafetyLv");
	    	strBuf.append(",MK.IsDeleteFlag");
	    	strBuf.append(",MK.BackColor");
	    	strBuf.append(",MK.FontColor");
	    	strBuf.append(" FROM P_SF_Safety SF");
	    	strBuf.append(" LEFT OUTER JOIN P_MK_SafetyKubun MK");
	    	strBuf.append(" ON SF.SafetyFlag = MK.Id");
	    	strBuf.append(" WHERE SF.WorkerId = ");
   	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" ORDER BY EntryDate DESC");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
		    while(result.next()){
		    	safety.id				= Integer.valueOf(result.getInt("Id")).toString();
		    	safety.safetyFlag		= Integer.valueOf(result.getInt("SafetyFlag")).toString();
		    	safety.note				= result.getString("Note");
		    	safety.entryDate		= result.getString("EntryDate");
		    	safety.safetyName		= result.getString("SafetyName");
		    	safety.safetyLv			= Integer.valueOf(result.getInt("SafetyLv")).toString();
		    	safety.isDeleteFlag		= Integer.valueOf(result.getInt("IsDeleteFlag")).toString();
		    	safety.backColor		= result.getString("BackColor");
		    	safety.fontColor		= result.getString("FontColor");
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
	    return safety;
	}
	/**
	   * selectメソッド
	   * P_SF_Safetyの検索結果を返す
	   * @param　workInfo　パラメータ
	   * @return 検索結果
	   */
	public List<SafetyInfo> selectList(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 検索結果格納用
	    List<SafetyInfo> safetyList = new ArrayList<>();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);

	    	Statement stmt = conn.createStatement();
	    	
	    	// SQL構築用
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" MK.Id");
	    	strBuf.append(",MK.SafetyFlag");
	    	strBuf.append(",MK.SafetyName");
	    	strBuf.append(",MK.Note");
	    	strBuf.append(",MK.SafetyLv");
	    	strBuf.append(",MK.IsDeleteFlag");
	    	strBuf.append(",MK.BackColor");
	    	strBuf.append(",MK.FontColor");
	    	strBuf.append(" FROM P_MK_SafetyKubun MK");
	    	strBuf.append(" WHERE MK.CompanyId = ");
 	    	strBuf.append(workInfo.get(0));
 	    	strBuf.append(" AND MK.IsDeleteFlag = 0");

	    	ResultSet result = stmt.executeQuery(strBuf.toString());
		    while(result.next()){
			    SafetyInfo safety = new SafetyInfo();
		    	safety.id				= Integer.valueOf(result.getInt("Id")).toString();
		    	safety.safetyFlag		= Integer.valueOf(result.getInt("SafetyFlag")).toString();
		    	safety.safetyName		= result.getString("SafetyName");
		    	safety.note				= result.getString("Note");
		    	safety.safetyLv			= Integer.valueOf(result.getInt("SafetyLv")).toString();
		    	safety.isDeleteFlag		= Integer.valueOf(result.getInt("IsDeleteFlag")).toString();
		    	safety.backColor		= result.getString("BackColor");
		    	safety.fontColor		= result.getString("FontColor");
		    	//リストに追加
		    	safetyList.add(safety);
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
	    return safetyList;
	}
}
