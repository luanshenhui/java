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

'*****  2003/01/21  ADD  START  E.Yamamoto
Const FREECD = "FILM"	'汎用コード
Dim strMachineCls		'号機区分
Dim strMachineNo		'号機番号
Dim strDispFreeName		'汎用名（表示用）
Dim strArrMessage		'エラーメッセージ
'*****  2003/01/21  ADD  END    E.Yamamoto
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

'*****  2003/01/21  ADD  START  E.Yamamoto
call EditFreeCd(strKeyFreeCd)
'*****  2003/01/21  ADD  END    E.Yamamoto

'*****  2003/01/22  ADD  START  E.Yamamoto  
'更新処理
do
	If( strMode = "update"  ) Then
		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

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
		If( lngFreeCount = False ) Then
			objCommon.AppendArray vntArrMessage, "フィルム番号の更新に失敗しました。"
		End If
	Else

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
	
	End If

	
	exit Do
Loop


'*****  2003/01/21  ADD  START  E.Yamamoto
If( strMachineCls <> 0 ) then
	strDispFreeName = strFreeName & "（" & strMachineNo & "号機)"
Else
	strDispFreeName = strFreeName
End If
'*****  2003/01/21  ADD  END    E.Yamamoto

'*****  2003/01/21  ADD  START  E.Yamamoto
'-------------------------------------------------------------------------------
'
' 機能　　 : フリーコードをから号機区分，号機番号を取得する
'
' 引数　　 : 
'
' 戻り値　 : なし
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function EditFreeCd(strFreeCd)

	Dim lngStrLength
	Dim lngConstStrLength
	
	lngStrLength = len(strFreeCd)
	lngConstStrLength = len(FREECD) + 1
	
	strMachineCls = mid(strFreeCd,lngConstStrLength,1)
	lngConstStrLength = lngConstStrLength + 1
	
	strMachineNo = mid(strFreeCd,lngConstStrLength,1)
 	
End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 団体情報各値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()


	Dim vntArrMessage	'エラーメッセージの集合
	Dim strMessage		'エラーメッセージ
	Dim i				'インデックス

	'各値チェック処理
	With objCommon
	
		'カナ姓
		If( strFreeField1 <> "" ) Then
			If( Not IsNumeric(strFreeField1) ) Then
				.AppendArray vntArrMessage, "フィルム番号に数値以外の文字が含まれています。"
			End If
		End If

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'*****  2003/01/21  ADD  END    E.Yamamoto
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
	objForm.mode.value = 'update';
	objForm.submit();

}

//-->
</SCRIPT>

<TITLE>フィルム番号修正</TITLE>
</HEAD>

<BODY ONLOAD="document.entryForm.freeField1.focus()">


<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<BASEFONT SIZE="2">
<BLOCKQUOTE>
<FORM NAME="entryForm" ACTION="" METHOD="get">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">フィルム番号発番情報修正</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<INPUT TYPE="hidden" NAME="mode"  VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="freeCd" VALUE="<%= strKeyFreeCd %>">
<INPUT TYPE="hidden" NAME="freeClassCd" VALUE="<%= strFreeClassCd %>">
<INPUT TYPE="hidden" NAME="freeName" VALUE="<%= strFreeName %>">
<INPUT TYPE="hidden" NAME="freeField3" VALUE="<%= strFreeField3 %>">
<INPUT TYPE="hidden" NAME="freeField4" VALUE="<%= strFreeField4 %>">
<INPUT TYPE="hidden" NAME="freeField5" VALUE="<%= strFreeField5 %>">
<%
	'メッセージの編集
	If( strMode = "update" )Then

		'保存完了時は「保存完了」の通知
		If( IsEmpty(strArrMessage) ) Then
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
%>
		<BR>
<%
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD NOWRAP>修正フィルム番号種類</TD>
		<TD>：</TD>
		<TD><B><%= strDispFreeName %></B></TD>
	</TR>
	<TR><TD HEIGHT="10"></TD>
	</TR>
	<TR>
		<TD NOWRAP>フィルム番号先頭文字列</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="text" NAME="freeField2" SIZE="8" MAXLENGTH="2" VALUE="<%= strFreeField2 %>"></TD>
	</TR>
		<TD NOWRAP>現在のフィルム番号</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="text" NAME="freeField1" SIZE="10" MAXLENGTH="8" VALUE="<%= strFreeField1 %>"></TD>
		<TD></TD>
	</TR>
	</TR>
		<TD></TD>
		<TD></TD>
		<TD><FONT COLOR="#666666">※次の受診者は、ここで指定された番号＋１から発番されます。</FONT></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
<TR>
<TD><A HREF="FilmNo.asp?freeCd=<%= strKeyFreeCd %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="バーコード入力画面に戻ります"></A></TD>
<TD WIDTH="7"></TD>
<TD><A HREF="javascript:updateSubmit()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="フィルム番号の更新"></A></TD>
</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
