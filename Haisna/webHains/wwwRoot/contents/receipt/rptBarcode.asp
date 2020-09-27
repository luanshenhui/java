<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		バーコード受付 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const FREECD_BCDRPT_FECES = "BCDRPTFECES"	'汎用コード(便検体受付情報)
Const FREECD_BCDRPT_URINE = "BCDRPTURINE"	'汎用コード(尿検体受付情報)

'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objConsult		'受診情報アクセス用
Dim objFree			'汎用情報アクセス用
Dim objItem			'検査項目情報アクセス用
Dim objResult		'結果情報アクセス用

'引数値
Dim strKey			'バーコード値
Dim strRsvNo		'予約番号
Dim strStatus		'状態
Dim strActMode		'動作モード
Dim strResult		'検体持参情報
DIm strCtrPtCd		'削除された時点での契約パターンコード
DIm strDelOptCd		'削除されたオプションコード
Dim strSaveEnd		'検体持参情報が保存された場合に"1"

'バーコード情報
Dim strKeyCslDate	'受診年月日
Dim strKeyCsCd		'コースコード
Dim strKeyDiv		'区分
Dim strKeyPerId		'個人ＩＤ

'受診情報
Dim strCslDate		'受診年月日
Dim strPerId		'個人ＩＤ
Dim strCsCd			'コースコード
Dim strCsName		'コース名
Dim strAge			'受診時年齢
Dim strDayId		'当日ＩＤ
Dim strOrgSName		'団体略称
Dim strUpdDate		'(受付情報の)更新日時
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strGender		'性別

'サブコース情報
Dim strSubCsName	'サブコース名
Dim lngCount		'レコード数

'検体受付情報
Dim strItemCd(1)	'検査項目コード
Dim strSuffix(1)	'サフィックス
Dim strItemName(1)	'検査項目名
Dim strResultOn(1)	'持参時の検査結果
Dim strResultOff(1)	'未持参時の検査結果
Dim strCode(1)		'請求明細分類コード(便の場合)または検査項目コード(尿の場合)
'## 2003.08.18 Add 1Line By T.Takagi@FSIT 便のオプションが存在しない場合、便の検査項目コードで扱うための設定
Dim strFecesItemCd	'便検査項目コード
'## 2003.08.18 Add End

Dim lngRsvNo		'予約番号
Dim lngStatus		'状態

Dim strGetResult	'検査結果
Dim strChecked		'チェック状態
Dim strMessage		'エラーメッセージ
Dim strURL			'ジャンプ先のURL
Dim strUpdUser		'更新者
Dim strBuffer		'文字列バッファ
Dim strSubject		'分野
Dim blnExistsResult	'依頼の有無
Dim Ret				'関数戻り値
Dim Ret2			'関数戻り値
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objFree    = Server.CreateObject("HainsFree.Free")
Set objItem    = Server.CreateObject("HainsItem.Item")
Set objResult  = Server.CreateObject("HainsResult.Result")

'便検体受付情報の読み込み
objFree.SelectFree 0, FREECD_BCDRPT_FECES, , , , strItemCd(0), strSuffix(0), strResultOn(0), strResultOff(0), strCode(0), , , strFecesItemCd

'便検体検査項目の読み込み
If strItemCd(0) <> "" And strSuffix(0) <> "" Then
	objItem.SelectItemName strItemCd(0), strSuffix(0), strItemName(0)
End If

'尿検体受付情報の読み込み
objFree.SelectFree 0, FREECD_BCDRPT_URINE, , , , strItemCd(1), strSuffix(1), strResultOn(1), strResultOff(1), strCode(1)

'尿検体検査項目の読み込み
If strCode(1) <> "" Then
	objItem.SelectItem_P strCode(1), strItemName(1)
End If

'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得
strKey      = Request("key")
strRsvNo    = Request("rsvNo")
strStatus   = Request("status")
strActMode  = Request("act")
strCtrPtCd  = Request("ctrPtCd")
strDelOptCd = Request("delOptCd")
strSaveEnd  = Request("saveEnd")

'検体持参情報チェック状態の取得
strResult = ConvIStringToArray(Request("result"))

