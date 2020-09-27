<%
'-----------------------------------------------------------------------------
'		色ガイド Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var colorGuide_ElemObj;			// セットカラー格納用エレメント
var colorGuide_ColorElemName;	// セットカラー変更用エレメント

var winColor;					// ウィンドウハンドル

// 色選択ガイド画面を表示
function colorGuide_showGuideColor( elemObj, colorElemName ) {

	var opened = false;	// 画面が開かれているか

	// ガイド画面との連絡域を使用して処理制御を行う
	colorGuide_ElemObj = elemObj;
	colorGuide_ColorElemName = colorElemName;

	// すでにガイドが開かれているかチェック
	if ( winColor != null ) {
		if ( !winColor.closed ) {
			opened = true;
		}
	}

	var url = '/webHains/contents/guide/gdeColor.asp';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winColor.focus();
	} else {
		winColor = window.open(url, '', 'width=270,height=184,status=no,directories=no,menubar=no,resizable=no,toolbar=no');
	}

}

// ガイドを閉じる
function colorGuide_closeGuideColor() {

	if ( winColor ) {
		if ( !winColor.closed ) {
			winColor.close();
		}
	}

	winColor = null;
}
//-->
</SCRIPT>
