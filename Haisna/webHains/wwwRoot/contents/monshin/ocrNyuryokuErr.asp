<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   OCR入力結果確認（エラー）  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim lngRsvNo			'予約番号（今回分）
Dim strGrpNo			'グループNo
Dim strCsCd				'コースコード

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lngRsvNo			= Request("rsvno")

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>OCR入力結果確認</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 表示状態の変更
function chgSelect() {
	var myForm = document.entryForm;

	// 選択された状態のエラー情報を表示
	dispErrList( myForm.selectState.value );

	return;
}

// エラー情報を表示
function dispErrList( state ) {
	var ElementId;
	var strHtml;
	var i;

	strHtml = '<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">\n';
	strHtml = strHtml + '<TR>\n';
	strHtml = strHtml + '<TD COLSPAN="2" NOWRAP WIDTH="70" BGCOLOR="#eeeeee">状態</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">メッセージ</TD>\n';
	strHtml = strHtml + '</TR>\n';
	for ( i = 0; i < parent.lngErrCount; i++ ) {
		if ( state == 0 || state == parent.varErrState[i] ) {
			strHtml = strHtml + '<TR>\n';
			switch ( parent.varErrState[i] ) {
			case 1:
				strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:function voi(){};voi()"><IMG SRC="../../images/ico_e.gif" WIDTH="16" HEIGHT="16" ALT="エラー" BORDER="0" ONCLICK="JavaScript:jumpErrInfo(' + i + ')"></A></TD>\n';
				strHtml = strHtml + '<TD NOWRAP>エラー</TD>\n';
				break;
			case 2:
				strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:function voi(){};voi()"><IMG SRC="../../images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="警告" BORDER="0" ONCLICK="JavaScript:jumpErrInfo(' + i + ')"></A></TD>\n';
				strHtml = strHtml + '<TD NOWRAP>警告</TD>\n';
				break;
			default:
				strHtml = strHtml + '<TD COLSPAN="2" NOWRAP>"&nbsp;"</TD>\n';
			}

			strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:function voi(){};voi()" ONCLICK="JavaScript:jumpErrInfo(' + i + ')">' + parent.varErrMessage[i] + '</A></TD>\n';
		}
	}
	strHtml = strHtml + '</TABLE>\n';

	ElementId = 'OcrNyuryokuErrList';
	if( document.all ) {
		document.all(ElementId).innerHTML = strHtml;
	}else if( document.getElementById ) {
		document.getElementById(ElementId).innerHTML = strHtml;
	}

}

// エラー情報へジャンプ
function jumpErrInfo( index ) {
	var		strAnchor

	if( parent.varErrNo[index] > 0 ) {
		strAnchor = "Anchor-ErrInfo" + parent.varErrNo[index];

		parent.list.document.entryForm.anchor.value = strAnchor;
		parent.list.JumpAnchor();
	}

	return;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<BODY ONLOAD="javascript:dispErrList(0)">
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<TABLE WIDTH="985" BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD NOWRAP WIDTH="20"></TD>
			<TD NOWRAP VALIGN="top" WIDTH="100">表示：<SELECT NAME="selectState" SIZE="1" ONCHANGE="javascript:chgSelect()">
					<OPTION VALUE="1">エラー</OPTION>
					<OPTION VALUE="2">警告</OPTION>
					<OPTION VALUE="0" SELECTED>全て</OPTION>
				</SELECT>
			</TD>
			<TD>
				<SPAN ID="OcrNyuryokuErrList">
				<TABLE  BORDER="0" CELLSPACING="2" CELLPADDING="0">
					<TR>
						<TD COLSPAN="2" NOWRAP WIDTH="70" BGCOLOR="#eeeeee">状態</TD>
						<TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">メッセージ</TD>
					</TR>
				</TABLE>
				</SPAN>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
