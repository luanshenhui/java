<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求明細内訳登録・修正表示 (Ver0.0.1)
'		AUTHER  : T.Yaguchi@Orb
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------

Dim objCommon				'共通クラス
Dim objDemand				'請求情報アクセス用

Dim Ret						'関数戻り値

Dim lngCount				'取得件数
Dim lngCount2				'取得件数
Dim lngCount3				'取得件数
Dim lngRecord				'レコードカウンタ
Dim i						'ループカウンタ

'パラメータ
Dim strBillNo				'請求書番号
Dim strLineNo				'明細No.
Dim strItemNo				'内訳No.
Dim strSecondLineDivCd			'２次請求明細コード
Dim strSecondLineDivName		'２次請求明細名
Dim strRsvNo				'予約番号
Dim strDayId				'当日ID
Dim strLastName				'姓
Dim strFirstName			'名
Dim strLastKName			'カナ姓
Dim strFirstKName			'カナ名
Dim strDetailName			'名称
Dim lngPrice				'金額
Dim lngEditPrice			'調整金額
Dim lngTaxPrice				'税額
Dim lngEditTax				'調整税額
Dim strPerId				'個人ID
Dim strPerName				'氏名
Dim strOrgCd1				'団体コード１
Dim strOrgCd2				'団体コード２
Dim strGetCount				'前画面１ページ表示件数
Dim strStartPos				'前画面取得開始位置

Dim lngStrYear				'受診日（年）
Dim lngStrMonth				'受診日（月）
Dim lngStrDay				'受診日（日）
Dim strCslDate				'受信日

'請求書明細取得
Dim vntArrBillNo			'請求書番号
Dim vntArrLineNo			'明細No.
Dim vntArrCloseDate			'締め日
Dim vntArrBillSeq			'請求書Seq
Dim vntArrBranchno			'請求書枝番
Dim vntArrDayId				'当日ID
Dim vntArrRsvNo				'予約番号
Dim vntArrCslDate			'受診日
Dim vntArrDetailName		'名称
Dim vntArrPerId				'個人ID
Dim vntArrLastName			'姓
Dim vntArrFirstName			'名
Dim vntArrLastKName			'カナ姓
Dim vntArrFirstKName		'カナ名
Dim vntArrPrice				'金額
Dim vntArrEditPrice			'調整金額
Dim vntArrTaxPrice			'税額
Dim vntArrEditTax			'調整税額
Dim vntArrOrgCd1			'団体コード１
Dim vntArrOrgCd2			'団体コード２
Dim vntArrOrgName			'団体名
Dim vntArrOrgKName			'団体カナ名
Dim vntArrMethod			'作成方法
Dim vntArrSecondLineDivCd		'２次請求明細コード
Dim vntArrSecondLineDivName		'２次請求明細名
Dim vntArrItemNo			'内訳コード
Dim vntArrPaymentCnt		'入金件数
Dim vntArrDispatchCnt		'発送件数

Dim vntArrYMD				'締め日（/で分解後）

Dim strDivCd				'セット外請求明細コード
Dim strSetName				'対応セット名称
Dim strNoEditFlg			'修正不可フラグ

Dim strMode					'処理モード
Dim strAction				'動作モード(保存:"save"、保存完了:"saved"、削除："delete"、削除完了："deleted")
Dim strHTML
Dim strArrMessage	'エラーメッセージ

strArrMessage = ""
strNoEditFlg = 0
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求明細登録・修正</TITLE>
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->

<%
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")

'引数値の取得
strBillNo = Request("BillNo")
strLineNo = Request("LineNo")
strItemNo = Request("ItemNo")
strSecondLineDivCd = Request("secondLineDivCd")
strSecondLineDivName = Request("secondLineDivName")

lngStrYear     = CLng("0" & Request("strYear"))
lngStrMonth    = CLng("0" & Request("strMonth"))
lngStrDay      = CLng("0" & Request("strDay"))
'未設定時はシステム日付
If IsNull(strLineNo) Or strLineNo = "" Then
	lngStrYear    = IIf(lngStrYear  = 0, Year(Now),    lngStrYear )
	lngStrMonth   = IIf(lngStrMonth = 0, Month(Now),   lngStrMonth)
	lngStrDay     = IIf(lngStrDay   = 0, Day(Now),     lngStrDay  )
