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
Dim objPerbill				'受診情報アクセス用

Dim Ret						'関数戻り値

Dim lngCount				'取得件数
Dim lngRsvNo				'予約番号
Dim lngRecord				'レコード番号

Dim strLineName				'セット外請求明細名称
'Dim lngPrice				'金額
Dim lngEditPrice			'調整金額
'Dim lngTaxPrice				'税額
Dim lngEditTax				'調整税額
Dim lngOmitTaxFlg			'消費税免除フラグ

'個人受診金額用変数
Dim vntOrgCd1               '団体コード１
Dim vntOrgCd2               '団体コード２
Dim vntOrgSeq				'契約パターンＳＥＱ
Dim vntOrgName              '団体名
Dim vntPrice                '金額
Dim vntEditPrice            '調整金額
Dim vntTaxPrice             '税額
Dim vntEditTax            	'調整税額
Dim vntLineTotal			'小計（金額、調整金額、税額、調整税額）
Dim vntPriceSeq             'ＳＥＱ
Dim vntCtrPtCd				'契約パターンコード
Dim vntOptCd				'オプションコード
Dim vntOptBranchNo			'オプション枝番
Dim vntOptName				'オプション名称
Dim vntOtherLineDivCd		'セット外名称区分
Dim vntLineName				'明細名称（セット外明細名称含む）
Dim vntDmdDate				'請求日
Dim vntBillSeq				'請求書Ｓｅｑ
Dim vntBranchNo				'請求書枝番
Dim vntBillLineNo			'請求書明細行No
Dim vntOmitTaxFlg			'消費税免除フラグ

Dim strDivCd				'セット外請求明細コード
Dim strSetName				'対応セット名称


Dim strMode					'処理モード
Dim strAction				'動作モード(保存:"save"、保存完了:"saved")
Dim i						'インデックス
Dim strHTML
Dim strArrMessage	'エラーメッセージ

strArrMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得

lngEditPrice   = Request("editprice")
'lngTaxPrice   = Request("taxprice")
lngEditTax     = Request("edittax")
strLineName    = Request("linename")
lngRsvNo       = Request("rsvno")
strDivCd       = Request("divcd")
lngRecord      = Request("record")
strSetName     = Request("setname")
lngOmitTaxFlg  = Request("omitTaxFlg")

strAction      = Request("act")
strMode        = Request("mode")

'初期表示設定
If strMode = "" Then strMode = "init"

Do

	'個人受診金額情報取得
		lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, _
												 vntOrgCd1, _
												 vntOrgCd2, _
												 vntOrgSeq, _
												 vntOrgName, _
												 vntPrice, _
												 vntEditPrice, _
												 vntTaxPrice, _
												 vntEditTax, _
												 vntLineTotal, _ 
												 vntPriceSeq, _
												 vntCtrPtCd, _
												 vntOptCd, _
												 vntOptBranchNo, _
												 vntOptName, _
												 vntOtherLineDivCd, _
												 vntLineName, _
												 vntDmdDate, _
												 vntBillSeq, _
												 vntBranchNo, _
												 vntBillLineNo, _
												, , vntOmitTaxFlg )
	'受診金額情報が存在しない場合
	If lngCount < 1 Then
		Exit Do
	End If

	If strMode = "init" Then
		'初期表示設定
		If strLineName = "" Then strLineName = vntLineName(lngRecord)
		If lngEditPrice = "" Then lngEditPrice = vntEditPrice(lngRecord)
		If lngEditTax = "" Then lngEditTax = vntEditTax(lngRecord)
		If lngOmitTaxFlg = "" Then lngOmitTaxFlg = vntOmitTaxFlg(lngRecord)
		strMode = "initend"
	End If

	'対応セット名保存する。
	If strSetName = "" Then strSetName = vntLineName(lngRecord)


	'確定ボタン押下時、保存処理実行
	If strAction = "save" Then
