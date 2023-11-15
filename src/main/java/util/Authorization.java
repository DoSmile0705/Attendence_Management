package util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class Authorization {
	
	/**
	 * セッション状態を確認し、セッションの中にワーカーIDが存在するか確認する。
	 * @param request
	 * @return true:認証成功。false:認証失敗
	 */
	public static boolean isSessionValidChk(HttpServletRequest request) {
		
		HttpSession session = request.getSession(true);
		Object obj = session.getAttribute("workerId");
		if (obj == null) {
	        // ログイン情報削除
	        request.setAttribute("loginid","");
	        request.setAttribute("password1","");
	        request.setAttribute("mailaddress","");
	        request.setAttribute("companyCode","");
			return false;
		}
		
		return true;
	}
}
