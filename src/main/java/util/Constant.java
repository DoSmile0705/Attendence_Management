package util;

/** 定数クラス **/
public class Constant {
	private Constant() {}
	// SQL Server接続文字列
    /** ▼▼▼2022/7/29 DB接続先を変更▼▼▼ **/
	// テスト用
	//public static final String URL = "jdbc:sqlserver://sac.database.windows.net:1433;database=SAC_Data;user=dbadmin@sac;password=sac001SAC001;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
	// 本番用
	//public static final String URL = "jdbc:sqlserver://sacportal.database.windows.net:1433;database=DSK_Data;user=dbadmin@sacportal;password=sac001SAC001;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
    /** ▲▲▲2022/7/29 DB接続先を変更▲▲▲ **/
    //▼▼▼2022.9.15 DB接続文字をAzureに設定▼▼▼
    //WebAppsの環境変数から値を取得
	public static String hostName	= System.getenv("SQLCONNSTR_serverId");
	public static String dbName	= System.getenv("SQLAZURECONNSTR_dbId");
	public static String user		= System.getenv("SQLCONNSTR_useId");
	public static String password	= System.getenv("SQLCONNSTR_pass");
    public static final String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;", hostName, dbName, user, password);
    //▲▲▲2022.9.15 DB接続文字をAzureに設定▲▲▲
	// JDBCドライバ
	public static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	// 文字列暗号化用
	public static final String ENCRYPT_KEY		= "oP3feFoWLoEwaa12";
	public static final String ENCRYPT_IV		= "eF20TGd0kdfe5Ye9";
	// 文字コード
	public static final String CHARSET			= "UTF-8";
	// 暗号方式
	public static final String CRYRTOGRAPHY	= "AES";
	public static final String CIPHERTEXT		= "AES/CBC/PKCS5Padding";
}
