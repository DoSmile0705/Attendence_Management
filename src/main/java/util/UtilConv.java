package util;

import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class UtilConv {

	/**
	   * コンストラクタ
	   */
	public UtilConv () {
	}

	/**
	   * 暗号化メソッド
	   * AES暗号方式の暗号化文字列を返す
	   * @param　text 暗号化する文字列
	   * @return　encryptText 暗号化文字列
	   */
	public String encrypt(String text) {
		String encryptText = null;
		//パラメータがnullだったら処理しない
		if(text != null) {
			try {
				// 文字列をバイト配列へ変換
				byte[] byteText = text.getBytes(Constant.CHARSET);

				// 暗号化キーと初期化ベクトルをバイト配列へ変換
				byte[] byteKey = Constant.ENCRYPT_KEY.getBytes(Constant.CHARSET);
				byte[] byteIv  = Constant.ENCRYPT_IV.getBytes(Constant.CHARSET);

				// 暗号化キーと初期化ベクトルのオブジェクト生成
				SecretKeySpec key = new SecretKeySpec(byteKey, Constant.CRYRTOGRAPHY);
				IvParameterSpec iv = new IvParameterSpec(byteIv);

				// Cipherオブジェクト生成
				Cipher cipher = Cipher.getInstance(Constant.CIPHERTEXT);

				// Cipherオブジェクトの初期化
				cipher.init(Cipher.ENCRYPT_MODE, key, iv);

				// 暗号化の結果格納
				byte[] byteResult = cipher.doFinal(byteText);

				// Base64へエンコード
				encryptText = Base64.getEncoder().encodeToString(byteResult);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return encryptText;
	}

	/**
	   * 復号化メソッド
	   * AES暗号方式の復号化文字列を返す
	   * @param　text 復号化する文字列
	   * @return　decodeText 復号化文字列
	   */
	public String decrypt (String text) {
		String decodeText = null;
		//パラメータがnullだったら処理しない
		if(text != null) {
			try {
				// 暗号化キーと初期化ベクトルをバイト配列へ変換
				byte[] byteKey = Constant.ENCRYPT_KEY.getBytes(Constant.CHARSET);
				byte[] byteIv  = Constant.ENCRYPT_IV.getBytes(Constant.CHARSET);

				// 復号化キーと初期化ベクトルのオブジェクト生成
				SecretKeySpec key = new SecretKeySpec(byteKey, Constant.CRYRTOGRAPHY);
				IvParameterSpec iv = new IvParameterSpec(byteIv);

				// Cipherオブジェクト生成
				Cipher cipher = Cipher.getInstance(Constant.CIPHERTEXT);

				// Cipherオブジェクトの初期化
				cipher.init(Cipher.DECRYPT_MODE, key, iv);

				// 復号化の結果格納
				byte[] byteResult = cipher.doFinal(Base64.getDecoder().decode(text));

				// デコード
				decodeText = new String(byteResult, Constant.CHARSET);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return decodeText;
	}
	/**
	   * シフト一覧を取得する為の期日日の様式を取得する
	   * yyyy年MM月　→　yyyy-MM-dd　に変換する
	   * @param		subDate		対象日付
	   * @return	formatDate	フォーマット変換済み日付
	   */
	public String GetForShiftList(String subDate, int addMonth) {
		
		// パラメータを「yyyy-MM-dd」の形式に変換
		String formatDate = null;
		formatDate = subDate.replace("年", "-");
		formatDate = formatDate.replace("月", "-");
		// 「yyyy年MM月」の為、日にち「01」を追加
		formatDate += "01";
		
		try{
			SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd");	
			Date date = sdFormat.parse(formatDate);
	        /** ▼▼▼2022.08.06「前の月」「次の月」追加対応▼▼▼ **/
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
            cal.add(Calendar.MONTH, addMonth);
			formatDate = sdFormat.format(cal.getTime());
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return formatDate;
	}
	/**
	   * 申請一覧を取得する為の起算日を取得する
	   * yyyy-MM-dd　→　yyyyMMdd　に変換する
	   * @param		subDate		対象日付
	   * @return	formatDate	フォーマット変換済み日付
	   */
	public String GetForRequestMin(String subDate) {
		
		// パラメータを「yyyyMMdd」の形式に変換
		String formatDate = null;
		formatDate = subDate.replace("-", "");
		
		try{
			SimpleDateFormat sdFormat = new SimpleDateFormat("yyyyMMdd");	
			Date date = sdFormat.parse(formatDate);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			formatDate = sdFormat.format(cal.getTime());
			formatDate = formatDate.substring(0, 6) + "01";
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return formatDate;
	}
	/**
	   * 申請一覧を取得する為の起算日を取得する
	   * yyyy-MM-dd　→　yyyyMMdd　に変換する
	   * @param		subDate		対象日付
	   * @return	formatDate	フォーマット変換済み日付
	   */
	public String GetForRequestMax(String subDate) {
		
		// パラメータを「yyyyMMdd」の形式に変換
		String formatDate = null;
		formatDate = subDate.replace("-", "");
		
		try{
			SimpleDateFormat sdFormat = new SimpleDateFormat("yyyyMMdd");	
			Date date = sdFormat.parse(formatDate);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			formatDate = sdFormat.format(cal.getTime());
			formatDate = formatDate.substring(0, 6) + cal.getActualMaximum(Calendar.DATE);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return formatDate;
	}

	/**
	   * 打刻日時を取得すために日時フォーマットを検索条件に合わせる
	   * 「yyyy-MM-dd HH:mm:ss.sssssss」　→　「yyyy-MM-dd HH:mm:ss.sss」に変換する
	   * @param		subDate		対象日付
	   * @return	formatDate	フォーマット変換済み日付
	   */
	public String GetWhereDate(String subDate) {
		
		// パラメータを「yyyy-MM-dd HH:mm:ss.sss」の形式に変換
		String formatDate = null;
		
		try{
			SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.sss", Locale.JAPANESE);	
			Date date = sdFormat.parse(subDate);
			formatDate = sdFormat.format(date);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return formatDate;
	}

	/**
	   * 文字列にアルファベットが含まれているかどうか判定
	   * 「yyyy-MM-dd HH:mm:ss.sssssss」　→　「yyyy-MM-dd HH:mm:ss.sss」に変換する
	   * @param		text		判定対象
	   * @return	result		判定結果
	   * 			true		アルファベットが含まれている
	   * 			false		アルファベットが含まれていない
	   */
	public boolean isAlpha(String text)
    {
        boolean result = false;

        if (text == null) {
			result = false;
        }else {
            for (int i = 0; i < text.length(); i++)
            {
                char c = text.charAt(i);
                if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
                	result = true;
                }
            }
        }
        return result;
    }
	/**
	   * 日付の前後を比較
	   * @param		dateText1	単独上番日時
	   * 			dateText2	単独下番日時
	   * @return	result		判定結果
	   * 			true		上番が新しい
	   * 			false		下番が新しい
	   */
	public boolean dateComp(String dateText1, String dateText2)
  {
      boolean result = false;
      
      if(dateText1 != null && dateText2 != null) {
			try {
				SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date1 = sdFormat.parse(dateText1);
				Date date2 = sdFormat.parse(dateText2);
				//上番よりも下番の方が前だったら真
				if(date2.before(date1)) {
					result = true;
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
      }
      return result;
  }
	/**
	   * ログイン情報のGPS情報を取得し暗号化してセットする
	   * @param		LoginInfo	ログイン情報
	   * @return	void		
	   */
	public void setLoginInfoGpsEncrypt(LoginInfo loginInfo) {
    	/***位置情報がすでに暗号化されているか確認***/
    	//暗号化していなかったら暗号化、していたらそのままセット
    	if(!this.isAlpha(loginInfo.geoIdo_Value)) {
    		// 端末から取得した緯度を暗号化
        	loginInfo.geoIdo_Value = this.encrypt(loginInfo.geoIdo_Value);
    	}else {
        	loginInfo.geoIdo_Value = loginInfo.geoIdo_Value;
    	}
    	//暗号化していなかったら暗号化、していたらそのままセット
    	if(!this.isAlpha(loginInfo.geoKeido_Value)) {
    		// 端末から取得した経度を暗号化
        	loginInfo.geoKeido_Value = this.encrypt(loginInfo.geoKeido_Value);
    	}else {
        	loginInfo.geoKeido_Value = loginInfo.geoKeido_Value;
    	}
	}
}
