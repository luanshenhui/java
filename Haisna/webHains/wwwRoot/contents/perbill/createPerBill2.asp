<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求書作成処理（枚数選択） (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------

Dim objCommon				'共通クラス
Dim objDemand				'請求情報アクセス用
Dim objConsult				'受診情報アクセス用
Dim objPerBill				'個人請求情報アクセス用

Dim Ret						'関数戻り値

Dim lngCreateCnt
Dim lngCount				'取得件数
Dim lngBillCount			'取得件数
Dim lngSelectNo				'選択枚数
Dim lngRsvNo				'予約番号

Dim strYear				'請求発生日(年)
Dim strMonth				'請求発生日(月)
Dim strDay				'請求発生日(日)
Dim strDmdDate				'請求日

Dim strUpdUser        			'更新者

'請求書作成用
Dim lngArrPriceSeq             		'ＳＥＱ
Dim lngArrLineNo             		'作成ページ
Dim arrParamSeq             		'パラメータＳＥＱ

'受診情報用変数
Dim strPerId				'個人ID
Dim strCslDate				'受診日
Dim strCsCd					'コースコード
Dim strCsName				'コース名
Dim strLastName				'姓
Dim strFirstName			'名
Dim strLastKName			'カナ姓
Dim strFirstKName			'カナ名
Dim strBirth				'生年月日
Dim strAge					'年齢
Dim strGender				'性別
Dim strGenderName			'性別名称
Dim strKeyDayId				'当日ID

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
Dim vntPaymentDate			'入金日
Dim vntPaymentSeq			'入金Ｓｅｑ


Dim strMode					'処理モード
Dim strAction				'動作モード(保存:"save"、保存完了:"saved")
Dim strHTML
Dim strArrMessage	'エラーメッセージ

Dim i			'ループカウンタ
Dim j			'ループカウンタ
Dim cnt			'カウンタ

strArrMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerBill = Server.CreateObject("HainsPerBill.PerBill")

lngRsvNo       = Request("rsvno")
lngSelectNo    = Request("selectno")
lngArrLineNo   = ConvIStringToArray(Request("lineno"))
lngArrPriceSeq = ConvIStringToArray(Request("arrPriceSeq"))
'lngArrLineNo   = Request("lineno")
strAction      = Request("act")
strMode        = Request("mode")

strYear        = Request("year")
strMonth       = Request("month")
strDay         = Request("day")

strUpdUser     = Session.Contents("userId")

Do

	If strAction = "create" Then

		'請求日の編集
		strDmdDate = CDate(strYear & "/" & strMonth & "/" & strDay)

		'データチェック
		lngCreateCnt = 0
		For i=0 To UBound(lngArrLineNo)
			If lngArrLineNo(i) = "" OR IsNull(lngArrLineNo(i)) Then
				lngArrLineNo(i) = 0
			Else
				If lngArrLineNo(i) <> 0 Then
					lngCreateCnt = lngCreateCnt + 1
				End If
			End If
		Next

		If lngCreateCnt = 0 Then
			strArrMessage = Array("請求書Noを選択して下さい。")
			Exit Do
		End If

		'受診情報から請求書を作成する
		Ret = objPerBill.CreatePerBill_CSL(lngSelectNo, _
						   strDmdDate,  _
						   lngRsvNo,    _
						   lngArrLineNo, _
					 	   lngArrPriceSeq, _
						   strUpdUser)

		'保存に失敗した場合
		If Ret <> True Then
			strArrMessage = Array("請求書の作成に失敗しました。")
'			Err.Raise 1000, , "請求書の作成に失敗しました。（Ret　= " & Ret
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

Do
	'受診情報検索
	Ret = objConsult.SelectRslConsult(lngRsvNo,      _
									  strPerId,      _
									  strCslDate,    _
									  strCsCd,       _
									  strCsName,     _
									  strLastName,   _
									  strFirstName,  _
									  strLastKName,  _
									  strFirstKName, _
									  strBirth,      _
									  strAge,        _
									  strGender,     _
									  strGenderName, _
									  strKeyDayId)

	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	'デフォルト請求日を受診日に設定
	strYear        = IIf(strYear  = "", Year(strCslDate),  strYear )
	strMonth       = IIf(strMonth = "", Month(strCslDate), strMonth)
	strDay         = IIf(strDay   = "", Day(strCslDate),   strDay  )

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
											 vntPaymentDate, _
											 vntPaymentSeq )
	'受診金額情報が存在しない場合
	If lngCount < 1 Then
		Exit Do
	End If

	If strAction = "new" Then
		lngArrLineNo = Array()
		ReDim Preserve lngArrLineNo(lngCount)
	End If

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 選択枚数のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function SelectList( no )

	Dim num

	Redim Preserve strArrSelectNo(lngSelectNo-1)	'枚数
	Redim Preserve strArrSelectName(lngSelectNo-1) 	'名称


	'固定値の編集

	For num =0 To lngSelectNo - 1
		strArrSelectNo(num)  = Cstr(num + 1)
		strArrSelectName(num) = num + 1 & "枚目"
	Next

	'1枚のときはデフォルトで１を表示
	If lngSelectNo = 1 Then
		SelectList = EditDropDownListFromArray("lineno", strArrSelectNo, strArrSelectName, lngArrLineNo(no), NON_SELECTED_DEL)
	Else
		SelectList = EditDropDownListFromArray("lineno", strArrSelectNo, strArrSelectName, lngArrLineNo(no), NON_SELECTED_ADD)
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
<TITLE>請求明細追加</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function createData() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	// モードを指定してsubmit
	document.entryForm.act.value = 'create';
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
<INPUT TYPE="hidden" NAME="act" VALUE="">
<INPUT TYPE="hidden" NAME="RsvNo"   VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="selectno" VALUE="<%= lngSelectNo %>">
<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>請求書作成処理</B></TD>
	</TR>
