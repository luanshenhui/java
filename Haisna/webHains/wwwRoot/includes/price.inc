<%
'-----------------------------------------------------------------------------
'		金額編集用 Include File (Ver0.0.1)
'		AUTHER  : Takagi@fsit.Fujitsu.com
'-----------------------------------------------------------------------------
%>
<!--
function calcPrice(objPrice, totalPriceName) {

	var regExpString = '^[+-]?[0-9]+$';		// 数字列の正規表現

	var calcPrice = 0;						// 負担金額
	var editPrice = '';						// ￥マークおよびカンマ編集後の負担金額
	var objTotalPrice;						// 負担金額総計のオブジェクト

	var errFlg = false;						// エラーフラグ

	for ( ; ; ) {

		// 負担金額テキストが存在しない場合
		if ( objPrice == null ) {
			errFlg = true;
			break;
		}

		// 負担金額テキストが１つしか存在しない場合
		if ( objPrice.length == null ) {

			// 未入力であればチェックしない
			if ( objPrice.value == '' ) {
				break;
			}

			// 正規表現チェック
			if ( objPrice.value.match(regExpString) == null ) {
				errFlg = true;
				break;
			}

			// 単一テキストの値をそのまま編集
			calcPrice = objPrice.value;
			break;

		}

		// 全負担金額テキストの検索
		for ( i = 0; i < objPrice.length; i++ ) {

			// 未入力であればチェックしない
			if ( objPrice[i].value == '' ) {
				continue;
			}

			// 正規表現チェック
			if ( objPrice[i].value.match(regExpString) == null ) {
				errFlg = true;
				break;
			}

			// 負担金額を加算
			calcPrice = eval(calcPrice + parseInt(objPrice[i].value, 10));

		}

		break;
	}

	editPrice = !errFlg ? formatCurrency(calcPrice) : '&nbsp;';

	// ブラウザごとの金額編集用エレメントの設定処理
	for ( ; ; ) {

		// IEの場合
		if ( document.all ) {
			objTotalPrice = document.all(totalPriceName);
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			objTotalPrice = document.getElementById(totalPriceName);
		}

		break;
	}

	if ( objTotalPrice != null ) {
		objTotalPrice.innerHTML = editPrice;
	}

}

// 金額形式への編集
function formatCurrency(expression) {

	var buffer = '';	// 文字列編集バッファ
	var i, j;			// インデックス

	var minusSign = expression >= 0 ? '' : '-';
	var editPrice = Math.abs(expression).toString(10);

	for ( i = editPrice.length - 1, j = 0; i >= 0; i-- ) {
		if ( buffer != '' && ++j % 3 == 0 ) {
			buffer = ',' + buffer;
		}
		buffer = editPrice.charAt(i) + buffer;
	}

	return minusSign + '\\' + buffer;

}
//-->
