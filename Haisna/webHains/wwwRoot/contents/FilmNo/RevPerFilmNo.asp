<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		フィルム番号発番情報修正 (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon	 		'共通クラス
Dim objFree	 			'汎用テーブル

Dim strMode				'処理モード

'汎用テーブル
Dim strKeyFreeCd		'汎用コード（検索キー）
Dim strFreeCd			'汎用コード
Dim strFreeName			'汎用名称
Dim strFreeDate			'更新日
Dim strFreeField1		'フィルム番号
Dim strFreeField2		'プリフィックス
Dim strFreeField3		'検査項目コード
Dim strFreeField4		'サフィックス
Dim strFreeField5		'汎用フィールド５（未使用）
Dim strFreeClassCd		'汎用分類コード

Dim lngFreeCount		'戻り値（汎用テーブル）

Dim i	  				'ループカウント

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon 		= Server.CreateObject("HainsCommon.Common")
Set objFree 		= Server.CreateObject("HainsFree.Free")

strMode			= Request("mode")
strKeyFreeCd	= Request("freeCd")
strFreeClassCd	= Request("freeClassCd")
strFreeName		= Request("freeName")
strFreeField1	= Request("freeField1")
strFreeField2	= Request("freeField2")
strFreeField3	= Request("freeField3")
strFreeField4	= Request("freeField4")
strFreeField5	= Request("freeField5")

strFreeDate = FormatDateTime(Now,2)

'更新処理
If( strMode = "update"  ) Then
	lngFreeCount = objFree.UpdateFree( _
									strKeyFreeCd, _
									strFreeClassCd, _
									strFreeName, _
									strFreeDate, _
									strFreeField1, _
									strFreeField2, _
									strFreeField3, _
									strFreeField4, _
									strFreeField5 _
								 	)
End If


'汎用テーブルよりフィルム種別名を取得
If( strKeyFreeCd <> "" ) Then
	lngFreeCount = objFree.SelectFree( _
									0, _
									strKeyFreeCd, _
									strFreeCd, _
									strFreeName, _
									strFreeDate, _
									strFreeField1, _
									strFreeField2, _
									strFreeField3, _
									strFreeField4, _
									strFreeField5, _
									false, _
									strFreeClassCd _
								 	)

'*****  2003/01/17  EDIT  START  E.Yamamoto
	If( Not IsNull(strFreeField1) AND strFreeField1 <> "" ) Then
		If( Clng(strFreeField1) = 99999999 ) Then
			strFreeField1 = "1"
		End If
	End If
'*****  2003/01/17  EDIT  END  E.Yamamoto

End If

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

function updateSubmit(){

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	 if( confirm('データを保存します。よろしいですか？') ){
		if( Number( objForm.freeField1.value ) ){
			objForm.mode.value = 'update';
			objForm.submit();
		}else{
			alert('フィルム番号に数値以外の文字が含まれています。');
			objForm.freeField1.focus();
		}
	}

}

//-->
</SCRIPT>

<TITLE>個人フィルム番号修正</TITLE>
</HEAD>

<BODY ONLOAD="document.entryForm.freeField1.focus()">


<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<BASEFONT SIZE="2">
<BLOCKQUOTE>
<FORM NAME="entryForm" ACTION="" METHOD="get">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">個人フィルム番号発番情報修正</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<INPUT TYPE="hidden" NAME="mode"  VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="freeCd" VALUE="<%= strKeyFreeCd %>">
<INPUT TYPE="hidden" NAME="freeClassCd" VALUE="<%= strFreeClassCd %>">
<INPUT TYPE="hidden" NAME="freeName" VALUE="<%= strFreeName %>">
<INPUT TYPE="hidden" NAME="freeField2" VALUE="<%= strFreeField2 %>">
<INPUT TYPE="hidden" NAME="freeField3" VALUE="<%= strFreeField3 %>">
<INPUT TYPE="hidden" NAME="freeField4" VALUE="<%= strFreeField4 %>">
<INPUT TYPE="hidden" NAME="freeField5" VALUE="<%= strFreeField5 %>">
<BR>
<%
	If( strMode = "update" )Then
		Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)
	End If
%>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="1159">
	<TR>
		<TD VALIGN="top" WIDTH="15"></TD>
		<TD VALIGN="top">修正フィルム番号種類：<B><%= strFreeName %></B><BR>
		<BR>
			現在のフィルム番号：<INPUT TYPE="text" NAME="freeField1" SIZE="10" MAXLENGTH="8" VALUE="<%= strFreeField1 %>"></TD>
	</TR>
	<TR>
		<TD WIDTH="15"></TD>
		<TD><BR>
			<A HREF="javascript:updateSubmit()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="フィルム番号の更新"></A>
		</TD>
	</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
