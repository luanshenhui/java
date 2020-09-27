<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   結果参照　経年変化 (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editGrpList.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
If Request("mode") = "1" Then
	Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)
Else
	Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)
End If

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim strAction				'処理状態(表示ボタン押下時:"select")
Dim strPerID				'個人ＩＤ
Dim strGrpCd				'検査グループコード
Dim lngCslYear				'受診日(年)
Dim lngCslMonth				'受診日(月)
Dim lngCslDay				'受診日(日)
Dim strHisCount				'表示歴数

'表示色
Dim strH_Color				'基準値フラグ色（Ｈ）
Dim strU_Color				'基準値フラグ色（Ｕ）
Dim strD_Color				'基準値フラグ色（Ｄ）
Dim strL_Color				'基準値フラグ色（Ｌ）
Dim strT1_Color				'基準値フラグ色（＊）
Dim strT2_Color				'基準値フラグ色（＠）

Dim objCommon				'共通関数アクセス用COMオブジェクト

Const STDFLG_H = "H"		'異常（上）
Const STDFLG_U = "U"		'軽度異常（上）
Const STDFLG_D = "D"		'軽度異常（下）
Const STDFLG_L = "L"		'異常（下）
Const STDFLG_T1 = "*"		'定性値異常
Const STDFLG_T2 = "@"		'定性値軽度異常

Const STDFLG_MARK_HU = "▲"	'基準値フラグ "H","U" 表示用記号
Const STDFLG_MARK_DL = "▼"	'基準値フラグ "D","L" 表示用記号
Const STDFLG_MARK_T  = "■"	'基準値フラグ "@","*" 表示用記号

Dim lngConsultCount			'受診歴件数
Dim lngGrpCount				'グループ内検査項目件数
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strAction   = Request("act")
strPerID    = Request("perID")
strGrpCd    = Request("grpCd")
lngCslYear  = CLng("0" & Request("cslYear") )
lngCslMonth = CLng("0" & Request("cslMonth"))
lngCslDay   = CLng("0" & Request("cslDay")  )
strHisCount = Request("hisCount")

'受診日のデフォルト値設定
lngCslYear  = IIf(lngCslYear  = 0, Year(Date()),  lngCslYear )
lngCslMonth = IIf(lngCslMonth = 0, Month(Date()), lngCslMonth)
lngCslDay   = IIf(lngCslDay   = 0, Day(Date()),   lngCslDay  )

'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'規定の表示歴数
If IsEmpty(strHisCount) Then
	strHisCount = objCommon.SelectInqHistoryCount()
End If

'基準値フラグ色取得
Call objCommon.SelectStdFlgColor("H_COLOR", strH_Color)
Call objCommon.SelectStdFlgColor("U_COLOR", strU_Color)
Call objCommon.SelectStdFlgColor("D_COLOR", strD_Color)
Call objCommon.SelectStdFlgColor("L_COLOR", strL_Color)
Call objCommon.SelectStdFlgColor("*_COLOR", strT1_Color)
Call objCommon.SelectStdFlgColor("@_COLOR", strT2_Color)

'オブジェクトのインスタンス削除
Set objCommon = Nothing

'-----------------------------------------------------------------------------
' 表示歴数ドロップダウン編集
'-----------------------------------------------------------------------------
Function EditHisCountList(strName, strSelectedHisCount)

	Dim strHisCount		'表示歴数
	Dim strHisCountName	'表示歴数名称

	Dim lngCount		'件数

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'表示歴数情報の読み込み
	lngCount = objCommon.SelectInqHistoryCountList(strHisCount, strHisCountName)

	If lngCount > 0 Then
		'ドロップダウンリストの編集
		EditHisCountList = EditDropDownListFromArray(strName, strHisCount, strHisCountName, strSelectedHisCount, NON_SELECTED_DEL)
	End If

	'オブジェクトのインスタンス削除
	Set objCommon = Nothing

End Function

