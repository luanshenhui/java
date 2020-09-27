<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(負担元・負担金額の設定) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_SAVE           = "save"		'処理モード（保存）
Const MODE_CHANGEROW      = "change"	'処理モード（表示行数変更）
Const DEFAULT_ROW         = 10			'負担元のデフォルト表示行数
Const INCREASE_COUNT      =  5			'表示負担元の増分単位
Const LENGTH_PRICE        =  7			'負担金額の項目長

'メッセージの編集
Const MESSAGE_DELETEORG        = "セット料金負担を行う団体は削除できません。"
Const MESSAGE_DELETEPRICE      = "削除項目負担を行う団体の負担金額は必ず指定する必要があります。"
Const MESSAGE_DELETELIMITPRICE = "限度額負担の設定が行われている負担元は削除できません。"

'データベースアクセス用オブジェクト
Dim objContract			'契約情報アクセス用
Dim objContractControl	'契約情報アクセス用
Dim objCourse			'コース情報アクセス用
Dim objOrganization		'団体情報アクセス用

'引数値
Dim strMode				'処理モード
Dim strCtrPtCd			'契約パターンコード
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strCsCd				'コースコード
Dim strStrYear			'契約開始年
Dim strStrMonth 		'契約開始月
Dim strStrDay			'契約開始日
Dim strEndYear			'契約終了年
Dim strEndMonth 		'契約終了月
Dim strEndDay			'契約終了日
Dim strApDiv			'適用元区分の配列
Dim strSeq				'SEQの配列
Dim strBdnOrgCd1		'団体コード1の配列
Dim strBdnOrgCd2		'団体コード2の配列
Dim strArrOrgName		'団体名称の配列
Dim strPrice			'負担金額の配列
Dim strTaxFlg			'消費税負担フラグの配列
Dim strOptBurden		'オプション負担対象フラグの配列
Dim strLimitPriceFlg	'限度額負担フラグの配列
Dim lngCount			'負担情報数
Dim lngRow				'表示行数

'契約管理情報
Dim strOrgName			'団体名
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日

Dim strArrRetOrgName	'団体名称
Dim strMessage			'エラーメッセージ
Dim strStrDate			'編集用の契約開始日
Dim strEndDate			'編集用の契約終了日
Dim strHTML				'HTML編集用
Dim Ret					'関数戻り値
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strMode          = Request("mode")
strCtrPtCd       = Request("ctrPtCd")
strOrgCd1        = Request("orgCd1")
strOrgCd2        = Request("orgCd2")
strCsCd          = Request("csCd")
strStrYear       = Request("strYear")
strStrMonth      = Request("strMonth")
strStrDay        = Request("strDay")
strEndYear       = Request("endYear")
strEndMonth      = Request("endMonth")
strEndDay        = Request("endDay")
strApDiv         = ConvIStringToArray(Request("apDiv"))
strSeq           = ConvIStringToArray(Request("seq"))
strBdnOrgCd1     = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2     = ConvIStringToArray(Request("bdnOrgCd2"))
strArrOrgName    = ConvIStringToArray(Request("orgName"))
strPrice         = ConvIStringToArray(Request("price"))
strTaxFlg        = ConvIStringToArray(Request("taxFlg"))
strOptBurden     = ConvIStringToArray(Request("optBurden"))
strLimitPriceFlg = ConvIStringToArray(Request("limitPriceFlg"))
lngRow           = CLng("0" & Request("row"))

'負担情報数の設定
If Not IsEmpty(strApDiv) Then
	lngCount = UBound(strApDiv) + 1
End If

'表示行数の設定
lngRow = IIf(lngRow = 0, DEFAULT_ROW, lngRow)

