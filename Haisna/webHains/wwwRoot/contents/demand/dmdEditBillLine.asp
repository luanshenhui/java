<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求明細登録・修正表示 (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
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
Dim lngRecord				'レコードカウンタ
Dim i						'ループカウンタ

'パラメータ
Dim strBillNo				'請求書番号
Dim strLineNo				'明細No.
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
Dim vntArrPaymentCnt		'入金件数
Dim vntArrDispatchCnt		'発送件数
'2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
Dim vntArrSecondFlg			'２次検査フラグ
Dim strSumPrice				'金額合計
Dim strSumEditPrice			'調整金額合計
Dim strSumTaxPrice			'税額合計
Dim strSumEditTax			'調整税額合計
Dim strSumPriceTotal			'総合計
Dim lngSumPrice				'金額合計
Dim lngSumEditPrice			'調整金額合計
Dim lngSumTaxPrice			'税額合計
Dim lngSumEditTax			'調整税額合計
Dim lngSumPriceTotal			'総合計
Dim lngSumRecord			'レコード数
'2004.06.02 ADD END

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

lngStrYear     = CLng("0" & Request("strYear"))
lngStrMonth    = CLng("0" & Request("strMonth"))
lngStrDay      = CLng("0" & Request("strDay"))
'未設定時はシステム日付
If IsNull(strLineNo) Or strLineNo = "" Then
	lngStrYear    = IIf(lngStrYear  = 0, Year(Now),    lngStrYear )
	lngStrMonth   = IIf(lngStrMonth = 0, Month(Now),   lngStrMonth)
	lngStrDay     = IIf(lngStrDay   = 0, Day(Now),     lngStrDay  )
End If

strCslDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
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
'2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加
'	'請求書明細
'	lngCount = objDemand.SelectDmdBurdenModifyBillDetail(strBillNo, _
'														strLineNo, _
'														"","", _
'														vntArrBillNo, _
'														vntArrLineNo, _
'														vntArrCloseDate, _
'														vntArrBillSeq, _
'														vntArrBranchno, _
'														vntArrDayId, _
'														vntArrRsvNo, _
'														vntArrCslDate, _
'														vntArrDetailName, _
'														vntArrPerId, _
'														vntArrLastName, _
'														vntArrFirstName, _
'														vntArrLastKName, _
'														vntArrFirstKName, _
'														vntArrPrice, _
'														vntArrEditPrice, _
'														vntArrTaxPrice, _
'														vntArrEditTax, _
'														vntArrOrgCd1, _
'														vntArrOrgCd2, _
'														vntArrOrgName, _
'														vntArrOrgKName,_
'														vntArrMethod)
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
														vntArrMethod,, _
														vntArrSecondFlg)
	'２次検査合計金額の追加
	lngSumRecord = objDemand.SelectSumDetailItems(strBillNo,, _
							strSumPrice, _
							strSumEditPrice, _
							strSumTaxPrice, _
							strSumEditTax, _
							strSumPriceTotal)
	If lngSumRecord > 0 Then
		If strSumPrice(0) = ""  OR IsNull(strSumPrice(0)) Then
		 	lngSumPrice = 0
		Else
		 	lngSumPrice = strSumPrice(0)
		End If
		If strSumEditPrice(0) = ""  OR IsNull(strSumEditPrice(0)) Then
			lngSumEditPrice = 0
		Else
			lngSumEditPrice = strSumEditPrice(0)
		End if
		If strSumTaxPrice(0) = ""  OR IsNull(strSumTaxPrice(0)) Then
			lngSumTaxPrice = 0
		Else
			lngSumTaxPrice = strSumTaxPrice(0)
		End if
		If strSumEditTax(0) = ""  OR IsNull(strSumEditTax(0)) Then
			lngSumEditTax = 0
		Else
			lngSumEditTax = strSumEditTax(0)
		End if
	Else
	 	lngSumPrice = 0
		lngSumEditPrice = 0
		lngSumTaxPrice = 0
		lngSumEditTax = 0
	End If
