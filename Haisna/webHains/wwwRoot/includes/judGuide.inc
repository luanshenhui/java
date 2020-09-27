<%
'-----------------------------------------------------------------------------
'		判定ガイド Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var judGuide_JudCd;		// 判定コード
var judGuide_JudSName;	// 略称
var judGuide_JudRName;	// 報告書用判定名

var winGuideJud;		// ウィンドウハンドル

// 判定ガイド画面を表示
function judGuide_ShowGuideJud( judCd, judSName, judRName ) {

	var opened = false;									// 画面が開かれているか
	var url    = '/webHains/contents/guide/gdeJud.asp';	// 判定ガイド画面のURL

	// ガイド画面との連絡域を使用して処理制御を行う
	judGuide_JudCd    = judCd;
	judGuide_JudSName = document.getElementById( judSName );
	judGuide_JudRName = document.getElementById( judRName );

	// すでにガイドが開かれているかチェック
	if ( winGuideJud != null ) {
		if ( !winGuideJud.closed ) {
			opened = true;
		}
	}

	// 開かれている場合は画面をFOCUSし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideJud.focus();
	} else {
		winGuideJud = window.open( url, '', 'width=200,height=230,status=yes,directories=no,menubar=no,resizable=no,toolbar=no,scrollbars=yes');
	}

}

// 判定情報編集用関数
function judGuide_setJudInfo( judCd, judSName, judRName ) {

	// 判定コードの編集
	if ( judGuide_JudCd ) {
		judGuide_JudCd.value = judCd;
	}

	// 略称の編集
	if ( judGuide_JudSName ) {
		judGuide_JudSName.innerHTML = judSName;
	}

	// 報告書用判定名の編集
	if ( judGuide_JudRName ) {
		judGuide_JudRName.innerHTML = judRName;
	}

}

// 判定情報のクリア
function judGuide_clearJudInfo( judCd, judSName, judRName ) {

	// 判定コードのクリア
	if ( judCd ) {
		judCd.value = '';
	}

	// 略称エレメントのクリア
	if ( document.getElementById( judSName ) ) {
		document.getElementById( judSName ).innerHTML = '';
	}

	// 報告書用判定名エレメントのクリア
	if ( document.getElementById( judRName ) ) {
		document.getElementById( judRName ).innerHTML = '';
	}

}

// ガイドを閉じる
function judGuide_closeGuideJud() {

	if ( winGuideJud != null ) {
		if ( !winGuideJud.closed ) {
			winGuideJud.close();
		}
	}

	winGuideJud = null;

}
//-->
</SCRIPT>
