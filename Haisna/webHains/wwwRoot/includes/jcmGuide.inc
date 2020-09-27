<%
'-----------------------------------------------------------------------------
'		判定コメントガイド Include File (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// ガイド画面との連絡域
var jcmGuide_JudCmtCd;		// 判定コメントコード
var jcmGuide_JudCmtStc;		// 判定コメント文章
var jcmGuide_FreeJudCmtStc;	// 判定コメント文章(フリー入力用)
var jcmGuide_GuidanceCd;	// 指導内容コード
var jcmGuide_GuidanceStc;	// 指導内容
var jcmGuide_JudCd;			// 判定コード
var jcmGuide_JudSName;		// 略称

var winGuideJcm;			// ウィンドウハンドル

// 判定コメントガイド画面を表示
function jcmGuide_ShowGuideJcm( judClassCd, judCmtCd, judCmtStc, freeJudCmtStc, guidanceCd, guidanceStc, judCd, judSName ) {

	var opened = false;	// 画面が開かれているか
	var url;			// 判定コメントガイドのURL

	// ガイド画面との連絡域を使用して処理制御を行う
	jcmGuide_JudCmtCd      = judCmtCd;
	jcmGuide_JudCmtStc     = document.getElementById( judCmtStc );
	jcmGuide_FreeJudCmtStc = freeJudCmtStc;
	jcmGuide_GuidanceCd    = guidanceCd;
	jcmGuide_GuidanceStc   = document.getElementById( guidanceStc );
	jcmGuide_JudCd         = judCd;
	jcmGuide_JudSName      = document.getElementById( judSName );

	// すでにガイドが開かれているかチェック
	if ( winGuideJcm != null ) {
		if ( !winGuideJcm.closed ) {
			opened = true;
		}
	}

	// 判定コメントガイドのURL編集
	url = '/webHains/contents/guide/gdeJudCmtStc.asp?judClassCd=' + judClassCd;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideJcm.focus();
		winGuideJcm.location.replace( url );
	} else {
		winGuideJcm = window.open( url, '', 'width=700,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// 判定コメント情報編集用関数
function jcmGuide_setJudCmtInfo( judCmtCd, judCmtStc, guidanceCd, guidanceStc, judCd, judSName ) {

	// 判定コメントコードの編集
	if ( jcmGuide_JudCmtCd ) {
		jcmGuide_JudCmtCd.value = judCmtCd;
	}

	// 判定コメント文章の編集
	if ( jcmGuide_JudCmtStc ) {
		jcmGuide_JudCmtStc.innerHTML = judCmtStc;
	}

	// 判定コメント文章(フリー入力用)の編集
	if ( jcmGuide_FreeJudCmtStc ) {
		if ( jcmGuide_FreeJudCmtStc.value == '' ) {
			jcmGuide_FreeJudCmtStc.value = judCmtStc;
		}
	}

	// 指導内容コードの編集
	if ( jcmGuide_GuidanceCd ) {
		jcmGuide_GuidanceCd.value = guidanceCd;
	}

	// 指導内容の編集
	if ( jcmGuide_GuidanceStc ) {
		jcmGuide_GuidanceStc.innerHTML = guidanceStc;
	}

	// 判定コードの編集
	if ( jcmGuide_JudCd ) {
		jcmGuide_JudCd.value = judCd;
	}

	// 略称の編集
	if ( jcmGuide_JudSName ) {
		jcmGuide_JudSName.innerHTML = judSName;
	}

}

// 判定コメント情報のクリア
function jcmGuide_clearJudCmtInfo( judCmtCd, judCmtStc ) {

	// 判定コメントコードのクリア
	if ( judCmtCd ) {
		judCmtCd.value = '';
	}

	// 判定コメント文章エレメントのクリア
	if ( document.getElementById( judCmtStc ) ) {
		document.getElementById( judCmtStc ).innerHTML = '';
	}

}

// ガイドを閉じる
function jcmGuide_closeGuideJcm() {

	if ( winGuideJcm != null ) {
		if ( !winGuideJcm.closed ) {
			winGuideJcm.close();
		}
	}

	winGuideJcm = null;
}
//-->
</SCRIPT>