End If

'strCslDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
strCslDate = Request("cslDate")
strDayId = Request("DayId")
strRsvNo = Request("RsvNo")
strDetailName   = Request("DetailName")
strLastName = Request("LastName")
strFirstName = Request("FirstName")
strLastKName = Request("LastKName")
strFirstKName = Request("FirstKName")
lngPrice = Request("Price")
lngEditPrice = Request("EditPrice")
lngTaxPrice = Request("TaxPrice")
lngEditTax = Request("EditTax")
strPerId = Request("perId")
strOrgCd1 = Request("OrgCd1")
strOrgCd2 = Request("OrgCd2")

strGetCount = Request("getCount")
strStartPos = Request("startpos")

strAction      = Request("act")
strMode        = Request("mode")

'初期表示設定
If strMode = "" Then strMode = "init"
Do
	'請求書明細
	lngCount = objDemand.SelectDmdBurdenModifyBillDetail(strBillNo, _
														strLineNo, _
														"","", _
														vntArrBillNo, _
														vntArrLineNo, _
														vntArrCloseDate, _
														vntArrBillSeq, _
														vntArrBranchno, _
														vntArrDayId, _
														vntArrRsvNo, _
														vntArrCslDate, _
														vntArrDetailName, _
														vntArrPerId, _
														vntArrLastName, _
														vntArrFirstName, _
														vntArrLastKName, _
														vntArrFirstKName, _
														vntArrPrice, _
														vntArrEditPrice, _
														vntArrTaxPrice, _
														vntArrEditTax, _
														vntArrOrgCd1, _
														vntArrOrgCd2, _
														vntArrOrgName, _
														vntArrOrgKName,_
														vntArrMethod)

	'請求書明細内訳が存在しない場合
	If lngCount < 1 Then
		strArrMessage = Array("該当する請求書が存在しません")
		strAction = "Err"
		Exit Do
	End If

	'請求書明細内訳
	lngCount3 = 0
	If strItemNo <> "" Then
		lngCount3 = objDemand.SelectDmdDetailItmList(strBillNo, _
														strLineNo, strItemNo, _
														"","", _
														vntArrBillNo, _
														vntArrLineNo, _
														vntArrCloseDate, _
														vntArrBillSeq, _
														vntArrBranchno, _
														vntArrDayId, _
														vntArrRsvNo, _
														vntArrCslDate, _
														vntArrDetailName, _
														vntArrPerId, _
														vntArrLastName, _
														vntArrFirstName, _
														vntArrLastKName, _
														vntArrFirstKName, _
														vntArrPrice, _
														vntArrEditPrice, _
														vntArrTaxPrice, _
														vntArrEditTax, _
														vntArrOrgCd1, _
														vntArrOrgCd2, _
														vntArrOrgName, _
														vntArrOrgKName,_
														vntArrMethod,,vntArrItemNo,vntArrSecondLineDivCd,vntArrSecondLineDivName)
	End If

	If strMode = "init" Then
		'初期表示設定
		If lngStrYear = "0" Then
			vntArrYMD = split(vntArrCslDate(lngRecord),"/")
			For i=0 to UBound(vntArrYMD)
				Select Case i
				case 0
					lngStrYear = vntArrYMD(i)
				case 1
					lngStrMonth = vntArrYMD(i)
				case 2
					lngStrDay = vntArrYMD(i)
				End Select
			Next
		End If
		If strDetailName = "" Then strDetailName = vntArrDetailName(lngRecord)
		If lngCount3 > 0 Then
			If lngPrice = "" Then lngPrice = vntArrPrice(0)
			If lngTaxPrice = "" Then lngTaxPrice = vntArrTaxPrice(0)
			If lngEditPrice = "" Then lngEditPrice = vntArrEditPrice(0)
			If lngEditTax = "" Then lngEditTax = vntArrEditTax(0)
			If strSecondLineDivCd = "" Then strSecondLineDivCd = vntArrSecondLineDivCd(0)
			If strSecondLineDivName = "" Then strSecondLineDivName = vntArrSecondLineDivName(0)
		End If
		If strPerName = "" Then strPerName = vntArrLastName(lngRecord) & " " & vntArrFirstName(lngRecord)
		If strPerId = "" Then strPerId = vntArrPerId(lngRecord)
		If strDayId = "" Then strDayId = vntArrDayId(lngRecord)
		If strRsvNo = "" Then strRsvNo = vntArrRsvNo(lngRecord)
		If strOrgCd1 = "" Then strOrgCd1 = vntArrOrgCd1(lngRecord)
		If strOrgCd2 = "" Then strOrgCd2 = vntArrOrgCd2(lngRecord)
		strMode = "initend"
	End If

	If lngPrice = ""  OR IsNull(lngPrice) Then lngPrice = 0
	If lngEditPrice = "" OR IsNull(lngEditPrice) Then lngEditPrice = 0
	If lngTaxPrice = "" OR IsNull(lngTaxPrice) Then lngTaxPrice = 0
	If lngEditTax = "" OR IsNull(lngEditTax) Then lngEditTax = 0

	'入金済み、発送済みチェック
	lngCount2 = objDemand.SelectPaymentAndDispatchCnt(strBillNo, _
													vntArrPaymentCnt, _
													vntArrDispatchCnt)



	If vntArrPaymentCnt(0) > 0 Or vntArrDispatchCnt(0) > 0 Then
		strAction = "Err"
		strNoEditFlg = 1
		strArrMessage = Array("発送済みまたは入金済みのため、変更できません")
		Exit Do
	End If

	If vntArrBranchno(0) = "1" Then
		strAction = "Err"
		strNoEditFlg = 1
		strArrMessage = Array("取消済みのため、変更できません")
		Exit Do
	End If

	'確定ボタン押下時、保存処理実行
	If strAction = "save" Then

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		If strItemNo = "" Then
		'請求書明細の登録
		Ret = objDemand.InsertBillDetail_Items(strBillNo, _
										strLineNo, _
										strSecondLineDivCd, _
										lngPrice, _
										lngEditPrice, _
										lngTaxPrice, _
										lngEditTax)
		Else
		'請求書明細の更新
		Ret = objDemand.UpdateBillDetail_Items(strBillNo, _
										strLineNo, _
										strItemNo, _
										strSecondLineDivCd, _
										lngPrice, _
										lngEditPrice, _
										lngTaxPrice, _
										lngEditTax)
		End If

		'保存に失敗した場合
		If Ret <> True Then
			strArrMessage = Array("請求明細内訳の更新に失敗しました。")
