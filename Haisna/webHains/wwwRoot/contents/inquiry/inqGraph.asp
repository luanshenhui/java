<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		結果参照(グラフ) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editGrpList.inc"  -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim objResult		'検査結果情報アクセス用

Dim strPerID		'個人ID
Dim strGrpCd		'検査グループコード

Dim strSeq			'SEQ
Dim strItemName		'検査項目名
Dim strCslDate		'受診日
Dim strResult		'検査結果
Dim lngCount		'検査結果レコード数

Dim lngItemCount	'グループ内検査項目数
Dim lngCslCount		'受診情報数

Dim strPrevSeq		'直前レコードのSEQ
Dim lngItemIndex	'検査項目検索用インデックス
Dim lngCslIndex		'受診日検索用インデックス
Dim i				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objResult = Server.CreateObject("HainsResult.Result")

'引数値の取得
strPerID = Request("perID")
strGrpCd = Request("grpCd")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>グラフ</TITLE>
</HEAD>
<BODY BGCOLOR="#ffffff">

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">

<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="inquiry">■</SPAN><FONT COLOR="#000000">グラフ</FONT></B></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>検査項目グループ：</TD>
		<TD><%= EditGrpIList_GrpDiv("grpCd", strGrpCd, "", "", ADD_FIRST) %></TD>
		<TD>のグラフを</TD>
		<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></A>
	</TR>
</TABLE>

</FORM>
<%
Do
	'グループ未決定時は何もしない
	If strGrpCd = "" Then
		Exit Do
	End If

	'検査結果の読み込み
	lngCount = objResult.SelectRslHistory(strPerID, strGrpCd, False, strSeq, , , strItemName, strCslDate, , strResult)
	If lngCount <= 0 Then
		EditMessage "このグループに検査項目が存在しない、あるいは受診情報が存在しません。", MESSAGETYPE_WARNING
		Exit Do
	End If

	'グループ内検査項目数カウント
	strPrevSeq = ""
	For i = 0 To lngCount - 1

		'読み込んだ検査結果情報はグループ内検査項目のSEQ順に存在するため、
		'直前レコードとSEQ値が変わった時点でカウントを行う
		If strSeq(i) <> strPrevSeq Then
			lngItemCount = lngItemCount + 1
		End If

		'直前レコードのSEQを現値で更新
		strPrevSeq = strSeq(i)

	Next

	'受診情報数カウント
	strPrevSeq = ""
	For i = 0 To lngCount - 1

		'読み込んだ検査結果情報は検査項目単位において受診日の降順に存在するため、
		'SEQ値が変わるまでのレコード数をカウントすればそれが受診者数となる
		If strPrevSeq <> "" And strSeq(i) <> strPrevSeq Then
			Exit For
		End If

		'ここで受診情報数をカウント
		lngCslCount = lngCslCount + 1

		'直前レコードのSEQを現値で更新
		strPrevSeq = strSeq(i)

	Next
%>
	<OBJECT ID="HainsChartMain" CLASSID="CLSID:2437FFA5-E1C6-4FA3-9330-13AA3A2E1A56" CODEBASE="/webHains/cab/Chart/HainsChartPrj.CAB#version=1,0,0,2"></OBJECT>

	<script type="text/javascript">
	<!--
	var GraphActiveX = document.getElementById('HainsChartMain');
	GraphActiveX.Rows = <%= lngItemCount %>; // 結果数
	GraphActiveX.Cols = <%= lngCslCount  %>; // 履歴数

		// 検査項目名設定
<%
		strPrevSeq   = ""
		lngItemIndex = 0
		For i = 0 To lngCount - 1

			'読み込んだ検査結果情報はグループ内検査項目のSEQ順に存在するため、
			'直前レコードとSEQ値が変わった時点で項目名の編集を行う
			If strSeq(i) <> strPrevSeq Then
				lngItemIndex = lngItemIndex + 1
%>
					GraphActiveX.SetData(0, <%= lngItemIndex %>, "<%= strItemName(i) %>");
<%
			End If

			'直前レコードのSEQを現値で更新
			strPrevSeq = strSeq(i)

		Next
%>
		// 履歴データ設定
<%
		'先頭から受診情報数分の受診日を履歴データとして編集
		For i = 0 To lngCslCount - 1
%>
			GraphActiveX.SetData(<%= i + 1 %>, 0, "<%= strCslDate(i) %>");
<%
		Next
%>
		// 検査結果値設定
<%
		lngItemIndex = 0
		lngCslIndex  = 0

		strPrevSeq = ""
		For i = 0 To lngCount - 1

			'直前レコードとSEQ値が変わった場合
			If strSeq(i) <> strPrevSeq Then

				'検査項目インデックスをインクリメント
				lngItemIndex = lngItemIndex + 1

				'受診日インデックスを初期化
				lngCslIndex = 0

			End If

			'受診日インデックスをインクリメント
			lngCslIndex = lngCslIndex + 1

			If strResult(i) <> "" Then
%>
				GraphActiveX.SetData(<%= lngCslIndex %>, <%= lngItemIndex %>, "<%= strResult(i) %>");
<%
			End If

			'直前レコードのSEQを現値で更新
			strPrevSeq = strSeq(i)

		Next
%>
		GraphActiveX.Showchart();
	//-->
	</script>
<%
	Exit Do
Loop
%>
</BODY>
</HTML>