'更新モードごとの処理制御
Select Case strMode

	'保存
	Case MODE_SAVE

		'入力チェック
		strMessage = CheckValue()
		If IsEmpty(strMessage) Then

			'契約パターンコード未指定時(即ち新規登録時)
			If strCtrPtCd = "" Then

				'契約情報の挿入
				Ret = objContractControl.InsertContract(strOrgCd1, strOrgCd2, strCsCd, strStrYear, strStrMonth, strStrDay, strEndYear, strEndMonth, strEndDay, strSeq, strApdiv, strBdnOrgCd1, strBdnOrgCd2, strPrice, strTaxFlg)

				'既存の契約情報と契約期間が存在する場合はメッセージを編集する
				If Ret = 0 Then
					strMessage = Array("すでに登録済みの契約情報と契約期間が重複するため、登録できません。")
				End If

			'契約パターンコード指定時(即ち更新時)
			Else

				'契約情報の更新
				Ret = objContractControl.UpdateContract(strOrgCd1, strOrgCd2, strCtrPtCd, strSeq, strApdiv, strBdnOrgCd1, strBdnOrgCd2, strPrice, strTaxFlg, strArrRetOrgName)

				'戻り値の判定
				Select Case Ret
					Case 0
					Case 1
						strMessage = Array(MESSAGE_DELETEORG)
					Case 2
						strMessage = Array(MESSAGE_DELETEPRICE)
					Case 3
						'この契約を参照している団体が負担元として追加されエラーとなった場合、その団体名をすべて編集
						strMessage = Array()
						Redim Preserve strMessage(UBound(strArrRetOrgName))
						For i = 0 To UBound(strArrRetOrgName)
							strMessage(i) = "負担元「" & strArrRetOrgName(i) & "」は現在この契約情報を参照しています。登録できません。"
						Next
					Case 4
						strMessage = Array("受診情報で参照されている負担元を削除しようとしました。削除できません。")
					Case 5
						strMessage = Array(MESSAGE_DELETELIMITPRICE)
					Case Else
						strMessage = Array("その他のエラーが発生しました。")
				End Select

			End If

			'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
			If IsEmpty(strMessage) Then
				strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
				strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
				strHTML = strHTML & "</BODY>"
				strHTML = strHTML & "</HTML>"
				Response.Write strHTML
				Response.End
			End If

		End If

	'表示行数変更
	Case MODE_CHANGEROW

	Case Else

		'契約パターンコード指定時(即ち更新時)
		If strCtrPtCd <> "" Then

			'契約パターン負担金額管理情報を読み込む
			lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, , , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, , , , strTaxFlg, , , strOptBurden, , , strLimitPriceFlg)

		End If

		lngRow = IIf(lngCount > DEFAULT_ROW, Int((lngCount + INCREASE_COUNT - 1) / INCREASE_COUNT) * INCREASE_COUNT, DEFAULT_ROW)

End Select

'契約パターンコード指定時(即ち更新時)
If strCtrPtCd <> "" Then

	'契約管理情報を読み、団体・コースの名称及び契約期間を取得する
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If


'契約パターンコード未指定時(即ち新規登録時)
Else

	'団体名の読み込み
	If objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName) = False Then
		Err.Raise 1000, , "団体情報が存在しません。"
	End If

	'コース名の読み込み
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "コース情報が存在しません。"
	End If

	'契約開始年月日の取得
	dtmStrDate = CDate(strStrYear & "/" & strStrMonth & "/" & strStrDay)

	'契約終了年月日の取得
	If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then
		dtmEndDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
	End If

End If

'負担情報配列の制御
Call ControlDemandArray()

