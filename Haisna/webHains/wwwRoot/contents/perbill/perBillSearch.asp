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
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
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
Dim objOrg			'団体情報アクセス用
Dim objPerson			'個人情報アクセス用

Dim strMode			'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget			'ターゲット先のURL
Dim strLineNo              	'親画面の行Ｎｏ

Dim strDmdDate     		'請求日

Dim strArrKey              	'検索キー(空白で分割後のキー）
Dim strStartDmdDate     	'検索条件請求年月日（開始）
Dim strStartYear     		'検索条件請求年（開始）
Dim strStartMonth     		'検索条件請求月（開始）
Dim strStartDay     		'検索条件請求日（開始）
Dim strEndDmdDate     		'検索条件請求日（終了）
Dim strEndYear     			'検索条件請求年（終了）
Dim strEndMonth     		'検索条件請求月（終了）
Dim strEndDay     			'検索条件請求日（終了）
Dim strSearchDmdNo	    	'検索条件請求No
Dim strSearchDmdDate    	'検索条件請求日
Dim lngSearchBillSeq    	'検索条件請求書Ｓｅｑ
Dim lngSearchBranchno   	'検索条件請求書枝番
Dim strOrgCd1		   	'検索条件団体コード１
Dim strOrgCd2		   	'検索条件団体コード２
Dim strOrgName		   	'検索条件団体名
Dim strPerId		   	'検索条件個人ＩＤ
Dim strPerName		   	'検索条件個人名
Dim strLastName         	'検索条件姓
Dim strFirstName        	'検索条件名

Dim lngCheckPayment		'未収請求書のみ表示チェック
Dim lngCheckDel			'取消伝票は表示しないチェック

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
Dim lngPerCount       		'受診者数　－　１
Dim vntOrgSName          	'受診団体略称
Dim vntOrgKName          	'受診団体カナ
Dim vntPrice         		'合計金額
Dim vntTax         		'税金合計
Dim vntTotalPrice        	'請求金額合計
Dim vntPaymentDate      	'入金日
Dim vntPaymentSeq	      	'入金Seq
Dim vntDelflg           	'取消伝票フラグ
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
Dim vntDayId           	    '当日ID
'### 2004/9/29 Updated End

Dim lngBillCnt			'請求書数

Dim i				'カウンタ

Dim lngStartPos				'表示開始位置
Dim lngPageMaxLine			'１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()		'１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName()	'１ページ表示ＭＡＸ行名の配列

Dim Ret				'関数戻り値

Dim strURL					'ジャンプ先のURL

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")
Set objOrg          = Server.CreateObject("HainsOrganization.Organization")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'引数値の取得
'strLineNo         = Request("lineno")
strMode           = Request("mode")
strAction         = Request("act")
'strTarget         = Request("target")
'strDmdDate        = Request("dmddate")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strSearchDmdNo    = Request("searchDmdNo")
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strPerId          = Request("perId")
lngCheckPayment   = Request("checkPaymentVal")
lngCheckDel       = Request("checkDelVal")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

'デフォルトはシステム年月日を適用する
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(Now))
	strEndMonth = CStr(Month(Now))
	strEndDay   = CStr(Day(Now))
End If

lngCheckPayment = IIf( lngCheckPayment = "" , 0, lngCheckPayment)
lngCheckDel = IIf( lngCheckDel = "" , 1, lngCheckDel)

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Call CreatePageMaxLineInfo()

Do
	
	strArrKey = Array()
	Redim Preserve strArrKey(0)

	'検索開始請求日の編集
	strStartDmdDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
	'検索終了請求日の編集
	strEndDmdDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)

	'検索請求書No分解
	If strSearchDmdNo <> "" Then
		strSearchDmdDate = CDate(mid(strSearchDmdNo,1,4) & "/" & mid(strSearchDmdNo,5,2) & "/" & _
									mid(strSearchDmdNo,7,2))
		lngSearchBillSeq = CLng(mid(strSearchDmdNo,9,5))
		lngSearchBranchNo = CLng(mid(strSearchDmdNo,14,1))
	End If

'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する

	'検索条件に従い個人請求書一覧を抽出する