'-----------------------------------------------------------------------------
' 検査結果編集
'-----------------------------------------------------------------------------
Sub EditRslHistory()

	Dim objConsult			'受診情報アクセス用COMオブジェクト
	Dim objGrp				'検査項目情報アクセス用COMオブジェクト
	Dim objResult			'検査結果情報アクセス用COMオブジェクト

	Dim strKeyCslDate		'受診日
	
	'受診歴情報
	Dim strRsvNo			'予約番号
	Dim strCslDate			'受診日
	Dim strCsName			'コース名

	'検査項目情報
	Dim strItemCd			'検査項目コード
	Dim strSuffix			'サフィックス
	Dim strItemName			'検査項目名称

	'検査結果情報
	Dim strRslItemCd		'検査項目コード
	Dim strRslSuffix		'サフィックス
	Dim strRslRsvNo			'予約番号
	Dim strResult			'検査結果
	Dim strStdFlg			'基準値表示色

	Dim strDispResult		'編集用検査結果
	Dim strDispStdFlg		'編集用基準値フラグ
	Dim strDispStdFlgColor	'編集用基準値表示色
	Dim strDispStdFlgMark	'編集用基準値フラグ記号

	Dim lngHisCount			'取得歴数
	Dim lngRslCount			'検査結果件数

	Dim i					'インデックス
	Dim j					'インデックス
	Dim k					'インデックス

	'初期表示時は何もしない
	If strAction = "" Then
		Exit Sub
	End If
	
	'検査グループが指定されてない場合何もしない
	If strGrpCd = "" Then
		Exit Sub
	End If

	strKeyCslDate = lngCslYear & "/" & lngCslMonth & "/" & lngCslDay

	If Not IsDate(strKeyCslDate) Then
%>
		<BR>受診日の形式に誤りがあります。
<%
		Exit Sub
	End If

	'オブジェクトのインスタンス作成
	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	Set objGrp    = Server.CreateObject("HainsGrp.Grp")
	Set objResult  = Server.CreateObject("HainsResult.Result")

	'取得歴数の設定
	If IsNumeric(strHisCount) Then
		lngHisCount = CLng(strHisCount)
	End If

	'受診歴読取得
	lngConsultCount = objConsult.SelectConsultHistory(strPerID, strKeyCslDate, , , lngHisCount, strRsvNo, strCslDate, , strCsName)

	'グループ内検査項目取得
	lngGrpCount = objGrp.SelectGrpItem_cList(strGrpCd, strItemCd, strSuffix, strItemName)

	'受診歴が存在しない
	If lngConsultCount = 0 Then
%>
		<BR>この受診者の受診歴は存在しません。
<%
		'オブジェクトのインスタンス削除
		Set objConsult = Nothing
		Set objGrp    = Nothing
		Set objResult  = Nothing

		Exit Sub
	End If

	'検査結果が存在しない
	If lngGrpCount = 0 Then
%>
		<BR>このグループの検査は受診していません。
<%
		'オブジェクトのインスタンス削除
		Set objConsult = Nothing
		Set objGrp    = Nothing
		Set objResult  = Nothing

		Exit Sub
	End If

	'検査結果取得
	lngRslCount = objResult.SelectInqHistoryRslList(strPerID, strKeyCslDate, strHisCount, strGrpCd, strRslRsvno, strRslItemCd, strRslSuffix, strResult, strStdFlg)
%>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" class="mensetsu-tb">
		<TR ALIGN="center" BGCOLOR="#E6E6E6">
			<TD ROWSPAN="2" ALIGN="center">検査項目</TD>
<%
			For i = 0 To lngConsultCount - 1
%>
				<TD><A HREF="/webHains/contents/inquiry/inqReport.asp?rsvNo=<%= strRsvNo(i) %>" target="detail"><%= strCslDate(i) %></A></TD>
<%
			Next
%>
		</TR>
		<TR ALIGN="center" BGCOLOR="#e6e6e6">
<%
			For i = 0 To lngConsultCount - 1
%>
				<TD><%= strCsName(i) %></TD>
<%
			Next
%>
		</TR>
<%
		'検査項目数ループ
		For i = 0 To lngGrpCount - 1
%>
			<TR>
				<TD NOWRAP><%= strItemName(i) %></TD>
