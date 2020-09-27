<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	団体別予約受診料金統計 (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode			'印刷モード
Dim vntMessage		'通知メッセージ
Dim strHdnMode

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon		'共通クラス
Dim objOrganization	'団体情報アクセス用
Dim objOrgBsd		'事業部情報アクセス用
Dim objOrgRoom		'室部情報アクセス用
Dim objOrgPost		'所属情報アクセス用
Dim objPerson		'個人情報アクセス用

'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim strYear					'開始年
Dim strOrgCd1				'団体コード11
Dim strOrgCd2				'団体コード12
Dim strOrgCd3				'団体コード21
Dim strOrgCd4				'団体コード22
Dim strOrgCd5				'団体コード31
Dim strOrgCd6				'団体コード32
Dim strOrgCd7				'団体コード41
Dim strOrgCd8				'団体コード42
Dim strOrgCd9				'団体コード51
Dim strOrgCd10				'団体コード52
Dim strOrgCd11				'団体コード61
Dim strOrgCd12				'団体コード62
Dim strOrgCd13				'団体コード71
Dim strOrgCd14				'団体コード72
Dim strOrgCd15				'団体コード81
Dim strOrgCd16				'団体コード82
Dim strOrgCd17				'団体コード91
Dim strOrgCd18				'団体コード92
Dim strOrgCd19				'団体コード101
Dim strOrgCd20				'団体コード102

'2006/02/27		Add by　李 ST) -----------------------
Dim strOrgGrpCd1			'団体グループコード1
Dim strOrgGrpCd2			'団体グループコード2
Dim strOrgGrpCd3			'団体グループコード3
Dim strOrgGrpCd4			'団体グループコード4
Dim strOrgGrpCd5			'団体グループコード5
Dim strOrgGrpCd6			'団体グループコード6
Dim strOrgGrpCd7			'団体グループコード7
Dim strOrgGrpCd8			'団体グループコード8
Dim strOrgGrpCd9			'団体グループコード9
Dim strOrgGrpCd10			'団体グループコード10
Dim strOrgView
'2006/02/27		Add by　李 ED) -----------------------

Dim strTYear				'抽出年度
Dim strContents	    			'集計内容
Dim strTarget				'集計対象
Dim strOrgMethod			'団体指定方法
Dim strSort				'ソート
Dim strSysDate				'起動日
Dim strSCslYear				'起動年
Dim strSCslMonth			'起動月
Dim strSCslDay				'起動日
Dim UID

'■■■■■■■■■■
'作業用変数
Dim P_Month	
Dim strOrgName		'団体名
Dim i
Dim Flg
Dim PriFlg

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'共通引数値の取得
strMode = Request("mode")
PriFlg = 0
strHdnMode = Request("hdn_Mode")
strOrgView = Request("hdn_OrgView")

if strOrgView = "" then
    strOrgView = "0"
end if

if strHdnMode <> "XX" then
	'帳票出力処理制御
	vntMessage = PrintControl(strMode)
else
	Call GetQueryString()
end if

'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
Sub GetQueryString()
'■■■■■■■■■■ 画面項目にあわせて編集
	'括弧内の文字列はHTML部で記述した項目の名称となります

'◆ 抽出年度
	If IsEmpty(Request("strCslYear")) Then
		strYear  = Year(Now())
		strTYear   = Year(Now())
		P_Month = Month(Now())
		If P_Month < 4 Then
			strTYear = strTYear - 1
			strYear  = Year(Now()) - 1
		End If
	Else
		strTYear   = Request("strCslYear")		'抽出年度
        strYear = strTYear
	End If
	
	strSCslYear   = Year(Now())			'起動年
	strSCslMonth  = Month(Now())			'起動月
	strSCslDay    = Day(Now())			'起動日
	strSysDate    = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay	'起動年月日

'◆ 集計内容
	strContents 	= Request("Contents")		'集計内容

'◆ 集計対象
	strTarget	= Request("Target")		'集計対象

'◆ 団体指定方法
	strOrgMethod	= Request("OrgMethod")		'団体指定方法

'◆ 団体１～１０
	strOrgCd1       = Request("orgCd1")			'団体１のコード１
	strOrgCd2       = Request("orgCd2")			'団体１のコード２
	strOrgCd3		= Request("orgCd3")			'団体２のコード１
	strOrgCd4		= Request("orgCd4")			'団体２のコード２
	strOrgCd5		= Request("orgCd5")			'団体３のコード１
	strOrgCd6		= Request("orgCd6")			'団体３のコード２
	strOrgCd7		= Request("orgCd7")			'団体４のコード１
	strOrgCd8		= Request("orgCd8")			'団体４のコード２
	strOrgCd9		= Request("orgCd9")			'団体５のコード１
	strOrgCd10		= Request("orgCd10")		'団体５のコード２
	strOrgCd11		= Request("orgCd11")		'団体６のコード１
	strOrgCd12		= Request("orgCd12")		'団体６のコード２
	strOrgCd13		= Request("orgCd13")		'団体７のコード１
	strOrgCd14		= Request("orgCd14")		'団体７のコード２
	strOrgCd15		= Request("orgCd15")		'団体８のコード１
	strOrgCd16		= Request("orgCd16")		'団体８のコード２
	strOrgCd17		= Request("orgCd17")		'団体９のコード１
	strOrgCd18		= Request("orgCd18")		'団体９のコード２
	strOrgCd19		= Request("orgCd19")		'団体１０のコード１
	strOrgCd20		= Request("orgCd20")		'団体１０のコード２


' 2006.03.01  Add by 李　ST) ---------------------------------------
'◆ 団体グループ１～１０
	strOrgGrpCd1	= Request("OrgGrpCd1")		'団体グループ１のコード
	strOrgGrpCd2	= Request("OrgGrpCd2")		'団体グループ２のコード
	strOrgGrpCd3	= Request("OrgGrpCd3")		'団体グループ３のコード
	strOrgGrpCd4	= Request("OrgGrpCd4")		'団体グループ４のコード
	strOrgGrpCd5	= Request("OrgGrpCd5")		'団体グループ５のコード
	strOrgGrpCd6	= Request("OrgGrpCd6")		'団体グループ６のコード
	strOrgGrpCd7	= Request("OrgGrpCd7")		'団体グループ７のコード
	strOrgGrpCd8	= Request("OrgGrpCd8")		'団体グループ８のコード
	strOrgGrpCd9	= Request("OrgGrpCd9")		'団体グループ９のコード
	strOrgGrpCd10	= Request("OrgGrpCd10")		'団体グループ１０のコード

' 2006.03.01  Add by 李　ED) ---------------------------------------	


'◆ ソート
	strSort         = Request("Sort")		'ソート

'■■■■■■■■■■
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
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
	Dim aryChkString
	
	aryChkString = Array("1","2","3","4","5","6","7","8","9","0")

	'ここにチェック処理を記述
	With objCommon

		If strMode <> "" Then
			
			Flg = 0
			If strOrgMethod = 1 Then
				If Len(strOrgCd1) = 0 Or Len(strOrgCd2) = 0 Or Len(strOrgCd3) = 0 Or Len(strOrgCd4) = 0 Then	
						Flg = 1
				End if
			ElseIf strOrgMethod = 2 Then
				If Len(strOrgCd1) <> 0 Or Len(strOrgCd2) <> 0 Or Len(strOrgCd3) <> 0 Or Len(strOrgCd4) <> 0 Or Len(strOrgCd5) <> 0 Or _
				   Len(strOrgCd6) <> 0 Or Len(strOrgCd7) <> 0 Or Len(strOrgCd8) <> 0 Or Len(strOrgCd9) <> 0 Or Len(strOrgCd10) <> 0 Or _
				   Len(strOrgCd11) <> 0 Or Len(strOrgCd12) <> 0 Or Len(strOrgCd13) <> 0 Or Len(strOrgCd14) <> 0 Or Len(strOrgCd15) <> 0 Or _
				   Len(strOrgCd16) <> 0 Or Len(strOrgCd17) <> 0 Or Len(strOrgCd18) <> 0 Or Len(strOrgCd19) <> 0 Or Len(strOrgCd20) <> 0 Then
					Flg = 0
				Else
					Flg = 2
				End If
			End If
									
		End If

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If



End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票ドキュメントファイル作成処理
'
' 引数　　 :
'
' 戻り値　 : 印刷ログ情報のシーケンス値
'
' 備考　　 : 帳票ドキュメントファイル作成メソッドを呼び出す。メソッド内では次の処理が行われる。
' 　　　　   ?@印刷ログ情報の作成
' 　　　　   ?A帳票ドキュメントファイルの作成
' 　　　　   ?B処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objPrintCls  	'団体一覧出力用COMコンポーネント
	Dim objPrintCls2	
	
	Dim Ret			'関数戻り値
	Dim Ret2
	
	
	If Not IsArray(CheckValue()) Then

		'団体別予約受診金額統計帳票
		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
		Set objPrintCls = Server.CreateObject("HainsprtOrgConPay.prtOrgConsultPay")

		If strContents = 0 Then
			'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
			Ret = objPrintCls.PrintOut(Session("USERID"), Cdate(strSysDate), strTYear, strContents, strTarget, strOrgMethod, _
						   strOrgCd1, strOrgCd2, strOrgCd3, strOrgCd4, strOrgCd5, _
						   strOrgCd6, strOrgCd7, strOrgCd8, strOrgCd9, strOrgCd10, _
						   strOrgCd11, strOrgCd12, strOrgCd13, strOrgCd14, strOrgCd15, _
						   strOrgCd16, strOrgCd17, strOrgCd18, strOrgCd19, strOrgCd20, _
						   strSort)
			print = Ret		
		
		''団体グループ別
		Else
			Ret = objPrintCls.PrintOut(Session("USERID"), Cdate(strSysDate), strTYear, strContents, strTarget, strOrgMethod, _
						   strOrgGrpCd1, strOrgGrpCd2, strOrgGrpCd3, strOrgGrpCd4, strOrgGrpCd5, _
						   strOrgGrpCd6, strOrgGrpCd7, strOrgGrpCd8, strOrgGrpCd9, strOrgGrpCd10, _
						   , , , , , _
						   , , , , , _
						   strSort)
			print = Ret				
		End if
		
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- ◆ ↓<Title>の修正を忘れないように ◆ -->
<TITLE>団体別予約受診人数・料金統計</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体画面表示
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {
    // 団体情報エレメントの参照設定
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );
    // 画面表示
    orgPostGuide_showGuideOrg();
}