'			Err.Raise 1000, , "請求明細内訳が更新できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
			Exit Do
		Else
			'エラーがなければ呼び元画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); location.href='dmdDetailItmList.asp?BillNo=" & strBillNo & "&LineNo=" & strLineNo & "&perId=" & strPerId & "&lastName=" & strLastName & "&firstName=" & strFirstName & "&cslDate=" & strCslDate & "'"">"
			strHTML = strHTML & "<BODY ONLOAD=""location.href='dmdDetailItmList.asp?BillNo=" & strBillNo & "&LineNo=" & strLineNo & "&perId=" & strPerId & "&lastName=" & strLastName & "&firstName=" & strFirstName & "&cslDate=" & strCslDate & "'"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If

	'削除ボタン押下時、削除処理実行
	If strAction = "delete" Then
		'請求書明細の登録
		Ret = objDemand.DeleteBillDetail_Items(strBillNo, strLineNo, strItemNo)
		'削除に失敗した場合
		If Ret <> True Then
			strArrMessage = Array("請求明細内訳の削除に失敗しました。")
			Exit Do
		Else
			'エラーがなければ呼び元画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""location.href='dmdDetailItmList.asp?BillNo=" & strBillNo & "&LineNo=" & strLineNo & "&perId=" & strPerId & "&lastName=" & strLastName & "&firstName=" & strFirstName & "&cslDate=" & strCslDate & "'"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If

	Exit Do
Loop


