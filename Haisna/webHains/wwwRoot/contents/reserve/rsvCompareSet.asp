<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約情報詳細(検査セット情報の比較) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用
Dim objContract			'契約情報アクセス用
Dim objCourse			'コース情報アクセス用
Dim objFree				'汎用情報アクセス用
Dim objOrganization		'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objSetClass			'セット分類情報アクセス用

'引数値
Dim dtmCslDate			'受診日
Dim lngRsvNo			'予約番号
Dim strPerId			'個人ＩＤ
Dim strAge				'受診時年齢
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCsCd				'コースコード
Dim strCslDivCd			'受診区分コード
Dim strCtrPtCd			'契約パターンコード
Dim strOptCd			'オプションコード
Dim strOptBranchNo		'オプション枝番

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strGender			'性別

'セット分類情報
Dim strSetClassCd		'セット分類コード
Dim strSetClassName		'セット分類名
Dim lngSetClassCount	'セット分類数

'前回保存時の受診オプション情報
Dim strLastOptCd		'オプションコード
Dim strLastOptBranchNo	'オプション枝番
Dim strLastOptName		'オプション名
Dim strLastSetClassCd	'セット分類コード
Dim lngLastOptCount		'オプション検査数

'指定契約パターンの受診オプション情報
Dim strCtrOptCd			'オプションコード
Dim strCtrOptBranchNo	'オプション枝番
Dim strCtrOptName		'オプション名
Dim strCtrSetClassCd	'セット分類コード
Dim lngCtrOptCount		'オプション検査数

'最新の受診オプション情報
Dim strCurOptCd()		'オプションコード
Dim strCurOptBranchNo()	'オプション枝番
Dim strCurOptName()		'オプション名
Dim strCurSetClassCd()	'セット分類コード
Dim lngCurOptCount		'オプション検査数

'前回保存として編集するオプションのインデックス情報
Dim strLastIndex()		'前回保存時の受診オプション情報のインデックスを持つ配列
Dim lngLastIndexCount	'オプション検査数

'最新情報として編集するオプションのインデックス情報
Dim strCurIndex()		'最新の受診オプション情報のインデックスを持つ配列
Dim lngCurIndexCount	'オプション検査数

Dim strLastGender		'前回保存時の性別
Dim strLastAge			'前回保存時の受診時年齢
Dim strLastCslDivCd		'前回保存時の受診区分コード

Dim strOrgSName			'団体略称
Dim strCsName			'コース名
Dim strFreeField		'フリーフィールド
Dim lngOptCount			'最新のオプション検査数
Dim lngSetIndex			'セット分類のインデックス
Dim blnEdit				'何らかを編集したか
Dim Ret					'関数戻り値
Dim i, j				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
dtmCslDate     = CDate(Request("cslDate"))
lngRsvNo       = CLng("0" & Request("rsvNo"))
strPerId       = Request("perId")
strAge         = Request("age")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCsCd        = Request("csCd")
strCslDivCd    = Request("cslDivCd")
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = ConvIStringToArray(Request("optCd"))
strOptBranchNo = ConvIStringToArray(Request("optBranchNo"))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>検査セット情報の比較</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">検査セット情報の比較</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD NOWRAP>受診日</TD>
		<TD>：</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= dtmCslDate %></B></FONT></TD>
		<TD NOWRAP>　予約番号：</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
	</TR>
</TABLE>
<%
'個人情報読み込み
Set objPerson = Server.CreateObject("HainsPerson.Person")
Ret = objPerson.SelectPerson_Lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strBirth, strGender)
Set objPerson = Nothing
If Ret = False Then
	Err.Raise 1000, , "個人情報が存在しません。"
End If

Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD HEIGHT="3"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2" VALIGN="top" NOWRAP><%= strPerId %></TD>
		<TD NOWRAP><B><%= Trim(strLastName  & "　" & strFirstName) %></B>（<%= Trim(strLastKName & "　" & strFirstKName) %>）</TD>
	</TR>
	<TR>
		<TD NOWRAP><%= objCommon.FormatString(CDate(strBirth), "ge.m.d") %>生　<%= CLng(strAge) %>歳　<%= IIf(strGender = CStr(GENDER_MALE), "男性", "女性") %></TD>
	</TR>
