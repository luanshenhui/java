<%
'-----------------------------------------------------------------------------
'		定性結果ガイド Include File (Ver0.0.1)
'		AUTHER  : Chikaishi Yumi@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域

var tseGuide_ResultType;			//結果タイプ
var tseGuide_Result;		    	//結果値
var tseGuide_CalledFunction;		//ガイド選択後に呼び出す関数

// ウィンドウハンドル
var winGuideTse;

// 定性結果ガイド画面を表示
function showGuideTse() {

	var opened = false;	// 画面が開かれているか
	var url;			// URL文字列

	// ガイド画面との連絡域(Out)を初期化
	tseGuide_Result = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideTse != null ) {
		if ( !winGuideTse.closed ) {
			opened = true;
		}
	}

	// 定性結果ガイドのURL編集
	url = '/webHains/contents/guide/gdeTeisei.asp?resulttype=' + tseGuide_ResultType;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideTse.focus();
		winGuideTse.location.replace(url);
	} else {
		winGuideTse = window.open(url, '', 'width=300,height=300,status=yes,directories=no,menubar=no,resizable=no,toolbar=no');
	}

	return false;
}

// ガイドを閉じる
function closeGuideTse() {

	if ( winGuideTse != null ) {
		if ( !winGuideTse.closed ) {
			winGuideTse.close();
		}
	}

	winGuideTse = null;
}
//-->
