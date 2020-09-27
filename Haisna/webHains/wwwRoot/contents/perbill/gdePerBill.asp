<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   個人請求書の検索 (Ver0.0.1)
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

Dim strMode			'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget			'ターゲット先のURL
Dim strLineNo              	'親画面の行Ｎｏ

Dim strDmdDate     		'請求日
Dim strBillSeq     		'請求書Ｓｅｑ(結合先)
Dim strBranchNo     	'請求書枝番(結合先)

Dim lngPaymentflg			'1:未収のみ 0:全て
Dim lngDelDisp				'1:取消伝票除く 0:全て
Dim strKey              	'検索キー
Dim strArrKey              	'検索キー(空白で分割後のキー）
Dim strStartDmdDate     	'検索条件請求日（開始）
Dim strStartYear     		'検索条件請求年（開始）
Dim strStartMonth     		'検索条件請求月（開始）
Dim strStartDay     		'検索条件請求日（開始）
Dim strEndDmdDate     		'検索条件請求日（終了）
Dim strEndYear     			'検索条件請求年（終了）
Dim strEndMonth     		'検索条件請求月（終了）
Dim strEndDay     			'検索条件請求日（終了）
Dim strSearchDmdDate    	'検索条件請求日
Dim lngSearchBillSeq    	'検索条件請求書Ｓｅｑ
Dim lngSearchBranchno   	'検索条件請求書枝番
Dim vntDmdDate          	'請求日
Dim vntBillSeq          	'請求書Ｓｅｑ
Dim vntBranchNo         	'請求書枝番
Dim vntRsvNo            	'予約番号
Dim vntCtrPtCd          	'契約パターンコード
Dim vntCsName           	'コース名
Dim vntWebColor           	'コース色
Dim vntPerId            	'個人ＩＤ
Dim vntLastName         	'姓
Dim vntFirstName        	'名
Dim vntLastKName        	'カナ姓
Dim vntFirstKName       	'カナ名
Dim vntAge       	        '年齢
Dim vntGender           	'性別
Dim vntPerCount       		'受診者数
Dim vntOrgSName          	'受診団体略称
Dim vntOrgKName          	'受診団体カナ
Dim vntPrice         		'合計金額
Dim vntTax         		'税金合計
Dim vntTotalPrice        	'請求金額合計
Dim vntPaymentDate      	'入金日
Dim vntPaymentSeq	      	'入金Seq
Dim vntDelflg           	'取消伝票フラグ

Dim lngBillCnt			'請求書数
Dim lngBillCnt2			'請求書数(同一請求書No.を除いた数)

Dim lngPageMaxLine			'１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()		'１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName()	'１ページ表示ＭＡＸ行名の配列

Dim i				'カウンタ
Dim i2				'カウンタ(同一請求書No.を除いた数)

Dim Ret				'関数戻り値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得
strLineNo         = Request("lineno")
strMode           = Request("mode")
strAction         = Request("act")
strTarget         = Request("target")
'strStartDmdDate   = Request("dmddate")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strDmdDate        = Request("dmddate")
strKey            = Request("textKey")
strBillSeq        = Request("billseq")
strBranchNo       = Request("branchno")
lngPaymentflg	  = Request("paymentflg")
lngDelDisp		  = Request("deldsp")
lngPageMaxLine      = Request("pageMaxLine")

'デフォルトは引数を適用する
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(strDmdDate))
	strStartMonth = CStr(Month(strDmdDate))
	strStartDay   = CStr(Day(strDmdDate))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(strDmdDate))
	strEndMonth = CStr(Month(strDmdDate))
	strEndDay   = CStr(Day(strDmdDate))
End If

Call CreatePageMaxLineInfo()

