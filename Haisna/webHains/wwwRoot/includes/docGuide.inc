<%
'-----------------------------------------------------------------------------
'		判定医師名ガイド Include File (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var docGuide_DoctorCd;			// (Out) 医師コード
var docGuide_DoctorName;		// (Out) 医師名
var docGuide_CalledFunction;	// (In)  ガイド選択後に呼び出す関数

// ウィンドウハンドル
var winGuideDoc;

// 判定医師名ガイド画面を表示
function showGuideDoc() {

	var opened = false;

	// ガイド画面との連絡域(Out)を初期化
	docGuide_DoctorCd   = '';
	docGuide_DoctorName = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideDoc != null ) {
		if ( !winGuideDoc.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winGuideDoc.focus();
	} else {
//		winGuideDoc = window.open('/webHains/contents/guide/gdeDoctor.asp', '', 'width=700,height=570,status=yes,directories=no,menubar=no,resizable=no,toolbar=no');
//		winGuideDoc = window.open('/webHains/contents/guide/gdeDoctor.asp', '', 'width=200,height=250,status=no,directories=no,menubar=no,resizable=no,toolbar=no,scrollbars=yes');
//		winGuideDoc = window.open('/webHains/contents/guide/gdeDoctor.asp', '', 'width=200,height=250,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
		winGuideDoc = window.open('/webHains/contents/guide/gdeDoctor.asp?doctorFlg=1', '', 'width=300,height=320,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

	return false;
}

// ガイドを閉じる
function closeGuideDoc() {

	if ( winGuideDoc != null ) {
		if ( !winGuideDoc.closed ) {
			winGuideDoc.close();
		}
	}

	winGuideDoc = null;
}
//-->