// 団体情報削除
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {
    // 団体情報エレメントの参照設定
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );

    // 削除
    orgPostGuide_clearOrgInfo();
}

function checkDisp(sval) {
    document.entryForm.hdn_OrgView.value = sval ;
	document.entryForm.hdn_Mode.value = "XX" ;
   // alert ('sval = ' + sval);
	parent.document.entryForm.submit();
}

-->
</SCRIPT>

<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

<!--- タイトル -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN>団体別予約受診料金統計</B></TD>
		</TR>
	</TABLE>
	<BR>

<%
'エラーメッセージ表示
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<BR>
<!--- 抽出年度 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>■</TD>
			<TD WIDTH="90" NOWRAP>抽出年度</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strYear, False) %></TD>
			<TD>年度</TD>
		</TR>
	</TABLE>
	
<!-- 集計内容 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>■</TD>
			<TD WIDTH="90" NOWRAP>集計方法</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="Radio" NAME="Contents" VALUE="<%= strOrgView %>" <%= IIf(strOrgView = "0", "CHECKED", "") %> ONCLICK="javascript:checkDisp('0')" >団体別集計</TD>
						<TD><INPUT TYPE="Radio" NAME="Contents" VALUE="<%= strOrgView %>" <%= IIf(strOrgView = "1", "CHECKED", "") %> ONCLICK="javascript:checkDisp('1')" >団体グループ別集計</TD>
                        
                        <TD><INPUT TYPE="hidden" NAME="hdn_OrgView" ></TD>
						<TD><INPUT TYPE="hidden" NAME="hdn_Mode" ></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	
