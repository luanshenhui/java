<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(参照先契約団体の検索) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const OPMODE_BROWSE  = "browse"	'処理モード(複写)
Const OPMODE_COPY    = "copy"	'処理モード(コピー)
Const GETCOUNT       = 20		'表示件数のデフォルト値

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objOrganization		'団体情報アクセス用
Dim objCourse			'コース情報アクセス用

'前画面から送信されるパラメータ値(参照・コピー共通)
Dim strOpMode			'処理モード
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strCsCd				'コースコード

'前画面から送信されるパラメータ値(コピー時のみ)
Dim strStrYear			'契約開始年
Dim strStrMonth 		'契約開始月
Dim strStrDay			'契約開始日
Dim strEndYear			'契約終了年
Dim strEndMonth 		'契約終了月
Dim strEndDay			'契約終了日

'自身をリダイレクトする場合のみ送信されるパラメータ値
Dim strKey				'検索キー
Dim lngStartPos			'検索開始位置
Dim lngGetCount			'表示件数

'契約管理情報
Dim strOrgName			'団体名
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日
Dim strStrDate			'編集用の契約開始日
Dim strEndDate			'編集用の契約終了日

'検索情報
Dim strRefOrgCd1		'参照先団体コード1
Dim strRefOrgCd2		'参照先団体コード2
Dim strRefOrgName		'参照先団体名称
Dim strRefOrgSName		'参照先略称
Dim strRefOrgKanaName	'参照先団体カナ名称

'固定団体コード
Dim strPerOrgCd1		'個人受診用団体コード1
Dim strPerOrgCd2		'個人受診用団体コード2
Dim strWebOrgCd1		'Web用団体コード1
Dim strWebOrgCd2		'Web用団体コード2

Dim strArrKey			'(分割後の)検索キーの集合
Dim lngCount			'レコード件数
Dim strDispOrgCd1		'編集用の団体コード1
Dim strDispOrgCd2		'編集用の団体コード2
Dim strDispOrgName		'編集用の漢字名称
Dim strDispOrgKanaName	'編集用のカナ名称
Dim strQueryString		'QUERY文字列
Dim strURL				'URL文字列
Dim blnAnchor			'アンカーの要否
Dim i, j				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objCourse       = Server.CreateObject("HainsCourse.Course")

'前画面から送信されるパラメータ値の取得
strOpMode = Request("opMode")
strOrgCd1 = Request("orgCd1")
strOrgCd2 = Request("orgCd2")
strCsCd   = Request("csCd")

'前画面から送信されるパラメータ値の取得(コピー時のみ)
strStrYear  = Request("strYear")
strStrMonth = Request("strMonth")
strStrDay   = Request("strDay")
strEndYear  = Request("endYear")
strEndMonth = Request("endMonth")
strEndDay   = Request("endDay")

'自身をリダイレクトする場合のみ送信されるパラメータ値の取得
strKey      = Request("key")
lngStartPos = CLng("0" & Request("startPos"))
lngGetCount = CLng("0" & Request("getCount"))

'個人受診、web用団体コードの取得
objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2

'検索開始位置未指定時は先頭から検索する
If lngStartPos = 0 Then
	lngStartPos = 1
End If

'表示件数未指定時はデフォルト値を適用する
If lngGetCount = 0 Then
	lngGetCount = GETCOUNT
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>参照先契約団体の検索</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="opMode" VALUE="<%= strOpMode %>">
	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
	<INPUT TYPE="hidden" NAME="csCd"   VALUE="<%= strCsCd   %>">
<%
	'処理モードが複写の場合は契約期間の値を保持する
	If strOpMode = OPMODE_COPY Then
%>
		<INPUT TYPE="hidden" NAME="strYear"  VALUE="<%= strStrYear  %>">
		<INPUT TYPE="hidden" NAME="strMonth" VALUE="<%= strStrMonth %>">
		<INPUT TYPE="hidden" NAME="strDay"   VALUE="<%= strStrDay   %>">
		<INPUT TYPE="hidden" NAME="endYear"  VALUE="<%= strEndYear  %>">
		<INPUT TYPE="hidden" NAME="endMonth" VALUE="<%= strEndMonth %>">
		<INPUT TYPE="hidden" NAME="endDay"   VALUE="<%= strEndDay   %>">
<%
	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">参照先契約団体の検索</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'団体名の読み込み
	If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
		Err.Raise 1000, , "団体情報が存在しません。"
	End If

	'コース名の読み込み
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "コース情報が存在しません。"
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>対象コース</TD>
			<TD>：</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
<%
		'処理モードが複写の場合は先に入力した契約期間を編集する
		If strOpMode = OPMODE_COPY Then

			'契約開始年月日の取得
			If strStrYear <> "" And strStrMonth <> "" And strStrDay <> "" Then
				dtmStrDate = CDate(strStrYear & "/" & strStrMonth & "/" & strStrDay)
			End If

			'契約終了年月日の取得
			If strEndYear <> "" And strEndMonth <> "" And strEndDay <> "" Then
				dtmEndDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
			End If

			'編集用の契約開始日設定
			If dtmStrDate > 0 Then
				strStrDate = FormatDateTime(dtmStrDate, 1)
			End If

			'編集用の契約終了日設定
			If dtmEndDate > 0 Then
				strEndDate = FormatDateTime(dtmEndDate, 1)
			End If