'-------------------------------------------------------------------------------
'
' 機能　　 : 負担金額情報の配列を制御する
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub ControlDemandArray()

	Dim lngSeq	'SEQ

	'負担情報が存在しない場合（初期表示時）は新規配列の作成
	If IsEmpty(strApDiv) Then
		Call CreateDemandArray()
	End If

	'配列の要素数が表示行数に満たない場合
	If lngCount < lngRow Then

		'現負担金額情報の最終情報をもとに、次に発番するSEQ値を取得する
		If lngCount > 0 Then
			lngSeq = CLng(strSeq(lngCount - 1)) + 1
		Else
			lngSeq = 1
		End If

		'表示行数に達するまで配列の拡張を行う
		Do Until lngCount >= lngRow
			Call AppendDemandArray(APDIV_ORG, lngSeq, "", "", "")
			lngSeq = lngSeq + 1
		Loop

	'配列の要素数が表示行数以上の場合
	Else

		'要素数が表示行数に等しくなるよう、配列の再定義を行う
		Call ReDimDemandArray(lngRow)

	End If

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 負担金額情報の配列を作成する
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : 新規負担情報として個人負担・契約団体負担の負担情報を作成
' 　　　　   ただし個人受診・web予約の場合、契約団体は必要ない
'
'-------------------------------------------------------------------------------
Sub CreateDemandArray()

	Dim objCommon		'共通クラス

	Dim strPerOrgCd1	'（個人受診）団体コード１
	Dim strPerOrgCd2	'（個人受診）団体コード２
	Dim strWebOrgCd1	'（Ｗｅｂ予約）団体コード１
	Dim strWebOrgCd2	'（Ｗｅｂ予約）団体コード２

	'共通クラスのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'個人受診、Web予約用の団体コード取得
	objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
	objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2

	'新しく配列を作成する
	strApDiv         = Array()
	strSeq           = Array()
	strBdnOrgCd1     = Array()
	strBdnOrgCd2     = Array()
	strArrOrgName    = Array()
	strPrice         = Array()
	strTaxFlg        = Array()
	strOptBurden     = Array()
	strLimitPriceFlg = Array()
	lngCount = 0

	'個人受診・Web予約の場合
	If (strOrgCd1 = strPerOrgCd1 And strOrgCd2 = strPerOrgCd2) Or (strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2) Then

		'自団体用の要素を追加
		Call AppendDemandArray(APDIV_MYORG, 2, "", "", "個人負担")

	'契約団体の場合
	Else

		'個人用・契約団体用の要素を追加
		Call AppendDemandArray(APDIV_PERSON, 1, strPerOrgCd1, strPerOrgCd2, "個人負担")
		Call AppendDemandArray(APDIV_MYORG, 2, "", "", "契約団体負担")

	End If

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 負担情報配列の要素追加
'
' 引数　　 : (In)     lngAddApDiv    適用元区分
' 　　　　   (In)     lngAddSeq      SEQ
' 　　　　   (In)     strAddOrgCd1   団体コード１
' 　　　　   (In)     strAddOrgCd2   団体コード２
' 　　　　   (In)     strAddOrgName  団体名称
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub AppendDemandArray(lngAddApDiv, lngAddSeq, strAddOrgCd1, strAddOrgCd2, strAddOrgName)

	'配列の拡張
	Call ReDimDemandArray(lngCount + 1)

	'初期値の編集
	strApDiv(lngCount - 1)         = CStr(lngAddApDiv)
	strSeq(lngCount - 1)           = CStr(lngAddSeq)
	strBdnOrgCd1(lngCount - 1)     = strAddOrgCd1
	strBdnOrgCd2(lngCount - 1)     = strAddOrgCd2
	strArrOrgName(lngCount - 1)    = strAddOrgName
	strPrice(lngCount - 1)         = "0"
	strTaxFlg(lngCount - 1)        = "0"
	strOptBurden(lngCount - 1)     = "0"
	strLimitPriceFlg(lngCount - 1) = ""

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 負担情報配列の再定義
'
' 引数　　 : (In)     lngElementCount  配列の要素数
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub ReDimDemandArray(lngElementCount)

	'配列の再定義
	ReDim Preserve strApDiv(lngElementCount - 1)
	ReDim Preserve strSeq(lngElementCount - 1)
	ReDim Preserve strBdnOrgCd1(lngElementCount - 1)
	ReDim Preserve strBdnOrgCd2(lngElementCount - 1)
	ReDim Preserve strArrOrgName(lngElementCount - 1)
	ReDim Preserve strPrice(lngElementCount - 1)
	ReDim Preserve strTaxFlg(lngElementCount - 1)
	ReDim Preserve strOptBurden(lngElementCount - 1)
	ReDim Preserve strLimitPriceFlg(lngElementCount - 1)

	'配列の要素数を取得
	lngCount = UBound(strApDiv) + 1

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 入力チェック
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'共通クラス

	Dim strPerOrgCd1	'個人受診用団体コード１
	Dim strPerOrgCd2	'個人受診用団体コード２

	Dim strArrMessage	'エラーメッセージの配列
	Dim strMessage		'エラーメッセージ

	Dim blnError1		'エラーフラグ
	Dim blnError2		'エラーフラグ
	Dim i, j			'インデックス

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	blnError1 = False
	blnError2 = False

	'個人受診用団体コードの取得
	objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2

	'個人受診管理用の団体が指定されていないかを検索
	For i = 0 To lngCount - 1
		If CLng(strApDiv(i)) <> APDIV_PERSON And strBdnOrgCd1(i) = strPerOrgCd1 And strBdnOrgCd2(i) = strPerOrgCd2 Then
			objCommon.AppendArray strArrMessage, "個人受診用の団体コードを指定することはできません。"
			Exit For
		End If
	Next

	'自社が指定されていないかを検索
	For i = 0 To lngCount - 1
		If strBdnOrgCd1(i) = strOrgCd1 And strBdnOrgCd2(i) = strOrgCd2 Then
			objCommon.AppendArray strArrMessage, "契約団体自身の団体コードを指定することはできません。"
			Exit For
		End If
	Next

	'団体重複チェック
	For i = 0 To lngCount - 1
		j = 0
		Do Until j >= i
			If strBdnOrgCd1(j) & strBdnOrgCd2(j) <> "" Then
				If strBdnOrgCd1(j) = strBdnOrgCd1(i) And strBdnOrgCd2(j) = strBdnOrgCd2(i) Then
					objCommon.AppendArray strArrMessage, "同一団体を複数指定することはできません。"
					Exit For
				End If
			End If
			j = j + 1
		Loop
	Next

	'セット料金負担を行う負担元は削除できない
	For i = 0 To lngCount - 1
		If CLng(strApDiv(i)) = APDIV_ORG And strBdnOrgCd1(i) = "" And strBdnOrgCd2(i) = "" Then
			If strOptBurden(i) <> "0" Or strTaxFlg(i) <> "0" Then
				objCommon.AppendArray strArrMessage, MESSAGE_DELETEORG
				Exit For
			End If
		End If
	Next

	'限度額設定にて使用されている負担元は削除できない
	For i = 0 To lngCount - 1
		If CLng(strApDiv(i)) = APDIV_ORG And strBdnOrgCd1(i) = "" And strBdnOrgCd2(i) = "" Then
			If strLimitPriceFlg(i) <> "" Then
				objCommon.AppendArray strArrMessage, MESSAGE_DELETELIMITPRICE
				Exit For
			End If
		End If
	Next

	'負担情報のSEQ値チェック
	For i = 0 To lngCount - 1
		If strBdnOrgCd1(i) <> "" Or strBdnOrgCd2(i) <> "" Then
			If CLng(strSeq(i)) > 99 Then
				objCommon.AppendArray strArrMessage, "負担情報のシーケンス値が最大数を超えました。"
				Exit For
			End If
		End If
	Next

	'チェック結果を返す
	CheckValue = strArrMessage

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>負担元の設定</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var lngSelectedIndex;	// ガイド表示時に選択された負担情報のインデックス