'検体受付情報の保存が指定された場合
If strActMode <> "" Then

	'検体持参情報の更新
	lngStatus = UpdateResult(strRsvNo, strResult, strCtrPtCd, strDelOptCd)

	'予約番号、ステータス(予約番号)付きのURLを作成
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?rsvNo="   & strRsvNo
	strURL = strURL & "&status="  & lngStatus

	'正常時は終了通知と削除されたオプションコードとのその契約パターンを更に追加
	If lngStatus > 0 Then
		strURL = strURL & "&ctrPtCd="  & strCtrPtCd
		strURL = strURL & "&delOptCd=" & strDelOptCd
		strURL = strURL & "&saveEnd="  & "1"
	End If

	'リダイレクト
	Response.Redirect strURL
	Response.End

End If

'バーコード値が存在する場合
If strKey <> "" Then

	'チェック・更新・読み込み処理の制御
	Do

		'バーコード文字列より受診情報の予約番号を取得
		Ret = objConsult.GetRsvNoFromBarCode(strKey)

		'バーコード文字列が不正な場合
		If Ret < 0 Then
			lngStatus = -99
			Exit Do
		End If

		'受診情報が存在しない場合
		If Ret = 0 Then
			lngStatus = 0
			Exit Do
		End If

		'予約番号を取得
		lngRsvNo = Ret

		'システム日付で受付処理を行う(自動発番モードで)
		'(ここで起こりうるエラーは次のとおり)
		'-1  指定受診日に同一受診者、コースの受診情報が存在(運用上ほとんど有り得ない)
		'-2  すでにキャンセル済みである
		'-11 すでに受付済みである
		'-14 発番可能な最大番号数を超えた(運用上ほとんど有り得ない)
		'-15 受診情報が保留中
		'-21 契約期間外の受診日が指定された(運用上あまり有り得ない)
		'-22 現受診時年齢と指定受診日時点での年齢が異なる(運用上ほとんど有り得ない)
		'-30 枠溢れ

		Ret2 = objConsult.Receipt(lngRsvNo, Year(Date), Month(Date), Day(Date), strUpdUser, 1, 0, 0, Request.ServerVariables("REMOTE_ADDR"), strMessage)

		'正常な場合
		If Ret2 > 0 Then

			'状態として予約番号を設定する
			lngStatus = lngRsvNo

			'検体持参情報のチェック状態はすべて「持参」とする
			strResult = Array()
			Redim Preserve strResult(1)
			strResult(0) = "1"
			strResult(1) = "1"

			'検体持参情報の更新
			InsertResult lngRsvNo, strResult

			Exit Do
		End If

		'メソッドにてエラーコードが返された場合、上記エラー以外は起こりえないが、念のため
		Select Case Ret2
			Case -1, -2, -11, -14, -15, -21, -22, -30
				lngStatus = Ret2
			Case Else
				Err.Raise, 1000, , strMessage
		End Select

		Exit Do
	Loop

	'予約番号、ステータス(予約番号)付きのURLでリダイレクト
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?rsvNo="  & lngRsvNo
	strURL = strURL & "&status=" & lngStatus
	Response.Redirect strURL
	Response.End

End If

Do

	'状態が存在しない場合
	If strStatus = "" Then
		strMessage = "バーコードを読み込ませてください。"
		Exit Do
	End If

	'案内メッセージの編集
	Select Case CLng(strStatus)
		Case 0
			strMessage = "受診情報が存在しません。"
		Case -1
			strMessage = "指定された個人の受診情報が本日すでに存在します。"
		Case -2
			strMessage = "この受診情報はキャンセルされています。"
		Case -11
			strMessage = "すでに受付済みです。"
		Case -14
			strMessage = "これ以上当日ＩＤの発番ができません。"
		Case -15
			strMessage = "この受診情報は現在保留中です。"
		Case -21
			strMessage = "本日時点でこの受診情報の契約は有効でありません。"
		Case -22
			strMessage = "本日時点での年齢が予約時と異なるため、<BR>受診オプション検査に変更が発生する可能性があります。"
		Case -30
			strMessage = "空き予約枠がありません。"
		Case -81
			strMessage = "契約情報が変更されたため保存できません。"
		Case -82
			strMessage = "便潜血オプション検査が存在しないため保存できません。"
		Case -99
			strMessage = "バーコードの値が正しくありません。"
		Case Else
			strMessage = "バーコードを読み込ませてください。"
	End Select

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 検体持参情報の更新
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     strCheckedResult  検体持参情報のチェック状態("":依頼なし、"0":未持参、"1":持参)
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub InsertResult(lngRsvNo, strCheckedResult)

	Dim strUpdItemCd(0)	'検査項目コード
	Dim strUpdSuffix(0)	'サフィックス
	Dim strUpdResult(0)	'検査結果

	Dim strUpdRslCmtCd1(0)	'結果コメントコード１
	Dim strUpdRslCmtCd2(0)	'結果コメントコード２

	Dim i				'インデックス

	For i = 0 To UBound(strItemCd)

		Do

			'汎用テーブル設定不備等で項目情報が存在しない場合は何もしない
			If strItemCd(i) = "" Or strSuffix(i) = "" Or strItemName(i) = "" Then
				Exit Do
			End If

			'請求明細分類または検査項目が設定されていなければ何もしない
			If strCode(i) = "" Then
				Exit Do
			End If

			'チェック状態が存在しない場合は何もしない
			If strCheckedResult(i) = "" Then
				Exit Do
			End If

			'便の場合
			If i = 0 Then

				'指定請求明細分類(実際は便潜血)の受診オプションを持つかで依頼があるかをチェック
				'依頼がなければ何もしない
				If objConsult.CheckConsult_O_Isr(lngRsvNo, strCode(i)) = False Then

