<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診）前回総合コメント  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objInterview		'面接情報アクセス用

'パラメータ
Dim lngRsvNo			'予約番号


'総合コメント
Dim vntCmtSeq			'表示順
Dim vntTtlJudCmtCd		'判定コメントコード
Dim vntTtlJudCmtstc		'判定コメント文章
Dim vntTtlJudClassCd	'判定分類コード
Dim vntRsvNo 			'予約番号
Dim vntCslDate 			'受診日
Dim vntCsCd 			'コースコード
Dim vntCsName 			'コース名称
Dim lngTtlCmtCnt		'行数


Dim strBakCslDate 		'受診日（前行）
Dim strBakCsCd 			'コースコード（前行）

Dim strColor			'背景色

Dim Ret					'復帰値
Dim i, j				'カウンター

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon 		= Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")

'引数値の取得
lngRsvNo			= Request("rsvno")


Do


	'総合コメント取得
	lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
    									lngRsvNo, 1, _
										"*", 0,  , 1, _
    									vntCmtSeq, _
    									vntTtlJudCmtCd, _
    									vntTtlJudCmtstc, _
    									vntTtlJudClassCd, _
										vntRsvNo, _
										vntCslDate, _
										vntCsCd, _
										vntCsName _
										)
	If lngTtlCmtCnt < 0 Then
		Err.Raise 1000, , "総合コメントが存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	Exit Do
Loop

Set objCommon 		= Nothing
Set objInterview    = Nothing
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>健診前準備（問診）前回総合コメント</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 15px; }
</style>

</HEAD>
<BODY>
		<TABLE WIDTH="431" BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
		strBakCslDate = ""
		strBakCsCd    = ""
		For i = 0 To lngTtlCmtCnt - 1
			If i mod 2 = 0 Then
				strColor = ""
			Else
				strColor = "#e0ffff"
			End If
%>
			<TR HEIGHT="17">
<%
			'前の行と違う
			If strBakCslDate <> vntCslDate(i) Then
%>
				<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="81" HEIGHT="17"><%= vntCslDate(i) %></TD>
<%
				strBakCslDate = vntCslDate(i)
			Else
%>
				<TD ALIGN="left" BGCOLOR="<%= strColor %>" WIDTH="81" HEIGHT="17"></TD>
<%
			End If
%>
<%
			'前の行と違う
			If strBakCsCd <> vntCsCd(i) Then
%>
				<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="116" HEIGHT="17"><%= vntCsName(i) %></TD>
<%
				strBakCsCd = vntCsCd(i)
			Else
%>
				<TD ALIGN="left" BGCOLOR="<%= strColor %>" WIDTH="116" HEIGHT="17"></TD>
<%
			End If
%>
				<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="350" HEIGHT="17"><%= vntTtlJudCmtstc(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</BODY>
</HTML>