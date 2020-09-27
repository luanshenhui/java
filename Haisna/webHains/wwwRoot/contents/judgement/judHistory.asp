<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		判定歴 (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim strPerId						'個人ＩＤ
Dim strYear							'表示年
Dim strMonth						'表示月
Dim strDay							'表示日
Dim strDate							'表示日付

'個人情報
Dim strLastName						'姓
Dim strFirstName					'名
Dim strLastKName					'カナ姓	
Dim strFirstKName					'カナ名
Dim strBirth						'生年月日
Dim strGender						'性別
Dim strGenderName					'性別名称

'判定結果情報
Dim strArrRsvNo()					'予約番号
Dim lngArrRsvNoRows()				'予約番号ごとの行数
Dim strArrCslDate()					'受診日
Dim strArrCsName()					'コース名
Dim strArrJudClassCd()				'判定分類コード
Dim lngArrJudClassRows()			'予約番号・判定分類ごとの行数
Dim strArrJudClassName()			'判定分類名称
Dim strArrJudSName()				'判定略称
Dim strArrStdJudNote()				'定型所見名称
Dim strArrFreeJudCmt()				'フリー判定コメント
Dim strArrGuidanceStc()				'指導内容文章
Dim strArrJudCmtStc()				'判定コメント

Dim strOldRsvNo						'件数カウント用・予約番号
Dim strOldJudClassCd				'件数カウント用・判定分類
Dim lngRsvNoRows					'予約番号ごとの行数カウンタ
Dim lngRsvNoStartPos				'配列検索用・予約番号位置
Dim lngJudClassRows					'予約番号・判定分類ごとの行数カウンタ
Dim lngJudClassStartPos				'配列検索用・判定分類位置

Dim objPerson						'個人情報アクセス用COMオブジェクト
Dim objJudgement					'判定結果情報アクセス用COMオブジェクト
Dim objCommon						'共通関数アクセス用COMオブジェクト

Dim i								'インデックス
Dim j								'インデックス
Dim lngCount						'レコード件数
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strPerId = Request("perID")
strYear  = Request("year")
strMonth = Request("month")
strDay   = Request("day")

'オブジェクトのインスタンス作成
Set objPerson	= Server.CreateObject("HainsPerson.Person")
Set objJudgement = Server.CreateObject("HainsJudgement.Judgement")
Set objCommon	= Server.CreateObject("HainsCommon.Common")

Do

	'表示開始日付が渡されなかった場合、システム日付を表示開始日付とする
	If strYear = "" And strMonth = "" And strDay = "" Then
		strYear  = Year(Now)
		strMonth = Month(Now)
		strDay   = Day(Now)
	End If

	'日付型に変換
	strDate = CDate(strYear & "/" & strMonth & "/" & strDay)

	'個人情報読み込み
	Call objPerson.SelectPersonInf(strPerId, _
									strLastName, _
									strFirstName, _
									strLastKName, _
									strFirstKName, _
									strBirth, _
									strGender, _
									strGenderName)

	'生年月日和暦表示
	strBirth = objCommon.FormatString(strBirth, "g ee.mm.dd")

	'判定結果情報読み込み
	lngCount = objJudgement.SelectHistoryJudRslList(strPerId, _
													strDate, _
													strArrRsvNo, _
													strArrCslDate, _
													strArrCsName, _
													strArrJudClassCd, _
													strArrJudClassName, _
													strArrJudSName, _
													strArrStdJudNote, _
													strArrFreeJudCmt, _
													strArrGuidanceStc, _
													strArrJudCmtStc)

	'対象データが存在しない場合、何もしない
	If lngCount = 0 Then
		Exit Do
	End If
	
	'配列初期化
	ReDim lngArrRsvNoRows(UBound(strArrRsvNo))
	ReDim lngArrJudClassRows(UBound(strArrRsvNo))

	'比較用ワーク初期化
	strOldRsvNo = ""
	strOldJudClassCd = ""

	'カウンタ初期化
	lngRsvNoRows = 0
	lngRsvNoStartPos = 0
	lngJudClassRows = 0
	lngJudClassStartPos = 0

	'予約番号・判定分類ごとに行数をカウント
	For i = 0 To UBound(strArrRsvNo)
		'初期状態
		If strOldRsvNo = "" Then
			strOldRsvNo = strArrRsvNo(i)
			strOldJudClassCd = strArrJudClassCd(i)
		End If
		'予約番号が変わったとき、予約番号ごとの行数をセット
		If strArrRsvNo(i) <> strOldRsvNo Then
			lngArrJudClassRows(lngJudClassStartPos) = lngJudClassRows
			lngArrRsvNoRows(lngRsvNoStartPos) = lngRsvNoRows
			strOldRsvNo = strArrRsvNo(i)
			strOldJudClassCd = strArrJudClassCd(i)
			lngRsvNoStartPos = i
			lngRsvNoRows = 0
			lngJudClassStartPos = i
			lngJudClassRows = 0
		End If
		'判定分類が変わったとき、判定分類ごとの行数をセット
		If strArrJudClassCd(i) <> strOldJudClassCd Then
			lngArrJudClassRows(lngJudClassStartPos) = lngJudClassRows
			strOldJudClassCd = strArrJudClassCd(i)
			lngJudClassStartPos = i
			lngJudClassRows = 0
		End If
		'行数をカウント
		lngRsvNoRows = lngRsvNoRows + 1
		lngJudClassRows = lngJudClassRows + 1
	Next
	'最後の予約番号・判定分類の行数をセット
	If strOldRsvNo <> "" Then
		lngArrJudClassRows(lngJudClassStartPos) = lngJudClassRows
		lngArrRsvNoRows(lngRsvNoStartPos) = lngRsvNoRows
	End If
	
	Exit Do

Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>判定歴</TITLE>
</HEAD>

<BODY MARGINWIDTH="0" MARGINHEIGHT="0" BGCOLOR="#FFFFFF">

<!-- ウインドウ説明見出し -->
<TABLE width=100% border=0 cellspacing=0 cellpadding=0>
	<TR>
		<TD bgcolor="#999999" width="20%">
			<TABLE border=0 cellpadding=2 cellspacing=1 width=100%>
				<TR height="15">
					<TD bgcolor=#eeeeee nowrap><B>過去の判定入力内容</B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="100%">
	<TR>
		<TD COLSPAN="2"><IMG SRC="/webHains/images/spacer.gif" HEIGHT="3"></TD>
	</TR>
	<TR>
		<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="TOP"><%= strPerId %></TD>
		<TD NOWRAP><B><%= strLastName & "　" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKName & "　" & strFirstKName %></FONT>)<BR><%= strBirth %>生　<%= strGenderName %></TD>
	</TR>
