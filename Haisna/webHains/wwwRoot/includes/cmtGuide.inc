<%
'-----------------------------------------------------------------------------
'		結果コメントガイド Include File (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var cmtGuide_RslCmtCd;		// (Out) 結果コメントコード
var cmtGuide_RslCmtName;	// (Out) 結果コメント名
var cmtGuide_CalledFunction;	// (In)  ガイド選択後に呼び出す関数

// ウィンドウハンドル
var winGuideCmt;

// 結果コメントガイド画面を表示
// function showGuideCmt() {
function showGuideCmt( entryOk ) {

	var opened = false;

	// ガイド画面との連絡域(Out)を初期化
	cmtGuide_RslCmtCd   = '';
	cmtGuide_RslCmtName = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideCmt != null ) {
		if ( !winGuideCmt.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winGuideCmt.focus();
	} else {
//		winGuideCmt = window.open('/webHains/contents/guide/gdeComment.asp', '', 'width=700,height=570,status=yes,directories=no,menubar=no,resizable=no,toolbar=no');
//		winGuideCmt = window.open('/webHains/contents/guide/gdeComment.asp', '', 'width=200,height=250,status=no,directories=no,menubar=no,resizable=no,toolbar=no,scrollbars=yes');
//		winGuideCmt = window.open('/webHains/contents/guide/gdeComment.asp', '', 'width=200,height=250,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
//		winGuideCmt = window.open('/webHains/contents/guide/gdeComment.asp', '', 'width=300,height=320,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
		var url = '/webHains/contents/guide/gdeComment.asp';
		if ( entryOk != null ) {
			url = url + '?entryOk=' + entryOk;
		}
		winGuideCmt = window.open( url, '', 'width=300,height=320,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );

	}

	return false;
}

// ガイドを閉じる
function closeGuideCmt() {

	if ( winGuideCmt != null ) {
		if ( !winGuideCmt.closed ) {
			winGuideCmt.close();
		}
	}

	winGuideCmt = null;
}
//-->
