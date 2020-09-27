<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求書明細内訳検索 (Ver0.0.1)
'		AUTHER  : T.Yaguchi@orbsys.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'引数値
Dim strAction				'処理状態（検索ボタン押下時:"search"）
Dim strBillNo				'請求書Ｎｏ
Dim strLineNo				'明細Ｎｏ
Dim strItemNo				'内訳Ｎｏ
Dim strPerId				'個人ID
Dim strLastName				'姓
Dim strFirstName			'名
Dim strCslDate				'受診日
Dim lngStartPos				'表示開始位置

'COMオブジェクト
Dim objCommon				'共通関数アクセス用COMオブジェクト
Dim objDemand				'請求アクセス用COMオブジェクト
Dim objOrganization			'団体アクセス用COMオブジェクト

'請求書情報読み込み
Dim lngAllCount				'条件を満たす全レコード件数
Dim strPageMaxLine			'１ページ表示行数
Dim lngGetCount				'１ページ表示件数
Dim lngCount				'検索できた件数
Dim lngCount2				'検索できた件数
Dim lngArrBillNo			'請求書Ｎｏ
Dim strArrCloseDate			'締め日（"yyyy/m/d"編集）
Dim strArrBillSeq			'請求書Seq
Dim strArrBranchno			'請求書枝番
Dim strArrOrgCd1			'団体コード1
Dim strArrOrgCd2			'団体コード2
Dim strArrOrgName			'団体名
Dim strArrOrgKName			'団体カナ名
Dim strArrPrtDate			'請求書出力日
Dim lngArrSumPriceTotal		'合計
Dim lngArrSumTaxTotal		'税額合計
Dim strArrSeq				'Seq
Dim strArrDispatchDate		'発送日付
Dim strArrUpdUser			'更新者
Dim strArrUserName			'ユーザ名
Dim strArrUpdDate			'更新日
Dim strArrDelFlg			'取消伝票フラグ

'## 2004.06.02 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
Dim strSumPrice				'金額合計
Dim strSumEditPrice			'調整金額合計
Dim strSumTaxPrice			'税額合計
Dim strSumEditTax			'調整税額合計
Dim strSumPriceTotal			'総合計
Dim lngSumRecord			'レコード数
'## 2004.06.02 ADD END

Dim strArrLineNo			'明細No
Dim strArrCslDate			'受診日
Dim strArrDayId				'当日ID
Dim strArrRsvNo				'予約番号
Dim strArrDetailName		'明細名
Dim strArrPerId				'個人ID
Dim strArrLastName			'姓
Dim strArrFirstName			'名
Dim strArrLastKName			'カナ姓
Dim strArrFirstKName		'カナ名
Dim strArrPrice				'金額
Dim strArrEditPrice			'調整金額
Dim strArrTaxPrice			'税額
Dim strArrEditTax			'調整税額
Dim strArrMethod			'作成方法
Dim strArrItemNo			'内訳コード
Dim strArrSecondLineDivCd		'２次請求明細コード
Dim strArrSecondLineDivName		'２次請求明細名

Dim vntArrPaymentCnt		'入金件数
Dim vntArrDispatchCnt		'発送件数
Dim strGetCount				'１ページ表示件数
Dim strOldGetCount			'１ページ表示件数（変更前）
Dim lngDelResult 			'請求書削除結果

'画面表示用編集領域
Dim strDispCloseDate		'編集用の締め日（"yyyy/m/d"編集）
Dim strDispBillNo			'請求書番号
Dim strDispOrgName			'編集用の負担元団体名
Dim strDispOrgKName

Dim strDispDiscount			'編集用の値引き
Dim strDispCsSubTotal
Dim strDispCsTax
Dim strDispCsTotal


Dim strDispCslDate			'受診日
Dim strDispDayId			'当日ID
Dim strDispRsvNo			'予約番号
Dim strDispPerId			'個人ID
Dim strDispLastName			'姓
Dim strDispFirstName		'名
Dim strDispLastKName		'カナ姓
Dim strDispFirstKName		'カナ名

Dim strDispBillTotal		'請求金額
Dim strDispTaxTotal			'消費税
Dim strDispPrice			'小計
Dim strDispPriceTotal		'入金額

'グループインデント処理用
Dim strWCslDate
Dim strWDayId
Dim strWRsvNo
Dim strWPerId

'入力チェック
Dim strArrMessage		'エラーメッセージ

'インデックス
Dim i

