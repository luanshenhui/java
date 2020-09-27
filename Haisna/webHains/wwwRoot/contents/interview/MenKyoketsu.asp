<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   虚血性心疾患指導表パターン  (Ver0.0.1)
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
Const GRPCD_KYOKETSU1 = "X020"	'虚血性心疾患指導表パターン（失点）グループコード
Const GRPCD_KYOKETSU2 = "X021"	'虚血性心疾患指導表パターン（心電図判定区分）グループコード

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objHainsUser		'ユーザ情報アクセス用
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

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
Dim vntResult1			'検査結果(心電図判定区分)

Dim vntGraphValue1(11)	'グラフ用データ（今回）
Dim vntGraphValue2(11)	'グラフ用データ（前回）
Dim strItemCd			'検査項目コード
Dim strSuffix			'サフィックス
Dim lngItemCnt			'検査項目No

Dim lngShitten(2)		'失点数

Dim strShinden()		'心電図判定区分
Dim lngShindenCnt		'心電図判定区分数

Dim i, j				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objHainsUser	= Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")

'### 2004/01/07 K.Kagawa コースしばりのデフォルト値を判断する
If strSelCsGrp = "" Then
	Dim lngCsGrpCnt		'コースグループ数
	Dim vntCsGrpCd		'コースグループコード

	'コースグループ取得
	lngCsGrpCnt = objInterview.SelectCsGrp( lngRsvNo, vntCsGrpCd )
	If lngCsGrpCnt > 0 Then
		strSelCsGrp = vntCsGrpCd(0)
	Else
		strSelCsGrp = "0"
	End If
