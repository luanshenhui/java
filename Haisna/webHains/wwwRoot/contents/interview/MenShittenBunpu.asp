<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   失点分布 (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_SHITTENBUNPU = "X020"	'失点分布グループコード

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
Dim strPerId			'個人ID
Dim lngAge				'年齢
Dim lngGender			'性別

'検査結果用変数
Dim lngLastDspMode		'前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp			'前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
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

Dim lngShitten			'失点数

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


Do	

	'受診情報検索（予約番号より個人情報取得）
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, , _
									strPerId, _
									, , , , , , , _
									lngAge, _
									, , , , , , , , , , , , , , , _
									0, , , , , , , , , , , , , , , _
									, , , , , _
									lngGender _
									)

	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	lngLastDspMode = 0
	vntCsGrp = ""
	'指定対象受診者の検査結果を取得する
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_SHITTENBUNPU, _
						lngLastDspMode, _
						vntCsGrp, _
						1, _
						0, _
						0, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	'失点計算
	lngShitten = 0
	For i=0 To lngRslCnt-1
		If IsNumeric(vntResult(i)) Then
			lngShitten = lngShitten + CLng(vntResult(i))
		End If
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
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>失点分布</TITLE>
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

<FORM ACTION="" METHOD="get" NAME="entryForm" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<!-- タイトルの表示 -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">失点分布</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#ffffff">
		<TR>
			<TD ALIGN="RIGHT">
			<A HREF="MenKyoketsu.asp?grpno=<%= strGrpNo %>&rsvno=<%= lngRsvNo %>&cscd=<%= strCsCd %>&winmode=<%= strWinMode %>">虚血性心疾患指導表パターンへ</A>
			</TD>
		</TR>
	</TABLE>

<!-- グラフの表示 -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="900" HEIGHT="500" BGCOLOR="#000000">
<!--
-->
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="100%" HEIGHT="100%" BGCOLOR="#ffffff">
					<TR>
						<TD ALIGN="center">
							<OBJECT ID="HainsChartDist" CLASSID="CLSID:BFD8C23E-2B51-41EA-BFD0-7EACB2A47657" CODEBASE="/webHains/cab/Graph/HainsChartDist.CAB#version=1,0,0,1"></OBJECT>
<script type="text/javascript">
<!--
	var GraphActiveX = document.getElementById('HainsChartDist');
	GraphActiveX.SetAge( <%=lngAge%> );
	GraphActiveX.SetGender( <%=lngGender%> );
	GraphActiveX.SetShitten( <%=lngShitten%> );
	GraphActiveX.ShowGraph();
//-->
</script>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>