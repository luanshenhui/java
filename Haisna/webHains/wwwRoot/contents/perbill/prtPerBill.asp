<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		領収書・請求書印刷表示 (Ver0.0.1)
'		AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-239~240
'       修正日  ：2010.06.11
'       担当者  ：ASC)宍戸
'       修正内容：Report DesignerをCo Reportsに変更
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon				'共通クラス
Dim objPerbill				'受診情報アクセス用



Dim lngCountCsl				'取得件数
Dim lngCount				'取得件数
Dim Ret						'関数戻り値

'受診情報用変数
Dim vntRsvNo				'予約番号
Dim vntCslDate				'受診日
Dim vntPerId				'個人ＩＤ
Dim vntLastName				'姓
Dim vntFirstName			'名
Dim vntLastKName			'カナ姓
Dim vntFirstKName			'カナ名
Dim vntCsCd					'コースコード
Dim vntCsName				'コース名

'個人請求管理情報(BillNo)
Dim vntDelFlg				'取消し伝票フラグ
Dim vntPrintDate			'領収書印刷日
Dim vntBillName				'請求宛先
Dim vntKeishou				'敬称

'配列
Dim vntArrRsvNo()			'予約番号
Dim vntArrCslDate()			'受診日
Dim vntArrPerId()			'個人ＩＤ
Dim vntArrLastName			'姓
Dim vntArrFirstName			'名
Dim vntArrLastKName()		'カナ姓
Dim vntArrFirstKName()		'カナ名
Dim vntArrCsCd()			'コースコード
Dim vntArrCsName			'コース名
Dim vntArrDelFlg()			'取消し伝票フラグ
Dim vntArrPrintDate()		'領収書印刷日
Dim vntArrBillName			'請求宛先
Dim vntArrKeishou			'敬称

Dim strPrintDate			'領収書印刷日

Dim vntDmdDate     		'請求日 配列
Dim vntBillSeq     		'請求書Ｓｅｑ 配列
Dim vntBranchNo     	'請求書枝番 配列


Dim strReqDmdDate     	'請求日 Request
Dim strReqBillSeq     	'請求書Ｓｅｑ Request
Dim strReqBranchNo     	'請求書枝番 Request

Dim strArrKeishou()			'敬称　配列
Dim strArrKeishouName()		'敬称（表示用）　配列

Dim strAct  			'動作モード(保存:"save"、保存完了:"saved")
Dim strMessage			'エラーメッセージ
Dim i					'インデックス

Dim lngPrtKbn			'印刷対象

Dim strHTML

Dim strReqDisp			'呼び出し元画面名

'#### 2010.06.11 SL-UI-Y0101-239~240 ADD START ####'
Dim objPrintCls			'請求書、領収書作成用
Dim lngRet				'プリントSEQ
Dim vntFileName()		'帳票ファイル名
Dim intCnt				'インデックス
'#### 2010.06.11 SL-UI-Y0101-239~240 ADD END ####'

strMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得


strReqDmdDate     = Request("reqdmddate")
strReqBillSeq     = Request("reqbillseq")
strReqBranchNo    = Request("reqbranchno")

strAct            = Request("act")

strReqDisp        = Request("reqDisp")

lngPrtKbn         = Request("prtKbn")
lngPrtKbn = IIf( lngPrtKbn = "", "1", lngPrtKbn )

vntArrLastName	  = ConvIStringToArray(Request("lastName"))
vntArrFirstName	  = ConvIStringToArray(Request("firstName"))
vntArrCsName	  = ConvIStringToArray(Request("csName"))
vntArrBillName    = ConvIStringToArray(Request("billName"))
vntArrKeishou     = ConvIStringToArray(Request("keishou"))

'敬称配列の作成
Call CreateKeishouInfo