</TABLE>
<%
	'メッセージの編集
	If strAction <> "" Then
		Select Case strAction
			Case "new"

			'エラーメッセージを編集
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End Select
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD NOWRAP>受診日</TD>
		<TD>：</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></TD>
		<TD WIDTH="10"></TD>
		<TD NOWRAP>予約番号</TD>
		<TD>：</TD>
		<TD><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
	</TR>
	<TR>
		<TD NOWRAP>受診コース</TD>
		<TD>：</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD NOWRAP ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
		<TD NOWRAP><B><%= strLastName & " " & strFirstName %></a></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
		<TD NOWRAP></TD>
		<TD NOWRAP></TD>
	</TR>
	<TR>
		<TD NOWRAP><%= FormatDateTime(strBirth, 1) %>生　<%= strAge %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD NOWRAP>請求発生日</TD>     
		<TD NOWRAP>：</TD>
		<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示" BORDER="0"></A></TD>
		<TD><%= EditSelectNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strYear)) %></TD>
		<TD>年</TD>
		<TD><%= EditSelectNumberList("month", 1, 12, Clng("0" & strMonth)) %></TD>
		<TD>月</TD>
		<TD><%= EditSelectNumberList("day",   1, 31, Clng("0" & strDay  )) %></TD>
		<TD>日</TD>
	</TR>
</TABLE>
<BR>
<!-- 引数情報 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<TR BGCOLOR="CCCCCC">
		<TD NOWRAP ALIGN="RIGHT">請求書No.</TD>
		<TD NOWRAP>請求明細分類</TD>
		<TD NOWRAP ALIGN="RIGHT">　金額</TD>
		<TD NOWRAP ALIGN="RIGHT">調整金額</TD>
		<TD NOWRAP ALIGN="RIGHT">　税額</TD>
		<TD NOWRAP ALIGN="RIGHT">調整税額</TD>
	</TR>
<%
	Do

		For i = 0 To lngCount - 1

			'個人負担情報を表示する。
			If ((vntOrgCd1(i) = "XXXXX") AND (vntOrgCd2(i) = "XXXXX")) Then
%>
			<TR BGCOLOR=#EEEEEE>
<%
				If (vntDmdDate(i) <> "") AND (vntBillSeq(i) <> "") AND (vntBranchNo(i) <> "") Then
%>
					<INPUT TYPE="hidden" NAME="lineno" VALUE="0">
					<TD NOWRAP ALIGN="left">作成済み</TD>
<%
				Else
%>
					<TD NOWRAP><%= SelectList(i) %></TD>
<%
				End If
%>
				<!--- 請求書作成処理へ渡すデータ -->
				<INPUT TYPE="hidden" NAME="arrPriceSeq" VALUE="<%= vntPriceSeq(i) %>">

				<TD NOWRAP><%= vntLineName(i) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax(i)) %></TD>
			</TR>
<%
			End If

		Next

		Exit Do
	Loop
%>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<!-- 修正時 -->
		<TD WIDTH="100%"></TD>
		<TD NOWRAP><A HREF="javascript:createData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で確定する"></A></TD>
		<TD>&nbsp;</TD>
		<TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