'-------------------------------------------------------------------------------
'
' 機能　　 : 請求書コメントの妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'共通クラス
	Dim vntArrMessage	'エラーメッセージの集合

	'共通クラスのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'各値チェック処理
	With objCommon
		'請求書コメントチェック
		If strSecondLineDivCd = "" Then 
			.AppendArray vntArrMessage, "請求詳細名が入力されていません。"
		End If
		If IsNumeric(lngPrice) Then lngPrice = CDbl(lngPrice)
		If IsNumeric(lngEditPrice) Then lngEditPrice = CDbl(lngEditPrice)
		If IsNumeric(lngTaxPrice) Then lngTaxPrice = CDbl(lngTaxPrice)
		If IsNumeric(lngEditTax) Then lngEditTax = CDbl(lngEditTax)
		.AppendArray vntArrMessage, .CheckNumericWithSign("請求金額", lngPrice, 7)
		.AppendArray vntArrMessage, .CheckNumericWithSign("調整金額", lngEditPrice, 7)
		.AppendArray vntArrMessage, .CheckNumericWithSign("消費税", lngTaxPrice, 7)
		.AppendArray vntArrMessage, .CheckNumericWithSign("調整税額", lngEditTax, 7)
	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function


%>
<!--
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>請求明細内訳登録・修正</TITLE>
-->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/secondLineDivGuide.inc"    -->
<!--

function closeGuide(){
	// カレンダーガイドを閉じる
	if ( winGuideCalendar ) {
		if ( !winGuideCalendar.closed ) {
			winGuideCalendar.close();
		}
	}

	// 個人検索ガイドを閉じる
	if ( winGuidePersonal ) {
		if ( !winGuidePersonal.closed ) {
			winGuidePersonal.close();
		}
	}
}

//保存
function saveData() {

	// モードを指定してsubmit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}

//削除
function deleteData(){
	// モードを指定してsubmit
	var rt = confirm('この明細内訳を削除してもよろしいですか？');
	if(rt == true){
		document.entryForm.act.value = 'delete';
		document.entryForm.submit();
	}
}

// 文章ガイド呼び出し
function callSecondLineDivGuide() {

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	secondLineDivGuide_CalledFunction = setSecondLineDivInfo;

	// 文章ガイド表示
	showGuideSecondLineDiv();
}

// 文章コード・略文章のセット
function setSecondLineDivInfo() {

	setSecondLineDiv( secondLineDivGuide_SecondLineDivCd, secondLineDivGuide_SecondLineDivName , secondLineDivGuide_stdPrice , secondLineDivGuide_stdTax );

}

// ２次請求明細の編集
function setSecondLineDiv( secondLineDivCd, secondLineDivName , stdPrice , stdTax ) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var objSecondLineDivCd, objSecondLineDivName;		// 結果・文章のエレメント
	var objstdPrice, objstdTax;						// 標準単価・標準税額のエレメント
	var secondLineDivNameElement;					// 文章のエレメント

	// 編集エレメントの設定
	objSecondLineDivCd   = myForm.secondLineDivCd;
	objSecondLineDivName = myForm.secondLineDivName;
	objstdPrice = myForm.Price;
	objstdTax = myForm.TaxPrice;

	secondLineDivNameElement = 'secondLineDivName';

	// 値の編集
	objSecondLineDivCd.value   = secondLineDivCd;
	document.getElementById(secondLineDivNameElement).innerHTML = secondLineDivName;
	objstdPrice.value   = stdPrice;
	objstdTax.value   = stdTax;

	if ( document.getElementById(secondLineDivNameElement) ) {
		document.getElementById(secondLineDivNameElement).innerHTML = secondLineDivName;
	}

}