Dim dtmDate				'受診日デフォルト値計算用の日付
Dim strBranchno			'請求書枝番（削除ボタンの表示判定）

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strAction      = Request("action") & ""
strBillNo      = Request("billNo")
strLineNo      = Request("lineNo")
strItemNo      = Request("itemNo")
strPerId       = Request("perId")
strLastName    = Request("lastName")
strFirstName   = Request("firstName")
strCslDate     = Request("cslDate")
lngStartPos    = CLng("0" & Request("startPos"))
lngStartPos    = IIf(lngStartPos = 0, 1, lngStartPos)
strGetCount    = Request("getCount")
strOldGetCount = Request("oldGetCount")

'初期設定
strArrMessage = Empty

'一覧表示行数の取得
Set objCommon = Server.CreateObject("HainsCommon.Common")
strPageMaxLine = objCommon.SelectDmdBurdenListPageMaxLine
If strGetCount = "" Then
	strGetCount = strPageMaxLine
Else
	If strGetCount = "*" Then
'		strGetCount = ""
	End If
End If

If strOldGetCount = "" Then
'	strOldGetCount = strPageMaxLine
	strOldGetCount = strGetCount
End If

If strOldGetCount <> "" And strOldGetCount <> strGetCount Then
	lngStartPos = 1
End If
'-------------------------------------------------------------------------------
'
' 機能　　 : 表示行数一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                 エレメント名
' 　　　　 : (In)     strSelectedPageMaxLine  リストにて選択すべき表示行数
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditDailyPageMaxLineList(strName, strSelectedPageMaxLine)

	Dim vntPageMaxLine	'表示行数
	Dim vntPageMaxName	'表示行数名称

	'表示行数情報の取得
	If objCommon.SelectDailyPageMaxLineList(vntPageMaxLine, vntPageMaxName) > 0 Then

		'ドロップダウンリストの編集
		EditDailyPageMaxLineList = EditDropDownListFromArray(strName, vntPageMaxLine, vntPageMaxName, strSelectedPageMaxLine, NON_SELECTED_DEL)

	End If

End Function

'ソート順指定時のセル背景色変更
Function getSelectedColor(strWkSortName)
	Dim strColor

	If strWksortName = strSortName Then
		strColor = "CLASS=""selectedcolor"""
	Else
		strColor = ""
	End If

	getSelectedColor = strColor
End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>請求書基本情報</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
'請求アクセス用COMオブジェクトの割り当て
Set objDemand = Server.CreateObject("HainsDemand.Demand")

'If strAction = "delete" Then
'	lngDelResult = objDemand.DeleteBill(strBillNo)
'	Select Case lngDelResult
'	Case 2
'		strArrMessage = Array("請求書を取消伝票にしました。")
'	Case 1
'		strArrMessage = Array("請求書を削除しました。")
'	Case 0
'		strArrMessage = Array("該当する請求書がありません。")
'	Case -1
'		strArrMessage = Array("請求書の削除に失敗しました。")
'	End Select
'End If

%>
<SCRIPT TYPE="text/javascript">
<!--
var dmdSendCheckDay_CalledFunction;		// 送信日修正後呼び出し関数
var winSendCheckDay;					// 送信日修正ウィンドウハンドル


// 請求書基本情報呼び出し
function callSendCheckDay( billNo, seq ) {
	var opened = false;

	dmdSendCheckDay_CalledFunction = loadBurdenModify;

	// すでに請求書基本情報が開かれているかチェック
	if ( winSendCheckDay != null ) {
		if ( !winSendCheckDay.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winSendCheckDay.location.replace("dmdSendCheckDay.asp?billNo=" + billNo);
		winSendCheckDay.focus();
	} else {
		winSendCheckDay = window.open("dmdSendCheckDay.asp?billNo=" + billNo + "&seq=" + seq + "&mode=update","","toolbar=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,width=700,height=400");
//		winSendCheckDay = window.open("dmdSendCheckDay.asp?billNo=" + billNo,"","");
	}

	return false;
}

function closeSendCheckDay(){
	if ( winSendCheckDay != null ) {
		if ( !winSendCheckDay.closed ) {
			winSendCheckDay.close();
		}
	}
}

// 請求書削除
function callDelete(){
	var rtn = false;

	rtn = confirm("この請求書を削除してもよろしいですか？")

	if(rtn == true){
		document.entryCondition.action.value = "delete";
		document.entryCondition.submit();
	}

	return false;
}

function loadBurdenModify() {
	location.reload();
}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeSendCheckDay()">
<!--<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">-->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="action" VALUE="search">
<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= CStr(lngStartPos) %>">
<INPUT TYPE="hidden" NAME="getCoutn" VALUE="<%=strGetCount%>">
<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo%>">
<INPUT TYPE="hidden" NAME="lineNo" VALUE="<%= strLineNo%>">
<INPUT TYPE="hidden" NAME="itemNo" VALUE="<%= strItemNo%>">
<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId%>">
<INPUT TYPE="hidden" NAME="lastName" VALUE="<%= strLastName%>">
<INPUT TYPE="hidden" NAME="firstName" VALUE="<%= strFirstName%>">
<INPUT TYPE="hidden" NAME="cslDate" VALUE="<%= strCslDate%>">
<INPUT TYPE="hidden" NAME="oldGetCount" VALUE="<%= strOldGetCount%>">
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">請求書基本情報</FONT></B></TD>
	</TR>
</TABLE>
<%
If strAction = "delete" Then
	If lngDelResult < 0 Then
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	Else
		Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)
	End If
