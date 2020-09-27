<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		団体検索ガイド (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_BSD  = "1"	'検索モード(事業部)
Const MODE_ROOM = "2"	'検索モード(室部)
Const MODE_POST = "3"	'検索モード(所属)
Const STARTPOS  = 1		'開始位置のデフォルト値
Const GETCOUNT  = 20	'表示件数のデフォルト値

'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objOrganization	'団体情報アクセス用

'引数値
Dim strMode			'処理モード(未指定：団体のみ、"1":事業部遷移、"2":室部遷移、"3":所属遷移)
Dim lngDispMode		'表示モード(0:コメント表示、1:住所表示)
Dim strKey			'検索キー
Dim strDelFlg		'削除フラグ
Dim lngAddrDiv		'住所区分
Dim lngStartPos		'検索開始位置
Dim lngGetCount		'表示件数

'団体情報
Dim strArrOrgCd1	'団体コード１
Dim strArrOrgCd2	'団体コード２
Dim strOrgSName		'略称
Dim strNotes		'特記事項
Dim strPrefName		'都道府県名
Dim strCityName		'市区町村名
Dim strAddress1		'住所１
Dim strDispOrgCd1	'編集用の団体コード１
Dim strDispOrgCd2	'編集用の団体コード２
Dim strDispOrgName	'編集用の漢字名称

'固定団体コード
Dim strPerOrgCd1	'個人受診用団体コード１
Dim strPerOrgCd2	'個人受診用団体コード２

Dim strArrKey		'(分割後の)検索キーの集合
Dim lngCount		'レコード件数
Dim blnDelFlg(3)	'削除フラグのチェック状態
Dim strURL			'URL文字列
Dim strBuffer		'文字列バッファ
Dim i, j			'インデックス

Dim strCnvKey		'キー変換値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strMode     = Request("mode")
lngDispMode = CLng("0" & Request("dispMode"))
strKey      = Request("key")
strDelFlg   = ConvIStringToArray(Request("delFlg"))
lngAddrDiv  = CLng("0" & Request("addrDiv"))
lngStartPos = Request("startPos")
lngGetCount = Request("getCount")

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))
lngAddrDiv  = IIf(lngAddrDiv = 0, 1, lngAddrDiv)

'### 使用状態区分の変更により修正 2005.04.02 張
'使用状態のデフォルト値は「使用中」
'⇒　使用状態のデフォルト値は「使用中①」「使用中②」両方チェックされるように修正
If IsEmpty(Request("act")) Then
    strDelFlg = Array("0","2")