</TABLE>
<%
Set objCommon = Nothing

'団体名の読み込み
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , strOrgSName
Set objOrganization = Nothing

'コース名の読み込み
Set objCourse = Server.CreateObject("HainsCourse.Course")
objCourse.SelectCourse strCsCd, strCsName
Set objCourse = Nothing

Set objFree = Server.CreateObject("HainsFree.Free")

'受診区分の読み込み
objFree.SelectFree 0, strCslDivCd, , , , strFreeField
%>
<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
	<TR>
		<TD HEIGHT="30" NOWRAP>団体：</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strOrgSName %></B></FONT></TD>
		<TD NOWRAP>受診コース：</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		<TD NOWRAP>受診区分：</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strFreeField %></B></FONT></TD>
	</TR>
</TABLE>
<%
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'受診情報の読み込み
objConsult.SelectConsult lngRsvNo, , , , , strCsName, , , , , , strLastAge, , , , , , , , , , , , , , , , , , , strOrgSName, , , , , , , , , , , , , , , , , strLastGender, , , , , strLastCslDivCd

'受診区分の読み込み
objFree.SelectFree 0, strLastCslDivCd, , , , strFreeField

Set objFree = Nothing
%>
<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
	<TR>
		<TD HEIGHT="30" NOWRAP>（前回保存時）</TD>
		<TD NOWRAP><%= strOrgSName %></TD>
		<TD NOWRAP><%= strCsName %></TD>
		<TD NOWRAP><%= CLng(strLastAge) %>歳</TD>
		<TD NOWRAP><%= IIf(strLastGender = CStr(GENDER_MALE), "男性", "女性") %></TD>
		<TD NOWRAP>受診区分：<%= strFreeField %></TD>
	</TR>
</TABLE>
<%
'セット分類情報の読み込み
Set objSetClass = Server.CreateObject("HainsSetClass.SetClass")
lngSetClassCount = objSetClass.SelectSetClassList(strSetClassCd, strSetClassName)
Set objSetClass = Nothing

'セット分類なし用の要素追加に際し、要素が存在しない場合は配列を作成
If lngSetClassCount = 0 Then
	strSetClassCd   = Array()
	strSetClassName = Array()
End If

'セット分類なし用の要素を追加
ReDim Preserve strSetClassCd(lngSetClassCount)
ReDim Preserve strSetClassName(lngSetClassCount)
strSetClassCd(lngSetClassCount)   = ""
strSetClassName(lngSetClassCount) = "（なし）"
lngSetClassCount = lngSetClassCount + 1

'データベース上の最新となるオプション検査情報の読み込み
lngLastOptCount = objConsult.SelectConsult_O(lngRsvNo, strLastOptCd, strLastOptBranchNo, strLastOptName, strLastSetClassCd)

Set objConsult = Nothing

'最新のオプション検査が渡されている場合
If IsArray(strOptCd) Then

	'最新のオプション検査数を取得
	lngOptCount = UBound(strOptCd) + 1

	'指定契約パターンの全オプション検査を取得
	Set objContract = Server.CreateObject("HainsContract.Contract")
	lngCtrOptCount = objContract.SelectCtrPtOptFromConsult(dtmCslDate, strCslDivCd, strCtrPtCd, , strGender, strBirth, , , , strCtrOptCd,  strCtrOptBranchNo, strCtrOptName, , , strCtrSetClassCd)
	Set objContract = Nothing

	'最新のオプションとして存在するもののみを追加
	For i = 0 To lngCtrOptCount - 1
		For j = 0 To lngOptCount - 1
			If strOptCd(j) = strCtrOptCd(i) And strOptBranchNo(j) = strCtrOptBranchNo(i) Then
				ReDim Preserve strCurOptCd(lngCurOptCount)
				ReDim Preserve strCurOptBranchNo(lngCurOptCount)
				ReDim Preserve strCurOptName(lngCurOptCount)
				ReDim Preserve strCurSetClassCd(lngCurOptCount)
				strCurOptCd(lngCurOptCount)       = strCtrOptCd(i)
				strCurOptBranchNo(lngCurOptCount) = strCtrOptBranchNo(i)
				strCurOptName(lngCurOptCount)     = strCtrOptName(i)
				strCurSetClassCd(lngCurOptCount)  = strCtrSetClassCd(i)
				lngCurOptCount = lngCurOptCount + 1
				Exit For
			End If
		Next
	Next