'## 2003.08.18 Add 4Lines By T.Takagi@FSIT 受診オプションが存在しない場合は尿と同一
					'依頼が存在しない場合は尿と同じく、指定検査項目を持つかでチェック
					If objConsult.ExistsItem(lngRsvNo, strFecesItemCd) = False Then
						Exit Do
					End If
'## 2003.08.18 Add End

				End If

			'尿の場合
			Else

				'指定検査項目(尿検査)を持つかで依頼があるかをチェック
				If objConsult.ExistsItem(lngRsvNo, strCode(i)) = False Then
					Exit Do
				End If

			End If

			'更新検査結果の編集
			strUpdItemCd(0) = strItemCd(i)
			strUpdSuffix(0) = strSuffix(i)
			strUpdResult(0) = IIf(strCheckedResult(i) = "1", strResultOn(i), strResultOff(i))

			'検体持参情報を更新
			objResult.MergeRsl lngRsvNo, strUpdItemCd, strUpdSuffix, strUpdResult

			Exit Do
		Loop

	Next

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 検体持参情報の更新
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     strCheckedResult  検体持参情報のチェック状態("":依頼なし、"0":未持参、"1":持参)
' 　　　　   (In/Out) strCtrPtCd        (便潜血のオプション検査削除時)削除された時点での契約パターンコード
' 　　　　   (In/Out) strDelOptCd       (便潜血のオプション検査削除時)削除されたオプションコード
'
' 戻り値　 : ステータス(正常時は予約番号)
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function UpdateResult(lngRsvNo, strCheckedResult, strCtrPtCd, strDelOptCd)

	Dim strUpdItemCd(0)		'検査項目コード
	Dim strUpdSuffix(0)		'サフィックス
	Dim strUpdResult(0)		'検査結果

	Dim strUpdRslCmtCd1(0)	'結果コメントコード１
	Dim strUpdRslCmtCd2(0)	'結果コメントコード２

	Dim blnExists			'オプション検査の存在状態(即ち依頼有無)
	Dim lngStatus			'ステータス
	Dim Ret					'関数戻り値
	Dim i					'インデックス

	'初期処理
	lngStatus = lngRsvNo

	For i = 0 To UBound(strItemCd)

		Do

			'汎用テーブル設定不備等で項目情報が存在しない場合は何もしない
			If strItemCd(i) = "" Or strSuffix(i) = "" Or strItemName(i) = "" Then
				Exit Do
			End If

			'チェック状態が存在しない場合は何もしない
			If strCheckedResult(i) = "" Then
				Exit Do
			End If

			'更新検査結果の編集
			strUpdItemCd(0) = strItemCd(i)
			strUpdSuffix(0) = strSuffix(i)
			strUpdResult(0) = IIf(strCheckedResult(i) = "1", strResultOn(i), strResultOff(i))

			'検体持参情報を更新
			objResult.MergeRsl lngRsvNo, strUpdItemCd, strUpdSuffix, strUpdResult

			'尿の場合はここまで
			If i = 1 Then
				Exit Do
			End If

			'便の場合

			'請求明細分類が設定されていなければ何もしない
			If strCode(i) = "" Then
				Exit Do
			End If

			'指定請求明細分類(実際は便潜血)の受診オプションを持つかで依頼があるかをチェック
			blnExists = objConsult.CheckConsult_O_Isr(lngRsvNo, strCode(i))

			'チェック状態による処理分岐
			Select Case strCheckedResult(i)

				'チェックあり(持参)
				Case "1"

					'依頼があれば何もしない
					If blnExists Then
						Exit Do
					End If

