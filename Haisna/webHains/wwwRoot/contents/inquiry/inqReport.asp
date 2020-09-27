<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		HTML報告書 (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit

'電カルに本ASPで作成したHTMLを送信するため、セッションチェックは行わない
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'引数部
Dim strRsvNo				'予約番号

'受診情報
Dim strCslDate				'受診日
Dim strCsName				'コース名
Dim strAge					'年齢
Dim strReportPrintDate		'報告書出力日
Dim strDispCslDate			'編集受診日

'判定結果情報
Dim strJudClassCd			'判定分類コード
Dim strJudClassName			'判定分類名称
Dim strJudSName				'判定名称
Dim strStdJudNote			'定型所見名称
Dim strFreeJudCmt			'フリー判定コメント
Dim strOldJudClassCd		'編集用判定分類コード
Dim lngJudClassRows			'判定分類行数
Dim lngJudClassRowPos		'判定分類ごと行数セット位置

'受診者個人情報読み込み
Dim strPerID				'個人ＩＤ
Dim strCsCd					'コースコード
Dim strLastName				'姓
Dim strFirstName			'名
Dim strLastKName			'カナ姓
Dim strFirstKName			'カナ名
Dim strBirth				'生年月日（未編集）
Dim strGender				'性別
Dim strGenderName			'性別名称（"男性"，"女性"）
Dim strDayId				'当日ID（未編集）
Dim blnRetCd				'リターンコード

'受診者個人情報編集
Dim strEditCslDate			'受診日（"yyyy/mm/dd"編集）
Dim strEditBirth			'生年月日（"gee.mm.dd"編集）
Dim strEditGenderName		'性別名称（"男"，"女"）
Dim strEditDayId			'当日ID（"0001"編集）

Dim objConsult				'受診情報アクセス用COMオブジェクト
Dim objJudgement			'判定結果アクセス用COMオブジェクト
Dim objCommon				'共通関数アクセス用COMオブジェクト

Dim lngJudCount				'判定結果レコード件数
Dim lngRowCount				'判定分類行数（カウンタ）

Dim i						'インデックス
Dim j						'インデックス
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strRsvNo		   = Request("rsvNo")

'オブジェクトのインスタンス作成
Set objConsult   = Server.CreateObject("HainsConsult.Consult")
Set objJudgement = Server.CreateObject("HainsJudgement.Judgement")
Set objCommon	 = Server.CreateObject("HainsCommon.Common")

'受診者個人情報読み込み
blnRetCd = objConsult.SelectConsult(strRsvNo, 0, strCslDate, strPerId, strCsCd, strCsName, , , , , , _
									strAge, , , , , , , , , , , , , _
									strDayId, , , , , , , , , , , , , , , , , , _
									strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender)


'受診者個人情報を編集する
Set objCommon = Server.CreateObject("HainsCommon.Common")

With objCommon
	strEditCslDate = .FormatString(CDate(strCslDate), "yyyy/mm/dd")
	strEditBirth = .FormatString(CDate(strBirth), "gee.mm.dd")
End With
Set objCommon = Nothing

If Trim(strGender) = CStr(GENDER_MALE) Then
	strEditGenderName = "男"
ElseIf Trim(strGender) = CStr(GENDER_FEMALE) Then
	strEditGenderName = "女"
Else
	strEditGenderName = strGender
End If
strEditDayId = Trim(strDayId)

If strEditDayId <> "" Then
	Do While Len(strEditDayId) < 4
		strEditDayId = "0" & strEditDayId
	Loop
End If

'受診情報読み込み
objConsult.SelectConsult strRsvNo, CONSULT_USED, strCslDate, , ,strCsName, , , , , , strAge, , , ,strReportPrintDate

'受診日編集
'strDispCslDate = objCommon.FormatString(strCslDate, "yyyy年mm月dd日")

'判定結果読み込み
lngJudCount = objJudgement.SelectInquiryJudRslList(strRsvNo, strJudClassCd, strJudClassName, strJudSName, strStdJudNote, strFreeJudCmt)

'判定分類ごとの行数取得
If lngJudCount > 0 Then
	ReDim lngJudClassRows(lngJudCount - 1)
	strOldJudClassCd = ""
	For i = 0 To lngJudCount - 1
		'最初の判定分類
		If strOldJudClassCd = "" Then
			strOldJudClassCd = strJudClassCd(i)
			lngJudClassRowPos = 0
			lngRowCount = 0
		End If
		'判定分類コードが変わったとき
		If strOldJudClassCd <> strJudClassCd(i) Then
			lngJudClassRows(lngJudClassRowPos) = lngRowCount
			strOldJudClassCd = strJudClassCd(i)
			lngJudClassRowPos = i
			lngRowCount = 0
		End If
		lngRowCount = lngRowCount + 1
	Next
	'最後の判定分類の行数をセット
	If strOldJudClassCd <> "" Then
		lngJudClassRows(lngJudClassRowPos) = lngRowCount
	End If
End If

'オブジェクトのインスタンス削除
Set objConsult		= Nothing
Set objJudgement	= Nothing
Set objCommon		= Nothing

'-----------------------------------------------------------------------------
' 検査結果／問診結果編集
'-----------------------------------------------------------------------------
Sub EditRslList

	Dim objResult				'検査結果情報アクセス用COMオブジェクト

	Dim strItemName				'検査項目名
	Dim strResult				'検査結果
	Dim strResultType			'結果タイプ
	Dim strShortStc				'略文章
	Dim strStdFlgColor			'基準値フラグ表示色
	Dim strRslCmtName1			'結果コメント名称１
	Dim strRslCmtName2			'結果コメント名称２
	Dim strClassName			'検査分類
	Dim strEditClassName		'検査分類
	Dim blnBreakFlg				'

	Dim lngCount				'レコード件数

	Dim i						'インデックス

	'オブジェクトのインスタンス作成
	Set objResult = Server.CreateObject("HainsResult.Result")

	'検査結果読み込み
	lngCount = objResult.SelectInquiryRslList(strRsvNo, _
												RSLQUE_R, _
												strItemName, _
												strResult, _
												strResultType, _
												strShortStc, _
												strStdFlgColor, _
												strRslCmtName1, _
												strRslCmtName2, _
												strClassName)
%>
	<BR>
	<!-- 検査結果 -->
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#999999">■</FONT><FONT COLOR="#333333">検査結果</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR BGCOLOR="#cccccc">
			<TD WIDTH="110" ALIGN="center" NOWRAP>検査分類名</TD>
			<TD WIDTH="160" ALIGN="center" NOWRAP>検査項目名</TD>
			<TD WIDTH="360" ALIGN="center" NOWRAP>検査結果</TD>
			<TD ALIGN="center" COLSPAN="2" NOWRAP>コメント</TD>
		</TR>
<% 
		strEditClassName = ""
		blnBreakFlg = False
		For i = 0 To lngCount - 1 

			'ひさしぶりにコントロールブレイクなどを・・・
			If i = 0 Then
				strEditClassName = strClassName(i)
			Else
				If strClassName(i) <> strClassName(i - 1) Then
					Response.Write "<TR><TD HEIGHT=""7""></TD></TR>"
					strEditClassName = strClassName(i)
				Else
					strEditClassName = ""
				End If
			End If
%>
			<TR BGCOLOR="#eeeeee">
				<TD WIDTH="110"><%= strEditClassName %></TD>
				<TD WIDTH="160"><%= strItemName(i) %></TD>
				<TD WIDTH="360"><FONT COLOR="<%= strStdFlgColor(i) %>"><% If strStdFlgColor(i) <> "" Then %><B><% End If %>
				<%= IIf(CStr(strResultType(i)) = CStr(RESULTTYPE_SENTENCE), IIf(strShortStc(i)="", "&nbsp;", strShortStc(i)), IIf(strResult(i)="", "&nbsp;", strResult(i))) %></FONT></TD>
				<TD WIDTH="65"><%= IIf(strRslCmtName1(i)="", "&nbsp;", strRslCmtName1(i)) %></TD>
				<TD WIDTH="65"><%= IIf(strRslCmtName2(i)="", "&nbsp;", strRslCmtName2(i)) %></TD>
			</TR>
<% 	
		Next
%>
	</TABLE>

<%
	'問診結果読み込み
	lngCount = objResult.SelectInquiryRslList(strRsvNo, _
												RSLQUE_Q, _
												strItemName, _
												strResult, _
												strResultType, _
												strShortStc, _
												strStdFlgColor, _
												strRslCmtName1, _
												strRslCmtName2)
%>

	<!-- 問診結果 -->
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#999999">■</FONT><FONT COLOR="#333333">問診結果</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR BGCOLOR="#cccccc">
			<TD WIDTH="160" ALIGN="center" NOWRAP>問診項目名</TD>
			<TD WIDTH="237" ALIGN="center" NOWRAP>問診回答</TD>
		</TR>
		<% For i = 0 To lngCount - 1 %>
			<TR BGCOLOR="#eeeeee">
				<TD WIDTH="160" NOWRAP><%= strItemName(i) %></TD>
				<TD WIDTH="237" NOWRAP><%= IIf(CStr(strResultType(i)) = CStr(RESULTTYPE_SENTENCE), IIf(strShortStc(i)="", "&nbsp;", strShortStc(i)), IIf(strResult(i)="", "&nbsp;", strResult(i))) %></TD>
			</TR>
		<% Next %>
	</TABLE>
<%
	'オブジェクトのインスタンス削除
	Set objResult = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>HTML Report</TITLE>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="report" action="#">

<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><FONT COLOR="#6600ff">■</FONT><FONT COLOR="#000000">Report</FONT></B></TD>
	</TR>
</TABLE>


<%
	'受診者個人情報の表示
	If strRsvNo <> 0 Then
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD HEIGHT="10"></TD>
			</TR>
			<TR>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TR>
							<TD>受診日：</TD>
							<TD><FONT COLOR="#ff6600"><B><%= strEditCslDate %></B></FONT></TD>
							<TD WIDTH="10"></TD>
							<TD>受診コース：</TD>
							<TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
							<TD WIDTH="10"></TD>
							<TD>予約番号：</TD>
							<TD><FONT COLOR="#ff6600"><B><%= strRsvNo %></B></FONT></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR><TD HEIGHT="10"></TD></TR>
			<TR>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TR>
							<TD NOWRAP><%= strPerID %></TD>
							<TD WIDTH="5"></TD>
							<TD NOWRAP><B><%= strLastName & "　" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKName & "　" & strFirstKName %></FONT>)</TD>
						</TR>
						<TR>
							<TD HEIGHT="5"></TD>
						</TR>
						<TR>
							<TD></TD>
							<TD></TD>
							<TD NOWRAP><%= strEditBirth %>生　<%= strAge %>歳　<%= strEditGenderName %></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR><TD HEIGHT="10"></TD></TR>
		</TABLE>
<%
	End If
%>

	<!-- 判定結果 -->
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#999999">■</FONT><FONT COLOR="#333333">判定結果</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>

	<TABLE WIDTH="100%" BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR BGCOLOR="#cccccc">
			<TD WIDTH="80" ALIGN="center">分野</TD>
			<TD ALIGN="center">判定</TD>
<!--				<TD ALIGN="center">定型所見</TD>-->
<!--			<TD ALIGN="center">コメント</TD>	-->
		</TR>
		<% For i = 0 To lngJudCount - 1 %>
			<TR BGCOLOR="#eeeeee">
				<TD NOWRAP><%= IIf(strJudClassName(i)="", "&nbsp;", strJudClassName(i)) %></TD>
				<TD NOWRAP><%= IIf(strJudSName(i)="", "&nbsp;", strJudSName(i)) %></TD>
<!--				<TD NOWRAP><%= IIf(strFreeJudCmt(i)="", "&nbsp;", strFreeJudCmt(i)) %></TD>-->
			</TR>
		<% Next %>
	</TABLE>

<% '検査結果／問診結果編集 %>
<% Call EditRslList %>
</FORM>
</BODY>
</HTML>