Do
	
	If strKey <> "" Then
		'検索キーを空白で分割する
		strArrKey = SplitByBlank(strKey)
	Else 
		
		strArrKey  = Array()
		ReDim Preserve strArrKey(0)
	End if

	If lngPaymentflg <> 1 Then lngPaymentflg = 0
	
	'取消伝票は表示しない
	lngDelDisp = 1

	'検索開始請求日の編集
	strStartDmdDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
	'検索終了請求日の編集
	strEndDmdDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)

	'検索条件に従い個人請求書一覧を抽出する
	lngBillCnt = objPerBill.SelectListPerBill( _
                    0, 0, lngPaymentflg, lngDelDisp, _
                    strArrKey, _
                    strStartDmdDate, strEndDmdDate, _
                    "", "", _
                    "", _
                    "", "", _
                    "", _
                    vntDmdDate, _
                    vntBillSeq, _
                    vntBranchNo, _
                    vntRsvNo, _
                    vntCtrPtCd, _
                    vntCsName, _
                    vntWebColor, _
                    vntPerId, _
                    vntLastName, _
                    vntFirstName, _
                    vntLastKName, _
                    vntFirstkName, _
                    vntAge, _
                    vntGender, _
                    vntPerCount, _
                    vntOrgSName, _
                    vntOrgSName, _
                    vntPrice, _
                    vntTax, _
                    vntTotalPrice, _
                    vntPaymentDate, _
                    vntPaymentSeq, _
                    vntDelflg _
                    )

	'請求書数
	lngBillCnt2 = 0
	For i = 0 To lngBillCnt - 1
		'同一の請求書No.は表示しない
		If objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(strBillSeq, "00000") & strBranchNo _
		  <> objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) Then

			lngBillCnt2 = lngBillCnt2 + 1
		End If
	Next

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : １ページ表示ＭＡＸ行の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()


	Redim Preserve lngArrPageMaxLine(4)
	Redim Preserve strArrPageMaxLineName(4)

	lngArrPageMaxLine(0) = 50:strArrPageMaxLineName(0) = "50行ずつ"
	lngArrPageMaxLine(1) = 100:strArrPageMaxLineName(1) = "100行ずつ"
	lngArrPageMaxLine(2) = 200:strArrPageMaxLineName(2) = "200行ずつ"
	lngArrPageMaxLine(3) = 300:strArrPageMaxLineName(3) = "300行ずつ"
	lngArrPageMaxLine(4) = 0:strArrPageMaxLineName(4) = "すべて"
'	lngArrPageMaxLine(0) = 2:strArrPageMaxLineName(0) = "2行ずつ"
'	lngArrPageMaxLine(1) = 3:strArrPageMaxLineName(1) = "3行ずつ"
'	lngArrPageMaxLine(2) = 5:strArrPageMaxLineName(2) = "5行ずつ"
'	lngArrPageMaxLine(3) = 10:strArrPageMaxLineName(3) = "10行ずつ"
'	lngArrPageMaxLine(4) = 0:strArrPageMaxLineName(4) = "すべて"

End Sub

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>個人請求書の検索</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 請求書データのセット
function SelectDmdData( index ) {

	var objForm;		// 自画面のフォームエレメント
	var varPerId;		// 個人ＩＤ
	var varLastName;	// 姓
	var varFirstName;	// 名
	var varLastKName;	// カナ姓
	var varFirstKName;	// カナ名
        var varAge;		// 年齢
        var varGender;		// 性別
	var varRsvNo;		// 予約番号
	var varDmdDate;		// 請求日
	var varBillSeq;		// 請求書Ｓｅｑ
	var varBranchNo;	// 請求書枝番

	objForm = document.entryForm;

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return;
	}

	// 個人ＩＤの取得
	if ( objForm.perid.length != null ) {
		varPerId  = objForm.perid[ index ].value;
	} else {
		varPerId  = objForm.perid.value;
	}

	// 姓の取得
	if ( objForm.lastname.length != null ) {
		varLastName = objForm.lastname[ index ].value;
	} else {
		varLastName = objForm.lastname.value;
	}

	// 名の取得
	if ( objForm.firstname.length != null ) {
		varFirstName = objForm.firstname[ index ].value;
	} else {
		varFirstName = objForm.firstname.value;
	}

	// カナ姓の取得
	if ( objForm.lastkname.length != null ) {
		varLastKName = objForm.lastkname[ index ].value;
	} else {
		varLastKName = objForm.lastkname.value;
	}

	// カナ名の取得
	if ( objForm.firstkname.length != null ) {
		varFirstKName = objForm.firstkname[ index ].value;
	} else {
		varFirstKName = objForm.firstkname.value;
	}

	// 年齢の取得
	if ( objForm.age.length != null ) {
		varAge = objForm.age[ index ].value;
	} else {
		varAge = objForm.age.value;
	}

	// 性別の取得
	if ( objForm.gender.length != null ) {
		varGender = objForm.gender[ index ].value;
	} else {
		varGender = objForm.gender.value;
	}

	// 予約番号の取得
	if ( objForm.rsvno.length != null ) {
		varRsvNo = objForm.rsvno[ index ].value;
	} else {
		varRsvNo = objForm.rsvno.value;
	}

	// 請求日の取得
	if ( objForm.listdmddate.length != null ) {
		varDmdDate = objForm.listdmddate[ index ].value;
	} else {
		varDmdDate = objForm.listdmddate.value;
	}

	// 請求書Ｓｅｑの取得
	if ( objForm.listbillseq.length != null ) {
		varBillSeq = objForm.listbillseq[ index ].value;
	} else {
		varBillSeq = objForm.listbillseq.value;
	}

	// 請求書枝番の取得
	if ( objForm.listbranchno.length != null ) {
		varBranchNo = objForm.listbranchno[ index ].value;
	} else {
		varBranchNo = objForm.listbranchno.value;
	}

	opener.setDmdDataInfo( objForm.lineno.value, varPerId, varLastName, varFirstName, varLastKName, varFirstKName, varAge, varGender, varRsvNo, varDmdDate, varBillSeq, varBranchNo );

	// 画面を閉じる
	opener.winGuidePerBill = null;
	close();

}
//-->

