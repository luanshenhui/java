<%
'-----------------------------------------------------------------------------
'		指導文章ガイド Include File (Ver0.0.1)
'		AUTHER  : Ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var guidanceGuide_JudClassCd;		// (In)  判定分類コード
var guidanceGuide_GuidanceCd;		// (Out) 指導文章コード
var guidanceGuide_GuidanceStc;		// (Out) 指導文章
var guidanceGuide_CalledFunction;	// (In)  ガイド選択後に呼び出す関数

// ウィンドウハンドル
var winGuideGuidance;

// 指導文章ガイド画面を表示
function showGuideGuidance() {

	var opened = false;	// 画面が開かれているか
	var url;			// 判定コメントガイドのURL

	// ガイド画面との連絡域(Out)を初期化
	guidanceGuide_GuidanceCd  = '';
	guidanceGuide_GuidanceStc = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideGuidance != null ) {
		if ( !winGuideGuidance.closed ) {
			opened = true;
		}
	}

	// 指導文章ガイドのURL編集
	url = '/webHains/contents/guide/gdeGuidance.asp?judClassCd=' + guidanceGuide_JudClassCd;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideGuidance.focus();
		winGuideGuidance.location.replace(url);
	} else {
		winGuideGuidance = window.open(url, '', 'width=700,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

	return false;
}

// ガイドを閉じる
function closeGuideGuidance() {

	if ( winGuideGuidance != null ) {
		if ( !winGuideGuidance.closed ) {
			winGuideGuidance.close();
		}
	}

	winGuideGuidance = null;
}
//-->