End If
'If IsEmpty(Request("act")) Then
'    strDelFlg = Array("0")
'End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>団体の検索</TITLE>
<style type="text/css">
	body { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">団体の検索</FONT></B></TD>
	</TR>
</TABLE>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" STYLE="margin: 0px;">
	<INPUT TYPE="hidden" NAME="act"      VALUE="1">
	<INPUT TYPE="hidden" NAME="mode"     VALUE="<%= strMode     %>">
	<INPUT TYPE="hidden" NAME="dispMode" VALUE="<%= lngDispMode %>">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD HEIGHT="25" COLSPAN="4">団体コードもしくは団体名称を入力して下さい。</TD>
		</TR>
		<TR>
			<TD NOWRAP>検索条件</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>" STYLE="ime-mode:active;"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></TD>
<%
			'個人受診用団体コードの取得
			Set objCommon = Server.CreateObject("HainsCommon.Common")
			objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
			Set objCommon = Nothing

			'個人選択時のURLを編集
			strURL = "gdeSelectOrg.asp"
			strURL = strURL & "?orgCd1="  & strPerOrgCd1
			strURL = strURL & "&orgCd2="  & strPerOrgCd2
			strURL = strURL & "&addrDiv=" & lngAddrDiv
%>
			<TD WIDTH="100%" ALIGN="right"><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/perconsult.gif" WIDTH="77" HEIGHT="24" ALT="個人で受診する場合に選択します"></A></TD>
		</TR>
		<TR>
			<TD NOWRAP>使用状態</TD>
			<TD>：</TD>
<%
			'削除フラグのチェック状態を取得
			If IsArray(strDelFlg) Then
				For i = 0 To UBound(strDelFlg)
					blnDelFlg(CLng(strDelFlg(i))) = True
				Next
			End If
%>
			<TD COLSPAN="3">
                <!--### 団体使用状態変更により修正 2005.04.02 Start 張 ###-->
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="0"<%= IIf(blnDelFlg(0), " CHECKED", "") %>></TD>
						<TD NOWRAP>使用中①</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="2"<%= IIf(blnDelFlg(2), " CHECKED", "") %>></TD>
						<TD NOWRAP>使用中②</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="3"<%= IIf(blnDelFlg(3), " CHECKED", "") %>></TD>
						<TD NOWRAP>長期未使用</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="1"<%= IIf(blnDelFlg(1), " CHECKED", "") %>></TD>
						<TD NOWRAP>未使用</TD>
					</TR>
				</TABLE>

                <!--TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="0"<%= IIf(blnDelFlg(0), " CHECKED", "") %>></TD>
						<TD NOWRAP>使用中</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="2"<%= IIf(blnDelFlg(2), " CHECKED", "") %>></TD>
						<TD NOWRAP>契約手続中</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="3"<%= IIf(blnDelFlg(3), " CHECKED", "") %>></TD>
						<TD NOWRAP>長期未使用</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="1"<%= IIf(blnDelFlg(1), " CHECKED", "") %>></TD>
						<TD NOWRAP>未使用</TD>
					</TR>
				</TABLE-->
                <!--### 団体使用状態変更により修正 2005.04.02 End   張 ###-->
			</TD>
		</TR>
<%
		If lngDispMode = 1 Then
%>
			<TR>
				<TD>住所</TD>
				<TD>：</TD>
				<TD COLSPAN="3">
					<SELECT NAME="addrDiv">
						<OPTION VALUE="1"<%= IIf(lngAddrDiv = 1, " SELECTED", "") %>>住所１
						<OPTION VALUE="2"<%= IIf(lngAddrDiv = 2, " SELECTED", "") %>>住所２
						<OPTION VALUE="3"<%= IIf(lngAddrDiv = 3, " SELECTED", "") %>>住所３
					</SELECT>
				</TD>
			</TR>
<%
		End If
%>
	</TABLE>
</FORM>
<BR>
<%
Do

	'検索ボタン押下時以外は何もしない
	If Request("act") = "" Then
		Exit Do
	End If

	'検索キーも削除フラグも指定されていない場合は何もしない
	If strKey = "" And IsEmpty(strDelFlg) Then
		Exit Do
	End If

	'検索キーを空白で分割する
	strArrKey = SplitByBlank(strKey)

	'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
	lngCount = objOrganization.SelectOrgList(strArrKey, lngStartPos, lngGetCount, strArrOrgCd1, strArrOrgCd2, , strOrgSName, , , , , , strDelFlg, lngAddrDiv, strNotes, strPrefName, strCityName, strAddress1)

	'検索結果が存在しない場合はメッセージを編集
	If lngCount = 0 Then
%>
		検索条件を満たす団体情報は存在しません。<BR>
		キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
		Exit Do
	End If

	'レコード件数情報を編集
	If strKey <> "" Then
%>
		「<FONT COLOR="#ff6600"><B><%= strKey %></B></FONT>」の検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>
<%
	Else
%>
		検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>
<%
	End If

	'団体一覧の編集開始
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>団体コード</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>団体名称</TD>
			<TD WIDTH="10"></TD>
			<TD WIDTH="400" NOWRAP><%= IIf(lngDispMode = 0, "コメント", "住所") %></TD>
			<TD WIDTH="10"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD BGCOLOR="#999999" COLSPAN="5"></TD>
		</TR>
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
<%
		For i = 0 To UBound(strArrOrgCd1)

			'団体情報の取得
			strDispOrgCd1  = strArrOrgCd1(i)
			strDispOrgCd2  = strArrOrgCd2(i)
			strDispOrgName = strOrgSName(i)

			'検索キーに合致する部分に<B>タグを付加
			If Not IsEmpty(strArrKey) Then

				For j = 0 To UBound(strArrKey)

					If Instr(strDispOrgCd1, strArrKey(j)) = 1 Then
						strDispOrgCd1 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd1, Len(strDispOrgCd1) - Len(strArrKey(j)))
					End If

					If Instr(strDispOrgCd2, strArrKey(j)) = 1 Then
						strDispOrgCd2 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd2, Len(strDispOrgCd2) - Len(strArrKey(j)))
					End If

					strDispOrgName = Replace(strDispOrgName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")

					'小さいカナを変換したパターン
					strCnvKey = strArrKey(j)
					strCnvKey = Replace(strCnvKey, "ァ", "ア")
					strCnvKey = Replace(strCnvKey, "ィ", "イ")
					strCnvKey = Replace(strCnvKey, "ゥ", "ウ")
					strCnvKey = Replace(strCnvKey, "ェ", "エ")
					strCnvKey = Replace(strCnvKey, "ォ", "オ")
					strCnvKey = Replace(strCnvKey, "ッ", "ツ")
					strCnvKey = Replace(strCnvKey, "ャ", "ヤ")
					strCnvKey = Replace(strCnvKey, "ュ", "ユ")
					strCnvKey = Replace(strCnvKey, "ョ", "ヨ")

					'変換後の値が元の値と異なる場合は更に置換する
					If strCnvKey <> strArrKey(j) Then
						strDispOrgName = Replace(strDispOrgName, strCnvKey, "<B>" & strCnvKey & "</B>")
					End If

				Next


			End If

			'団体選択時のURLを編集
			strURL = "gdeSelectOrg.asp"
			strURL = strURL & "?orgCd1="  & strArrOrgCd1(i)
			strURL = strURL & "&orgCd2="  & strArrOrgCd2(i)
			strURL = strURL & "&addrDiv=" & lngAddrDiv

			'団体情報の編集
%>
			<TR VALIGN="top">
				<TD></TD>
				<TD NOWRAP><%= strDispOrgCd1 %>-<%= strDispOrgCd2 %></TD>
				<TD></TD>
				<TD NOWRAP><A HREF="<%= strURL %>"><%= strDispOrgName %></A></TD>
				<TD></TD>
				<TD WIDTH="400"><%= IIf(lngDispMode = 0, strNotes(i), strPrefName(i) & strCityName(i) & strAddress1(i)) %></TD>
<%
				'団体以下を検索する場合、検索ボタンを編集
				If strMode = MODE_BSD Or strMode = MODE_ROOM Or strMode = MODE_POST Then

					'処理モードに対応するのURLの編集
					Select Case strMode
						Case MODE_BSD
							strURL = "gdeOrgBusinessDiv.asp"
							strBuffer = "事業部"
						Case MODE_ROOM
							strURL = "gdeOrgRoom.asp"
							strBuffer = "室部"
						Case MODE_POST
							strURL = "gdeOrgPost.asp"
							strBuffer = "所属"
					End Select

					'引数の追加
					strURL = strURL & "?orgCd1=" & strArrOrgCd1(i)
					strURL = strURL & "&orgCd2=" & strArrOrgCd2(i)
%>
					<TD></TD>
					<TD><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/cue.gif" WIDTH="14" HEIGHT="14" ALT="この団体の全<%= strBuffer %>を検索"></A></TD>
<%
				End If
%>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'ページングナビゲータの編集
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?act="      & "1"
	strURL = strURL & "&mode="     & strMode
	strURL = strURL & "&dispMode=" & lngDispMode
	strURL = strURL & "&key="      & Server.URLEncode(strKey)

	'削除フラグのチェック状態をもとにURLを編集
	If IsArray(strDelFlg) Then
		For i = 0 To UBound(strDelFlg)
			strURL = strURL & "&delFlg=" & strDelFlg(i)
		Next
	End If

	strURL = strURL & "&addrDiv=" & lngAddrDiv
%>
	<%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
	Exit Do
Loop
%>
</BODY>
</HTML>
