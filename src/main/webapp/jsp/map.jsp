<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <title>Google Maps API サンプル</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width,user-scalable=no,maximum-scale=1" />
  </head>
  <body>

    <div id="map" style="width:600px; height:400px"></div>


    <script type="text/javascript">
    function initMap() {
    	  var opts = {
    	    zoom: 15,
    	    center: new google.maps.LatLng(34.66489094513114, 135.49275299980832)
    	  };
    	  var map = new google.maps.Map(document.getElementById("map"), opts);
    	}
    </script>

    <script async defer
      src="https://www.google.co.jp/maps/place/%E3%80%92556-0023+%E5%A4%A7%E9%98%AA%E5%BA%9C%E5%A4%A7%E9%98%AA%E5%B8%82%E6%B5%AA%E9%80%9F%E5%8C%BA%E7%A8%B2%E8%8D%B7%EF%BC%91%E4%B8%81%E7%9B%AE">
    </script>
<form action="<%= request.getContextPath() %>/Login" method="post" accept-charset="UTF-8">
  <button class="btn btn-success">
    最初に戻る
  </button>
</form>
  </body>
</html>