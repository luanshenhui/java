<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		面接情報の登録(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objAfterCare		'アフターケア情報用

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Const strSectionName = "OTHERJUDCLASS"
Const strKeyName = "NAME"

Dim strPerId			'個人ＩＤ
Dim strContactDate		'面接日
Dim strJudClassEtcCd	'その他判定分類コード
Dim strRsvNo			'予約番号

'アフターケア管理項目情報
Dim strJudClassCd_af	'判定分類
Dim strJudClassName_af	'判定分類名
Dim strJudClassEtc_af	'その他判定分類名

'判定分類情報
Dim strJudClassCd		'判定分類コード
Dim strJudClassName		'判定分類名称
Dim strAllJudFlg		'統計用総合判定フラグ
Dim strAfterCareCd		'アフターケアコード

Dim strToday			'本日日付（システム日付）
Dim strDispPerName		'個人名称（漢字）
Dim strDispPerKName		'個人名称（カナ）
Dim strDispAge			'年齢（表示用）
Dim strDispBirth		'生年月日（表示用）
Dim strDispJudClassEtc	'その他判定分類名（表示用）

Dim strChargeLastName	'担当者姓
Dim strChargeFirstName	'担当者名
Dim lngLudClassCount	'判定分類レコードカウント
Dim lngAfteCateMCount	'アフターケア管理項目レコードカウント
Dim strHtml				'HTMLワーク
Dim i,j					'ループカウント

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")
Set objAfterCare 	= Server.CreateObject("HainsAfterCare.AfterCare")

strPerId			= Request("perId")
strContactDate		= Request("contactDate")
strRsvNo			= Request("RsvNo")

'iniファイルからその他判定分類のコードを取得
	strJudClassEtcCd = objCommon.ReadIniFile( strSectionName, strKeyName )

'判定分類テーブルからアフターケア関連の判定分類名称を取得（画面表示項目の取得）
	lngLudClassCount = objAfterCare.SelectJudClassAfterCare( strJudClassCd , strJudClassName, strAllJudFlg, strAfterCareCd )

If ( strPerId <> "" And strContactDate <> "" ) Or (strRsvNo <> "") Then

	'アフターケア管理項目より個人ＩＤ，面接日に該当するレコードを取得
	lngAfteCateMCount = objAfterCare.SelectAfterCareM( strPerId , _
													   strContactDate , _
													   strJudClassCd_af ,  _
													   strJudClassName_af,  _
													   strJudClassEtc_af, _
													   strRsvNo)

End If


Function JudClassCdCheck( arrDispJudCd, arrCheckJudCd )

	If Not IsArray(arrCheckJudCd) Then
		Exit Function
	End If

	
	For j = 0 To Ubound(arrCheckJudCd)
		If( arrCheckJudCd(j) = arrDispJudCd ) Then
			JudClassCdCheck = " CHECKED"
			Exit Function
		End If
	Next

	JudClassCdCheck = ""

End Function

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>面接情報の登録</TITLE>
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="" METHOD="get" target="_top" ONSUBMIT="return false;">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="100%">
		<TR>
			<TD>所見：</TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
<%
'所見（判定分類）のHTML編集
If( lngLudClassCount > 0 ) Then
	For i = 0 to lngLudClassCount - 1
		strHtml = "		<TR>" & vbCrLf & _
				  "			<TD>" & vbCrLf & _
				  "				<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf & _
		  		  "					  <TR>" & vbCrLf & "						<TD><INPUT TYPE=""checkbox"" NAME=""judClassCd"""
		strHtml = strHtml & "VALUE=""" & strJudClassCd(i) & """" & JudClassCdCheck(strJudClassCd(i), strJudClassCd_af ) & " ></TD>" & vbCrLf
		strHtml = strHtml & "						<TD NOWRAP>" & strJudClassName(i) & "</TD>" & vbCrLf
		strHtml = strHtml & "					</TR>" & vbCrLf & _
							"				</TABLE>" & vbCrLf & _
							"			</TD>" & vbCrLf & _
							" 		</TR>" & vbCrLf
		Response.Write strHtml

	Next

End If

'その他判定分類名称の設定
For i = 0 To lngAfteCateMCount - 1
	If( strJudClassEtc_af(i) <> "" or Not IsNull(strJudClassEtc_af(i)) ) Then
		strDispJudClassEtc = strJudClassEtc_af(i)
	End If
Next

%>

		<TR>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD WIDTH="20"></TD>
						<TD><INPUT TYPE="text" NAME="judClassCdEtc" SIZE="14" MAXLENGTH="10" VALUE="<%= strDispJudClassEtc %>"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