End If

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
						2, _
						0, _
						vntHisPerId, _
						vntHisRsvNo, _
						vntHisCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "受診歴が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	'指定対象受診者の検査結果を取得する[失点]
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						2, _
						GRPCD_KYOKETSU1, _
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
						vntItemName, _
						vntResult _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	'失点をグラフ用に編集
	lngItemCnt = 0
	If lngRslCnt > 0 Then
		strItemCd = vntItemCd(0)
		strSuffix = vntSuffix(0)
		For i=0 To lngRslCnt-1
			'検査項目が変わった
			If vntItemCd(i) <> strItemCd Or vntSuffix(i) <> strSuffix Then
				lngItemCnt = lngItemCnt + 1
				'リセット
				strItemCd = vntItemCd(i)
				strSuffix = vntSuffix(i)
			End If
			'今回と前回の結果を分けてセット
			Select Case vntHisNo(i)
			Case 1:
				vntGraphValue1(lngItemCnt) = vntResult(i)
			Case 2:
				vntGraphValue2(lngItemCnt) = vntResult(i)
			End Select
		Next
	End If

	'失点の合計計算
	lngShitten(0) = 0
	lngShitten(1) = 0
	For i=0 To lngRslCnt-1
		If IsNumeric(vntResult(i)) Then
			lngShitten(vntHisNo(i)-1) = lngShitten(vntHisNo(i)-1) + CLng("0" & vntResult(i))
		End If
	Next

	'指定対象受診者の検査結果を取得する[心電図判定区分]
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_KYOKETSU2, _
						lngLastDspMode, _
						vntCsGrp, _
						0, _
						0, _
						0, _
						, , , , , , , , ,_
						vntResult1 _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	'心電図判定区分を編集
	lngShindenCnt = 0
	For i=0 To lngRslCnt-1
		If Not IsNull(vntResult1(i)) And vntResult1(i) <> "" Then
			Redim Preserve strShinden(lngShindenCnt)
			strShinden(lngShindenCnt) = vntResult1(i)
			lngShindenCnt = lngShindenCnt + 1
		End If
	Next

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>虚血性心疾患指導表パターン</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//認識レベルの登録画面呼び出し
function callEntryRecogLevel() {
	var url;							// URL文字列

	url = '/WebHains/contents/interview/EntryRecogLevel.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	location.href(url);

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
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" STYLE="margin: 0px;" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">虚血性心疾患指導表パターン</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'前回歴コンボボックス表示
			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
	<!-- 受診履歴の表示 -->
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="900">
		<TR>
			<TD NOWRAP HEIGHT="30">前回受診日：</TD>
<%
	If lngHisCount > 1 Then
%>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntHisCslDate(1) %>　<%= vntCsSName(1) %></B></FONT></TD>
<%
	Else
%>
			<TD NOWRAP>&nbsp;</TD>
<%
	End If
%>


			<TD WIDTH="100%" ALIGN="right" NOWRAP><A HREF="MenShittenBunpu.asp?grpno=<%= strGrpNo %>&rsvno=<%= lngRsvNo %>&cscd=<%= strCsCd %>&winmode=<%= strWinMode %>">失点分布</A></TD>
			<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
			<TD WIDTH="100%" ALIGN="right" NOWRAP><A HREF="JavaScript:callEntryRecogLevel()">認識レベル</A></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD WIDTH="614" HEIGHT="400" BGCOLOR="#000000">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="100%">
					<TR>
						<TD>
							<OBJECT ID="HainsChartCircle" CLASSID="CLSID:EED1C467-A6B5-4758-9439-08CC9986AD74" CODEBASE="/webHains/cab/Graph/HainsChartCircle.CAB#version=1,0,0,1"></OBJECT>
<script type="text/javascript">
<!--
	var GraphActiveX = document.getElementById('HainsChartCircle');

<%
	For i=0 To lngItemCnt
%>
		GraphActiveX.SetResult(<%=i%>,"<%=vntGraphValue1(i)%>");
		GraphActiveX.SetLastResult(<%=i%>,"<%=vntGraphValue2(i)%>");
<%
	Next
%>
	GraphActiveX.ShowGraph();
//-->
</script>
						</TD>
					</TR>
				</TABLE>
			</TD>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
			<TD VALIGN="top" WIDTH="270">
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="100%">
					<TR>
						<TD BGCOLOR="#000000">
							<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="100%">
								<TR>
									<TD HEIGHT="270" VALIGN="top">
										<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
											<TR>
												<TD NOWRAP>心電図判定区分：</TD>
<%
	If lngShindenCnt > 0 Then
%>
												<TD NOWRAP><%=strShinden(0)%></TD>
<%
	Else
%>
												<TD NOWRAP>&nbsp;</TD>
<%
	End If
%>
											</TR>
<%
	For i=1 To lngShindenCnt-1
%>
											<TR>
												<TD></TD>
												<TD NOWRAP><%=strShinden(i)%></TD>
											</TR>
<%
	Next
%>
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD HEIGHT="10"></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#000000">
							<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="100%">
								<TR>
									<TD VALIGN="top">
										<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
											<TR>
												<TD NOWRAP><FONT COLOR="red"><B>今回受診日：</B></FONT></TD>
												<TD NOWRAP><FONT COLOR="red"><B><%= vntHisCslDate(0) %></B></FONT></TD>
												<TD>
													<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" BGCOLOR="red">
														<TR>
															<TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="3" ALT=""></TD>
														</TR>
													</TABLE>
												</TD>
											</TR>
											<TR>
												<TD NOWRAP><FONT COLOR="blue"><B>前回受診日：</B></FONT></TD>
<%
	If lngHisCount > 1 Then
%>
												<TD NOWRAP><FONT COLOR="blue"><B><%= vntHisCslDate(1) %></B></FONT></TD>
<%
	Else
%>
												<TD NOWRAP><FONT COLOR="blue"><B>&nbsp;</B></FONT></TD>
<%
	End If
%>
												<TD>
													<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" BGCOLOR="blue">
														<TR>
															<TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="3" ALT=""></TD>
														</TR>
													</TABLE>
												</TD>
											</TR>
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD HEIGHT="10"></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#000000">
							<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="100%">
								<TR>
									<TD VALIGN="top">
										<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
											<TR>
												<TD VALIGN="top" NOWRAP>失点：</TD>
												<TD NOWRAP><FONT SIZE="5" COLOR="red"><B>今回</B></FONT></TD>
												<TD NOWRAP><FONT SIZE="5" COLOR="blue"><B>前回</B></FONT></TD>
											</TR>
											<TR ALIGN="center">
												<TD></TD>
												<TD NOWRAP><FONT SIZE="5" COLOR="red"><B><%= lngShitten(0) %></B></FONT></TD>
<%
	If lngHisCount > 1 Then
%>
												<TD NOWRAP><FONT SIZE="5" COLOR="blue"><B><%= lngShitten(1) %></B></FONT></TD>
<%
	Else
%>
												<TD NOWRAP><FONT SIZE="5" COLOR="blue"><B>&nbsp;</B></FONT></TD>
<%
	End If
%>
											</TR>
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>