<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html "-//W3C//DTD XHTML 1.0 Strict//EN" 
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>サンプル：住所から座標を取得</title>
  </head>
  <body>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://developers.google.com/maps/documentation/geocoding/get-api-key?hl=ja"></script>
<script type="text/javascript">
/* ========================================================================
   Attribute Latitude And Longitude From Address With Google Maps API
 ========================================================================== */
$(function(){
    function attrLatLngFromAddress(address){
    	alert(address);
        var geocoder = new google.maps.Geocoder();
    	alert(address);
        geocoder.geocode({'address': address}, function(results, status){
            if(status == google.maps.GeocoderStatus.OK) {
                var lat = results[0].geometry.location.lat();
                var lng = results[0].geometry.location.lng();
                // 小数点第六位以下を四捨五入した値を緯度経度にセット、小数点以下の値が第六位に満たない場合は0埋め
                document.getElementById("latitude").value = (Math.round(lat * 1000000) / 1000000).toFixed(6);
                document.getElementById("longitude").value = (Math.round(lat * 1000000) / 1000000).toFixed(6);
            }
        });
    }

    $('#attrLatLng').click(function(){
        var address = document.getElementById("address").value;
        alert(address);
        attrLatLngFromAddress(address);
    });
});
</script>

<tr>
    <th>住所</th>
    <td>
        <input id="address" name="address" type="text" value="">
    </td>
</tr>


<tr>
    <th>緯度</th>
    <td>
        <input id="latitude" name="latitude" type="text" value="">
    </td>
</tr>

<tr>
    <th>経度</th>
    <td>
        <input id="longitude" name="longitude" type="text" value="">
    </td>
</tr>

<input type="button" value="住所から緯度経度を入力する" id="attrLatLng">
  </body>
</html>