'KMT
'Err.Raise 1000, , "vntPrice= " & vntPrice(lngRecord)

		If lngEditPrice = "" OR IsNull(lngEditPrice) Then lngEditPrice = 0
		If lngEditTax = "" OR IsNull(lngEditTax) Then lngEditTax = 0

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'受診確定金額情報、個人請求明細情報の登録
		Ret = objPerbill.UpdatePerBill_c(vntDmdDate(lngRecord), _
											IIf( vntBillSeq(lngRecord)="", 0, vntBillSeq(lngRecord)), _
											IIf( vntBranchNo(lngRecord)="",0, vntBranchNo(lngRecord)), _
											IIf( vntBillLineNo(lngRecord)="", 0, vntBillLineNo(lngRecord)), _
											vntPrice(lngRecord), _
											lngEditPrice, _
											vntTaxPrice(lngRecord), _
											lngEditTax, _
											IIf( strSetName = strLineName, "", strLineName), _
											lngRsvNo, _
											vntPriceSeq(lngRecord), _
											lngOmitTaxFlg, _
											vntOtherLineDivCd(lngRecord)  )

		'保存に失敗した場合
		If Ret <> True Then
			strArrMessage = Array("請求明細の更新に失敗しました。")
'			Err.Raise 1000, , "請求明細が更新できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
			Exit Do
		Else
			'エラーがなければ呼び元画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
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
		If strLineName = "" Then 
			.AppendArray vntArrMessage, "請求詳細名が入力されていません。"
		End If
		.AppendArray vntArrMessage, .CheckWideValue("請求詳細名", strLineName, 40)
'		.AppendArray vntArrMessage, .CheckNumeric("請求金額", lngPrice, 7)
		.AppendArray vntArrMessage, objPerBill.CheckNumeric("調整金額", lngEditPrice, 7)
'		.AppendArray vntArrMessage, .CheckNumeric("消費税", lngTaxPrice, 7)
		.AppendArray vntArrMessage, objPerBill.CheckNumeric("調整税額", lngEditTax, 7)
	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>請求明細登録・修正</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

//消費税免除チェック処理
function checkOmitTaxFlgAct(taxprice) {

	with ( document.entryForm ) {
		checkOmitTaxFlg.value = (checkOmitTaxFlg.checked ? '1' : '0');
		edittax.value = (checkOmitTaxFlg.checked ? -1*(taxprice-0) : edittax.value );
		omitTaxFlg.value = checkOmitTaxFlg.value;
	}

}

//保存
function saveData() {

	// モードを指定してsubmit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}


//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>請求明細登録・修正</B></TD>
		</TR>
	</TABLE>
	<!-- 引数情報 -->
	<INPUT TYPE="hidden" NAME="act" VALUE="">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="record" VALUE="<%= lngRecord %>">
	<INPUT TYPE="hidden" NAME="divcd" VALUE="<%= strDivCd %>">
	<INPUT TYPE="hidden" NAME="setname" VALUE="<%= strSetName %>">


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

		End Select

	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>負担元</TD>
			<TD>：</TD>
			<TD NOWRAP><%= vntOrgName(lngRecord) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>対応セットコード</TD>
			<TD>：</TD>
<%
			If vntOptCd(lngRecord) <> "" Then
%>
				<TD NOWRAP><%= vntOptCd(lngRecord) & "-" & vntOptBranchNo(lngRecord) %></TD>
<%
			Else
%>
				<TD NOWRAP ALIGN="RIGHT"></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD NOWRAP>対応セット名</TD>
			<TD>：</TD>
			<TD><%= vntOptName(lngRecord) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>請求明細名</TD>
			<TD>：</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="linename" VALUE="<%= strLineName %>" SIZE="40" MAXLENGTH="20"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>請求金額</TD>
			<TD>：</TD>
			<TD NOWRAP><%= FormatCurrency(vntPrice(lngRecord)) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>調整金額</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="editprice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="7"></TD>
		</TR>
		<TR>
			<TD NOWRAP>消費税</TD>
			<TD>：</TD>
			<TD NOWRAP><%= FormatCurrency(vntTaxPrice(lngRecord)) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>調整税額</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="edittax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="7"></TD>
		</TR>
		<TR>
			<TD NOWRAP><INPUT TYPE="checkbox" NAME="checkOmitTaxFlg" VALUE="1" <%= IIf(lngOmitTaxFlg <> 0, " CHECKED", "") %>  ONCLICK="javascript:checkOmitTaxFlgAct(<%= vntTaxPrice(lngRecord) %>)" border="0">消費税免除</TD>
			<INPUT TYPE="hidden" NAME="omitTaxFlg" VALUE="<%= lngOmitTaxFlg %>">
		</TR>
	</TABLE>
	<BR>
	
    <% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
        <A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で確定"></A>
	<% End If %>
    
    <A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
</FORM>
</BODY>
</HTML>
