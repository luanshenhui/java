<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   所見選択 (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim lnglineno			'行番号
Dim strItemCd			'検査項目コード
Dim strSuffix			'サフィックス
Dim lngItemType			'項目タイプ
Dim strItemName			'検査項目名称
Dim strStcCd			'文章コード

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lnglineno			= Request("lineno")
strItemCd			= Request("itemcd")
strSuffix			= Request("suffix")
lngItemType			= Request("itemtype")
strItemName			= Request("itemname")
strStcCd			= Request("stccd")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>所見選択</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!--
// 所見選択画面の確定
function SentenceOk() {
	var		listForm = top.list.document.entryForm;	// 所見選択(ボディ)のフォームエレメント
	var		count;			// 所見選択数
	var		i;				// インデックス

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return;
	}

	// 選択チェック
	count = 0;
	for( i=0; i<listForm.chk.length; i++ ) {
		if( listForm.chk[i].checked ) {
			count++;
		}
	}
	if( count > opener.SameCount ) {
		alert( "この検査項目の選択可能数は" + opener.SameCount + "件です" );
		return;
	}

	// 所見のセット
	count = 0;
	for( i=0; i<listForm.chk.length; i++ ) {
		if( listForm.chk[i].checked ) {
			opener.setSentenceInfo( opener.SameLineno[count], listForm.stccd[i].value, listForm.shortstc[i].value );
			count++;
		}
	}
	for( i=count; i<opener.SameCount; i++ ) {
		opener.clearSentenceInfo( opener.SameLineno[i] );
	}
	

	opener.winSentence = null;
	close();

	return;
}
//-->
</SCRIPT>
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="90,*">
	<FRAME NAME="header" SRC="SentenceHeader.asp?itemname=<%=strItemName%>">
	<FRAME NAME="list"   SRC="SentenceBody.asp?itemcd=<%=strItemCd%>&itemtype=<%=lngItemType%>&stccd=<%=strStcCd%>">
</FRAMESET>
</HTML>