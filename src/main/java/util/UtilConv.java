package util;

import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;

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
    /** ▼▼▼2022.08.06「前の月」「次の月」追加対応▼▼▼ **/
	//public String GetForShiftList(String subDate) {
	public String GetForShiftList(String subDate, int addMonth) {
    /** ▲▲▲2022.08.06「前の月」「次の月」追加対応▲▲▲ **/
		
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
			//sdFormat = new SimpleDateFormat("yyyy-MM-dd");
			//formatDate = sdFormat.format(date);
			formatDate = sdFormat.format(cal.getTime());
	        /** ▲▲▲2022.08.06「前の月」「次の月」追加対応▲▲▲ **/
			
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
}