<!--
// アンロード時の処理
function closeGuideWindow() {

	//日付ガイドを閉じる
	calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="search">
<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
<INPUT TYPE="hidden" NAME="lineno" VALUE="<%= strLineNo %>">
<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= strBillSeq %>">
<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= strBranchNo %>">
<INPUT TYPE="hidden" NAME="paymentflg" VALUE="<%= lngPaymentflg %>">
<INPUT TYPE="hidden" NAME="deldsp" VALUE="<%= lngDelDisp %>">
<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD NOWRAP HEIGHT="15" BGCOLOR="#ffffff"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">個人請求書の検索</FONT></B></TD>
	</TR>
</TABLE>
<br>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR height="20">
		<TD NOWRAP WIDTH="10" ROWSPAN="2"></TD>
		<TD NOWRAP height="27">請求日範囲</TD>
		<TD>：</TD>
<!--
		<TD NOWRAP height="20"><b><%= strDmdDate %></b></TD>
-->
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
				<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
				<TD>&nbsp;年&nbsp;</TD>
				<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
				<TD>&nbsp;月&nbsp;</TD>
				<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
				<TD NOWRAP >&nbsp;日～&nbsp;</TD>
				<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
				<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
				<TD>&nbsp;年&nbsp;</TD>
				<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
				<TD>&nbsp;月&nbsp;</TD>
				<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
				<TD>&nbsp;日</TD>
			</TABLE>
		</TD>
		<TD NOWRAP VALIGN="bottom" height="20"></TD>
	</TR>
	<TR>
		<TD NOWRAP>キー</TD>
		<TD NOWRAP>：</TD>
		<TD NOWRAP><INPUT TYPE="text" NAME="textKey" SIZE="24" VALUE="<%= strKey %>"></TD>
		<TD NOWRAP></TD>
	</TR>
	<tr>
		<td NOWRAP width="10"></td>
		<td NOWRAP colspan="3"><input type="checkbox" name="checkboxName" value="checkboxValue" border="0">検査未完了者も表示する</td>
		<td NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false;"><IMG SRC="../../images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></A></td>
	</tr>
</TABLE>
<BR>
<!--ここは検索件数結果--><SPAN STYLE="font-size:9pt;">
	「<FONT COLOR="#ff6600"><B><%= CStr(Year(strStartDmdDate)) %>年<%= CStr(Month(strStartDmdDate)) %>月<%= CStr(Day(strStartDmdDate)) %>日～<%= strEndYear %>年<%= strEndMonth %>月<%= strEndDay %>日</B></FONT>」の請求書一覧を表示しています。<BR>
				対象請求書は <FONT COLOR="#ff6600"><B><%= lngBillCnt2 %></B></FONT>枚です。 </SPAN><BR>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
<!-- ここは一覧の見出し -->
	<TR BGCOLOR="cccccc">
		<TD NOWRAP>請求日</TD>
		<TD NOWRAP>請求書No</TD>
		<TD NOWRAP>対象予約番号</TD>
		<TD NOWRAP>受診コース</TD>
		<TD NOWRAP>個人氏名</TD>
		<TD NOWRAP>受診団体</TD>
		<TD NOWRAP ALIGN="right" WIDTH="65">合計</TD>
		<TD NOWRAP ALIGN="right" WIDTH="65">入金額</TD>
<!--
		<TD NOWRAP ALIGN="left" WIDTH="65">取消伝票</TD>
-->
	</TR>
<%
	i2 = 0
	For i = 0 To lngBillCnt - 1
		If i mod 2 = 0 Then
%>
			<TR BGCOLOR="#ffffff">
<%
		Else
%>
			<TR BGCOLOR="#eeeeee">
<%
		End If

		'同一の請求書No.は表示しない
		If objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(strBillSeq, "00000") & strBranchNo _
		  <> objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) Then
