<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診）既往歴  (Ver0.0.1)
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
Const DISEASE_GRPCD = "X028"		'既往歴　検査項目グループコード

Dim objCommon				'共通クラス
Dim objConsult				'受診クラス
Dim objPerResult			'個人検査結果情報アクセス用

'パラメータ
Dim lngRsvNo				'予約番号

'受診情報用変数
Dim strPerId				'個人ID

'個人検査項目情報用変数
Dim vntItemCd				'検査項目コード
Dim vntSuffix				'サフィックス
Dim vntItemName				'検査項目名
Dim vntResult				'検査結果
Dim vntResultType			'結果タイプ
Dim vntItemType				'項目タイプ
Dim vntStcItemCd			'文章参照用項目コード
Dim vntStcCd				'文章コード
Dim vntShortStc				'文章略称
Dim vntIspDate				'検査日

'表示用文章退避エリア
Dim strDspName()			'病名
Dim strDspAge()				'罹患年齢
Dim strDspStat()			'治癒状態

Dim strColor				'背景色

Dim Ret						'復帰値
Dim lngPerRslCount			'個人検査項目情報数
Dim i, j					'カウンター

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")

'引数値の取得
lngRsvNo			= Request("rsvno")


Do

	'受診情報検索
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, _
									, _
									strPerId    )

	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If


	'個人検査結果情報取得
	lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerId, _
														DISEASE_GRPCD, _
														1, 0, _
														vntItemCd, _
														vntSuffix, _
														vntItemName, _
														vntResult, _
														vntResultType, _
														vntItemType, _
														vntStcItemCd, _
														vntShortStc, _
														vntIspDate _
														)
	If lngPerRslCount < 0 Then
		Err.Raise 1000, , "個人検査結果情報が存在しません。（個人ID= " & strPerId & " )"
	End If

	Exit Do
Loop

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>既往歴_2</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 5px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="300" BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
		j = 0
		For i = 0 To lngPerRslCount - 1
			Select Case vntSuffix(i)
				'病名
				Case "01"
					Redim Preserve strDspName(j)
					'文章タイプ？
					If vntResultType(i) = 4 Then
						strDspName(j) = vntShortStc(i)
					Else
						strDspName(j) = vntResult(i)
					End If
				'罹患年齢
				Case "02"
					Redim Preserve strDspAge(j)
					'文章タイプ？
					If vntResultType(i) = 4 Then
						strDspAge(j) = vntShortStc(i)
					Else
						strDspAge(j) = vntResult(i)
					End If
				'治癒状態
				Case "03"
					Redim Preserve strDspStat(j)
					'文章タイプ？
					If vntResultType(i) = 4 Then
						strDspStat(j) = vntShortStc(i)
					Else
						strDspStat(j) = vntResult(i)
					End If
					j = j + 1
				Case Else
			End Select
		Next

		For i = 0 To j - 1
			If i mod 2 = 0 Then
				strColor = ""
			Else
				strColor = "#e0ffff"
			End If
%>
			<TR HEIGHT="17">
				<TD NOWRAP BGCOLOR="<%= strColor %>" WIDTH="100" HEIGHT="17"><%= strDspName(i) %></TD>
				<TD NOWRAP BGCOLOR="<%= strColor %>" WIDTH="70" HEIGHT="17"><%= strDspAge(i) %></TD>
				<TD NOWRAP BGCOLOR="<%= strColor %>" WIDTH="100" HEIGHT="17"><%= strDspStat(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</BODY>
</HTML>