'2004.06.02 MOD END

	'請求書明細が存在しない場合
	If lngCount < 1 Then
		strArrMessage = Array("該当する請求書が存在しません")
		strAction = "Err"
		Exit Do
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
		If lngPrice = "" Then lngPrice = vntArrPrice(lngRecord)
		If lngTaxPrice = "" Then lngTaxPrice = vntArrTaxPrice(lngRecord)
		If lngEditPrice = "" Then lngEditPrice = vntArrEditPrice(lngRecord)
		If lngEditTax = "" Then lngEditTax = vntArrEditTax(lngRecord)
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

		If strLineNo = "" Then
		'請求書明細の登録
		Ret = objDemand.InsertBillDetail(strBillNo, _
										strCslDate, _
										strRsvNo, _
										strDayId, _
										strDetailName, _
										strPerId, _
										lngPrice, _
										lngEditPrice, _
										lngTaxPrice, _
										lngEditTax)
		Else
		'請求書明細の更新
		Ret = objDemand.UpdateBillDetail(strBillNo, _
										strLineNo, _
										strCslDate, _
										strDetailName, _
										strPerId, _
										lngPrice, _
										lngEditPrice, _
										lngTaxPrice, _
										lngEditTax, _
										strRsvNo, _
										strDayId)
		End If

		'保存に失敗した場合
		If Ret <> True Then
			strArrMessage = Array("請求明細の更新に失敗しました。")
'			Err.Raise 1000, , "請求明細が更新できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
			Exit Do
		Else
			'エラーがなければ呼び元画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); location.href='dmdBurdenModify.asp?BillNo=" & strBillNo & "'"">"
			strHTML = strHTML & "<BODY ONLOAD=""location.href='dmdBurdenModify.asp?BillNo=" & strBillNo & "&getCount=" & strGetCount & "&startpos=" & strStartPos & "'"">"
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
		Ret = objDemand.DeleteBillDetail(strBillNo, strLineNo, strRsvNo, strOrgCd1, strOrgCd2)
		'削除に失敗した場合
		If Ret <> True Then
			strArrMessage = Array("請求明細の削除に失敗しました。")
			Exit Do
		Else
			'エラーがなければ呼び元画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""location.href='dmdBurdenModify.asp?BillNo=" & strBillNo & "&getCount=" & strGetCount & "'"">"
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
	Dim strYMD			'受診日戻り値

	'共通クラスのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'各値チェック処理
	With objCommon
		'請求書コメントチェック
		If strDetailName = "" Then 
			.AppendArray vntArrMessage, "請求詳細名が入力されていません。"
		End If
		.AppendArray vntArrMessage, .CheckDate("受診日",lngStrYear, lngStrMonth, lngStrDay, strYMD, 1)
		.AppendArray vntArrMessage, .CheckWideValue("請求詳細名", strDetailName, 30)
		If IsNumeric(strDayId) Then strDayId = CDbl(strDayId)
		If IsNumeric(strRsvNo) Then strRsvNo = CDbl(strRsvNo)
		If IsNumeric(lngPrice) Then lngPrice = CDbl(lngPrice)
		If IsNumeric(lngEditPrice) Then lngEditPrice = CDbl(lngEditPrice)
		If IsNumeric(lngTaxPrice) Then lngTaxPrice = CDbl(lngTaxPrice)
		If IsNumeric(lngEditTax) Then lngEditTax = CDbl(lngEditTax)
		.AppendArray vntArrMessage, .CheckNumeric("当日ID", strDayId, 5)
		.AppendArray vntArrMessage, .CheckNumeric("予約番号", strRsvNo, 9)
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
<TITLE>請求明細登録・修正</TITLE>
-->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
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
	var rt = confirm('この明細を削除してもよろしいですか？');
	if(rt == true){
		document.entryForm.act.value = 'delete';
		document.entryForm.submit();
	}
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>請求明細登録・修正</B></TD>
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
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>当日ID</TD>
			<TD>：</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD>
						<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
							<INPUT TYPE="text" NAME="DayId" VALUE="<%= strDayId%>" SIZE="7" MAXLENGTH="5">
						<%Else%>
							<%=strDayId%>
							<INPUT TYPE="hidden" NAME="DayId" VALUE="<%= strDayId%>">
						<%End If%>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>予約番号</TD>
			<TD>：</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD>
						<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
							<INPUT TYPE="text" NAME="RsvNo" VALUE="<%= strRsvNo%>" SIZE="10" MAXLENGTH="9">
						<%Else%>
							<%=strRsvNo%>
							<INPUT TYPE="hidden" NAME="RsvNo" VALUE="<%= strRsvNo%>">
						<%End If%>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>請求明細名</TD>
			<TD>：</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="DetailName" VALUE="<%= strDetailName %>" SIZE="40" MAXLENGTH="30"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="27">氏名</TD>
			<TD>：</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<A HREF="javascript:perGuide_showGuidePersonal(document.entryForm.perId, 'perName')">
								<IMG SRC="/webHains/images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21">
							</A>
							<A HREF="javascript:perGuide_clearPerInfo(document.entryForm.perId, 'perName');">
								<IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21">
							</A>
						</TD>
						<TD>
							<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
							<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
							<SPAN ID="perName"><%= strPerName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>請求金額</TD>
			<TD>：</TD>
			<TD NOWRAP>