%>
			<INPUT TYPE="hidden" NAME="perid" VALUE="<%= vntPerId(i) %>">
			<INPUT TYPE="hidden" NAME="lastname" VALUE="<%= vntLastName(i) %>">
			<INPUT TYPE="hidden" NAME="firstname" VALUE="<%= vntFirstName(i) %>">
			<INPUT TYPE="hidden" NAME="lastkname" VALUE="<%= vntLastKname(i) %>">
			<INPUT TYPE="hidden" NAME="firstkname" VALUE="<%= vntFirstKName(i) %>">
<%
			If vntAge(i) <> "" Then
%>
				<INPUT TYPE="hidden" NAME="age" VALUE="<%= vntAge(i) %>">
<%
			Else
%>
				<INPUT TYPE="hidden" NAME="age" VALUE="">
<%
			End If
%>
			<INPUT TYPE="hidden" NAME="gender" VALUE="<%= vntGender(i) %>">
			<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= vntRsvNo(i) %>">
			<INPUT TYPE="hidden" NAME="listdmddate" VALUE="<%= vntDmdDate(i) %>">
			<INPUT TYPE="hidden" NAME="listbillseq" VALUE="<%= vntBillSeq(i) %>">
			<INPUT TYPE="hidden" NAME="listbranchno" VALUE="<%= vntBranchNo(i) %>">

			<TD NOWRAP><%= vntDmdDate(i) %></TD>
			<TD NOWRAP><%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %></TD>
			<TD NOWRAP><A HREF="../Reserve/rsvMain.asp?rsvNo=<%= vntRsvNo(i) %>" TARGET="_blank"><%= vntRsvNo(i) %></A></TD>
<%
			If IsNull(vntWebColor(i)) = True Then
%>
			<TD NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>"> </FONT><%= vntCsName(i) %></TD><%
			Else
%>
			<TD NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>">■ </FONT><%= vntCsName(i) %></TD>
<%
			End If
%>
			<TD NOWRAP><A HREF="JavaScript:SelectDmdData(<%= i2 %>)"><%= vntLastName(i) & " " & vntFirstName(i) %><FONT SIZE="-1" COLOR="#666666">（<%= vntLastKname(i) & "　" & vntFirstKName(i) %>）</FONT></A></TD>
			<TD NOWRAP><%= vntOrgSName(i) %></TD>
<%
			If vntToTalPrice(i) = null Then
%>
			<TD NOWRAP ALIGN="right"><B></B></TD>
<%
			Else
%>
			<TD NOWRAP ALIGN="right"><B><%= FormatCurrency(vntToTalPrice(i)) %></B></TD>
<%
			End If
%>
<%
			If vntPaymentDate(i) = "" Then
%>
				<TD NOWRAP ALIGN="right">未収</TD>
<%
			Else
%>
				<TD NOWRAP ALIGN="right"><%= FormatCurrency(vntToTalPrice(i)) %></TD>
<%
			End If

		'''取消伝票自体表示しないのでこの欄も削除
'			If vntDelflg(i) = 1 Then
%>
<!--
				<TD NOWRAP ALIGN="left">取消</TD>
-->
<%
'			Else
%>
<!--
				<TD NOWRAP ALIGN="left"></TD>
-->
<%
'			End If
			i2 = i2 + 1
		End if
%>
		</TR>
<%
	Next
%>
</TABLE>
</FORM>
</BODY>
</HTML>