</TABLE>
<BR>
<%
	If lngCount > 0 Then
%>
		<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="2" WIDTH="600">
		<TR>
			<TD BGCOLOR="#eeeeee">受診日</TD>
			<TD BGCOLOR="#eeeeee">コース</TD>
			<TD BGCOLOR="#eeeeee">分類</TD>
			<TD BGCOLOR="#eeeeee">判定</TD>
			<TD BGCOLOR="#eeeeee">判定コメント</TD>
			<TD BGCOLOR="#eeeeee">指導内容</TD>
		</TR>
<% 
	Else
%>
		<UL><LI>判定歴は存在しません</UL>
<%
	End If
	
	For i = 0 To lngCount - 1
%>
		<TR>
<%
			If lngArrRsvNoRows(i) <> "" Then
%>
				<TD ROWSPAN="<%= lngArrRsvNoRows(i) %>" VALIGN="TOP"><%= strArrCslDate(i) %></TD>
				<TD ROWSPAN="<%= lngArrRsvNoRows(i) %>" VALIGN="TOP"><%= strArrCsName(i) %></TD>
<%
			End If
			If lngArrJudClassRows(i) <> "" Then
%>
				<TD ROWSPAN="<%= lngArrJudClassRows(i) %>" NOWRAP><%= strArrJudClassName(i) %></TD>
				<TD ROWSPAN="<%= lngArrJudClassRows(i) %>" NOWRAP><%= IIf(strArrJudSName(i)<>"",strArrJudSName(i),"&nbsp;") %></TD>
<%
			End If
%>
			<TD><%= IIf(strArrJudCmtStc(i)<>"",strArrJudCmtStc(i),"&nbsp;") %></TD>
<%
			If lngArrJudClassRows(i) <> "" Then
%>
				<TD ROWSPAN="<%= lngArrJudClassRows(i) %>"><%= IIf(strArrGuidanceStc(i)<>"", strArrGuidanceStc(i),"&nbsp;") %></TD>
<%
			End If
%>
		</TR>
<%
	Next
%>

</TABLE>
<BR>
<TR BGCOLOR="#ffffff" HEIGHT="40">
	<TD COLSPAN="2" ALIGN="RIGHT" VALIGN="BOTTOM">
		<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
	</TD>
</TR>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
