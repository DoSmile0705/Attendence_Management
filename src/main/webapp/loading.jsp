<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Jquery読み込み -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!-- 以下のCSS Styleには本JSPで利用するCSS定義以外実装しないこと！！ -->
<style>
	.disp_blocker {
		width: 100vw;
		height: 100vh;
		position: fixed;
		top: 0;
		left: 0;
		background-color: #00000010;
		display: flex;
		justify-content: center;
		align-items: center;
	}
				
	.loader-1 {
		width: 100px;
		height: 100px;
		border-radius: 50%;
		border: solid 6px;
		border-color: #000000 #00000010 #00000010;
		animation-name: spin;
		animation-duration: 1s;
		animation-iteration-count: infinite;
		animation-timing-function: linear;
	}
	
	@keyframes spin {
	  from {
	    transform: rotate(0);
	  }
	  to{
	    transform: rotate(359deg);
	  }
	}
</style>
<script>
	// 画面描画時
	window.addEventListener('pageshow', () => {
		// ローディング画面が表示されている場合、ローディング画面を削除 ブラウザバックなどで戻った際にローディング画面を消す為
		if($('#disp_blocker').length){
			removeDispBlocker();
		}
	});
	
	// サブミット処理時にローディング画面を表示する
	$('*').submit(function(){
		if(!$("#disp_blocker").length){
			showDispBlocker();
		}
	})

	// ブラウザバックに紐づけてローディング画面を表示する。
	window.history.pushState(null, null);
	window.addEventListener('popstate', (e) => {
		if(!$("#disp_blocker").length){
			showDispBlocker();
		}
		history.back();
	});

	// ローディング画面を表示する
	function showDispBlocker(){
		$("body").append("<div id='disp_blocker'></div>");
		$("#disp_blocker").addClass("disp_blocker");
		$("#disp_blocker").append("<span class='loader-1'></span>");
		$("#loader-1").addClass("loader-1");
		setTimeout(showLoadToTopPage, 60000);
	}
	
	// ローディング画面を削除する
	function removeDispBlocker(){
			// disp_blocker以下の要素を全て削除
			$("#disp_blocker").empty();
			// disp_blockerを削除
			$("#disp_blocker").remove();
	}

	// ボタン押下後に一定時間経過しても処理がすすまない場合、
	function showLoadToTopPage(){
		// ローディング画面が表示されている場合（ブラウザバック以外でローディング画面が表示されたままの時のみ）
		if($('#disp_blocker').length){
			window.location.replace("<%= request.getContextPath() %>/Logout");
		}
	}
</script>