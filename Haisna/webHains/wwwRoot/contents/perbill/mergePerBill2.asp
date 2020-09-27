<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   請求書統合処理（統合確認） (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objPerBill			'会計情報アクセス用
Dim objHainsUser		'ユーザ情報アクセス用
Dim objPerson			'個人情報アクセス用

'Dim strMode			'処理モード(表示:"disp"、確定:"save")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")

Dim strHTML			'

Dim vntPerID			'個人ＩＤ
Dim vntDmdDate     		'請求日
Dim vntBillSeq     		'請求書Ｓｅｑ
Dim vntBranchNo     		'請求書枝番

Dim strUpdDate			'更新日付
Dim strUpdUser        		'更新者



Dim lngBillCnt			'指定請求書数

'選択用
Dim arrDmdDate     		'請求日 配列
Dim arrBillSeq     		'請求書Ｓｅｑ 配列
Dim arrBranchNo     		'請求書枝番 配列
Dim arrPerID			'個人ＩＤ 配列
Dim arrLastName			'姓 配列
Dim arrFirstName		'名 配列
Dim arrLastKName		'カナ姓 配列
Dim arrFirstKName		'カナ名 配列
Dim arrPrice     		'金額 配列
Dim arrEditPrice     		'調整金額 配列
Dim arrTaxPrice     		'税額 配列
Dim arrEditTax     		'調整税額 配列
Dim arrPriceTotal     		'請求金額合計 配列

Dim vntBillLineNo		'請求明細行Ｎｏ
Dim vntPrice			'金額
Dim vntEditPrice		'調整金額
Dim vntTaxPrice			'税額
Dim vntEditTax			'調整税額
Dim vntCtrPtCd			'契約パターンコード
Dim vntOptCd			'オプションコード
Dim vntOptBranchNo		'オプション枝番
Dim vntRsvNo			'予約番号
Dim vntPriceSeq			'受診金額Ｓｅｑ
Dim vntLineName			'明細名称
Dim vntOtherLineDivCd		'セット外明細コード

Dim i				'カウンタ
Dim j				'カウンタ

Dim Ret				'関数戻り値


'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'引数値の取得
'strMode           = Request("mode")
strAction         = Request("act")
vntPerId          = Request("perId")
vntDmdDate        = Request("dmdDate")
vntBillSeq        = Request("billSeq")
vntBranchNo       = Request("branchNo")

arrPerId       = ConvIStringToArray(Request("arrperId"))
'arrLastName       = ConvIStringToArray(Request("lastName"))
'arrFirstName       = ConvIStringToArray(Request("firstName"))
'arrLastKName       = ConvIStringToArray(Request("lastKName"))
'arrFirstKName       = ConvIStringToArray(Request("firstKName"))
arrDmdDate       = ConvIStringToArray(Request("arrdmdDate"))
arrBillSeq       = ConvIStringToArray(Request("arrbillSeq"))
arrBranchNo       = ConvIStringToArray(Request("arrbranchNo"))

'arrPrice     = ConvIStringToArray(Request("price"))
'arrEditPrice     = ConvIStringToArray(Request("editPrice"))
'arrTaxPrice     = ConvIStringToArray(Request("taxPrice"))
'arrEditTax     = ConvIStringToArray(Request("editTax"))
'arrPriceTotal     = ConvIStringToArray(Request("priceTotal"))

strUpdDate	  = Request("updDate")
strUpdUser        = Session.Contents("userId")

'lngBillCnt       = Request("billcnt")

'初期値設定
lngBillCnt   = IIf(IsNumeric(lngBillCnt) = False, 0,  lngBillCnt )
'strMode   = IIf(strMode = "", "init",  strMode )


'チェック・更新・読み込み処理の制御
Do


	arrPerId = Split(vntPerId,",")
	arrDmdDate = Split(vntDmdDate,",")
	arrBillSeq = Split(vntBillSeq,",")
	arrBranchNo = Split(vntBranchNo,",")

	arrLastName = Array()
	Redim Preserve arrLastName(UBound(arrPerId))
	arrFirstName = Array()
	Redim Preserve arrFirstName(UBound(arrPerId))
	arrLastKName = Array()
	Redim Preserve arrLastKName(UBound(arrPerId))
	arrFirstKName = Array()
	Redim Preserve arrFirstKName(UBound(arrPerId))
	arrPrice = Array()
	Redim Preserve arrPrice(UBound(arrPerId))
	arrEditPrice = Array()
	Redim Preserve arrEditPrice(UBound(arrPerId))
	arrTaxPrice = Array()
	Redim Preserve arrTaxPrice(UBound(arrPerId))
	arrEditTax = Array()
	Redim Preserve arrEditTax(UBound(arrPerId))
	arrPriceTotal = Array()
	Redim Preserve arrPriceTotal(UBound(arrPerId))

	For i = 0 To UBound(arrPerId)
		
		If arrPerId(i) <> Empty  Then
			'個人ＩＤより氏名を取得する
			Ret = objPerson.SelectPerson_lukes(arrPerId(i), _
							arrLastName(i), _
							arrFirstName(i), _
							arrLastKName(i), _
							arrFirstKName(i) )
			'個人情報が存在しない場合
			If Ret = False Then
				Err.Raise 1000, , "個人情報が取得できません。（個人ＩＤ　= " & arrPerId(i) &" ）"
			End If

			'請求書Ｎｏから個人請求書管理情報を取得する
			Ret = objPerbill.SelectPerBill_BillNo (arrDmdDate(i), _
						   arrBillSeq(i), _
						   arrBranchNo(i), _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   arrPrice(i), _
						   arrEditPrice(i), _
						   arrTaxPrice(i), _
						   arrEditTax(i), _
						   arrPriceTotal(i) )
			'個人情報が存在しない場合
'			If Ret = False Then
'				Err.Raise 1000, , "請求書情報が取得できません。（請求書No　= " & objCommon.FormatString(arrDmdDate(i), "yyyymmdd") & objCommon.FormatString(arrBillSeq(i), "00000") & arrBranchNo(i) &" ）"
'			End If
		End If
	Next

	'確定ボタン押下時
	If strAction = "save" Then
		
		For i = 1 To UBound(arrPerId)
			If arrPerId(i) <> Empty  Then

				'請求書統合処理を行う
				Ret = objPerbill.MergePerBill(arrDmdDate(0), _
								arrBillSeq(0), _
								arrBranchNo(0), _
								arrDmdDate(i), _
								arrBillSeq(i), _
								arrBranchNo(i) _
								) 
				'更新エラー時は処理を抜ける
				If Ret = False Then
					Err.Raise 1000, , "請求書統合に失敗しました。１"
				End If

				'元の請求書を取り消す
				Ret = objPerbill.DeletePerBill( _
								arrDmdDate(i), _
								arrBillSeq(i), _
								arrBranchNo(i), _
								strUpdUser _
								)
				If Ret = False Then
					Err.Raise 1000, , "元の請求書の取消に失敗しました。"
				End If
			End If
		Next

		'エラーがなければ呼び元画面を再表示して自身を閉じる
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End
		Exit Do
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
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>請求統合処理</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!---
// 請求書統合
function savePerBill() {

	document.entryForm.act.value = 'save';
	document.entryForm.submit();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>請求統合処理</B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<TR>
		<TD NOWRAP WIDTH="342"><SPAN STYLE="color:#cc9999">●</SPAN>以下の請求書を統合します。</TD>
		<TD NOWRAP WIDTH="77"><A HREF="javascript:savePerBill()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
		<TD><A HREF="JavaScript:history.back();"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る" BORDER="0"></A></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="perId"  VALUE="<%= vntPerId %>"> 
	<INPUT TYPE="hidden" NAME="dmdDate"  VALUE="<%= vntDmdDate %>"> 
	<INPUT TYPE="hidden" NAME="billSeq"  VALUE="<%= vntBillSeq %>"> 
	<INPUT TYPE="hidden" NAME="branchNo"  VALUE="<%= vntBranchNo %>"> 

	<TR BGCOLOR="#cccccc" ALIGN="right">
		<TD NOWRAP ALIGN="left">個人ＩＤ</TD>
		<TD NOWRAP ALIGN="left">氏名</TD>
		<TD NOWRAP>金額</TD>
		<TD NOWRAP>調整金額</TD>
		<TD NOWRAP>税額</TD>
		<TD NOWRAP>調整税額</TD>
		<TD NOWRAP>請求金額</TD>
		<TD NOWRAP>請求書No.</TD>
	</TR>
<%
	For i = 0 To UBound(arrPerId)
%>
		<INPUT TYPE="hidden" NAME="arrperId"  VALUE="<%= arrPerId(i) %>"> 
		<INPUT TYPE="hidden" NAME="arrdmdDate"  VALUE="<%= arrDmdDate(i) %>"> 
		<INPUT TYPE="hidden" NAME="arrbillSeq"  VALUE="<%= arrBillSeq(i) %>"> 
		<INPUT TYPE="hidden" NAME="arrbranchNo"  VALUE="<%= arrBranchNo(i) %>"> 
		<INPUT TYPE="hidden" NAME="lastName"  VALUE="<%= arrLastName(i) %>"> 
		<INPUT TYPE="hidden" NAME="firstName"  VALUE="<%= arrFirstName(i) %>"> 
		<INPUT TYPE="hidden" NAME="lastKName"  VALUE="<%= arrLastKName(i) %>"> 
		<INPUT TYPE="hidden" NAME="firstKName"  VALUE="<%= arrFirstKName(i) %>"> 
		<INPUT TYPE="hidden" NAME="price"  VALUE="<%= arrPrice(i) %>"> 
		<INPUT TYPE="hidden" NAME="editPrice"  VALUE="<%= arrEditPrice(i) %>"> 
		<INPUT TYPE="hidden" NAME="taxPrice"  VALUE="<%= arrTaxPrice(i) %>"> 
		<INPUT TYPE="hidden" NAME="editTax"  VALUE="<%= arrEditTax(i) %>"> 
		<INPUT TYPE="hidden" NAME="priceTotal"  VALUE="<%= arrPriceTotal(i) %>"> 
<%
		If arrPerId(i) <> Empty  Then
%>
			<TR BGCOLOR=#EEEEEE>
				<TD NOWRAP><%= arrPerId(i) %></TD>
				<TD NOWRAP ALIGN="left"><SPAN STYLE="font-size:9px;"><B><%= arrLastKName(i) %></B>　<B><%= arrFirstKName(i) %></B><BR></SPAN><%= arrLastName(i) %>　<%= arrFirstName(i) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(arrPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(arrEditPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(arrTaxPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(arrEditTax(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(arrPriceTotal(i)) %></B></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= objCommon.FormatString(arrDmdDate(i), "yyyymmdd") & objCommon.FormatString(arrBillSeq(i), "00000") & arrBranchNo(i) %></TD>
			</TR>
<%
		End If
	Next
%>
</TABLE>
</FORM>
</BODY>
</HTML>
