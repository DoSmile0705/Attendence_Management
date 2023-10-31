package dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.Constant;
import util.KinmuData;
import util.UtilConv;

public class P_Kinmu_Data {

	/**
	   * selectメソッド
	   * P_Kinmu_Dataの検索結果を返す
	   * @param　loginid ログインID
	   * @return　検索結果
	   */
	public List<KinmuData> select(List workInfo) {
		// コネクション格納用
	    Connection conn = null;
	    // 返却用ログイン情報コンテナクラス
	    List<KinmuData> kinmuList = new ArrayList<>();
	    // 復号化するためのクラス
	    UtilConv utilConv = new UtilConv();
	    try {
	    	
	    	Class.forName(Constant.DRIVER).getDeclaredConstructor().newInstance();
	    	conn = DriverManager.getConnection(Constant.URL);
	    	Statement stmt = conn.createStatement();
	    	StringBuilder strBuf = new StringBuilder();
	    	strBuf.append("SELECT");
	    	strBuf.append(" KinmuDataIndex");
	    	strBuf.append(" ,KinmuDate_Value");
	    	strBuf.append(" ,KinmuBashoName");
	    	strBuf.append(" ,KintaiFlag");
	    	strBuf.append(" ,KinmuDataName01_Value");
	    	strBuf.append(" ,KinmuDataName02_Value");
	    	strBuf.append(" ,KinmuDataName03_Value");
	    	strBuf.append(" ,KinmuDataName04_Value");
	    	strBuf.append(" ,KinmuDataName05_Value");
	    	strBuf.append(" ,KinmuDataName06_Value");
	    	strBuf.append(" ,KinmuDataName07_Value");
	    	strBuf.append(" ,KinmuDataName08_Value");
	    	strBuf.append(" ,KinmuDataName09_Value");
	    	strBuf.append(" ,KinmuDataName10_Value");
	    	strBuf.append(" ,KinmuDataName11_Value");
	    	strBuf.append(" ,KinmuDataName12_Value");
	    	strBuf.append(" ,KinmuDataName13_Value");
	    	strBuf.append(" ,KinmuDataName14_Value");
	    	strBuf.append(" ,KinmuDataName15_Value");
	    	strBuf.append(" ,KinmuDataName16_Value");
	    	strBuf.append(" ,KinmuDataName17_Value");
	    	strBuf.append(" ,KinmuDataName18_Value");
	    	strBuf.append(" ,KinmuDataName19_Value");
	    	strBuf.append(" ,KinmuDataName20_Value");
	    	strBuf.append(" ,TimeFlag");
	    	strBuf.append(" ,Times_BgnTime_Value");
	    	strBuf.append(" ,Times_EndTime_Value");
	    	strBuf.append(" ,Times_BreakHiruTime_Value");
	    	strBuf.append(" ,Times_BreakYoruTime_Value");
	    	strBuf.append(" ,Times_BreakTaiki_Value");
	    	strBuf.append(" ,Times_KousokuTime_Value");
	    	strBuf.append(" ,Times_WorkTime_Value");
	    	strBuf.append(" ,Times_TrueKinmuTime_Value");
	    	strBuf.append(" ,Times_Note");
	    	strBuf.append(" ,DataValue01");
	    	strBuf.append(" ,DataValue02");
	    	strBuf.append(" ,DataValue03");
	    	strBuf.append(" ,DataValue04");
	    	strBuf.append(" ,DataValue05");
	    	strBuf.append(" ,DataValue06");
	    	strBuf.append(" ,DataValue07");
	    	strBuf.append(" ,DataValue08");
	    	strBuf.append(" ,DataValue09");
	    	strBuf.append(" ,DataValue10");
	    	strBuf.append(" ,EntryDate");
	    	strBuf.append(" ,PassCode");
	    	strBuf.append(" ,PassCode2");
	    	strBuf.append(" ,Worker_ID");
	    	strBuf.append(" FROM P_Kinmu_Data");
	    	strBuf.append(" WHERE Worker_ID = ");
	    	strBuf.append(workInfo.get(0));
	    	strBuf.append(" AND KinmuDate_Value >= ");
	    	strBuf.append(workInfo.get(1));
	    	strBuf.append(" AND KinmuDate_Value <= ");
	    	strBuf.append(workInfo.get(2));

	    	ResultSet result = stmt.executeQuery(strBuf.toString());

	    	while(result.next()) {
	    		KinmuData kinmuData = new KinmuData();
	    		kinmuData.kinmuDataIndex			= Integer.valueOf(result.getInt("KinmuDataIndex")).toString();
	    		kinmuData.kinmuDate_Value			= Integer.valueOf(result.getInt("KinmuDate_Value")).toString();
	    		kinmuData.kinmuBashoName			= result.getString("KinmuBashoName");
	    		kinmuData.kintaiFlag				= Integer.valueOf(result.getInt("KintaiFlag")).toString();
	    		kinmuData.kinmuDataName01_Value		= result.getString("KinmuDataName01_Value");
	    		kinmuData.kinmuDataName02_Value		= result.getString("KinmuDataName02_Value");
	    		kinmuData.kinmuDataName03_Value		= result.getString("KinmuDataName03_Value");
	    		kinmuData.kinmuDataName04_Value		= result.getString("KinmuDataName04_Value");
	    		kinmuData.kinmuDataName05_Value		= result.getString("KinmuDataName05_Value");
	    		kinmuData.kinmuDataName06_Value		= result.getString("KinmuDataName06_Value");
	    		kinmuData.kinmuDataName07_Value		= result.getString("KinmuDataName07_Value");
	    		kinmuData.kinmuDataName08_Value		= result.getString("KinmuDataName08_Value");
	    		kinmuData.kinmuDataName09_Value		= result.getString("KinmuDataName09_Value");
	    		kinmuData.kinmuDataName10_Value		= result.getString("KinmuDataName10_Value");
	    		kinmuData.kinmuDataName11_Value		= result.getString("KinmuDataName11_Value");
	    		kinmuData.kinmuDataName12_Value		= result.getString("KinmuDataName12_Value");
	    		kinmuData.kinmuDataName13_Value		= result.getString("KinmuDataName13_Value");
	    		kinmuData.kinmuDataName14_Value		= result.getString("KinmuDataName14_Value");
	    		kinmuData.kinmuDataName15_Value		= result.getString("KinmuDataName15_Value");
	    		kinmuData.kinmuDataName16_Value		= result.getString("KinmuDataName16_Value");
	    		kinmuData.kinmuDataName17_Value		= result.getString("KinmuDataName17_Value");
	    		kinmuData.kinmuDataName18_Value		= result.getString("KinmuDataName18_Value");
	    		kinmuData.kinmuDataName19_Value		= result.getString("KinmuDataName19_Value");
	    		kinmuData.kinmuDataName20_Value		= result.getString("KinmuDataName20_Value");
	    		kinmuData.timeFlag					= Integer.valueOf(result.getInt("TimeFlag")).toString();
	    		kinmuData.times_BgnTime_Value		= Integer.valueOf(result.getInt("Times_BgnTime_Value")).toString();
	    		kinmuData.times_EndTime_Value		= Integer.valueOf(result.getInt("Times_EndTime_Value")).toString();
	    		kinmuData.times_BreakHiruTime_Value	= Integer.valueOf(result.getInt("Times_BreakHiruTime_Value")).toString();
	    		kinmuData.times_BreakYoruTime_Value	= Integer.valueOf(result.getInt("Times_BreakYoruTime_Value")).toString();
	    		kinmuData.times_BreakTaiki_Value	= Integer.valueOf(result.getInt("Times_BreakTaiki_Value")).toString();
	    		kinmuData.times_KousokuTime_Value	= Integer.valueOf(result.getInt("Times_KousokuTime_Value")).toString();
	    		kinmuData.times_WorkTime_Value		= Integer.valueOf(result.getInt("Times_WorkTime_Value")).toString();
	    		kinmuData.times_TrueKinmuTime_Value	= Integer.valueOf(result.getInt("Times_TrueKinmuTime_Value")).toString();
	    		kinmuData.times_Note				= result.getString("Times_Note");
	    		kinmuData.dataValue01				= Integer.valueOf(result.getInt("DataValue01")).toString();
	    		kinmuData.dataValue02				= Integer.valueOf(result.getInt("DataValue02")).toString();
	    		kinmuData.dataValue03				= Integer.valueOf(result.getInt("DataValue03")).toString();
	    		kinmuData.dataValue04				= Integer.valueOf(result.getInt("DataValue04")).toString();
	    		kinmuData.dataValue05				= Integer.valueOf(result.getInt("DataValue05")).toString();
	    		kinmuData.dataValue06				= Integer.valueOf(result.getInt("DataValue06")).toString();
	    		kinmuData.dataValue07				= Integer.valueOf(result.getInt("DataValue07")).toString();
	    		kinmuData.dataValue08				= Integer.valueOf(result.getInt("DataValue08")).toString();
	    		kinmuData.dataValue09				= Integer.valueOf(result.getInt("DataValue09")).toString();
	    		kinmuData.dataValue10				= Integer.valueOf(result.getInt("DataValue10")).toString();
	    		kinmuData.passCode					= result.getString("PassCode");
	    		kinmuData.passCode2					= result.getString("PassCode2");
	    		kinmuData.worker_ID					= Integer.valueOf(result.getInt("Worker_ID")).toString();
	    		kinmuList.add(kinmuData);
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
	    return kinmuList;
	}
}
