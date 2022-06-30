package util;

import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class UtilConv {

	// 文字列暗号化用
	private static final String ENCRYPT_KEY	= "oP3feFoWLoEwaa12";
	private static final String ENCRYPT_IV		= "eF20TGd0kdfe5Ye9";
	// 文字コード
	private static final String CHARSET			= "UTF-8";
	// 暗号方式
	private static final String CRYRTOGRAPHY	= "AES";
	private static final String CIPHERTEXT		= "AES/CBC/PKCS5Padding";

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
		try {
			// 文字列をバイト配列へ変換
			byte[] byteText = text.getBytes(CHARSET);

			// 暗号化キーと初期化ベクトルをバイト配列へ変換
			byte[] byteKey = ENCRYPT_KEY.getBytes(CHARSET);
			byte[] byteIv = ENCRYPT_IV.getBytes(CHARSET);

			// 暗号化キーと初期化ベクトルのオブジェクト生成
			SecretKeySpec key = new SecretKeySpec(byteKey, CRYRTOGRAPHY);
			IvParameterSpec iv = new IvParameterSpec(byteIv);

			// Cipherオブジェクト生成
			Cipher cipher = Cipher.getInstance(CIPHERTEXT);

			// Cipherオブジェクトの初期化
			cipher.init(Cipher.ENCRYPT_MODE, key, iv);

			// 暗号化の結果格納
			byte[] byteResult = cipher.doFinal(byteText);

			// Base64へエンコード
			encryptText = Base64.getEncoder().encodeToString(byteResult);

		} catch (Exception e) {
			e.printStackTrace();
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
		try {
			// 暗号化キーと初期化ベクトルをバイト配列へ変換
			byte[] byteKey = ENCRYPT_KEY.getBytes(CHARSET);
			byte[] byteIv = ENCRYPT_IV.getBytes(CHARSET);

			// 復号化キーと初期化ベクトルのオブジェクト生成
			SecretKeySpec key = new SecretKeySpec(byteKey, CRYRTOGRAPHY);
			IvParameterSpec iv = new IvParameterSpec(byteIv);

			// Cipherオブジェクト生成
			Cipher cipher = Cipher.getInstance(CIPHERTEXT);

			// Cipherオブジェクトの初期化
			cipher.init(Cipher.DECRYPT_MODE, key, iv);

			// 復号化の結果格納
			byte[] byteResult = cipher.doFinal(Base64.getDecoder().decode(text));

			// デコード
			decodeText = new String(byteResult, CHARSET);


		} catch (Exception e) {
			e.printStackTrace();
		}
		return decodeText;
	}
}