<%
				'表示歴数ループ
				For j = 0 To lngConsultCount - 1

					strDispResult = ""
					strDispStdFlg = ""

					'検査結果数ループ
					For k = 0 To lngRslCount - 1
						If strRslItemCd(k) = strItemCd(i) And strRslSuffix(k) = strSuffix(i) And strRslRsvNo(k)  = strRsvNo(j) Then
							strDispResult = strResult(k)
							strDispStdFlg = strStdFlg(k)
							Exit For
						End If
					Next

					'基準値フラグにより色を設定する
					Select Case strDispStdFlg
						Case STDFLG_H
							strDispStdFlgColor = strH_Color
							strDispStdFlgMark  = STDFLG_MARK_HU
						Case STDFLG_U
							strDispStdFlgColor = strU_Color
							strDispStdFlgMark  = STDFLG_MARK_HU
						Case STDFLG_D
							strDispStdFlgColor = strD_Color
							strDispStdFlgMark  = STDFLG_MARK_DL
						Case STDFLG_L
							strDispStdFlgColor = strL_Color
							strDispStdFlgMark  = STDFLG_MARK_DL
						Case STDFLG_T1
							strDispStdFlgColor = strT1_Color
							strDispStdFlgMark  = STDFLG_MARK_T
						Case STDFLG_T2
							strDispStdFlgColor = strT2_Color
							strDispStdFlgMark  = STDFLG_MARK_T
						Case Else
							strDispStdFlgColor = "#000000"
							strDispStdFlgMark  = "　"
					End Select

					If strDispResult = "" Then
						strDispResult = "&nbsp;"
					End If
%>
					<TD>
						<span style="color:<%= strDispStdFlgColor %>"><%= strDispResult %></span>
						<span style="color:<%= strDispStdFlgColor %>"><%= strDispStdFlgMark %></span>
					</TD>
<%
				Next
%>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'オブジェクトのインスタンス削除
	Set objConsult = Nothing
	Set objGrp    = Nothing
	Set objResult  = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>経年変化</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 0 0 0 10px; }
	table.mensetsu-tb td.noborder { border:none;}
</style>
</HEAD>
<BODY>
<FORM NAME="history" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<DIV ALIGN="left">
<INPUT TYPE="hidden" NAME="act" VALUE="select">
<INPUT TYPE="hidden" NAME="perID" VALUE="<%= strPerID %>">
<INPUT TYPE="hidden" NAME="mode" VALUE="<%= Request("mode") %>">
<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="inquiry">■</SPAN><FONT COLOR="#000000">経年変化</FONT></B></TD>
	</TR>
</TABLE>
<BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>検査項目グループ：</TD>
		<TD><%= EditGrpIList_GrpDiv("grpCd", strGrpCd, "", "", ADD_FIRST) %></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
		<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
		<TD>年</TD>
		<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
		<TD>月</TD>
		<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
		<TD>日</TD>
		<TD>から過去</TD>
		<TD><%= EditHisCountList("hisCount", strHisCount) %></TD>
		<TD>歴まで</TD>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.history.submit();return false"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定月から表示"></A></TD>
	</TR>
</TABLE>

<!-- 検査結果編集 -->
<% Call EditRslHistory() %>
<BR>
<% If strAction <> "" And lngConsultCount > 0 And lngGrpCount > 0 Then %>
	<FONT COLOR="<%= strH_Color%>"><%= STDFLG_MARK_HU %></FONT>:異常(高) <FONT COLOR="<%= strU_Color %>"><%= STDFLG_MARK_HU %></FONT>:軽度異常(高) <FONT COLOR="<%= strD_Color %>"><%= STDFLG_MARK_DL %></FONT>:軽度異常(低) <FONT COLOR="<%= strL_Color %>"><%= STDFLG_MARK_DL %></FONT>:異常(低) <FONT COLOR="<%= strT1_Color %>"><%= STDFLG_MARK_T %></FONT>:定性値異常 <FONT COLOR="<%= strT2_Color %>"><%= STDFLG_MARK_T %></FONT>:定性値軽度異常<BR>
<% End If %>
<BR><BR>
</DIV>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>