'## 2003.08.18 Add 5Lines By T.Takagi@FSIT 受診オプションが存在しない場合は尿と同一
					'チェックが存在し、かつパターン、オプションが存在しない場合というのは受診オプションではなく検査項目の有無で依頼が判断された場合に等しい。
					'よってこの場合、以下のオプション追加処理は不要。
					If strCtrPtCd = "" Or strDelOptCd = "" Then
						Exit Do
					End If
'## 2003.08.18 Add End

					'指定オプションを追加し、受診情報の再作成を行う
					Ret = objConsult.UpdateConsultWithAddOption(lngRsvNo, strCtrPtCd, strDelOptCd)

					'エラー時
					If Ret <= 0 Then

						Select Case Ret
							Case 0		'受診情報が存在しない
								lngStatus = 0
							Case -2		'契約パターンが変更された
								lngStatus = -81
							Case -3, -4	'指定オプションが契約にない
								lngStatus = -82
							Case -10	'受診情報がキャンセルされた
								lngStatus = -3
							Case Else	'上記以外が返ることはないが気持ち的に
								Err.Raise, 1000, , "検体受付情報の更新にてエラーが発生しました。（エラーコード=" & Ret & "）"
						End Select

						Exit For
					End If

					'正常終了時はパターン、オプションを保持する必要がないため値をクリアする
					strCtrPtCd = ""
					strDelOptCd = ""

				'チェックなし(未持参)
				Case "0"

					'依頼がなければ何もしない
					If Not blnExists Then
						Exit Do
					End If

					'指定請求明細分類のオプション検査を削除し、受診情報の再作成を行う
					Ret = objConsult.UpdateConsultWithDelOption(lngRsvNo, strCode(i), strCtrPtCd, strDelOptCd)

					'エラー時
					If Ret <= 0 Then

						Select Case Ret
							Case 0		'受診情報が存在しない
								lngStatus = 0
							Case -10	'受診情報がキャンセルされた
								lngStatus = -3
							Case Else	'上記以外が返ることはないが気持ち的に
								Err.Raise, 1000, , "検体受付情報の更新にてエラーが発生しました。（エラーコード=" & Ret & "）"
						End Select

						Exit For
					End If

			End Select

			Exit Do
		Loop

	Next

	UpdateResult = lngStatus

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>受診者受付</TITLE>
<!-- #include virtual = "/webHains/includes/printDialog.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winCancelReceipt;	// 受付取り消し画面

function setFocus() {

	document.entryForm.key.focus();
	document.entryForm.key.value = '';

}

// チェックボックスのチェック状態をhiddenへ編集
function checkResult( objCheckBox, index ) {

	document.kentai.result[ index ].value = (objCheckBox.checked ? '1' : '0');
	document.entryForm.key.focus();

}

function printAll( rsvNo, cslDate ) {

	document.entryForm.key.focus();

	// 受診カード印刷用のダイアログ呼び出し
	showPrintDialog(3, rsvNo, cslDate);

	// 検体ラベル印刷用のダイアログ呼び出し
	showPrintDialog(4, rsvNo);

}

function printCard( rsvNo, cslDate ) {

	document.entryForm.key.focus();

	// 受診カード印刷用のダイアログ呼び出し
	showPrintDialog(3, rsvNo, cslDate);

}

function printLabel( rsvNo ) {

	document.entryForm.key.focus();

	// 検体ラベル印刷用のダイアログ呼び出し
	showPrintDialog(4, rsvNo);

}

// 検体持参情報の保存処理
function saveData() {

	document.kentai.submit();

}

// 受付取り消し画面呼び出し
function callCancelReceiptWindow() {

	var opened = false;	// 画面が開かれているか
	var url;			// 受付取り消し画面のURL

	document.entryForm.key.focus();

	// すでにガイドが開かれているかチェック
	if ( winCancelReceipt != null ) {
		if ( !winCancelReceipt.closed ) {
			opened = true;
		}
	}

	// 受付取り消し画面のURL編集
	url = '/webHains/contents/receipt/rptCancel.asp';
	url = url + '?calledFrom=bcd';
	url = url + '&rsvNo=<%= strRsvNo %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winCancelReceipt.focus();
	} else {
		winCancelReceipt = window.open( url, '', 'toolbar=no,directories=no,menubar=no,resizable=no,scrollbars=yes,width=500,height=385' );
	}

}