'	lngBillCnt = objPerBill.SelectListPerBill( _
'                    0, 0, lngCheckPayment, lngCheckDel, _
'                    strArrKey, _
'                    strStartDmdDate, strEndDmdDate, _
'                    strOrgCd1 & "", _
'                    strOrgCd2 & "", _
'                    strPerId & "", _
'                    strSearchDmdDate & "", _
'                    lngSearchBillSeq & "", _
'                    lngSearchBranchNo & "", _
'                    vntDmdDate, _
'                    vntBillSeq, _
'                    vntBranchNo, _
'                    vntRsvNo, _
'                    vntCtrPtCd, _
'                    vntCsName, _
'                    vntWebColor, _
'                    vntPerId, _
'                    vntLastName, _
'                    vntFirstName, _
'                    vntLastKName, _
'                    vntFirstkName, _
'                    vntAge, _
'                    vntGender, _
'                    vntPerCount, _
'                    vntOrgSName, _
'                    vntOrgSName, _
'                    vntPrice, _
'                    vntTax, _
'                    vntTotalPrice, _
'                    vntPaymentDate, _
'                    vntPaymentSeq, _
'                    vntDelflg, lngStartPos, lngPageMaxLine _
'                    )
                    
	'検索条件に従い個人請求書一覧を抽出する
	lngBillCnt = objPerBill.SelectListPerBill( _
                    0, 0, lngCheckPayment, lngCheckDel, _
                    strArrKey, _
                    strStartDmdDate, strEndDmdDate, _
                    strOrgCd1 & "", _
                    strOrgCd2 & "", _
                    strPerId & "", _
                    strSearchDmdDate & "", _
                    lngSearchBillSeq & "", _
                    lngSearchBranchNo & "", _
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
                    vntDelflg, lngStartPos, lngPageMaxLine, _
                    vntDayId _
                    )