// 団体名称および負担金額総計の編集
function setValue() {

	// すべての団体名称を編集する
	for ( var i = 0; i < document.entryForm.orgName.length; i++ ) {
		if ( document.getElementById('orgName' + i) ) {
			document.getElementById('orgName' + i).innerHTML = document.entryForm.orgName[ i ].value;
		}
	}

}

// 団体ガイド呼び出し
function callOrgGuide( index ) {

	// 選択されたガイドのインデックスを保持
	lngSelectedIndex = index;

	orgGuide_showGuideOrg(document.entryForm.bdnOrgCd1[ index ], document.entryForm.bdnOrgCd2[ index ], 'orgName' + index, '', '', setOrgName);

}

// hiddenタグの団体名編集
function setOrgName() {

	document.entryForm.orgName[ lngSelectedIndex ].value = orgGuide_OrgName.innerHTML;

}

// 団体の削除
function deleteOrgInfo( index ) {

	orgGuide_clearOrgInfo( document.entryForm.bdnOrgCd1[index], document.entryForm.bdnOrgCd2[index], 'orgName' + index );

	document.entryForm.orgName[index].value = '';

}

// submit時の処理
function submitForm( mode ) {

	// 処理モードを指定してsubmit
	document.entryForm.mode.value = mode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
	td.mnttab { background-color:#FFFFFF }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:setValue()" ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode"     VALUE="">
	<INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2 %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd %>">
	<INPUT TYPE="hidden" NAME="strYear"  VALUE="<%= strStrYear  %>">
	<INPUT TYPE="hidden" NAME="strMonth" VALUE="<%= strStrMonth %>">
	<INPUT TYPE="hidden" NAME="strDay"   VALUE="<%= strStrDay   %>">
	<INPUT TYPE="hidden" NAME="endYear"  VALUE="<%= strEndYear  %>">
	<INPUT TYPE="hidden" NAME="endMonth" VALUE="<%= strEndMonth %>">
	<INPUT TYPE="hidden" NAME="endDay"   VALUE="<%= strEndDay   %>">
	<INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd     %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">負担元の設定</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	'編集用の契約開始日設定
	If Not IsEmpty(dtmStrDate) Then
		strStrDate = FormatDateTime(dtmStrDate, 1)
	End If

	'編集用の契約終了日設定
	If Not IsEmpty(dtmEndDate) Then
		strEndDate = FormatDateTime(dtmEndDate, 1)
	End If
%>
	<BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" NOWRAP>対象コース</TD>
			<TD>：</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD>契約期間</TD>
			<TD>：</TD>
			<TD><B><%= strStrDate %>～<%= strEndDate %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR BGCOLOR="#eeeeee">
			<TD>負担元</TD>
			<TD ALIGN="center">セット負担</TD>
			<TD ALIGN="center">限度額設定</TD>
		</TR>
<%
		For i = 0 To UBound(strApDiv)
%>
			<TR>
				<TD HEIGHT="24">
					<INPUT TYPE="hidden" NAME="apDiv"         VALUE="<%= strApDiv(i)         %>">
					<INPUT TYPE="hidden" NAME="seq"           VALUE="<%= strSeq(i)           %>">
					<INPUT TYPE="hidden" NAME="bdnOrgCd1"     VALUE="<%= strBdnOrgCd1(i)     %>">
					<INPUT TYPE="hidden" NAME="bdnOrgCd2"     VALUE="<%= strBdnOrgCd2(i)     %>">
					<INPUT TYPE="hidden" NAME="orgName"       VALUE="<%= strArrOrgName(i)    %>">
					<INPUT TYPE="hidden" NAME="price"         VALUE="<%= strPrice(i)         %>">
					<INPUT TYPE="hidden" NAME="taxFlg"        VALUE="<%= strTaxFlg(i)        %>">
					<INPUT TYPE="hidden" NAME="optBurden"     VALUE="<%= strOptBurden(i)     %>">
					<INPUT TYPE="hidden" NAME="limitPriceFlg" VALUE="<%= strLimitPriceFlg(i) %>">
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
<%
							'適用元区分ごとの団体名称編集処理制御
							Select Case CLng(strApDiv(i))

								'個人負担の場合は名称のみ編集
								Case APDIV_PERSON
%>
									<TD><%= strArrOrgName(i) %></TD>
<%
								'自社負担の場合は自団体名称のみ編集
								Case APDIV_MYORG
%>
									<TD><%= strOrgName %></TD>
<%
								'それ以外はガイドボタン・団体コード・団体名を編集
								Case Else
%>
									<TD><A HREF="JavaScript:callOrgGuide(<%= CStr(i) %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体ガイド表示"></A></TD>
<%
									'セット料金負担を行わない、かつ限度額設定が行われていない負担元のみ削除可能とする
									If strOptBurden(i) = "0" And strLimitPriceFlg(i) = "" Then
%>
										<TD><A HREF="JavaScript:deleteOrgInfo(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="削除"></A></TD>
<%
									Else
%>
										<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
<%
									End If
%>
									<TD WIDTH="250"><SPAN ID="orgName<%= i %>" STYLE="position:relative"><%= strArrOrgName(i) %></SPAN></TD>
<%
							End Select
%>
						</TR>
					</TABLE>
				</TD>
				<TD ALIGN="center"><%= IIf(strOptBurden(i)     <> "0", "○", "") %></TD>
				<TD ALIGN="center"><%= IIf(strLimitPriceFlg(i) <> "",  "○", "") %></TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD HEIGHT="1" BGCOLOR="#999999" COLSPAN="8"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
		</TR>
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
					<TR>
						<TD>負担元の入力行数を指定：</TD>
						<TD>
							<SELECT NAME="row">
<%
								'負担元入力行数選択リストの編集
								i = DEFAULT_ROW
								Do

									'現在の負担元数以上の行数を選択可能とする
									If i >= lngCount Then
%>
										<OPTION VALUE="<%= i %>" <%= IIf(i = lngRow, "SELECTED", "") %>><%= i %>行
<%
									End If

									'編集行数が表示行数を超えた場合は処理を終了する
									If i > lngRow Then
										Exit Do
									End If

									i = i + INCREASE_COUNT

									'理論上の最大数は100なのでそれを超えれば終了
									If i > 100 Then
										Exit Do
									End If

								Loop
%>
							</SELECT>
						</TD>
						<TD><A HREF="javascript:submitForm('<%= MODE_CHANGEROW %>')"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR><BR>
<%
	'更新時は「キャンセル」「保存」ボタンを、新規時は「戻る」「次へ」ボタンをそれぞれ用意する
	If strCtrPtCd <> "" Then
%>
		<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
<%
	Else
%>
		<A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
<%
	End If
%>
	<% '2005.08.22 権限管理 Add by 李　--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	    <A HREF="javascript:submitForm('<%= MODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 権限管理 Add by 李　--- END %>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
