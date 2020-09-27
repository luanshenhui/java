<%
'-----------------------------------------------------------------------------
'	   ＣＵ経年変化（測定値） (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード
Dim strArrItemCd		'検査項目コード
Dim strArrSuffix		'サフィックス

'受診歴一覧用変数
Dim lngLastDspMode		'前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp			'前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
Dim vntHisPerId			'個人ＩＤ
Dim vntHisRsvNo			'予約番号
Dim vntHisCslDate		'受診日
Dim vntCsCd				'コースコード
Dim vntCsName			'コース名
Dim vntCsSName			'コース略称
Dim lngHisCount			'表示歴数

'検査結果用変数
Dim vntPerId			'予約番号
Dim vntCslDate			'検査項目コード
Dim vntHisNo			'履歴No.
Dim vntRsvNo			'予約番号
Dim vntItemCd			'検査項目コード
Dim vntSuffix			'サフィックス
Dim vntResultType		'結果タイプ
Dim vntItemType			'項目タイプ
Dim vntItemName			'検査項目名称
Dim vntResult			'検査結果
Dim lngRslCnt			'検査結果数

Dim lngItemCnt			'選択されている検査項目数
Dim strArrItemInfo()	'選択されている検査項目の情報
Dim strArrResult()		'選択されている検査項目の結果
Dim strItem				'処理対象の検査項目
Dim i, j				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf(strSelCsGrp="", "0", strSelCsGrp)

strArrItemCd		= ConvIStringToArray(Request("itemcd"))
strArrSuffix		= ConvIStringToArray(Request("suffix"))

Select Case strSelCsGrp
	'すべてのコース
	Case "0"
		lngLastDspMode = 0
		vntCsGrp = ""
	'同一コース
	Case "1"
		lngLastDspMode = 1
		vntCsGrp = strCsCd
	Case Else
		lngLastDspMode = 2
		vntCsGrp = strSelCsGrp
End Select

Do	

	'指定された個人ＩＤの受診歴一覧を取得する
	lngHisCount = objInterView.SelectConsultHistory( _
						lngRsvNo, _
						False, _
						lngLastDspMode, _
						vntCsGrp, _
						10, _
						0, _
						vntHisPerId, _
						vntHisRsvNo, _
						vntHisCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName, _
						1 _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "受診歴が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	'指定対象受診者の検査結果を取得する
	lngRslCnt = objInterView.SelectHistoryRslList_Item( _
														lngRsvNo, _
														lngHisCount, _
														strArrItemCd, _
														strArrSuffix, _
														lngLastDspMode, _
														vntCsGrp, _
														0, _
														0, _
														1, _
														vntPerId, _
														vntCslDate, _
														vntHisNo, _
														vntRsvNo, _
														vntItemCd, _
														vntSuffix, _
														vntResultType, _
														vntItemType, _
														, _
														vntItemName, _
														, _
														, _
														vntResult, _
														, , , , , , , , , _
														1 _
														)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	lngItemCnt = 0
	Redim strArrItemInfo( 3, -1 )
	Redim strArrResult( lngHisCount-1, -1 )
	'選択されている検査項目を抽出
	strItem = ""
	For i=0 To lngRslCnt-1
		If strItem <> vntItemCd(i) & "-" & vntSuffix(i) Then
			lngItemCnt = lngItemCnt + 1
			Redim Preserve strArrItemInfo( 3, lngItemCnt ) 
			Redim Preserve strArrResult( lngHisCount-1, lngItemCnt ) 
		End If

		strArrItemInfo( 0, lngItemCnt ) = vntItemName(i)
		strArrItemInfo( 1, lngItemCnt ) = vntItemCd(i)
		strArrItemInfo( 2, lngItemCnt ) = vntSuffix(i)
		'過去の結果が左にくるようにする
		strArrResult( lngHisCount - vntHisNo(i), lngItemCnt ) = vntResult(i)

		strItem = vntItemCd(i) & "-" & vntSuffix(i)
	Next

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>ＣＵ経年変化</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- 測定値の表示 -->
	<TABLE BORDER="1" CELLSPACING="1" CELLPADDING="1">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<TD WIDTH="130" NOWRAP>検査項目</TD>
<%
	For i=0 To lngHisCount-1
%>
			<TD WIDTH="60" NOWRAP><%=vntHisCslDate(i)%></TD>
<%
	Next
%>
		</TR>
<%
	For i=1 To lngItemCnt
%>	
		<TR ALIGN="right">
			<TD ALIGN="left" NOWRAP><%=strArrItemInfo(0, i)%></TD>
<%
		For j=0 To lngHisCount-1
%>
			<TD><%=IIf(strArrResult(j, i)="", "&nbsp;", strArrResult(j, i))%></TD>
<%
		Next
%>
		</TR>
<%
	Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