'### 2004/9/29 Updated End

	'団体コードあり？
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then
		ObjOrg.SelectOrg_Lukes _
    				strOrgCd1, strOrgCd2, _
    			 	 , , strOrgName 
	Else
		strOrgName = ""
	End If 

	'個人ＩＤあり？
	If strPerId <> "" Then
		ObjPerson.SelectPerson_lukes _
    						strPerId, _
    						strLastName, strFirstName 

		strPerName = strLastName & "　" & strFirstName
	Else
		strPerName = ""
	End If 

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
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人請求書の検索</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 未収請求書のみチェック
function checkPaymentAct() {

	with ( document.entryPersearch ) {
		checkPayment.value = (checkPayment.checked ? '1' : '0');
		checkPaymentVal.value = (checkPayment.checked ? '1' : '0');
	}

}
// 取消伝票は表示しないチェック
function checkDelAct() {

	with ( document.entryPersearch ) {
		checkDel.value = (checkDel.checked ? '1' : '0');
		checkDelVal.value = (checkDel.checked ? '1' : '0');
	}

}
// 検索ボタンクリック
function searchClick() {

	with ( document.entryPersearch ) {
		startPos.value = 1;
		submit();
	}

	return false;

}
// アンロード時の処理
function closeGuideWindow() {

	// 団体検索ガイドを閉じる
	orgGuide_closeGuideOrg();

	// 個人検索ガイドを閉じる
	perGuide_closeGuidePersonal();

	//日付ガイドを閉じる
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryPersearch" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="action" VALUE="search">
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= lngStartPos %>">
<BLOCKQUOTE>

<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="635">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="perbill">■</SPAN><FONT COLOR="#000000">個人請求書の検索</FONT></B></TD>
	</TR>
</TABLE>

<BR>
<!-- ここは検索条件 -->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD WIDTH="10" ></TD>
		<TD NOWRAP HEIGHT="27">請求日範囲</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
					<TD>&nbsp;日～&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
					<TD>&nbsp;日</TD>
				</TR>
			</TABLE>
		</TD>
		<TD WIDTH="100"></TD>
		<TD ROWSPAN="4" VALIGN="bottom">
			<A HREF="javascript:searchClick()" ><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></A>
		</TD>
	</TR>
	<TR>
		<TD WIDTH="10" ROWSPAN="2"></TD>
		<TD HEIGHT="27">団体コード</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryPersearch.orgCd1, document.entryPersearch.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="団体検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryPersearch.orgCd1, document.entryPersearch.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<INPUT TYPE="hidden" NAME="txtorgName" VALUE="<%= strOrgName %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD HEIGHT="27">個人ＩＤ</TD>
		<TD>：</TD>
		<TD NOWRAP>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryPersearch.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryPersearch.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
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
		<TD WIDTH="10"></TD>
		<TD HEIGHT="27">請求書No</TD>
		<TD>：</TD>
		<TD NOWRAP><INPUT TYPE="text" NAME="searchDmdNo" SIZE="24"  VALUE="<%= strSearchDmdNo %>">
			<INPUT TYPE="hidden" NAME="checkPaymentVal" VALUE="<%= lngCheckPayment %>">
			<INPUT TYPE="hidden" NAME="checkDelVal" VALUE="<%= lngCheckDel %>">
			<INPUT TYPE="checkbox" NAME="checkPayment" VALUE="1" <%= IIf(lngCheckPayment <> "0", " CHECKED", "") %>  ONCLICK="javascript:checkPaymentAct()" border="0">未収請求書のみ表示　			
			<INPUT TYPE="checkbox" NAME="checkDel" VALUE="1" <%= IIf(lngCheckDel <> "0", " CHECKED", "") %>  ONCLICK="javascript:checkDelAct()" border="0">取消伝票は表示しない
		</TD>
		<TD>　<%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %>　</TD>
	</TR>
</TABLE>

<BR>
<!--ここは検索件数結果--><SPAN STYLE="font-size:9pt;">
「<FONT COLOR="#ff6600"><B><%= strStartYear %>年<%= strStartMonth %>月<%= strStartDay %>日～<%= strEndYear %>年<%= strEndMonth %>月<%= strEndDay %>日</B></FONT>」の請求書一覧を表示しています。
<BR>
対象請求書は <FONT COLOR="#ff6600"><B><%= lngBillCnt %></B></FONT>枚です。 </SPAN>
<BR>
<BR>
<SPAN STYLE="color:#cc9999">●</SPAN><FONT COLOR="black">予約番号をクリックすると予約情報、請求書Noをクリックすると該当する請求書情報が表示されます。</FONT><BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
	<!-- ここは一覧の見出し -->
	<TR BGCOLOR="cccccc">
		<TD NOWRAP>請求書No</TD>
		<TD NOWRAP>対象予約番号</TD>
<!--'### 2004/10/3 Updated by FJTH)ITO 先頭から予約番号の後ろへ位置変更-->
		<TD NOWRAP>請求日</TD>
		<TD NOWRAP>受診コース</TD>
		<TD NOWRAP>個人ID</TD>
<!--'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する-->
		<TD NOWRAP>当日ID</TD>
<!--'### 2004/9/29 Updated End-->
		<TD NOWRAP>個人氏名</TD>
		<TD NOWRAP>他</TD>
		<TD NOWRAP>受診団体</TD>
		<TD NOWRAP ALIGN="right" WIDTH="65">合計</TD>
<!--'### 2004/10/14 Updated by FSIT)Gouda 個人請求書の検索画面に入金日を表示する-->
		<TD NOWRAP>入金日</TD>
<!--'### 2004/10/14 Updated End-->
		<TD NOWRAP ALIGN="right" WIDTH="65">入金</TD>
		<TD NOWRAP ALIGN="left" WIDTH="65">取消伝票</TD>
	</TR>
<%
	If lngBillCnt > 0 Then
	For i = 0 To UBound(vntDelflg)
		If i mod 2 = 0 Then
%>
<!--- 取消伝票はピンク 2004.01.04
			<TR BGCOLOR="#ffffff">
-->
			<TR BGCOLOR=<%= IIf( vntDelflg(i) = "1", "#FFC0CB", "#ffffff") %>>
<%
		Else
%>
<!--- 取消伝票はピンク 2004.01.04
			<TR BGCOLOR="#eeeeee">
-->
			<TR BGCOLOR=<%= IIf( vntDelflg(i) = "1", "#FFC0CB", "#eeeeee") %>>
<%
		End If
%>
<%
			'受診情報あり？
			If vntRsvNo(i) <> "" Then
%>
				<TD NOWRAP><A href="perBillInfo.asp?dmddate=<%= vntDmdDate(i) %>&billseq=<%= vntBillSeq(i) %>&branchno=<%= vntBranchNo(i) %>&rsvno=<%= vntRsvNo(i) %>"><%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %></TD>
<%
			Else
%>
				<TD NOWRAP><A href="createPerBill.asp?mode=update&dmddate=<%= vntDmdDate(i) %>&billseq=<%= vntBillSeq(i) %>&branchno=<%= vntBranchNo(i) %>"><%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %></TD>
<%
			End If
%>
			<TD NOWRAP><A HREF="../Reserve/rsvMain.asp?rsvNo=<%= vntRsvNo(i) %>" TARGET="_blank"><%= vntRsvNo(i) %></A></TD>
<!--'### 2004/10/3 Updated by FJTH)ITO 先頭から予約番号の後ろへ位置変更-->
			<TD NOWRAP><%= vntDmdDate(i) %></TD>
<%
			If IsNull(vntWebColor(i)) = True Then
%>
				<TD NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>"> </FONT><%= vntCsName(i) %></TD>
<%
			Else
%>
				<TD NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>">■ </FONT><%= vntCsName(i) %></TD>
<%
			End If
%>
			<TD NOWRAP><%= vntPerId(i) %></TD>
<!--'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する-->
<%
			If IsNull(vntDayId(i)) = True Then
%>
				<TD NOWRAP><%= vntDayId(i) %></TD>
<%
			Else 
%>
				<TD NOWRAP><%= objCommon.FormatString(vntDayId(i), "0000") %></TD>
<%
			End If
%>
<!--'### 2004/9/29 Updated End-->
<!--- 2004.01.04 名前をクリックしたら個人メンテが表示されるようにする start -->
			<TD NOWRAP><%= vntLastName(i) & " " & vntFirstName(i) %><A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= vntPerId(i) %>"  TARGET="_top"><FONT SIZE="-1" COLOR="#666666">（<%= vntLastKname(i) & "　" & vntFirstKName(i) %>）</FONT></A></TD>
<!--
			<TD NOWRAP><%= vntLastName(i) & " " & vntFirstName(i) %><A HREF="/webHains/contents/demand/dmdMoneyReceive.asp?rsvno=<%= vntRsvNo(i) %>"  TARGET="_top"><FONT SIZE="-1" COLOR="#666666">（<%= vntLastKname(i) & "　" & vntFirstKName(i) %>）</FONT></A></TD>
-->
<!--- 2004.01.04 名前をクリックしたら個人メンテが表示されるようにする end -->
<%
			If vntPerCount(i) = 1 Then
%>
				<TD NOWRAP></TD>
<%
			Else
				lngPerCount = vntPerCount(i) - 1
%>
				<TD NOWRAP><%= lngPerCount %>名</TD>
<%
			End If
%>
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
<!--'### 2004/10/14 Updated by FSIT)Gouda 個人請求書の検索画面に入金日を表示する-->
			<TD NOWRAP ><%= vntPaymentDate(i) %></TD>
<!--'### 2004/10/14 Updated End-->
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

			If vntDelflg(i) = 1 Then
%>
				<TD NOWRAP ALIGN="left">取消</TD>
<%
			Else
%>
				<TD NOWRAP ALIGN="left"></TD>
<%
			End If
%>
		</TR>
<%
	Next
	End If
%>
</TABLE>
<BR>
<%
	If lngBillCnt > 0 Then
			'全件検索時はページングナビゲータ不要
   	     	If lngPageMaxLine <= 0 Then
			Else
				'URLの編集
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?mode="        & strMode
				strURL = strURL & "&act="         & strAction
				strURL = strURL & "&startYear="   & strStartYear
				strURL = strURL & "&startMonth="  & strStartMonth
				strURL = strURL & "&startDay="    & strStartDay
				strURL = strURL & "&endYear="     & strEndYear
				strURL = strURL & "&endMonth="    & strEndMonth
				strURL = strURL & "&endDay="      & strEndDay
				strURL = strURL & "&searchDmdNo=" & strSearchDmdNo
				strURL = strURL & "&orgCd1="      & strOrgCd1
				strURL = strURL & "&orgCd2="      & strOrgCd2
				strURL = strURL & "&perId="       & strPerId
				strURL = strURL & "&checkPaymentVal=" & lngCheckPayment
				strURL = strURL & "&checkDelVal="     & lngCheckDel
				strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
				'ページングナビゲータの編集
'Err.Raise 1000, , lngCount & " " &  lngStartPos & " " & lngPageMaxLine 
%>
				<%= EditPageNavi(strURL, CLng(lngBillCnt), lngStartPos, CLng(lngPageMaxLine)) %>
<%
			End If
%>
		<BR>
<%
	End If
%>
<BR>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="ffffff">.</FONT></DIV>

</BODY>
</HTML>