<% '2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加 %>
<!--
				<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
					<INPUT TYPE="text" NAME="Price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="8">
				<%Else%>
					<%= FormatCurrency(lngPrice) %>
					<INPUT TYPE="hidden" NAME="Price" VALUE="<%= lngPrice%>">
				<%End If%>
-->
				<%If vntArrSecondFlg(0) <> "1" Then%>
					<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
						<INPUT TYPE="text" NAME="Price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="8">
					<%Else%>
						<%= FormatCurrency(lngPrice) %>
						<INPUT TYPE="hidden" NAME="Price" VALUE="<%= lngPrice%>">
					<%End If%>
				<%Else%>
					<INPUT TYPE="hidden" NAME="Price" VALUE="<%= lngPrice%>"><%= lngSumPrice %>
				<%End If%>
<% '2004.06.02 MOD END %>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>調整金額</TD>
			<TD>：</TD>
<% '2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加 %>
<!--
			<TD><INPUT TYPE="text" NAME="EditPrice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="8"></TD>
-->
			<%If vntArrSecondFlg(0) <> "1" Then%>
				<TD><INPUT TYPE="text" NAME="EditPrice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="8"></TD>
			<%Else%>
				<TD><INPUT TYPE="hidden" NAME="EditPrice" VALUE="<%= lngEditPrice %>"><%= lngSumEditPrice %></TD>
			<%End If%>
<% '2004.06.02 MOD END %>
		</TR>
		<TR>
			<TD NOWRAP>消費税</TD>
			<TD>：</TD>
			<TD NOWRAP>
<% '2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加 %>
<!--
				<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
					<INPUT TYPE="text" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="8">
				<%Else%>
					<%= FormatCurrency(lngTaxPrice) %>
					<INPUT TYPE="hidden" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>">
				<%End If%>
-->
				<%If vntArrSecondFlg(0) <> "1" Then%>
					<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
						<INPUT TYPE="text" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="8">
					<%Else%>
						<%= FormatCurrency(lngTaxPrice) %>
						<INPUT TYPE="hidden" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>">
					<%End If%>
				<%Else%>
					<INPUT TYPE="hidden" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>"><%= lngSumTaxPrice %>
				<%End If%>
<% '2004.06.02 MOD END %>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>調整税額</TD>
			<TD>：</TD>
<% '2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加 %>
<!--
			<TD><INPUT TYPE="text" NAME="EditTax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="8"></TD>
-->
			<%If vntArrSecondFlg(0) <> "1" Then%>
				<TD><INPUT TYPE="text" NAME="EditTax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="8"></TD>
			<%Else%>
				<TD><INPUT TYPE="hidden" NAME="EditTax" VALUE="<%= lngEditTax %>"><%= lngSumEditTax %></TD>
			<%End If%>
<% '2004.06.02 MOD END %>
		</TR>
	</TABLE>
	<BR>
<%If strLineNo <> "" Then%>
	<%If strNoEditFlg = 0 Then%>
		<% '2005.08.22 権限管理 Add by 李　--- START %>
		<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
		<A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="明細を削除します。"></A>
		<%  else    %>
			 &nbsp;
		<%  end if  %>
		<% '2005.08.22 権限管理 Add by 李　--- END %>	
	<%End If%>
<%End If%>
<%If strNoEditFlg = 0 Then%>
	<% '2005.08.22 権限管理 Add by 李　--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	<A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で確定"></A>
	<%  else    %>
		 &nbsp;
	<%  end if  %>
	<% '2005.08.22 権限管理 Add by 李　--- END %>
<%End If%>
	<A HREF="javascript:location.href='dmdBurdenModify.asp?BillNo=<%=strBillNo%>&getCount=<%=strGetCount%>&startpos=<%=strStartPos%>';"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
</FORM>
</BODY>
</HTML>
