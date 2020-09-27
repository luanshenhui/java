<%
'-----------------------------------------------------------------------------
'		印刷ダイアログ表示用 Include File (Ver0.0.1)
'		AUTHER  : Takagi@fsit.Fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// 印刷用小ウィンドウ表示
function showPrintDialog( no, rsvNo, cslDate ) {

	var url;		// URL文字列
	var winDialog;	// ウィンドウハンドル

	var dialogHeight = 100, dialogWidth = 200;
	var dialogTop, dialogLeft;

	// URLの編集
	url = '/webHains/contents/print/prtControl.asp?no=' + no + '&rsvNo=' + rsvNo;
	if ( cslDate != null ) {
		url = url + '&cslDate=' + cslDate;
	}

	// ダイアログを中央に表示するための計算
	dialogTop  = ( screen.height - dialogHeight ) / 2;
	dialogLeft = ( screen.width  - dialogWidth  ) / 2;

	// ダイアログを表示
	winDialog = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',resizable=yes' );

}
//-->
</SCRIPT>
