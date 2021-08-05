// 初期マップの設定
let map
let marker
function initMap(){
  geocoder = new google.maps.Geocoder()
  // new google.maps.MapはGoogleMapを表示するために、new google.maps.MarkerはGoogleMap上にピンを表示するために必要
  // それぞれの第2引数に指定されているオプションcenter、zoomは必ず設定が必要なので忘れずに設定する
  map = new google.maps.Map(document.getElementById('map'), {
    center:  {lat: 35.6803997, lng:139.7690174},  //東京
    zoom: 15,
  });
}

// 検索後のマップ作成
let geocoder
let aft
function codeAddress(){
// getElementByIdはHTMLタグで指定したIDにマッチするドキュメント要素を取得するメソッド。
// valueプロパティを使うことで、value属性の値を取得、変更できる
  let inputAddress = document.getElementById('address').value;
// geocoder.geocode();はGeocodingにリクエストを送ってレスポンスを受け取るために必要なコード
// 第1引数の{ 'address': inputAddress}でフォームに入力した文字列をaddressの形でリクエスト
// 第2引数のfunction(results, status)はレスポンスで受け取った結果を処理するために必要なコールバック関数
// resultsはGeocodingからのレスポンス結果、内容を受け取る
// statusはGeocodingからのレスポンスステータスコードを受け取る
  geocoder.geocode( { 'address': inputAddress}, function(results, status) {
// if (status == 'OK') {} else {}はコールバック関数で受け取ったstatusがOKだった場合に処理し、それ以外ならelseを処理するというコード
    if (status == 'OK') {
        //マーカーが複数できないようにする
        if (aft == true){
            marker.setMap(null);
        }

        //ここではmapのsetCenterというメソッドを利用してmapの座標を設定
        // setCenterを利用するためには緯度経度の値が必要になる
        // resultsの中にある緯度経度の値はresults[0]geometry.locationというコードで取得できるので取得して座標を設定
        map.setCenter(results[0].geometry.location);
            marker = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location,
            draggable: true // ドラッグ可能にする
        });

        //二度目以降か判断
        aft = true
    } else {
      alert('該当する結果がありませんでした：' + status);
    }
  });
}
