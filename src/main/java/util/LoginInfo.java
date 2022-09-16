package util;

//当日シフト一覧のコンテナクラス
public class LoginInfo {
	// メンバ変数としてP_MW_Workerテーブルのカラムを定義
	public String	id;					// 社員番号
	public String	workerIndex;
	public String	workerCD;
	public String	firstName_Value;	// 苗字　※暗号化
	public String	lastName_Value;		// 名前　※暗号化
	public String	firstRubi_Value;
	public String	lastRubi_Value;
	public String	email_Value;		// メールアドレス　※暗号化
	public String	nushaDate_Value;
	public String	retireDate_Value;
	public String	koyoFlag;
	public String	adminLv;
	public String	orderFlag1;
	public String	orderFlag2;
	public String	aspIdentityId;
	public String	geoIdo_Value;		// 緯度　※暗号化
	public String	geoKeido_Value;		// 経度　※暗号化
	public String	loginInfo1_Value;	// パスワード１　※暗号化
	public String	loginInfo2_Value;	// パスワード２　※暗号化
	public String	workerValue01;
	public String	workerValue02;
	public String	workerValue03;
	public String	workerValue04;
	public String	workerValue05;
	public String	workerValue06;
	public String	workerValue07;
	public String	workerValue08;
	public String	workerValue09;
	public String	workerValue10;
	public String	branchCD;
	public String	isDeleteFlag;
	public String	entryDate;
	public String	passCode;
	public String	passCode2;
	public String	company_ID;
	public String	division_ID;
	public String	shozokuKubun_ID;
	public String	sessionId;			// ログインセッション　※暗号化
	public String	stampDate;			// 出発／定時打刻日時
	public String	companyCode;		// 会社コード
	public String	companyName;		// 会社名
}
