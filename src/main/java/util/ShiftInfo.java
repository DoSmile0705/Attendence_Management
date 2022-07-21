package util;

// 当日シフト一覧のコンテナクラス
public class ShiftInfo {
	// メンバ変数
	public String	shiftHiduke;		// シフト日付
	public String	bgnTimeDate;		// 上番日付
	public String	bgnTime;			// 上番時刻
	public String	endTimeDate;		// 下番日付
	public String	endTime;			// 下番時刻
	public String	kinmuBashoName;		// ローカル配置先名称
	public String	gyomuKubunName;		// ローカル業務区分名称
	public String	kinmuKubunName;		// ローカル勤務区分名称
	public String	keiyakuKubunName;	// ローカル契約区分名称
	public String	workerId;			// 隊員ID
	public String	keiyakuId;			// 契約配置ID
	public String	bgnStampTime;		// 打刻済上番時刻
	public String	endStampTime;		// 打刻済下番時刻
	public String	adrPostNo;			// ローカル業務区分郵便番号
	public String	adrMain;			// ローカル業務区分住所１
	public String	adrSub;				// ローカル業務区分住所２
}