%>
<BR>
<BR>
<A HREF = "" onClick="window.close(); return false;"><IMG SRC="/webHains/images/back.gif" BORDER=0></A>
<%
	Response.End
End If

	'発送情報取得
	lngCount = objDemand.SelectDmdBurdenDispatch( _
								strBillNo, "", "", _
								lngArrBillNo, _
								strArrCloseDate, _
								strArrBillSeq, _
								strArrBranchno, _
								strArrOrgCd1, _
								strArrOrgCd2, _
								strArrOrgName, _
								strArrOrgKName, _
								strArrPrtDate, _
								lngArrSumPriceTotal, _
								lngArrSumTaxTotal, _
								strArrSeq, _
								strArrDispatchDate, _
								strArrUpdUser, _
								strArrUserName, _
								strArrUpdDate, _
								strArrDelFlg)

	If lngCount = 0 Then
		strArrMessage = Array("該当する請求書がありません")
	Else
		strBranchno = strArrBranchno(0)
	End If

	'メッセージの編集
	Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	If lngCount = 0 Then
		Response.End
	End If
Do
	If Not IsEmpty(strArrMessage) Then Exit Do

	'表示用に編集
	If lngArrSumPriceTotal(0) <> "" Then
		strDispBillTotal = lngArrSumPriceTotal(0)
		If lngArrSumTaxTotal(0) <> "" Then
			strDispBillTotal = CDbl(strDispBillTotal) + CDbl(lngArrSumTaxTotal(0))
			strDispTaxTotal = FormatCurrency(lngArrSumTaxTotal(0))
		End If
		strDispBillTotal = FormatCurrency(strDispBillTotal)
	End If
'## 2004.06.02 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
	lngSumRecord = objDemand.SelectSumDetailItems(strBillNo,strLineNo, _
							strSumPrice, _
							strSumEditPrice, _
							strSumTaxPrice, _
							strSumEditTax, _
							strSumPriceTotal)
	'２次検査合計金額の追加
	If lngSumRecord > 0 Then
		strDispBillTotal = CDbl(strDispBillTotal) + strSumPriceTotal(0)
		strDispTaxTotal = CDbl(strDispTaxTotal) + strSumTaxPrice(0) + strSumEditTax(0)
		strDispBillTotal = FormatCurrency(strDispBillTotal)
		strDispTaxTotal = FormatCurrency(strDispTaxTotal)
	End If
'## 2004.06.02 ADD END

'### 2004/3/27 Deleted by Ishihara@FSIT過去データも加工したい場合があるため、復活
''### 2004/3/8 Added by Ishihara@FSIT 締め日が過去日の場合（つまり移行データ）取消扱い（削除させたくないため）
'	If strArrCloseDate(0) < "2004/01/01" Then
'		strArrDelFlg(0) = "1"
'	End If
'### 2004/3/27 Deleted End

%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD>請求書番号</TD>
		<TD>：</TD>
		<TD><%= lngArrBillNo(0)%></TD>
	</TR>
	<TR>
		<TD>請求先団体</TD>
		<TD>：</TD>
		<TD><%= strArrOrgName(0)%></TD>
	</TR>
	<TR>
		<TD>締め日</TD>
		<TD>：</TD>
		<TD><%= strArrCloseDate(0)%></TD>
	</TR>
	<TR>
		<TD>請求書出力日</TD>
		<TD>：</TD>
		<TD><%= strArrPrtDate(0)%></TD>
	</TR>
	<TR>
		<TD>請求金額</TD>
		<TD>：</TD>
		<TD><%= strDispBillTotal%>　（内 消費税 <%=strDispTaxTotal%>）</TD>
	</TR>
