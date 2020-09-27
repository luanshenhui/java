<%
'-----------------------------------------------------------------------------
'		担当者ガイド Include File (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var usrGuide_UserCd;			// (Out) 担当者コード
var usrGuide_UserName;			// (Out) 担当者名
var usrGuide_CalledFunction;	// (In)  ガイド選択後に呼び出す関数

// ウィンドウハンドル
var winGuideUsr;

// 担当者ガイド画面を表示
function showGuideUsr() {

	var opened = false;

	// ガイド画面との連絡域(Out)を初期化
	usrGuide_UserCd   = '';
	usrGuide_UserName = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideUsr != null ) {
		if ( !winGuideUsr.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winGuideUsr.focus();
	} else {
//		winGuideUsr = window.open('/webHains/contents/guide/gdeDoctor.asp', '', 'width=700,height=570,status=yes,directories=no,menubar=no,resizable=no,toolbar=no');
//		winGuideUsr = window.open('/webHains/contents/guide/gdeDoctor.asp', '', 'width=200,height=250,status=no,directories=no,menubar=no,resizable=no,toolbar=no,scrollbars=yes');
//		winGuideUsr = window.open('/webHains/contents/guide/gdeDoctor.asp', '', 'width=200,height=250,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
		winGuideUsr = window.open('/webHains/contents/guide/gdeUser.asp', '', 'width=300,height=320,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

	return false;
}

// ガイドを閉じる
function closeGuideDoc() {

	if ( winGuideUsr != null ) {
		if ( !winGuideUsr.closed ) {
			winGuideUsr.close();
		}
	}

}
//-->