<!-- 集計対象 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>■</TD>
			<TD WIDTH="90" NOWRAP>集計対象</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="Radio" NAME="Target" VALUE="0" <%= "CHECKED" %> >今回分</TD>
						<TD><INPUT TYPE="Radio" NAME="Target" VALUE="1" >２年比較</TD>
						
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

<!-- 団体指定方法  -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>■</TD>
			<TD WIDTH="90" NOWRAP>団体指定方法</TD>
			<TD>：</TD>
			<TD>
				<select name="OrgMethod" size="1">
					<option selected value="0">全て</option>
					<option value="2">個別指定(１０団体まで指定可)</option>
				</select>
			</TD>
		</TR>
	</TABLE>

		
<% if strOrgView = "0"  or  strOrgView = "" then  %>

	<!-- 団体１ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体１</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName1"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<% = strOrgCd1 %>">
					<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<% = strOrgCd2 %>">
				</TD>
			</TR>
		</TABLE>
		
	<!-- 団体２ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体２</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd3, document.entryForm.orgCd4, 'orgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd3, document.entryForm.orgCd4, 'orgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName2"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd3" VALUE="<% = strOrgCd3 %>">
					<INPUT TYPE="hidden" NAME="orgCd4" VALUE="<% = strOrgCd4 %>">
				</TD>
			</TR>
		</TABLE>
			
	<!-- 団体３ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体３</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd5, document.entryForm.orgCd6, 'orgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd5, document.entryForm.orgCd6, 'orgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName3"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd5" VALUE="<% = strOrgCd5 %>">
					<INPUT TYPE="hidden" NAME="orgCd6" VALUE="<% = strOrgCd6 %>">
				</TD>
			</TR>
		</TABLE>
		
	<!-- 団体４ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体４</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd7, document.entryForm.orgCd8, 'orgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd7, document.entryForm.orgCd8, 'orgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName4"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd7" VALUE="<% = strOrgCd7 %>">
					<INPUT TYPE="hidden" NAME="orgCd8" VALUE="<% = strOrgCd8 %>">
				</TD>
			</TR>
		</TABLE>
			
	<!-- 団体５ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体５</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd9, document.entryForm.orgCd10, 'orgName5')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd9, document.entryForm.orgCd10, 'orgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName5"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd9" VALUE="<% = strOrgCd9 %>">
					<INPUT TYPE="hidden" NAME="orgCd10" VALUE="<% = strOrgCd10 %>">
				</TD>
			</TR>
		</TABLE>

	<!-- 団体６ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体６</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'orgName6')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'orgName6')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName6"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd11" VALUE="<% = strOrgCd11 %>">
					<INPUT TYPE="hidden" NAME="orgCd12" VALUE="<% = strOrgCd12 %>">
				</TD>
			</TR>
		</TABLE>
			
	<!-- 団体７ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体７</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd13, document.entryForm.orgCd14, 'orgName7')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd13, document.entryForm.orgCd14, 'orgName7')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName7"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd13" VALUE="<% = strOrgCd13 %>">
					<INPUT TYPE="hidden" NAME="orgCd14" VALUE="<% = strOrgCd14 %>">
				</TD>
			</TR>
		</TABLE>
		
	<!-- 団体８ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体８</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd15, document.entryForm.orgCd16, 'orgName8')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd15, document.entryForm.orgCd16, 'orgName8')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName8"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd15" VALUE="<% = strOrgCd15 %>">
					<INPUT TYPE="hidden" NAME="orgCd16" VALUE="<% = strOrgCd16 %>">
				</TD>
			</TR>
		</TABLE>
			
	<!-- 団体９ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体９</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd17, document.entryForm.orgCd18, 'orgName9')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd17, document.entryForm.orgCd18, 'orgName9')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName9"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd17" VALUE="<% = strOrgCd17 %>">
					<INPUT TYPE="hidden" NAME="orgCd18" VALUE="<% = strOrgCd18 %>">
				</TD>
			</TR>
		</TABLE>

	<!-- 団体１０ -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体１０</TD>
				<TD>：</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd19, document.entryForm.orgCd20, 'orgName10')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd19, document.entryForm.orgCd20, 'orgName10')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD NOWRAP><SPAN ID="orgName10"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd19" VALUE="<% = strOrgCd19 %>">
					<INPUT TYPE="hidden" NAME="orgCd20" VALUE="<% = strOrgCd20 %>">
				</TD>
			</TR>
		</TABLE>
		<BR>

