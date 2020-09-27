<%
'-----------------------------------------------------------------------------
'		定型所見ガイド Include File (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var obsGuide_JudClassCd;	// (In)  判定分類コード
var obsGuide_StdJudCd;		// (Out) 定型所見コード
var obsGuide_StdJudNote;	// (Out) 定型所見名称
var obsGuide_CalledFunction;	// (In)  ガイド選択後に呼び出す関数

// ウィンドウハンドル
var winGuideObs;

// 定型所見ガイド画面を表示
function showGuideObs() {

	var opened = false;	// 画面が開かれているか
	var url;			// 定型所見ガイドのURL

	// ガイド画面との連絡域(Out)を初期化
	obsGuide_StdJudCd   = '';
	obsGuide_StdJudNote = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideObs != null ) {
		if ( !winGuideObs.closed ) {
			opened = true;
		}
	}

	// 定型所見ガイドのURL編集
	url = '/webHains/contents/guide/gdeObservation.asp?judClassCd=' + obsGuide_JudClassCd;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideObs.focus();
		winGuideObs.location.replace(url);
	} else {
		winGuideObs = window.open(url, '', 'width=300,height=320,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

	return false;
}

// ガイドを閉じる
function closeGuideObs() {

	if ( winGuideObs != null ) {
		if ( !winGuideObs.closed ) {
			winGuideObs.close();
		}
	}

	winGuideObs = null;
}
//-->
