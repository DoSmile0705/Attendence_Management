package util;

public class DataCheck {

	/**
	   * コンストラクタ
	   */
	public DataCheck () {
	}

	/**
	   * 文字列がNULLもしくは空かどうかを判定する
	   * @param		text	チェックする文字列
	   * @return	result	チェック後の文字列
	   */
	public String emptyOrNull(String text) {
		
		// 返却する文字列
		String result = text;
		if(text == null || text.isEmpty() || text.isBlank() || text.equals("null")) {
			result = null;
		}
		return result;
	}
	/**
	   * 引数がNULLだったら1を返す
	   * @param		num		チェックする数値
	   * @return	result	チェック後の数値
	   */
	@SuppressWarnings("null")
	public int nullToOne(String text) {
		
		// 返却する文字列
		int result = 0;
		if(text == null || text.isEmpty() || text.isBlank() || text.equals("null")) {
			result = 1;
		}else {
			result = Integer.parseInt(text);
		}
		return result;
	}
	/**
	   * 文字列がNULLの場合DB登録用に加工
	   * @param		text	加工対象文字列
	   * @return	result	加工後文字列
	   */
	public String stringForDB(String text) {
		
		// 返却する文字列
		String result = null;
		if(text == null) {
			result = "''";
		}else {
			result = "'" + text + "'";
		}
		return result;
	}
	/**
	   * 文字列がNULLもしくは空文字だったら空文字を返す
	   * @param		text	チェックする文字列
	   * @return	result	チェック後の文字列
	   */
	public String nullToBlank(String text) {
		
		// 返却する文字列
		String result = text;
		if(text == null || text.isEmpty() || text.isBlank() || text.equals("null")) {
			result = "";
		}
		return result;
	}
}
