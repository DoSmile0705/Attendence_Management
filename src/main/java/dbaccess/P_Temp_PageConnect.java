package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import util.Constant;
import util.PageConnect;
import util.UtilConv;

public class P_Temp_PageConnect {

	/**
	   * insertメソッド
	   * P_TEMP_PageLinkにデータを登録する
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
	    	strBuf.append("INSERT INTO P_Temp_PageConnect");
	    	strBuf.append(" (CompanyId,WorkerId,DataId,GuidKey1,GuidKey2,ConnectPage,ConnectKey1,ConnectKey2,KeyValue1,KeyValue2,KeyValue3,KeyValue4,KeyValue5,KeyValue6,KeyValue7,KeyValue8,KeyValue9,EntryDate)");
	    	strBuf.append(" VALUES");
	    	strBuf.append(" (");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(1));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(2));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(3));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(4));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(5));
	    	strBuf.append(",");
	    	strBuf.append(workInfo.get(6));
	    	strBuf.append(",'','','','','','','','','',''");
	    	strBuf.append(",DATEADD(HOUR, 9, GETDATE())");
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
	   * P_MW_Workerの検索結果を返す
	   * @param　loginid ログインID
	   * @return　検索結果
	   */
	public PageConnect select(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 返却用ログイン情報コンテナクラス
	    PageConnect pageCon = new PageConnect();
    	// 復号化するためのクラス
        UtilConv utilConv = new UtilConv();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);
	    	Statement stmt = conn.createStatement();
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT Id ");
	    	strBuf.append(",CompanyId ");
	    	strBuf.append(",WorkerId ");
	    	strBuf.append(",DataId ");
	    	strBuf.append(",GuidKey1 ");
	    	strBuf.append(",GuidKey2 ");
	    	strBuf.append(",ConnectPage ");
	    	strBuf.append(",ConnectKey1 ");
	    	strBuf.append(",ConnectKey2 ");
	    	strBuf.append(",KeyValue1 ");
	    	strBuf.append(",KeyValue2 ");
	    	strBuf.append(",KeyValue3 ");
	    	strBuf.append(",KeyValue4 ");
	    	strBuf.append(",KeyValue5 ");
	    	strBuf.append(",KeyValue6 ");
	    	strBuf.append(",KeyValue7 ");
	    	strBuf.append(",KeyValue8 ");
	    	strBuf.append(",KeyValue9 ");
	    	strBuf.append(",EntryDate ");
	    	strBuf.append(" FROM P_Temp_PageConnect ");
	    	strBuf.append(" WHERE CompanyId = ");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" AND WorkerId = ");
	    	strBuf.append(workInfo.get(1));
	    	strBuf.append(" AND DataId = ");
	    	strBuf.append(workInfo.get(2));
	    	strBuf.append(" AND GuidKey1 = ");
	    	strBuf.append("'");
	    	strBuf.append(workInfo.get(3));
	    	strBuf.append("'");
	    	ResultSet result = stmt.executeQuery(strBuf.toString());
	    	while(result.next()) {
	    		pageCon.id			= Integer.valueOf(result.getInt("Id")).toString();
	    		pageCon.companyId	= Integer.valueOf(result.getInt("CompanyId")).toString();
	    		pageCon.workerId	= Integer.valueOf(result.getInt("WorkerId")).toString();
	    		pageCon.dataId		= Integer.valueOf(result.getInt("DataId")).toString();
	    		pageCon.guidKey1	= result.getString("GuidKey1");
	    		pageCon.guidKey2	= result.getString("GuidKey2");
	    		pageCon.connectPage	= Integer.valueOf(result.getInt("ConnectPage")).toString();
	    		pageCon.connectKey1	= utilConv.decrypt(result.getString("ConnectKey1"));
	    		pageCon.connectKey2	= utilConv.decrypt(result.getString("ConnectKey2"));
	    		pageCon.keyValue1	= result.getString("KeyValue1");
	    		pageCon.keyValue2	= result.getString("KeyValue2");
	    		pageCon.keyValue3	= result.getString("KeyValue3");
	    		pageCon.keyValue4	= result.getString("KeyValue4");
	    		pageCon.keyValue5	= result.getString("KeyValue5");
	    		pageCon.keyValue6	= result.getString("KeyValue6");
	    		pageCon.keyValue7	= result.getString("KeyValue7");
	    		pageCon.keyValue8	= result.getString("KeyValue8");
	    		pageCon.keyValue9	= result.getString("KeyValue9");
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
	    return pageCon;
		
	}
}
