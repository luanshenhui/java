<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		印刷用ダイアログ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"        -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objReport			'印刷情報アクセス用
Dim objReportLog		'印刷ログ情報アクセス用

Dim lngPrintSeq			'プリントSEQ
Dim strSelPrinter		'プリンタ選択モード(""以外ならば帳票テーブル値を適用)

Dim strFileName			'帳票ドキュメントファイル名
Dim strReportCd			'帳票コード
Dim strReportName		'帳票名称
Dim strDefaultPrinter	'デフォルトプリンタ

Dim strPrinterName		'出力プリンタ
Dim strIPAddress		'IPAddress

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objReport    = Server.CreateObject("HainsReport.Report")
Set objReportLog = Server.CreateObject("HainsReportLog.ReportLog")

'引数値の取得
lngPrintSeq   = CLng("0" & Request("seq"))
strSelPrinter = Request("selPrinter")

Do

	'印刷ログ情報のプリントSEQをキーに、帳票ドキュメントファイル名を取得する。
	If Not objReportLog.SelectReportLog2(lngPrintSeq, strFileName, strReportCd) Then
		Exit Do
	End If

	'帳票名称取得
	objReport.SelectReport2 strReportCd, strReportName, strDefaultPrinter

	'プリンタの設定(未指定時は起動端末のデフォルトプリンタが対象となる)
	If strSelPrinter <> "" Then

		strPrinterName = strDefaultPrinter

		'IPアドレスの取得
		strIPAddress = Request.ServerVariables("REMOTE_ADDR")

		'プリンタ名に取得したIPアドレスが存在する場合
		If InStr(strPrinterName, strIPAddress) > 0 Then

			'IPアドレス指定を取り除く
			strPrinterName = Replace(strPrinterName, strIPAddress, "")

			'更に￥マークも取り除く(これでローカルプリンタ指定にさせる)
			strPrinterName = Replace(strPrinterName, "\", "")

		End If

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
<TITLE>印刷</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<OBJECT CLASSID="clsid:5220CB21-C88D-11CF-B347-00AA00A28331">
	<PARAM NAME="LPKPath" VALUE="/webHains/cab/ViewCtrl/CrView.lpk">
</OBJECT>
<OBJECT CLASSID="clsid:551553D6-DAEA-11D3-BE3F-0090FE014382" CODEBASE="/webHains/cab/ViewCtrl/CrView.cab" ID="MyCrView" WIDTH="0" HEIGHT="0">
	<PARAM NAME="DocumentFileName" VALUE="http://<%= Request.ServerVariables("SERVER_NAME") & PRT_TEMPPATH & strFileName %>">
</OBJECT>
<P ALIGN="center">印刷中です．．．</P>
<SCRIPT TYPE="text/vbscript" LANGUAGE="VBScript" FOR="MyCrView" EVENT="DownLoaded(Status)">
<!--
Dim Ret

Select Case Status

	Case 0

		'印刷実行
		Ret = MyCrView.PrintOut("<%= strPrinterName %>", "<%= strReportName %>", 0)
		Select Case Ret
			Case 0
			Case -9
				MsgBox "プリンタがインストールされていません。"
			Case -10
				MsgBox "指定されたプリンタ<%= IIf(strPrinterName <> "", "（" & strPrinterName & "）" , "") %>は存在しません。"
			Case Else
				MsgBox "印刷処理においてエラーが発生しました。（エラーコード＝" & Ret & "）"
		End Select

	Case 1

		MsgBox "URLの指定に誤りがあります。"

	Case 2

		MsgBox "CoReportドキュメントファイルのダウンロードでエラーが発生しました。"

	Case Else

		MsgBox "ダウンロードされたファイルはCoReportドキュメントファイルの形式ではありません。"

End Select

Window.Close
//-->
</SCRIPT>
</BODY>
</HTML>
