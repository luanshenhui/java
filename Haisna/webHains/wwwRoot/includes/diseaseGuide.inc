<%
'-----------------------------------------------------------------------------
'		病名ガイド Include File (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto K-MIX
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var disGuide_DisCd;			// 病名コード
var disGuide_DisDivCd;		// 病類コード
var disGuide_DisName;		// 病名
var disGuide_DisDivName;	// 病類名
var disGuide_SearchChar;	// ガイド検索用文字列

var winGuideDisease;				// ウィンドウハンドル

// 病名検索ガイド画面を表示
function disGuide_showGuideDisease( disCd, disName, SearchChar, disDivCd, disDivName, calledFunc, connectCodeName ) {

	var opened = false;												// 画面が開かれているか
	var url    = '/webHains/contents/guide/gdeDisease.asp';			// 病名ガイド画面のURL

	url = url + '?disCd=' + disCd.value + '&disDivCd=' + disDivCd.value;

	// ガイド画面との連絡域を使用して処理制御を行う
	disGuide_DisCd      = disCd;
	disGuide_DisDivCd   = disDivCd;
	disGuide_SearchChar = SearchChar;
	disGuide_DisName    = document.getElementById( disName );
	disGuide_DisDivName = document.getElementById( disDivName );

	disGuide_CalledFunction  = calledFunc;
	disGuide_ConnectCodeName = connectCodeName;

	// すでにガイドが開かれているかチェック
	if ( winGuideDisease ) {
		if ( !winGuideDisease.closed ) {
			opened = true;
		}
	}

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideDisease.focus();
		winGuideDisease.location.replace( url );
	} else {
		winGuideDisease = window.open( url, '', 'width=700,height=570,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// 事業部情報編集用関数
function disGuide_setDiseaseInfo( disCd, disName, SearchChar, disDivCd, disDivName ) {

	// 病名コードの編集
	if ( disGuide_DisCd ) {
		disGuide_DisCd.value = disCd;
	}

	// 病類コードの編集
	if ( disGuide_DisDivCd ) {
		disGuide_DisDivCd.value = disDivCd;
	}

	// 病類コードの編集
	if ( disGuide_SearchChar ) {
		SearchChar.value = SearchChar;
	}

	// 病名の編集
	if ( disGuide_DisName ) {
		if ( disGuide_ConnectCodeName ) {
			disGuide_DisName.innerHTML = disCd + '：' + disName;
		} else {
			disGuide_DisName.innerHTML = disName;
		}
	}

	// 病類名の編集
	if ( disGuide_DisDivName ) {
		if ( disGuide_ConnectCodeName ) {
			disGuide_DisDivName.innerHTML = disDivCd + '：' + disDivName;
		} else {
			disGuide_DisDivName.innerHTML = disDivName;
		}
	}

	// 関数呼び出し
	if ( disGuide_CalledFunction ) {
		disGuide_CalledFunction();
	}

}

// 病名情報のクリア
function disGuide_clearDiseaseInfo( disCd, disName, SearchChar, disDivCd, disDivName ) {

	// 病名コードのクリア
	if ( disCd ) {
		disCd.value = '';
	}

	// 病類コードのクリア
	if ( disDivCd ) {
		disDivCd.value = '';
	}

	// ガイド検索用文字列のクリア
	if ( SearchChar ) {
		SearchChar.value = '';
	}

	// 病名エレメントのクリア
	if ( document.getElementById(disName) ) {
		document.getElementById(disName).innerHTML = '';
	}

	// 病類名称エレメントのクリア
	if ( document.getElementById(disDivName) ) {
		document.getElementById(disDivName).innerHTML = '';
	}

}

// ガイドを閉じる
function disGuide_closeGuideDisease() {

	if ( winGuideDisease ) {
		if ( !winGuideDisease.closed ) {
			winGuideDisease.close();
		}
	}

	winGuideDisease = null;
}
//-->
</SCRIPT>