// サブ画面を閉じる
function closeWindow() {

	// 受付取り消し画面を閉じる
	if ( winCancelReceipt != null ) {
		if ( !winCancelReceipt.closed ) {
			winCancelReceipt.close();
		}
	}

	winCancelReceipt = null;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setFocus()" ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受診者受付</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<IMG SRC="/webHains/images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left" ONCLICK="javascript:document.entryForm.key.focus()">
	<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="320" ALIGN="left">

	<BR>

	<FONT SIZE="6"><%= strMessage %></FONT>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>BarCode：</TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" STYLE="ime-mode:disabled"></TD>
		</TR>
	</TABLE>

</FORM>

<FORM NAME="kentai" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="act"     VALUE="save">
	<INPUT TYPE="hidden" NAME="rsvNo"   VALUE="<%= strRsvNo  %>">
	<INPUT TYPE="hidden" NAME="status"  VALUE="<%= strStatus %>">
	<INPUT TYPE="hidden" NAME="autoFlg" VALUE="">
<%
	'表示制御
	Do

		'予約番号が存在しない場合は何もしない
		If strRsvNo = "" Then
			Exit Do
		End If

		'受診情報読み込み
		objConsult.SelectConsult strRsvNo, ,   _
								 strCslDate,   _
								 strPerId,     _
								 strCsCd,      _
								 strCsName, , , , , , _
								 strAge , , , , , , , , , , , , , _
								 strDayId , , , , , , _
								 strOrgSName , , , , , , , , , , , _
								 strUpdDate,    _
								 strLastName,   _
								 strFirstName,  _
								 strLastKName,  _
								 strFirstKName, _
								 strBirth,      _
								 strGender
%>
<%
		'受付済みの場合
		If strDayId <> "" Then

			'受付時間を編集する
			strBuffer = objCommon.FormatString(CDate("0" & strUpdDate), "yyyy/m/d hh:nnam/pm") & "&nbsp;" & "受付完了"
%>
			<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0" WIDTH="450">
				<TR>
<%
					'受付済みエラーが発生している場合は強調表示
					If CLng(strStatus) = -4 Then
%>
						<TD NOWRAP><B><FONT COLOR="#ff0000"><%= strBuffer %></FONT></B></TD>
<%
					Else
%>
						<TD NOWRAP><%= strBuffer %></TD>
<%
					End If
%>
					<TD ALIGN="right" NOWRAP>予約番号：<B><%= strRsvNo %></B></TD>
				</TR>
			</TABLE>
<%
		End If
%>
		<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
			<TR>
				<TD NOWRAP><B><%= strPerId %></B></TD>
				<TD><B><%= strLastName %>&nbsp;<%= strFirstName %></B>（<%= strLastKName %>&nbsp;<%= strFirstKName %>）<%= objCommon.FormatString(strBirth, "ge.m.d") %>生&nbsp;<%= strAge %>歳&nbsp;<%= IIf(strGender = CStr(GENDER_MALE), "男性", "女性") %></TD>
			</TR>
			<TR>
				<TD ROWSPAN="3"></TD>
				<TD NOWRAP><B><%= strOrgSName %></B></TD>
			</TR>
<%
			strBuffer = ""

			'受診オプション管理情報をもとに受診サブコースを取得
			lngCount = objConsult.SelectConsult_O_SubCourse(strRsvNo, strSubCsName)

			'レコードが存在する場合は全サブコース名を読点で連結
			If lngCount > 0 Then
				strBuffer = "&nbsp;（" & Join(strSubCsName, "、") & "&nbsp;同時受診）"
			End If
%>
			<TR>
				<TD NOWRAP><B><%= strCsName %></B></TD>
			</TR>
			<TR>
				<TD><%= strBuffer %></TD>
			</TR>
		</TABLE>

		<BR>
<%
		'ステータスが正常な場合は検体受付情報を編集
		If CLng(strStatus) > 0 Or CLng(strStatus) = -4 Then

			blnExistsResult = False
%>
			<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
				<TR>
					<TD NOWRAP><FONT COLOR="#cc9999">●</FONT>検体受付情報</TD>
					<TD><INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>"><INPUT TYPE="hidden" NAME="delOptCd" VALUE="<%= strDelOptCd %>"></TD>
<%
					For i = 0 To UBound(strItemCd)

						strSubject = IIf(i = 0, "便", "尿")

						Do

							'テーブル設定不備の場合
							If strItemCd(i) = "" Or strSuffix(i) = "" Then
%>
								<TD NOWRAP><INPUT TYPE="hidden" NAME="result" VALUE=""><FONT COLOR="#999999">（<%= strSubject %>持参識別用検査項目が汎用テーブルに存在しません。）</FONT></TD>
<%
								Exit Do
							End If

							'検査項目が存在しない場合
							If strItemName(i) = "" Then
%>
								<TD NOWRAP><INPUT TYPE="hidden" NAME="result" VALUE=""><FONT COLOR="#999999">（<%= strSubject %>持参識別用検査項目が検査項目テーブルに存在しません。）</FONT></TD>
<%
								Exit Do
							End If

							'検体受付情報を読む
							strGetResult = ""
							If objResult.SelectRsl(strRsvNo, strItemCd(i), strSuffix(i), strGetResult) = False Then
%>
								<TD NOWRAP><INPUT TYPE="hidden" NAME="result" VALUE=""><FONT COLOR="#999999">（<%= strSubject %>依頼なし）</FONT></TD>
<%
								Exit Do
							End If

							'レコードが存在する場合、結果がチェック時の値と一致する場合はチェックする
							strChecked = IIf(strGetResult = strResultOn(i), "CHECKED", "")
%>
							<TD>
								<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
									<TR>
										<TD><INPUT TYPE="hidden" NAME="result" VALUE="<%= IIf(strChecked <> "", "1", "0") %>"><INPUT TYPE="checkbox" <%= strChecked %> ONCLICK="javascript:checkResult(this,<%= i %>)"></TD>
										<TD NOWRAP><%= strSubject %></TD>
									</TR>
								</TABLE>
							</TD>
<%
							blnExistsResult = True
							Exit Do
						Loop

					Next

					'依頼が存在する場合
					If blnExistsResult Then
%>
						<TD>&nbsp;&nbsp;<A HREF="javascript:saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="検体受付情報を保存する"></A></TD>
<%
					End If
%>
				</TR>
			</TABLE>
<%
		End If
%>
		<BR><BR>

		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="450">
			<TR>
				<TD><A HREF="javascript:callCancelReceiptWindow()"><IMG SRC="/webHains/images/cancelrsv.gif" WIDTH="77" HEIGHT="24" ALT="受付を取り消します"></A></TD>
				<TD WIDTH="100%"></TD>
				<TD><A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="読み込み画面に戻ります"></A></TD>
				<TD WIDTH="10"></TD>
				<TD>
<!--
					<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
						<TR>
							<TD>
								<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999">
									<TR>
<%
										'予約詳細画面のURL編集
										strURL = "/webHains/contents/reserve/rsvMain.asp"
										strURL = strURL & "?rsvNo=" & strRsvNo
%>
										<TD BGCOLOR="#eeeeee" NOWRAP></TD>
									</TR>
								</TABLE>
							</TD>

						</TR>
					</TABLE>
-->
					<A HREF="<%= strURL %>" TARGET="_blank" ALT="予約情報詳細画面を開きます"><IMG SRC="/webHains/images/torsv.gif" WIDTH="77" HEIGHT="24" ALT="予約情報へ"></A>
				</TD>
				<TD WIDTH="10"></TD>
				<TD>
<!--
					<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
						<TR>
-->
<!-- 2003.02.25 Updated by Ishihara@FSIT
							<TD NOWRAP><A HREF="javascript:printLabel('<%= strRsvNo %>')">検体ラベルを印刷</A></TD>
							<TD NOWRAP><A HREF="javascript:printCard('<%= strRsvNo %>','<%= strCslDate %>')">受診カードを印刷</A></TD>
							<TD NOWRAP><A HREF="javascript:printAll('<%= strRsvNo %>','<%= strCslDate %>')">検体ラベルと受診カードを印刷</A></TD>
-->
<!--
							<TD>
								<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999">
									<TR>
										<TD BGCOLOR="#eeeeee" NOWRAP><B><A HREF="javascript:printAll('<%= strRsvNo %>','<%= strCslDate %>')">ラベルとカードを印刷</A></B></TD>
									</TR>
								</TABLE>
							</TD>
						</TR>
					</TABLE>
-->
					<A HREF="javascript:printAll('<%= strRsvNo %>','<%= strCslDate %>')"><IMG SRC="/webHains/images/prtlabel.gif" WIDTH="110" HEIGHT="24" ALT="検体ラベルと受診カードを印刷します"></A>
				</TD>
			</TR>
		</TABLE>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>