End If

'データベース上の最新、画面上の最新オプション検査のいずれかが存在すれば比較情報を編集する
If lngLastOptCount > 0 Or lngCurOptCount > 0 Then
%>
	<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<TD NOWRAP>セット分類</TD>
			<TD COLSPAN="4" WIDTH="50%" NOWRAP>前回保存時</TD>
			<TD COLSPAN="4" WIDTH="50%" NOWRAP>最新の状態</TD>
		</TR>
<%
		'セット分類をベースに検索開始
		For lngSetIndex = 0 To lngSetClassCount - 1

			'格納情報の初期化
			Erase strLastIndex
			lngLastIndexCount = 0
			Erase strCurIndex
			lngCurIndexCount = 0

			'前回保存時の受診オプション情報から現セット分類のものを検索し、そのインデックスを格納
			For i = 0 To lngLastOptCount - 1
				If strLastSetClassCd(i) = strSetClassCd(lngSetIndex) Then
					ReDim Preserve strLastIndex(lngLastIndexCount)
					strLastIndex(lngLastIndexCount) = i
					lngLastIndexCount = lngLastIndexCount + 1
				End If
			Next

			'最新のの受診オプション情報から現セット分類のものを検索し、そのインデックスを格納
			For i = 0 To lngCurOptCount - 1
				If strCurSetClassCd(i) = strSetClassCd(lngSetIndex) Then
					ReDim Preserve strCurIndex(lngCurIndexCount)
					strCurIndex(lngCurIndexCount) = i
					lngCurIndexCount = lngCurIndexCount + 1
				End If
			Next

			'格納情報に何らかの内容が存在すれば編集を開始する
			If lngLastIndexCount > 0 Or lngCurIndexCount > 0 Then

				'すでに何らかの編集が行われている場合、セット分類の変わり目でセパレータを編集する
				If blnEdit Then
%>
					<TR>
						<TD COLSPAN="9" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" HEIGHT="1" WIDTH="1" ALT=""></TD>
					</TR>
<%
				End If

				'以降のセット分類の変わり目でセパレータを編集できるよう、フラグを成立させる
				blnEdit = True

				'前回値および最新情報ともに編集すべきオプション数分編集完了するまで処理を反復
				i = 0
				Do Until i >= lngLastIndexCount And i >= lngCurIndexCount
%>
					<TR>
						<TD NOWRAP><%= IIf(i = 0, strSetClassName(lngSetIndex), "") %></TD>
<%
						'編集すべき前回保存時の受診オプション数に達していない場合は編集
						If i < lngLastIndexCount Then
%>
							<TD NOWRAP><%= strLastOptCd(strLastIndex(i)) %></TD>
							<TD NOWRAP>-<%= strLastOptBranchNo(strLastIndex(i)) %></TD>
							<TD>：</TD>
							<TD WIDTH="50%" NOWRAP><%= strLastOptName(strLastIndex(i)) %></TD>
<%
						Else
%>
							<TD COLSPAN="4"></TD>
<%
						End If

						'編集すべき最新の受診オプション数に達していない場合は編集
						If i < lngCurIndexCount Then
%>
							<TD NOWRAP><%= strCurOptCd(strCurIndex(i)) %></TD>
							<TD NOWRAP>-<%= strCurOptBranchNo(strCurIndex(i)) %></TD>
							<TD>：</TD>
							<TD WIDTH="50%" NOWRAP><%= strCurOptName(strCurIndex(i)) %></TD>
<%
						End If
%>
					</TR>
<%
					i = i + 1
				Loop

			End If

		Next
%>
	</TABLE>
<%
Else
%>
	<BR>検査セットはありません。
<%
End If
%>
</BODY>
</HTML>