Do

	vntDmdDate = Split(strReqDmdDate,",")
	vntBillSeq = Split(strReqBillSeq,",")
	vntBranchNo = Split(strReqBranchNo,",")

	'保存ボタン押下時
	If strAct = "save" Then
		'入力チェック
		strMessage = CheckValue()
		If Not IsEmpty(strMessage) Then
			Exit Do
		End If
		For i = 0 To UBound(vntDmdDate)
			'宛名の保存
			Ret = objPerBill.UpdatePerBill( _
								vntDmdDate(i), vntBillSeq(i), vntBranchNo(i), _
								vntArrBillName(i), vntArrKeishou(i) )

			'保存に失敗した場合
			If Ret <> True Then
				objCommon.AppendArray strMessage, "保存に失敗しました ( " & objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) & " )"
				Exit Do
			End If
		Next
		strAct = "saveend"
	End If

	'保存して印刷または印刷ボタン押下時
	If strAct = "saveprt" Or strAct = "print" Then
		'保存して印刷
		If strAct = "saveprt" Then
			'入力チェック
			strMessage = CheckValue()
			If Not IsEmpty(strMessage) Then
				Exit Do
			End If
			'領収書印刷
			If lngPrtKbn = "1" Then
				'領収書印刷日の編集
				strPrintDate = CStr(Year(Now)) & "/" & CStr(Month(Now)) & "/" & CStr(Day(Now))
				For i = 0 To UBound(vntDmdDate)
					'宛名, 領収書印刷日の保存
					Ret = objPerBill.UpdatePerBill( _
								vntDmdDate(i), vntBillSeq(i), vntBranchNo(i), _
								vntArrBillName(i), vntArrKeishou(i), strPrintDate )
					'保存に失敗した場合
					If Ret <> True Then
						objCommon.AppendArray strMessage, "保存に失敗しました ( " & objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) & " )"
						Exit Do
					End If
				Next
			Else
				For i = 0 To UBound(vntDmdDate)
					'宛名の保存
					Ret = objPerBill.UpdatePerBill( _
								vntDmdDate(i), vntBillSeq(i), vntBranchNo(i), _
								vntArrBillName(i), vntArrKeishou(i) )
					'保存に失敗した場合
					If Ret <> True Then
						objCommon.AppendArray strMessage, "保存に失敗しました ( " & objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) & " )"
						Exit Do
					End If
				Next
			End If
		End If

'#### 2010.06.11 SL-UI-Y0101-239~240 MOD START ####'
'		'エラーがなければ印刷のみを行うHTMLを編集し、完了後自身をCLOSEし呼び出し元を再表示。
'		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'		strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
'		strHTML = strHTML & vbCrLf & "<!--"
'		For i = 0 To UBound(vntDmdDate)
'			strHTML = strHTML & vbCrLf & "var url = '/webHains/contents/report_form/rd_18_prtBill.asp';"
'			strHTML = strHTML & vbCrLf & "url = url + '?p_Uid='      + '" & Session("USERID") & "';"
'			strHTML = strHTML & vbCrLf & "url = url + '&p_ScslDate=' + '" & vntDmdDate(i) & "';"
'			strHTML = strHTML & vbCrLf & "url = url + '&p_BilSeq='   + '" & vntBillSeq(i) & "';"
'			strHTML = strHTML & vbCrLf & "url = url + '&p_BilBan='   + '" & vntBranchNo(i) & "';"
'			strHTML = strHTML & vbCrLf & "url = url + '&p_Option='   + '" & lngPrtKbn & "';"
'			strHTML = strHTML & vbCrLf & "open( url );"
'		Next
''		strHTML = strHTML & vbCrLf & "top.location.replace('" & strURL & "');"
'		strHTML = strHTML & vbCrLf & "//-->"
'		strHTML = strHTML & vbCrLf & "</SCRIPT>"
'		' 呼び出し元が入金情報　
'		If strReqDisp = "perBillIncome" Then
'			strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
'		Else
'			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
'		End If
'		strHTML = strHTML & "</BODY>"
'		strHTML = strHTML & vbCrLf & "</HTML>"
'		Response.Write strHTML
'		Response.End

		'請求書印刷
		if lngPrtKbn = 0 Then

			'情報漏えい対策用ログ書き出し
			Call putPrivacyInfoLog("PH045", "個人請求書画面 請求書の印刷を行った")

			'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
			Set objPrintCls = Server.CreateObject("HainsprtBill.prtBill")
		'領収書印刷
		Else

			'情報漏えい対策用ログ書き出し
			Call putPrivacyInfoLog("PH046", "個人請求書画面 領収書の印刷を行った")

			'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
			Set objPrintCls = Server.CreateObject("HainsprtReceipt.prtReceipt")
		End If

		Redim vntFileName(1)

		'複数印刷対応のため、print.incは未使用
		For intCnt = 0 To UBound(vntDmdDate)
			Redim Preserve vntFileName(intCnt + 1)
			'帳票作成（作成したプリントSEQ、帳票ファイル名を取得）
			lngRet = objPrintCls.PrintOut(Session("USERID"), vntDmdDate(intCnt), vntBillSeq(intCnt), vntBranchNo(intCnt), vntFileName(intCnt))
			If lngRet < 1 Then
				objCommon.AppendArray strMessage, "データがありませんでした。 ( " & objCommon.FormatString(vntDmdDate(intCnt), "yyyymmdd") & _
						objCommon.FormatString(vntBillSeq(intCnt), "00000") & vntBranchNo(intCnt) & " )"
				Exit Do
			End If
		Next

		'エラーがなければ印刷のみを行うHTMLを編集し、完了後自身をCLOSEし呼び出し元を再表示。
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
		strHTML = strHTML & vbCrLf & "<!--"
		'帳票の数分、ウインドウを表示
		For intCnt = 0 To UBound(vntDmdDate)
			strHTML = strHTML & vbCrLf & "var url = '/webHains/contents/print/prtPreview.asp?documentFileName=" & vntFileName(intCnt) & "';"
			strHTML = strHTML & vbCrLf & "open( url );"
		Next
		strHTML = strHTML & vbCrLf & "//-->"
		strHTML = strHTML & vbCrLf & "</SCRIPT>"
		' 呼び出し元が入金情報
		If strReqDisp = "perBillIncome" Then
			strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
		Else
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		End If
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & vbCrLf & "</HTML>"
		Response.Write strHTML
		Response.End
