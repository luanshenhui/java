<%
'-----------------------------------------------------------------------------
'		汎用テーブルガイド Include File (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto K-MIX
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var freeGuide_FreeCd;		// 汎用コード
var freeGuide_FreeClassCd;	// 汎用分類コード
var freeGuide_FreeName;		// 汎用名
var freeGuide_FreeDate;		// 汎用日付
var freeGuide_FreeFeild1;	// 汎用フィールド１
var freeGuide_FreeFeild2;	// 汎用フィールド２
var freeGuide_FreeFeild3;	// 汎用フィールド３
var freeGuide_FreeFeild4;	// 汎用フィールド４
var freeGuide_FreeFeild5;	// 汎用フィールド５

var winGuideFree;				// ウィンドウハンドル

// 汎用検索ガイド画面を表示
function freeGuide_showGuideFree( keyFreeCd , freeCd, freeClassCd, freeName, FreeDate, freeFeild1, freeFeild2, freeFeild3, freeFeild4, freeFeild5, calledFunc, connectCodeName ) {

	var opened = false;												// 画面が開かれているか
	var url    = '/webHains/contents/guide/gdeFree.asp';			// 汎用ガイド画面のURL

	url = url + '?freeCd=' + freeCd.value + '&key=' + keyFreeCd;

	// ガイド画面との連絡域を使用して処理制御を行う
	freeGuide_FreeCd = freeCd;		
	freeGuide_FreeClassCd	= freeClassCd;
	freeGuide_FreeName		= document.getElementById( freeName );
	freeGuide_FreeDate		= document.getElementById( FreeDate );
	freeGuide_FreeFeild1	= document.getElementById( freeFeild1 );
	freeGuide_FreeFeild2	= document.getElementById( freeFeild2 );
	freeGuide_FreeFeild3	= document.getElementById( freeFeild3 );
	freeGuide_FreeFeild4	= document.getElementById( freeFeild4 );
	freeGuide_FreeFeild5	= document.getElementById( freeFeild5 );

	freeGuide_CalledFunction  = calledFunc;
	freeGuide_ConnectCodeName = connectCodeName;

	// すでにガイドが開かれているかチェック
	if ( winGuideFree ) {
		if ( !winGuideFree.closed ) {
			opened = true;
		}
	}

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideFree.focus();
		winGuideFree.location.replace(url);
	} else {
		winGuideFree = window.open(url, '', 'width=700,height=570,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no');
	}

}

// 汎用情報編集用関数
function freeGuide_setFreeInfo( freeCd, freeClassCd, freeName, FreeDate, freeFeild1, freeFeild2, freeFeild3, freeFeild4, freeFeild5 ) {

	// 汎用コードの編集
	if ( freeGuide_FreeCd ) {
		freeGuide_FreeCd.value = freeCd;
	}

	// 汎用分類コードの編集
	if ( freeGuide_FreeClassCd ) {
		freeGuide_FreeClassCd.value = freeClassCd;
	}

	// 汎用名の編集
	if ( freeGuide_FreeName ) {
		if ( freeGuide_ConnectCodeName ) {
			freeGuide_FreeName.innerHTML = freeCd + '：' + freeName;
		} else {
			freeGuide_FreeName.innerHTML = freeName;
		}
	}

	// 汎用フィールド１の編集
	if ( freeGuide_FreeFeild1 ) {
		if ( freeGuide_ConnectCodeName ) {
			freeGuide_FreeFeild1.innerHTML = freeCd + '：' + freeFeild1;
		} else {
			freeGuide_FreeFeild1.innerHTML = freeFeild1;
		}
	}

	// 汎用フィールド２の編集
	if ( freeGuide_FreeFeild2 ) {
		if ( freeGuide_ConnectCodeName ) {
			freeGuide_FreeFeild2.innerHTML = freeCd + '：' + freeFeild2;
		} else {
			freeGuide_FreeFeild2.innerHTML = freeFeild2;
		}
	}

	// 汎用フィールド３の編集
	if ( freeGuide_FreeFeild3 ) {
		if ( freeGuide_ConnectCodeName ) {
			freeGuide_FreeFeild3.innerHTML = freeCd + '：' + freeFeild3;
		} else {
			freeGuide_FreeFeild3.innerHTML = freeFeild3;
		}
	}

	// 汎用フィールド４の編集
	if ( freeGuide_FreeFeild4 ) {
		if ( freeGuide_ConnectCodeName ) {
			freeGuide_FreeFeild4.innerHTML = freeCd + '：' + freeFeild4;
		} else {
			freeGuide_FreeFeild4.innerHTML = freeFeild4;
		}
	}

	// 汎用フィールド５の編集
	if ( freeGuide_FreeFeild5 ) {
		if ( freeGuide_ConnectCodeName ) {
			freeGuide_FreeFeild5.innerHTML = freeCd + '：' + freeFeild5;
		} else {
			freeGuide_FreeFeild5.innerHTML = freeFeild5;
		}
	}

	// 関数呼び出し
	if ( freeGuide_CalledFunction ) {
		freeGuide_CalledFunction();
	}

}

// 汎用情報のクリア
function freeGuide_clearFreeInfo( freeCd, freeClassCd, freeName, FreeDate, freeFeild1, freeFeild2, freeFeild3, freeFeild4, freeFeild5 ) {

	// 汎用コードのクリア
	if ( freeCd ) {
		freeCd.value = '';
	}

	// 汎用分類コードのクリア
	if ( freeClassCd ) {
		freeClassCd.value = '';
	}

	// 汎用名エレメントのクリア
	if ( document.getElementById(freeName) ) {
		document.getElementById(freeName).innerHTML = '';
	}

	// 汎用フィールド１エレメントのクリア
	if ( document.getElementById(freeFeild1) ) {
		document.getElementById(freeFeild1).innerHTML = '';
	}

	// 汎用フィールド２エレメントのクリア
	if ( document.getElementById(freeFeild2) ) {
		document.getElementById(freeFeild2).innerHTML = '';
	}

	// 汎用フィールド３エレメントのクリア
	if ( document.getElementById(freeFeild3) ) {
		document.getElementById(freeFeild3).innerHTML = '';
	}

	// 汎用フィールド４エレメントのクリア
	if ( document.getElementById(freeFeild4) ) {
		document.getElementById(freeFeild4).innerHTML = '';
	}

	// 汎用フィールド５エレメントのクリア
	if ( document.getElementById(freeFeild5) ) {
		document.getElementById(freeFeild5).innerHTML = '';
	}

}

// ガイドを閉じる
function freeGuide_closeGuideFree() {

	if ( winGuideFree ) {
		if ( !winGuideFree.closed ) {
			winGuideFree.close();
		}
	}

	winGuideFree = null;
}
//-->
</SCRIPT>
