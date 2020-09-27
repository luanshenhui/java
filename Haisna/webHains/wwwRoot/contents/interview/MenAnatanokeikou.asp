<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   多項目検査から見たあなたの傾向 (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_SDI = "X050"	'失点分布グループコード

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用
Dim objConsult			'受診クラス

Dim Ret					'復帰値
Dim i, j				'カウンター

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

'受診情報用変数
Dim lngLastDspMode		'前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp			'前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
Dim vntCslRsvNo			'予約番号
Dim vntCslCslDate		'受診日
Dim lngCount			'件数

Dim	dblValueX			'統計量Ｚ１（Ｘ座標）
Dim	dblValueY			'統計量Ｚ２（Ｘ座標）

'グラフへの引数
Dim vntGraphCslDate		'受診日の配列
Dim vntValueX			'統計量Ｚ１（Ｘ座標）の配列
Dim vntValueY			'統計量Ｚ２（Ｙ座標）の配列

Dim strArrMessage		'エラーメッセージ

Dim vntPerId
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult 		= Server.CreateObject("HainsConsult.Consult")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

strSelCsGrp		= Request("csgrp")
strSelCsGrp = IIf( strSelCsGrp="", 0, strSelCsGrp)

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

'	strArrMessage = ""
'	lngLastDspMode = 0
'	vntCsGrp = ""
	'検索条件に従い受診情報一覧を抽出する（全件）
	lngCount = objInterview.SelectConsultHistory( _
							    lngRsvNo, _
    							 , _
    							lngLastDspMode, _
    							vntCsGrp, _
    							 , _
    							 ,  , _
								vntCslRsvNo, _
    							vntCslCslDate _
								)

	If lngCount <= 0 Then
		objCommon.AppendArray strArrMessage, "受診情報がありません。RsvNo= "  & lngRsvNo 
'		Err.Raise 1000, , "受診情報がありません。RsvNo= " & lngLastDspMode & "(" & lngRsvNo 
		Exit Do
	End If

	vntGraphCslDate = Array()
	vntValueX = Array()
	vntValueY = Array()
	Redim Preserve vntGraphCslDate(1)
	Redim Preserve vntValueX(0)
	Redim Preserve vntValueY(0)
	vntGraphCslDate(1) = ""
	'現在の統計量を計算する
	Ret = objInterView.StatisticsCalc( _
						lngRsvNo, _
						dblValueX, _
						dblValueY _
						)
	If Ret = False Then
		objCommon.AppendArray strArrMessage, "欠損値が存在するため、計算できませんでした。"
		vntGraphCslDate(0) = vntCslCslDate(0)
		vntValueX(0) = ""
		vntValueY(0) = ""
	Else
		vntGraphCslDate(0) = vntCslCslDate(0)
		vntValueX(0) = dblValueX
		vntValueY(0) = dblValueY
	End If

	If lngCount = 1 Then
		objCommon.AppendArray strArrMessage, "過去のデータはありません。"
		vntGraphCslDate(1) = ""
	Else
		j = 1
		For	i = 1 To UBound(vntCslRsvNo)
			'1997/4/1以前なら終了
			If vntCslCslDate(i) < "1997/04/01" Then
				Exit For
			End If
			'過去の統計量を計算する
			Ret = objInterView.StatisticsCalc( _
							vntCslRsvNo(i), _
							dblValueX, _
							dblValueY _
							)
			If Ret = False Then
				vntGraphCslDate(1) = vntCslCslDate(i)
'				objCommon.AppendArray strArrMessage, "欠損値が存在するため、計算できませんでした。"
			Else
				Redim Preserve vntValueX(j)
				Redim Preserve vntValueY(j)
				vntGraphCslDate(1) = vntCslCslDate(i)
				vntValueX(j) = dblValueX
				vntValueY(j) = dblValueY
				j = j + 1
			End If
		Next
	End If


	'テストデータ
'	lngHisCount = 2
'	vntGraphCslDate = Array("2003/12/09","2002/12/01" )
'	vntValueX = Array(2.2, -0.2)
'	vntValueY = Array(2.2, -0.2)

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>多項目検査からみたあなたの傾向</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%

		Call interviewHeader(lngRsvNo, 0)
	End If
%>

<FORM ACTION="" METHOD="get" NAME="entryForm">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<!-- タイトルの表示 -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">多項目検査からみたあなたの傾向</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'前回歴コンボボックス表示
			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If IsEmpty(strArrMessage) = False Then

		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>
<!-- グラフの表示 -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="900" HEIGHT="300" BGCOLOR="#000000">
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="100%" HEIGHT="100%" BGCOLOR="#ffffff">
					<TR>
						<TD ALIGN="center">
							<OBJECT ID="HainsChartTend" CLASSID="CLSID:9179E3C7-F0BB-4D64-A848-958F14EA6DF6" CODEBASE="/webHains/cab/Graph/HainsChartTend.CAB#version=1,0,0,2">
							</OBJECT>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<script type="text/javascript">
var GraphActiveX = document.getElementById('HainsChartTend');
<%
For i = 0 To 2 - 1
%>
	GraphActiveX.SetCslDate(<%= i %>, '<%= vntGraphCslDate(i) %>');
<%
Next

For i = 0 To UBound(vntValueX)
%>
	GraphActiveX.SetResult(<%= i %>, '<%= vntValueX(i) %>', '<%= vntValueY(i) %>');
<%
Next
%>
GraphActiveX.ShowGraph();
</script>
</BODY>
</HTML>