<%
	For i = 0 to lngCount -1
%>
	<TR>
<%
		If i = 0 Then
%>
		<TD>請求書発送日</TD>
<%
		Else
%>
		<TD></TD>
<%
		End If
%>
		<TD>：</TD>
		<TD>
<%
		If strArrDispatchDate(i) <> "" Then
%>
			<TABLE>
				<TR>
					<TD>
						<%If strArrDelFlg(i) = "1" And strArrBranchno(i) = "0"Then%>
						<%Else%>
						<A HREF="" onClick="return callSendCheckDay('<%= lngArrBillNo(i)%>','<%=strArrSeq(i)%>');">
							<IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="請求書発送日を変更" BORDER=0>
						</A>
						<%End If%>
					</TD>
					<TD><%= strArrDispatchDate(i)%></TD>
					<TD WIDTH=50>
					<TD>更新者：</TD>
					<TD><%= strArrUserName(i)%></TD>
					<TD WIDTH=50></TD>
					<TD>更新日：</TD>
					<TD><%= strArrUpdDate(i)%></TD>
				</TR>
			</TABLE>
		</TD>
<%
		Else
%>
		<TD></TD>
<%
		End If
%>
	</TR>
<%
	Next
%>
	<TR>
		<TD>個人ID</TD>
		<TD>：</TD>
		<TD><%= strPerId%></TD>
	</TR>
	<TR>
		<TD>氏名</TD>
		<TD>：</TD>
		<TD><%= strLastName%>　<%= strFirstName%></TD>
	</TR>
</TABLE>
<%
	Exit Do
Loop

Do
	'検索条件が誤っている場合は何もしない
	If Not IsEmpty(strArrMessage) Then Exit Do

	lngArrBillNo = null
	strArrLineNo = null
	strArrCloseDate = null
	strArrBillSeq = null
	strArrBranchno = null
	strArrRsvNo = null
	strArrCslDate = null
	strArrDetailName = null
	strArrPerId = null
	strArrLastName = null
	strArrFirstName = null
	strArrLastKName = null
	strArrFirstKName = null
	strArrPrice = null
	strArrEditPrice = null
	strArrTaxPrice = null
	strArrEditTax = null
	strArrSecondLineDivCd = null
	strArrSecondLineDivName = null
	strArrItemNo = null

	'検索条件を満たすレコード件数を取得
	'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
	lngAllCount = objDemand.SelectDmdDetailItmList( _
											strBillNo, strLineNo, "", "", "")
	lngCount = objDemand.SelectDmdDetailItmList( _
											strBillNo, strLineNo, "", lngStartPos, strGetCount, _
											lngArrBillNo, _
											strArrLineNo, _
											strArrCloseDate, _
											strArrBillSeq, _
											strArrBranchno, _
											strArrDayId, _
											strArrRsvNo, _
											strArrCslDate, _
											strArrDetailName, _
											strArrPerId, _
											strArrLastName, _
											strArrFirstName, _
											strArrLastKName, _
											strArrFirstKName, _
											strArrPrice, _
											strArrEditPrice, _
											strArrTaxPrice, _
											strArrEditTax,"","","","","","",strArrItemNo,strArrSecondLineDivCd,strArrSecondLineDivName)

	'入金済み、発送済みチェック
	lngCount2 = objDemand.SelectPaymentAndDispatchCnt(strBillNo, _
													vntArrPaymentCnt, _
													vntArrDispatchCnt)

	'レコード件数情報を編集
%>
<BR>
<!--ここは検索件数結果-->

	<TABLE BORDER="0" CELLSPACING="4" CELLPADDING="0">
		<TR>
			<TD NOWRAP COLSPAN=4>
				<FONT color="#ff6600"><B><%= CStr(lngAllCount) %></B></FONT>件の明細情報が含まれています。
			</TD>
		<%If vntArrPaymentCnt(0) = 0 And vntArrDispatchCnt(0) = 0 Then%>
			<TD COLSPAN=5 ALIGN="right">
			<A HREF="dmdEditDetailItemLine.asp?action=insert&BillNo=<%=strBillNo%>&getCount=<%=strGetCount%>&startpos=<%=lngStartPos%>&LineNo=<%=strLineNo%>&perId=<%=strPerId%>&lastName=<%=strLastName%>&firstName=<%=strFirstName%>&cslDate=<%=strCslDate%>">
			<IMG SRC="../../images/newrsv.gif" BORDER="0" HEIGHT="24" WIDTH="77" ALT="請求書明細内訳を追加">
			</A>
			</TD>
		<%End If%>
		</TR>
		<TR>
			<TD COLSPAN=7 ALIGN=RIGHT><TD>
				<%= EditDailyPageMaxLineList("getCount", strGetCount) %>
			</TD>
			<TD>
				<A HREF="" onClick="javascript:document.entryCondition.submit();return false;">
					<img src="../../images/b_prev.gif" BORDER="0" >
				</A>
			</TD>
		</TR>
		<TR>
			<TD><BR></TD>
		</TR>