%>
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
			<TR>
				<TD>契約期間</TD>
				<TD>：</TD>
				<TD><B><%= strStrDate %>～<%= strEndDate %></B></TD>
			</TR>
<%
		End If
%>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD COLSPAN="2"><FONT COLOR="#cc9999">●</FONT>団体コードもしくは団体名称を入力して下さい。<FONT COLOR="#666666">（対象コースの契約情報を持つ団体のみを検索します）</FONT></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD COLSPAN="2"><FONT COLOR="#cc9999">●</FONT>一般団体から個人・Web予約の契約情報を参照する、またその逆は行うことはできません。</FONT></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD WIDTH="100%"><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></TD>
		</TR>
	</TABLE>
<%
	Do

		'検索キーを空白で分割する
		strArrKey = SplitByBlank(strKey)

		'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
		lngCount = objOrganization.SelectOrgList(strArrKey, lngStartPos, lngGetCount, strRefOrgCd1, strRefOrgCd2, strRefOrgName, strRefOrgSName, strRefOrgKanaName, strCsCd)
%>
		<BR><BR>
<%
		'検索結果が存在しない場合はメッセージを編集
		If lngCount = 0 Then
%>
			検索条件を満たす団体情報は存在しません。<BR>
			キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
			Exit Do
		End If

		'Query文字列の編集
		'(この文字列は参照先団体選択時、ページングナビゲータの両方で使用するため、ここで編集しておく)
		strQueryString = "?opMode=" & strOpMode & "&orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2 & "&csCd=" & strCsCd

		'処理モードが複写の場合は更に契約期間をQuery文字列として編集する
		If strOpMode = OPMODE_COPY Then
			strQueryString = strQueryString & "&strYear=" & strStrYear & "&strMonth=" & strStrMonth & "&strDay=" & strStrDay & _
											  "&endYear=" & strEndYear & "&endMonth=" & strEndMonth & "&endDay=" & strEndDay
		End If
%>
		検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
<%
			For i = 0 To UBound(strRefOrgCd1)

				'団体情報の取得
				strDispOrgCd1      = strRefOrgCd1(i)
				strDispOrgCd2      = strRefOrgCd2(i)
				strDispOrgName     = strRefOrgName(i)
				strDispOrgKanaName = strRefOrgKanaName(i)

				'検索キーに合致する部分に<B>タグを付加
				If Not IsEmpty(strArrKey) Then
					For j = 0 To UBound(strArrKey)
						If Instr(strDispOrgCd1, strArrKey(j)) = 1 Then
							strDispOrgCd1 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd1, Len(strDispOrgCd1) - Len(strArrKey(j)))
						End If
						If Instr(strDispOrgCd2, strArrKey(j)) = 1 Then
							strDispOrgCd2 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd2, Len(strDispOrgCd2) - Len(strArrKey(j)))
						End If
						strDispOrgName     = Replace(strDispOrgName,     strArrKey(j), "<B>" & strArrKey(j) & "</B>")
						strDispOrgKanaName = Replace(strDispOrgKanaName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					Next
				End If

				'団体情報の編集
%>
				<TR>
					<TD WIDTH="10"></TD>
					<TD NOWRAP><%= strDispOrgCd1 %>-<%= strDispOrgCd2 %></TD>
					<TD WIDTH="10"></TD>
					<TD NOWRAP>
<%
						'アンカーの要否
						blnAnchor = False

						Do
							'参照モードの場合、検索した団体が契約団体自身であればアンカーを張らない
							If strOpMode = OPMODE_BROWSE Then
								If strRefOrgCd1(i) = strOrgCd1 And strRefOrgCd2(i) = strOrgCd2 Then
									Exit Do
								End If
							End If

							'個人・Webの場合
							If (strOrgCd1 = strPerOrgCd1 And strOrgCd2 = strPerOrgCd2) Or (strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2) Then

								'個人・Web以外の場合はアンカーを張らない
								If Not ((strRefOrgCd1(i) = strPerOrgCd1 And strRefOrgCd2(i) = strPerOrgCd2) Or (strRefOrgCd1(i) = strWebOrgCd1 And strRefOrgCd2(i) = strWebOrgCd2)) Then
									Exit Do
								End If

							'通常団体の場合
							Else

								'個人・Webの場合はアンカーを張らない
								If (strRefOrgCd1(i) = strPerOrgCd1 And strRefOrgCd2(i) = strPerOrgCd2) Or (strRefOrgCd1(i) = strWebOrgCd1 And strRefOrgCd2(i) = strWebOrgCd2) Then
									Exit Do
								End If

							End If

							blnAnchor = True
							Exit Do
						Loop

						If blnAnchor Then
%>
							<A HREF="ctrBrowseContract.asp<%= strQueryString %>&refOrgCd1=<%= strRefOrgCd1(i) %>&refOrgCd2=<%= strRefOrgCd2(i) %>"><%= strDispOrgName %></A>
<%
						Else
%>
							<%= strDispOrgName %>
<%
						End If
%>
					</TD>
					<TD WIDTH="10"></TD>
					<TD NOWRAP><FONT COLOR="666666">（<%= strDispOrgKanaName %>）</FONT></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'ページングナビゲータ用URLの編集
		strURL = Request.ServerVariables("SCRIPT_NAME") & strQueryString & "&key=" & Server.URLEncode(strKey)

		'ページングナビゲータの編集
		Response.Write EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount)

		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
