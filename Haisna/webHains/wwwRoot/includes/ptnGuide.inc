<%
'-----------------------------------------------------------------------------
'		契約パターン検索ガイド Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var ptnGuide_CtrPtCd;			// 契約パターンコード
var ptnGuide_CsName;			// コース名
var ptnGuide_StrDate;			// 契約開始日
var ptnGuide_EndDate;			// 契約終了日

// ガイド選択値参照用変数
var ptnGuide_Val_OrgCd1;		// 団体コード１
var ptnGuide_Val_OrgCd2;		// 団体コード２
var ptnGuide_Val_OrgName;		// 団体名称

var ptnGuide_CalledFunction;	// ガイドを閉じる際に呼び出す親画面の関数

var winGuidePattern;			// ウィンドウハンドル

// 契約パターン検索ガイド画面を表示
function ptnGuide_showGuidePattern( ctrPtCd, csName, strDate, endDate, calledFunc, orgCd1, orgCd2, showAllPattern ) {

	var url = '/webHains/contents/guide/gdeCtrPattern.asp';	// 契約パターン検索ガイド画面のURL

	// ガイド画面との連絡域を使用して処理制御を行う
	ptnGuide_CtrPtCd = ctrPtCd;
	ptnGuide_CsName  = document.getElementById( csName );
	ptnGuide_StrDate = document.getElementById( strDate );
	ptnGuide_EndDate = document.getElementById( endDate );

	ptnGuide_Val_OrgCd1 = '';
	ptnGuide_Val_OrgCd2 = '';

	ptnGuide_CalledFunction = calledFunc;

	// 団体が決定している場合は追加
	if ( orgCd1 && orgCd2 ) {

		url = url + '?orgCd1='+ orgCd1.value;
		url = url + '&orgCd2='+ orgCd2.value;

		// 全パターンを表示する場合は追加
		if ( showAllPattern ) {
			url = url + '&showAllPattern=1';
		}

	} else {

		// 全パターンを表示する場合は追加
		if ( showAllPattern ) {
			url = url + '?showAllPattern=1';
		}

	}

	// ガイド画面を表示
	ptnGuide_openWindow( url );

}

// ガイド画面を表示
function ptnGuide_openWindow( url ) {

	var opened = false;	// 画面が開かれているか

	// すでにガイドが開かれているかチェック
	if ( winGuidePattern ) {
		if ( !winGuidePattern.closed ) {
			opened = true;
		}
	}

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuidePattern.focus();
		winGuidePattern.location.replace( url );
	} else {
		winGuidePattern = window.open( url, '', 'width=500,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// 契約パターン情報のクリア
function ptnGuide_clearPatternInfo() {

}

// 契約パターン情報編集用関数
function ptnGuide_setPatternInfo( ctrPtCd, csName, strDate, endDate, orgCd1, orgCd2, orgName ) {

	// 契約パターンコードの編集
	if ( ptnGuide_CtrPtCd ) {
		ptnGuide_CtrPtCd.value = ctrPtCd;
	}

	// コース名の編集
	if ( ptnGuide_CsName ) {
		ptnGuide_CsName.innerHTML = csName;
	}

	// 契約開始日の編集
	if ( ptnGuide_StrDate ) {
		ptnGuide_StrDate.innerHTML = strDate;
	}

	// 契約終了日の編集
	if ( ptnGuide_EndDate ) {
		ptnGuide_EndDate.innerHTML = ( ptnGuide_StrDate ? '～' : '' ) + endDate;
	}

	// 団体コードの編集
	ptnGuide_Val_OrgCd1  = orgCd1;
	ptnGuide_Val_OrgCd2  = orgCd2;
	ptnGuide_Val_OrgName = orgName;

	// 関数呼び出し
	if ( ptnGuide_CalledFunction ) {
		ptnGuide_CalledFunction();
	}

}

// 契約パターン情報のクリア
function ptnGuide_clearPatternInfo( ctrPtCd, csName, strDate, endDate ) {

	if ( ctrPtCd ) {
		ctrPtCd.value = '';
	}

	if ( document.getElementById( csName ) ) {
		document.getElementById( csName ).innerHTML = '';
	}

	if ( document.getElementById( strDate ) ) {
		document.getElementById( strDate ).innerHTML = '';
	}

	if ( document.getElementById( endDate ) ) {
		document.getElementById( endDate ).innerHTML = '';
	}

}

// ガイドを閉じる
function ptnGuide_closeGuidePattern() {

	if ( winGuidePattern != null ) {
		if ( !winGuidePattern.closed ) {
			winGuidePattern.close();
		}
	}

	winGuidePattern = null;

}
//-->
</SCRIPT>
