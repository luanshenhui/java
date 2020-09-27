<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		Ｘ線受診状況（年）(Ver0.0.1)
'		AUTHER  : (ORB)T.YAGUCHI
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode				'印刷モード
Dim vntMessage			'通知メッセージ
Dim strURL				'URL
Dim objFree						'汎用情報アクセス用
'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon								'共通クラス

'パラメータ値
Dim strSCslYear, strSCslMonth, strSCslDay	'受診開始年月日
Dim strDayId								'当日ID
Dim UID										'ユーザID
Dim dtmStrCslDate 	'開始受診
'作業用変数
Dim strSCslDate								'開始日
Dim strFreeCd					'汎用コード
Dim strFreeField1				'フィールド１
Dim strFreeField2				'フィールド１
Dim lngFreeCount				'汎用コード数
Dim strNationCd					'国籍コード
Dim i					'ループインデックス
Dim j					'ループインデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFree       = Server.CreateObject("HainsFree.Free")

'共通引数値の取得
strMode = Request("mode")
'strNationCd = Request("nationcd")

'帳票出力処理制御
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

'◆ 開始年月日
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'開始年
'		strSCslMonth  = Month(Now())			'開始月
'		strSCslDay    = Day(Now())				'開始日
	Else
		strSCslYear   = Request("strCslYear")	'開始年
'		strSCslMonth  = Request("strCslMonth")	'開始月
'		strSCslDay    = Request("strCslDay")	'開始日
	End If
'	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
	strSCslDate   = strSCslYear 


'◆ ユーザID
	UID = Session("USERID")
strNationCd     = Request("nationcd")
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
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

	'ここにチェック処理を記述
	With objCommon
'例)		.AppendArray vntArrMessage, コメント

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票ドキュメントファイル作成処理
'
' 引数　　 :
'
' 戻り値　 : 印刷ログ情報のシーケンス値
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objPrintCls		'Ｘ線受診状況（年）CSV作成用COMコンポーネント
	Dim Ret			'関数戻り値
	Dim strURL

	If Not IsArray(CheckValue()) Then
	

		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
		Set objPrintCls = Server.CreateObject("HainsprtXsituationsYear.XsituationsYear")

	    	'Ｘ線受診状況（年）CSV作成処理
		Ret = objPrintCls.PrintXsituationsYear(Session("USERID"), _
			                                strSCslYear, strNationCd)

		strMode = "csv"
		Print = Ret
	End If

End Function

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>■Ｘ線受診状況（年）</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■Ｘ線受診状況（年）</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>

	<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="114" NOWRAP>抽出年</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>年</TD>
		</TR>
	</TABLE>

<%
	lngFreeCount = objFree.SelectFree(1,"LST000592",strFreeCd,,,strFreeField1,strFreeField2)
%>


	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD><FONT COLOR="#ff0000">■</FONT></TD>
						<TD WIDTH="114" NOWRAP>抽出対象検査</TD>
						<TD>：</TD>
						<TD><%= EditDropDownListFromArray("nationcd", strFreeCd, strFreeField2, strNationCd, NON_SELECTED_DEL) %></TD>
					</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<INPUT TYPE="hidden" NAME="mode" VALUE="0">
		</TR>
	</TABLE>
				<BR><BR>

<!--- 印刷ボタン -->
	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
	<%  End if  %>
	</BLOCKQUOTE>
<!--
 <%= strSCslDate %> 
 <%= strNationCd  %>
-->
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>