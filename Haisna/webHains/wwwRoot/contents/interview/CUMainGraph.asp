<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ＣＵ経年変化（グラフ） (Ver0.0.1)
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
Dim vntLowerValue		'基準値（最低）
Dim vntUpperValue		'基準値（最高）
Dim lngRslCnt			'検査結果数

Dim lngItemCnt			'選択されている検査項目数
Dim strArrItemInfo()	'選択されている検査項目の情報
Dim strArrResult()		'選択されている検査項目の結果

'### 2004/07/17 Added by Ishihara@FSIT 各受診歴毎の基準値設定対応
Dim strArrLowerValue()		'各受診歴毎の基準値（低）
Dim strArrUpperValue()		'各受診歴毎の基準値（高）
'### 2004/07/17 Added End

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
														, _
														vntLowerValue, _
														vntUpperValue, _
														, , , , , , 1 _
														)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	lngItemCnt = 0
	Redim strArrItemInfo( 5, -1 )
'	Redim strArrResult( lngHisCount-1, -1 )
	Redim strArrResult( 10, -1 )
'### 2004/07/17 Added by Ishihara@FSIT 各受診歴毎の基準値設定対応
	Redim Preserve strArrLowerValue( 10, -1 )
	Redim Preserve strArrUpperValue( 10, -1 )
'### 2004/07/17 Added End
	'選択されている検査項目を抽出
	strItem = ""
	For i=0 To lngRslCnt-1
		If strItem <> vntItemCd(i) & "-" & vntSuffix(i) Then
			lngItemCnt = lngItemCnt + 1
			Redim Preserve strArrItemInfo( 5, lngItemCnt ) 
'			Redim Preserve strArrResult( lngHisCount-1, lngItemCnt ) 
			Redim Preserve strArrResult( 10, lngItemCnt ) 

'### 2004/07/17 Added by Ishihara@FSIT 各受診歴毎の基準値設定対応
			Redim Preserve strArrLowerValue( 10, lngItemCnt ) 
			Redim Preserve strArrUpperValue( 10, lngItemCnt ) 
'### 2004/07/17 Added End
		End If

		strArrItemInfo( 0, lngItemCnt ) = vntItemName(i)	'検査項目名称
		strArrItemInfo( 1, lngItemCnt ) = vntItemCd(i)		'検査項目コード
		strArrItemInfo( 2, lngItemCnt ) = vntSuffix(i)		'サフィックス
		strArrItemInfo( 3, lngItemCnt ) = vntLowerValue(i)	'基準値（最低）
		strArrItemInfo( 4, lngItemCnt ) = vntUpperValue(i)	'基準値（最高）
		'過去の結果が左にくるようにする
		strArrResult( lngHisCount - vntHisNo(i), lngItemCnt ) = vntResult(i)
'### 2004/07/17 Added by Ishihara@FSIT 各受診歴毎の基準値設定対応
		strArrLowerValue( lngHisCount - vntHisNo(i), lngItemCnt ) = vntLowerValue(i)
		strArrUpperValue( lngHisCount - vntHisNo(i), lngItemCnt ) = vntUpperValue(i)
'### 2004/07/17 Added End

		strItem = vntItemCd(i) & "-" & vntSuffix(i)
	Next

	'表示ボタン押下時に呼び出される自画面の関数を設定する
	DispCalledFunction = "callCUMainGraphTop()"

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
<SCRIPT TYPE="text/javascript">
<!--
// 下フレームの画面切替
function changeResultFrame() {

	var elem   = document.getElementById('anchorName');
	var myForm = document.entryForm;

	switch ( elem.innerHTML ) {
		case '生活習慣':
			elem.innerHTML = '測定値';
			parent.result.location.href = 'CULifeHabit.asp?<%= Request.ServerVariables("QUERY_STRING") %>';
			break;

		case '測定値':
			elem.innerHTML = '生活習慣';
			parent.result.location.href = 'CUResult.asp?<%= Request.ServerVariables("QUERY_STRING") %>';
			break;

	}

	return;
}

//表示
function callCUMainGraphTop() {

	// Topに選択されたコースグループを指定してsubmit
	parent.document.entryForm.csgrp.value = document.entryForm.csgrp.value;

	parent.document.entryForm.submit();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" STYLE="margin: 0px;" TARGET="result" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="920">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">ＣＵ経年変化</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'前回歴コンボボックス表示
			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
	<!-- リンクの表示 -->
	<TABLE BORDER="1" CELLSPACING="2" CELLPADDING="0">
		<TR>
			<TD NOWRAP ALIGN="center" WIDTH="120"><A HREF="CUSelectItemsMain.asp?<%= Request.ServerVariables("QUERY_STRING") %>" TARGET="_parent">項目選択画面へ</A></TD>
			<TD NOWRAP ALIGN="center" WIDTH="120"><A HREF="JavaScript:" ONCLICK="JavaScript:changeResultFrame(); return false;"><SPAN ID="anchorName">生活習慣</SPAN></A></TD>
		</TR>
	</TABLE>
	<!-- グラフの表示 -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="900">
		<TR>
			<TD>
<%
	If lngItemCnt > 0 Then
'### 2004/07/15 Updated by Ishihara@FSIT 各受診歴毎の基準値設定対応（ActiveX UpGrade)
%>
				<OBJECT ID="HainsChartCu" CLASSID="CLSID:4038097A-F1AD-4DE1-B76F-27A225AF5E54" CODEBASE="/webHains/cab/Graph/HainsChartCu.CAB#version=1,1,0,0"></OBJECT>
<%
	End If
%>
			</TD>
		</TR>
	</TABLE>

<%
	If lngItemCnt > 0 Then
%>
<script type="text/javascript">
	var GraphActiveX = document.getElementById("HainsChartCu");

	// X軸を固定するために常に受診回数を10回とする
	GraphActiveX.SetConsCount(10);
	GraphActiveX.SetItemCount(<%=lngItemCnt %>);
<%	For i=0 To lngHisCount-1 %>
	GraphActiveX.SetCslDate(<%=i%>,"<%=vntHisCslDate(i)%>");
<%	Next %>
<%	For i=1 To lngItemCnt %>
		GraphActiveX.SetItemName(<%=i-1%>,"<%=strArrItemInfo(0, i)%>");
		GraphActiveX.SetStdValue(<%=i-1%>, "<%=strArrItemInfo(3, i)%>", "<%=strArrItemInfo(4, i)%>");
<%		For j=0 To lngHisCount-1 %>
			GraphActiveX.SetResultWithStdValue(<%=i-1%>,<%=j%>,"<%=strArrResult(j, i)%>","<%= strArrLowerValue(j, i) %>", "<%= strArrUpperValue(j, i) %>");
<%		Next
	Next
%>
	GraphActiveX.ShowGraph();
</script>
<%
	End If
%>
</FORM>
</BODY>
</HTML>