<%  Else  %>

		<!-- 団体グループ１-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ１</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd1", strOrgGrpCd1, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- 団体グループ２-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ２</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd2", strOrgGrpCd2, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- 団体グループ３-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ３</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd3", strOrgGrpCd3, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- 団体グループ４-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ４</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd4", strOrgGrpCd4, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>
		<!-- 団体グループ５-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ５</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd5", strOrgGrpCd5, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- 団体グループ６-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ６</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd6", strOrgGrpCd6, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- 団体グループ７-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ７</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd7", strOrgGrpCd7, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- 団体グループ８-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ８</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd8", strOrgGrpCd8, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- 団体グループ９-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ９</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd9", strOrgGrpCd9, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- 団体グループ１０-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>□</TD>
				<TD WIDTH="90" NOWRAP>団体グループ１０</TD>
				<TD>：</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd10", strOrgGrpCd10, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

<%  End If %>
	


<!-- ソート -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>■</TD>
			<TD WIDTH="90" NOWRAP>ソート</TD>
			<TD>：</TD>
			<TD>
				<select name="Sort" size="1">
					<option selected value="0">団体コード順</option>
					<option value="1">団体カナ名順</option>
					<option value="2">金額順</option>
				</select>
			</TD>
		</TR>
		
	</TABLE>
	
<!--- 印刷モード -->
<%
	'印刷モードの初期設定
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
			<TD NOWRAP>プレビュー</TD>

			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
			<TD NOWRAP>直接出力</TD>
		</TR>
-->
	</TABLE>

	<BR>

<!--- 印刷ボタン -->
	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
	<%  End if  %>

	</BLOCKQUOTE>
	


</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>