function secondLineDivGuide_clearPerInfo() {
	var myForm = document.entryForm;	// 自画面のフォームエレメント

	// 編集エレメントの設定
	myForm.secondLineDivCd.value = '';
	document.getElementById('secondLineDivName').innerHTML = '';

}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 20px 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeGuide();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>請求明細内訳登録・修正</B></TD>
		</TR>
	</TABLE>
	<!-- 引数情報 -->
	<INPUT TYPE="hidden" NAME="act" VALUE="">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<INPUT TYPE="hidden" NAME="record" VALUE="<%= lngRecord %>">
	<INPUT TYPE="hidden" NAME="divcd" VALUE="<%= strDivCd %>">
	<INPUT TYPE="hidden" NAME="setname" VALUE="<%= strSetName %>">
	<INPUT TYPE="hidden" NAME="BillNo" VALUE="<%= strBillNo%>">
	<INPUT TYPE="hidden" NAME="LineNo" VALUE="<%= strLineNo%>">
	<INPUT TYPE="hidden" NAME="ItemNo" VALUE="<%= strItemNo%>">
	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId%>">
	<INPUT TYPE="hidden" NAME="lastName" VALUE="<%= strLastName%>">
	<INPUT TYPE="hidden" NAME="firstName" VALUE="<%= strFirstName%>">
	<INPUT TYPE="hidden" NAME="cslDate" VALUE="<%= strCslDate%>">
	<INPUT TYPE="hidden" NAME="OrgCd1" VALUE="<%= strOrgCd1%>">
	<INPUT TYPE="hidden" NAME="OrgCd2" VALUE="<%= strOrgCd2%>">
	<INPUT TYPE="hidden" NAME="getCount" VALUE="<%= strGetCount%>">
	<INPUT TYPE="hidden" NAME="startpos" VALUE="<%= strStartPos%>">
	<BR>
<%
'メッセージの編集
	'メッセージの編集
	If strAction <> "" Then
		Select Case strAction

			'保存完了時は「保存完了」の通知
			Case "saveend"
				Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

			'削除完了時は「削除完了」の通知
			Case "deleteend"
				Call EditMessage("削除が完了しました。", MESSAGETYPE_NORMAL)

			'さもなくばエラーメッセージを編集
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
				If lngCount = 0 Then
				Response.End
				End If
		End Select

	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD NOWRAP>団体名</TD>
			<TD>：</TD>
			<TD NOWRAP><%= vntArrOrgName(lngRecord) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD>
				<TABLE>
					<TR>
						<TD><%= objCommon.FormatString(strCslDate, "yyyy年mm月dd日") %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>請求明細内訳名</TD>
			<TD>：</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<A HREF="javascript:callSecondLineDivGuide()">
								<IMG SRC="/webHains/images/question.gif" ALT="２次請求内訳ガイドを表示" HEIGHT="21" WIDTH="21">
							</A>
							<A HREF="javascript:secondLineDivGuide_clearPerInfo();">
								<IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21">
							</A>
						</TD>
						<TD>
							<INPUT TYPE="hidden" NAME="secondLineDivCd" VALUE="<%= strSecondLineDivCd %>">
							<!--<INPUT TYPE="hidden" NAME="secondLineDivName" VALUE="<%= strSecondLineDivName %>">-->
							<SPAN ID="secondLineDivName"><%= strSecondLineDivName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>請求金額</TD>
			<TD>：</TD>
			<TD NOWRAP>
				<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
					<INPUT TYPE="text" NAME="Price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="8">
				<%Else%>
					<%= FormatCurrency(lngPrice) %>
					<INPUT TYPE="hidden" NAME="Price" VALUE="<%= lngPrice%>">
				<%End If%>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>調整金額</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="EditPrice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="8"></TD>
		</TR>
		<TR>
			<TD NOWRAP>消費税</TD>
			<TD>：</TD>
			<TD NOWRAP>
				<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
					<INPUT TYPE="text" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="8">
				<%Else%>
					<%= FormatCurrency(lngTaxPrice) %>
					<INPUT TYPE="hidden" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>">
				<%End If%>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>調整税額</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="EditTax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="8"></TD>
		</TR>
	</TABLE>
	<BR>
<%If strItemNo <> "" Then%>
	<%If strNoEditFlg = 0 Then%>
	<A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="明細を削除します。"></A>
	<%End If%>
<%End If%>
<%If strNoEditFlg = 0 Then%>
	<A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で確定"></A>
<%End If%>
	<A HREF="javascript:location.href='dmdDetailItmList.asp?BillNo=<%=strBillNo%>&LineNo=<%=strLineNo%>&perId=<%=strPerId%>&lastName=<%=strLastName%>&firstName=<%=strFirstName%>&cslDate=<%=strCslDate%>';"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
</FORM>
</BODY>
</HTML>