'#### 2010.06.11 SL-UI-Y0101-239~240 MOD END ####'

	End If


	Redim Preserve vntArrRsvNo(UBound(vntDmdDate))			
	Redim Preserve vntArrCslDate(UBound(vntDmdDate))			
	Redim Preserve vntArrPerId(UBound(vntDmdDate))			
	vntArrLastName = Array()
	Redim Preserve vntArrLastName(UBound(vntDmdDate))			
	vntArrFirstName = Array()
	Redim Preserve vntArrFirstName(UBound(vntDmdDate))		
	Redim Preserve vntArrLastKName(UBound(vntDmdDate))		
	Redim Preserve vntArrFirstKName(UBound(vntDmdDate))		
	Redim Preserve vntArrCsCd(UBound(vntDmdDate))				
	vntArrCsName = Array()
	Redim Preserve vntArrCsName(UBound(vntDmdDate))			
	Redim Preserve vntArrDelFlg(UBound(vntDmdDate))			
	Redim Preserve vntArrPrintDate(UBound(vntDmdDate))
	vntArrBillName = Array()
	vntArrKeishou = Array()
	Redim Preserve vntArrBillName(UBound(vntDmdDate))			
	Redim Preserve vntArrKeishou(UBound(vntDmdDate))			
	For i = 0 To UBound(vntDmdDate)
		'請求書Ｎｏから予約番号を取得しそれぞれの受診情報を取得する
		lngCountCsl = objPerbill.SelectPerBill_csl(vntDmdDate(i), _
											vntBillSeq(i), _
											vntBranchNo(i), _
											vntRsvNo, _
											vntCslDate, _
											vntPerId, _
											vntLastName, _
											vntFirstName, _
											vntLastKName, _
											vntFirstKName, _
											vntCsCd, _
											vntCsName )
		'受診情報が存在する場合
		If lngCountCsl > 0 Then
			vntArrRsvNo(i)		= vntRsvNo(0)
            vntArrCslDate(i)	= vntCslDate(0)
            vntArrPerId(i)		= vntPerId(0)
            vntArrLastName(i)	= vntLastName(0)
            vntArrFirstName(i)	= vntFirstName(0)
            vntArrLastKName(i)	= vntLastKName(0)
            vntArrFirstKName(i)	= vntFirstKName(0)
            vntArrCsCd(i)		= vntCsCd(0)
            vntArrCsName(i)		= vntCsName(0)
		End If



		'個人請求管理情報の取得
		''' 宛先、敬称を追加 2003.12.19
		Ret = objPerbill.SelectPerBill_BillNo(vntDmdDate(i), _
											vntBillSeq(i), _
											vntBranchNo(i), _
											vntDelFlg, _
											, , , _
											, _
											, _
											, _
                                            , _
											, _
											, _
											, _
											, _
											, _
											vntPrintDate, _
											vntBillName, _
											vntKeishou )
		If Ret = True Then
            vntArrDelFlg(i)		= vntDelFlg
            vntArrPrintDate(i)	= vntPrintDate
            vntArrBillName(i)	= vntBillName
            vntArrKeishou(i)	= vntKeishou
		End If
	Next


	Exit Do
Loop
'-------------------------------------------------------------------------------
'
' 機能　　 : 入力の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()
	Dim vntArrMessage	'エラーメッセージの集合
	Dim strMessage		'エラーメッセージ

	'各値チェック処理
	With objCommon

		For i = 0 To UBound(vntDmdDate)
			'宛名
			vntArrBillName(i) = .StrConvKanaWide( vntArrBillName(i) )

			strMessage = .CheckWideValue("宛名", vntArrBillName(i), 100)

			If strMessage <> "" Then
				.AppendArray vntArrMessage, strMessage
			End If
		Next

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 敬称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateKeishouInfo()

	Redim Preserve strArrKeishou(1)
	Redim Preserve strArrKeishouName(1)

	strArrKeishou(0) = "様":strArrKeishouName(0) = "様"
	strArrKeishou(1) = "御中":strArrKeishouName(1) = "御中"

End Sub

%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>領収書・請求書印刷</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--


//印刷対象チェック
function checkPrtKbnAct(index) {

	with ( document.entryForm ) {
		prtKbn.value = index;
		chkPrtKbn.value = index;
	}

}

// 宛名保存
function saveBillName() {

	// 自画面を送信
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

//	return false;
}

// 保存して印刷
function savePrint() {


	// 自画面を送信
	document.entryForm.act.value = 'saveprt';
	document.entryForm.submit();

	return false;
}

// 印刷
function printFunc() {


	// 自画面を送信
	document.entryForm.act.value = 'print';
	document.entryForm.submit();

	return false;
}


// ウインドウクローズ
function windowClose() {



	return false;
}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
	<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>領収書・請求書印刷</B></TD>
		</TR>
	</TABLE>
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="reqDisp" VALUE="<%= strReqDisp %>">
	<INPUT TYPE="hidden" NAME="reqdmddate" VALUE="<%= strReqDmdDate %>">
	<INPUT TYPE="hidden" NAME="reqbillseq" VALUE="<%= strReqBillSeq %>">
	<INPUT TYPE="hidden" NAME="reqbranchno" VALUE="<%= strReqBranchNo %>">
<%
	'メッセージの編集
	If strAct <> "" Then

		Select Case strAct

			'保存完了時は「保存完了」の通知
			Case "saveend"
				Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)


			'さもなくばエラーメッセージを編集
			Case Else
				Call EditMessage(strMessage, MESSAGETYPE_WARNING)

		End Select

	End If
%>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR><!-- 修正時 -->
			<% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
                <TD><A HREF="javascript:saveBillName()"><IMG SRC="/webHains/images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="宛名情報を保存します"></A></TD>
                <TD WIDTH="10"></TD>
                <TD><A HREF="javascript:savePrint()"><IMG SRC="/webHains/images/prtsave.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="宛名を保存して印刷します。"></A></TD>
                <TD WIDTH="10"></TD>
                <TD><A HREF="javascript:printFunc()"><IMG SRC="/webHains/images/print.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="印刷のみ実行"></A></TD>
             <% End If %>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR BGCOLOR="#DDDDDD">
			<TD NOWRAP>&nbsp;</TD>
			<TD NOWRAP>宛名</TD>
			<TD NOWRAP>敬称</TD>
		</TR>
<%
		For i = 0 To UBound(vntDmdDate)
			'宛名指定なし？
			If vntArrBillName(i) = "" Then
				vntArrBillName(i) = vntArrLastName(i) & " " & vntArrFirstName(i)
			End If
%>
			<INPUT TYPE="hidden" NAME="lastName" VALUE="<%= vntArrLastName(i) %>">
			<INPUT TYPE="hidden" NAME="firstName" VALUE="<%= vntArrFirstName(i) %>">
			<INPUT TYPE="hidden" NAME="csName" VALUE="<%= vntArrCsName(i) %>">
			<TD NOWRAP><%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %>　<%= vntArrCsName(i) %>　<%= vntArrLastName(i) %> <%= vntArrFirstName(i) %></TD>
			<TD><INPUT TYPE="text" NAME="billName" VALUE="<%= vntArrBillName(i) %>" SIZE="42" MAXLENGTH="50"></TD>
			<TD WIDTH="69"><%= EditDropDownListFromArray("keishou", strArrKeishou, strArrKeishouName, vntArrKeishou(i), NON_SELECTED_DEL) %></TD>
		</TR>
<%
		Next
%>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<tr height="12">
			<td height="12"></td>
			<td height="12"></td>
			<td height="12"></td>
			<td width="69" height="12"></td>
		</tr>
		<TR>
			<INPUT TYPE="hidden" NAME="prtKbn" VALUE="<%= lngPrtKbn %>">
			<TD WIDTH="49">印刷</TD>
			<TD>：</TD>
			<TD COLSPAN="2" NOWRAP>
				<INPUT TYPE="radio" NAME="chkPrtKbn" VALUE="<%= lngPrtKbn %>" <%= IIf(lngPrtKbn = "1", " CHECKED", "") %> ONCLICK="javascript:checkPrtKbnAct('1')"  BORDER="0">領収書印刷　
				<INPUT TYPE="radio" NAME="chkPrtKbn" VALUE="<%= lngPrtKbn %>" <%= IIf(lngPrtKbn = "0", " CHECKED", "") %> ONCLICK="javascript:checkPrtKbnAct('0')"  BORDER="0">請求書印刷
		</TR>
	</TABLE>
	<BR>
	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>
