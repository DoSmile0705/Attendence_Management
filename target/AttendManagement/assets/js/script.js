function init() {
    let elements = document.getElementsByTagName('button');
    for (let element of elements) {
        if (element.getAttribute('data-id')) {
            element.addEventListener('click', testLoad);
        }
    }
    stopAllLoad();
}

function testLoad() {
    let dataId = this.getAttribute('data-id');
    if (dataId) {
        startLoad(dataId);
        setTimeout(stopAllLoad, 3000);
    }
}

function startLoad(id) {
    document.getElementById(id).style.visibility = 'visible';
}

function stopAllLoad() {
    let elements = document.getElementsByClassName('loading');
    for (let element of elements) {
        element.style.visibility = 'hidden';
    }
}

// GPSを取得する
function getGpsData(frm) {
	
	// 緯度、経度を初期化
	if(document.getElementsByName("geoIdo") != null){
		$('input[name="geoIdo"]').val("");
	}
	
	if(document.getElementsByName("geoKeido") != null){
    	$('input[name="geoKeido"]').val("");
	}
	
	// サブミット処理時にローディング画面を表示する
	if(!$("#disp_blocker").length){
		//ブロッカーの表示
		showDispBlocker();
	}
	
	navigator.geolocation.getCurrentPosition((position) => {

		// 緯度取得
	    var latitude  = position.coords.latitude;
	    // 経度取得
	    var longitude = position.coords.longitude;

	    // 緯度経度を取得して隠し項目に格納
		if(document.getElementsByName("geoIdo") != null){
			$('input[name="geoIdo"]').val(latitude);
		}
		
		if(document.getElementsByName("geoKeido") != null){
		    $('input[name="geoKeido"]').val(longitude);
		}
		
		// submit実行
		frm.submit();
	// GPS未送信時のsubmit実行
	},function(){frm.submit()});
		
}

window.addEventListener('load', init);