<%
	'検索結果が存在しない場合は何もしない
	If lngCount = 0 Then
%>
	</TABLE>
<%
		Exit Do
	End If

	'請求情報一覧の編集開始
%>
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP>２次内訳</TD>
			<TD NOWRAP ALIGN="right">小計</TD>
			<TD NOWRAP ALIGN="right">合計</TD>
			<TD NOWRAP>処理</TD>
		</TR>
<%
	'明細の数だけループする
	For i = 0 To lngCount - 1
		'表示用に編集
		If strArrPrice(i) <> "" Then
			If strArrEditPrice(i) <> "" Then
				strDispPriceTotal = CDbl(strArrPrice(i)) + CDbl(strArrEditPrice(i))
			Else
				strDispPriceTotal = strArrPrice(i)
			End If
		Else
			strDispPriceTotal = ""
		End If
		If strArrTaxPrice(i) <> "" Then
			If strArrEditTax(i) <> "" Then
				strDispBillTotal = CDbl(strDispPriceTotal) + CDbl(strArrTaxPrice(i)) + CDbl(strArrEditTax(i))
			Else
				strDispBillTotal = CDbl(strDispPriceTotal) + CDbl(strArrTaxPrice(i))
			End If
		Else
			strDispBillTotal = strDispPriceTotal
		End If
%>
		<%If i=0 Then%>
			<TR>
				<TD HEIGHT="1" COLSPAN="5" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
			</TR>
		<%End If%>
			<TR>
				<TD NOWRAP><%= strArrSecondLineDivName(i)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispPriceTotal)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispBillTotal)%></TD>
				<TD><A HREF="dmdEditDetailItemLine.asp?BillNo=<%=lngArrBillNo(i)%>&LineNo=<%=strArrLineNo(i)%>&ItemNo=<%=strArrItemNo(i)%>&getCount=<%=strGetCount%>&startpos=<%=lngStartPos%>&perId=<%=strPerId%>&lastName=<%=strLastName%>&firstName=<%=strFirstName%>&cslDate=<%=strCslDate%>">修正</A></TD>
			</TR>
<!--
			<TR>
				<TD NOWRAP><%= strArrDetailName(i)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispPriceTotal)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispBillTotal)%></TD>
				<TD><A HREF="dmdEditDetailItemLine.asp?BillNo=<%=lngArrBillNo(i)%>&LineNo=<%=strArrLineNo(i)%>">修正</A></TD>
			</TR>
-->
			<TR>
				<TD HEIGHT="1" COLSPAN="5" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
			</TR>
<%
	Next
%>
	</TABLE>
	<BR>
<%
		'ページングナビゲータの編集
'		If IsNumeric(strPageMaxLine) Then
'			lngGetCount = CLng(strPageMaxLine)
		If IsNumeric(strGetCount) Then
			lngGetCount = CLng(strGetCount)
%>
			<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?action=search&billNo=" & strBillNo & "&LineNo=" & strLineNo & "&oldGetCount=" & lngGetCount & "&perId=" & strPerId & "&lastName=" & strLastName & "&firstName=" & strFirstName & "&cslDate=" & strCslDate, lngAllCount, lngStartPos, lngGetCount) %>
<%
		End If
'### 2004/3/4 Updated by Ishihara@FSIT 明細件数が０件の場合、元の位置ではインデックスエラーで落ちる
%>
<BR>
<!--<A HREF="/webHains/contents/print/prtOrgBill.asp?mode=0&BillNo=<%= lngArrBillNo(0) %>"><IMG SRC="../../images/print.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="請求書を印刷します" ></A>-->
<%
		Exit Do
	Loop

	'請求アクセス用COMオブジェクトの解放
	Set objDemand = Nothing
%>
<%If strArrDelFlg(0) = "0" Then%>
<!--<A HREF="" onClick="return callDelete()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="請求書を削除します。"></A>-->
<%End if%>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
<%
Set objCommon = Nothing
%>