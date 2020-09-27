<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   検査結果表示タイプ３～更新モード  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用
Dim objResult			'検査結果アクセス用COMオブジェクト

'パラメータ
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strGrpNo			'グループNo
Dim	strWinMode			'ウィンドウモード
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

Dim lngLastDspMode		'前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp			'前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
Dim vntPerId			'個人ＩＤ
Dim vntRsvNo			'予約番号
Dim vntCslDate			'受診日
Dim vntCsCd				'コースコード
Dim vntCsName			'コース名
Dim vntCsSName			'コース略称
Dim lngHisCount			'表示歴数
Dim i					'インデックス

'検査結果情報
Dim vntRsvNo1			'予約番号
Dim vntItemCd			'検査項目コード
Dim vntSuffix			'サフィックス
Dim vntResult			'検査結果
Dim vntRslCmtCd1		'結果コメント１
Dim vntRslCmtCd2		'結果コメント２
Dim vntUpdFlg			'更新フラグ

'実際に更新する項目情報を格納した検査結果
Dim vntUpdItemCd		'検査項目コード
Dim vntUpdSuffix		'サフィックス
Dim vntUpdResult		'検査結果
Dim vntUpdRslCmtCd1		'結果コメント１
Dim vntUpdRslCmtCd2		'結果コメント２
Dim lngUpdCount			'更新項目数
Dim strArrMessage		'エラーメッセージ

Dim strUpdUser			'更新者
Dim strIPAddress		'IPアドレス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strAction			= Request("act")
strWinMode			= Request("winmode")
strGrpNO			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf(strSelCsGrp="", "0", strSelCsGrp)
lngEntryMode		= Request("entrymode")
lngEntryMode		= IIf(lngEntryMode="", INTERVIEWRESULT_REFER, lngEntryMode)
lngHideFlg			= Request("hideflg")
lngHideFlg			= IIf(lngHideFlg="", "1", lngHideFlg)

'検査結果情報
vntItemCd			= ConvIStringToArray(Request("itemcd"))
vntSuffix			= ConvIStringToArray(Request("suffix"))
vntResult			= ConvIStringToArray(Request("stccd"))
vntRslCmtCd1		= ConvIStringToArray(Request("cmtcd1"))
vntRslCmtCd2		= ConvIStringToArray(Request("cmtcd2"))
vntUpdFlg			= ConvIStringToArray(Request("updflg"))
'グループ情報取得
Call GetMenResultGrpInfo(strGrpNo)

Select Case strSelCsGrp
	'すべてのコース
	Case "0"
		lngLastDspMode = 0
		vntCsGrp = ""
	'同一コース
	Case "1"
		lngLastDspMode = 1
		vntCsGrp = strCsCd
	Case Else
		lngLastDspMode = 2
		vntCsGrp = strSelCsGrp
End Select

Do	
	'保存
	If strAction = "save" Then

		lngUpdCount = 0
		vntUpdItemCd = Array()
		vntUpdSuffix = Array()
		vntUpdResult = Array()
		vntUpdRslCmtCd1 = Array()
		vntUpdRslCmtCd2 = Array()

		'実際に更新を行う項目のみを抽出
		For i = 0 To UBound(vntUpdFlg)
			If vntUpdFlg(i) = "1" Then
				ReDim Preserve vntUpdItemCd(lngUpdCount)
				ReDim Preserve vntUpdSuffix(lngUpdCount)
				ReDim Preserve vntUpdResult(lngUpdCount)
				ReDim Preserve vntUpdRslCmtCd1(lngUpdCount)
				ReDim Preserve vntUpdRslCmtCd2(lngUpdCount)
				vntUpdItemCd(lngUpdCount) = vntItemCd(i)
				vntUpdSuffix(lngUpdCount) = vntSuffix(i)
				vntUpdResult(lngUpdCount) = vntResult(i)
				vntUpdRslCmtCd1(lngUpdCount) = vntRslCmtCd1(i)
				vntUpdRslCmtCd2(lngUpdCount) = vntRslCmtCd2(i)
				lngUpdCount = lngUpdCount + 1
			End If
		Next

		If lngUpdCount > 0 Then
			'更新者の設定
			strUpdUser = Session("USERID")
			'IPアドレスの取得
			strIPAddress = Request.ServerVariables("REMOTE_ADDR")

			'オブジェクトのインスタンス作成
			Set objResult  = Server.CreateObject("HainsResult.Result")

			'検査結果更新
'			strArrMessage = objResult.UpdateRsl_tk( _
'								strUpdUser, _
'								strIPAddress, _
'								lngRsvNo, _
'								vntUpdItemCd, _
'								vntUpdSuffix, _
'								vntUpdResult, _
'								vntUpdRslCmtCd1, _
'								vntUpdRslCmtCd2 _
'								)
			objResult.UpdateResult lngRsvNo, strIPAddress, strUpdUser, vntUpdItemCd, vntUpdSuffix, vntUpdResult, vntUpdRslCmtCd1, vntUpdRslCmtCd2, strArrMessage
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'オブジェクトのインスタンス削除
			Set objResult = Nothing

			'保存完了
			strAction = "saveend"
		Else
			strAction = ""
		End If
	End If

	'指定された個人ＩＤの受診歴一覧を取得する
	lngHisCount = objInterView.SelectConsultHistory( _
						lngRsvNo, _
						False, _
						lngLastDspMode, _
						vntCsGrp, _
						3, _
						0, _
						vntPerId, _
						vntRsvNo, _
						vntCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "受診歴が取得できません。（予約番号 = " & lngRsvNo & ")"
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
<TITLE>検査結果表示</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!-- #include virtual = "/webHains/includes/interviewSentence.inc" -->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="act"       VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="entrymode" VALUE="<%= lngEntryMode %>">
	<INPUT TYPE="hidden" NAME="hideflg"   VALUE="<%= lngHideFlg %>">
<%
	'メッセージの編集
	If strAction <> "" Then

		'保存完了時は「保存完了」の通知
		If strAction = "saveend" Then
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

		'さもなくばエラーメッセージを編集
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>

	<!-- 検査結果の一覧表示 -->
<%
	Call EditMenResultTable3( lngHisCount, vntRsvNo, lngRsvNo, strMenResultGrpCd3, lngLastDspMode, vntCsGrp )
%>
</FORM>
</BODY>
</HTML>
