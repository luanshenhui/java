<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(契約外受診項目の負担事業所指定) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objContract			'契約情報アクセス用
Dim objContractControl	'契約管理情報アクセス用

'引数値
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strCtrPtCd			'契約パターンコード
Dim strApDiv			'適用元区分
Dim strSeq				'SEQ
Dim strBdnOrgCd1		'団体コード1
Dim strBdnOrgCd2		'団体コード2
Dim strArrOrgName		'団体名称
Dim strNoCtr			'契約外項目負担フラグ
Dim strFraction			'契約外項目端数負担フラグ
Dim strOrgDiv			'団体種別
Dim lngCount			'契約パターン負担元レコード数

'契約管理情報
Dim strOrgName			'団体名
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日

Dim strStrDate			'編集用の契約開始日
Dim strEndDate			'編集用の契約終了日
Dim strHTML				'HTML編集用
Dim strMessage			'エラーメッセージ
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'引数値の取得
strOrgCd1     = Request("orgCd1")
strOrgCd2     = Request("orgCd2")
strCtrPtCd    = Request("ctrPtCd")
strApDiv      = ConvIStringToArray(Request("apDiv"))
strSeq        = ConvIStringToArray(Request("seq"))
strBdnOrgCd1  = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2  = ConvIStringToArray(Request("bdnOrgCd2"))
strArrOrgName = ConvIStringToArray(Request("orgName"))
strNoCtr      = ConvIStringToArray(Request("noCtr"))
strFraction   = ConvIStringToArray(Request("fraction"))
strOrgDiv     = ConvIStringToArray(Request("orgDiv"))

'チェック・更新・読み込み処理の制御
Do
	'保存ボタン押下時
	If Not IsEmpty(Request("save.x")) Then

		'契約外項目の負担情報更新
		If objContractControl.UpdateOuterContract(strOrgCd1, strOrgCd2, strCtrPtCd, strSeq, strBdnOrgCd1, strBdnOrgCd2, strNoCtr, strFraction) <> 0 Then
			strMessage = "この契約情報の負担元情報は変更されています。更新できません。"
			Exit Do
		End If

		'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

		Exit Do
	End If

	'契約パターン負担元管理情報を読み込む
	lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, , , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , , , , , , strNoCtr, strFraction, , , strOrgDiv)
	If lngCount <= 0 Then
		Exit Do
	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>契約外受診項目の負担元指定</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 契約外項目負担チェック時の制御
function checkNoCtr( index ) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	// チェックボックスの制御
	checkNoCtrOrg( ( myForm.noCtrOrg[ index ].checked ? index : null ) );

	// hiddenデータとチェックボックス状態との同期制御

	// 負担元が単数の場合
	if ( !myForm.noCtr.length ) {
		myForm.noCtr.value = setNoCtr( myForm.noCtrOrg.checked );
		return;
	}

	// 負担元が複数の場合
	for ( i = 0; i < myForm.noCtr.length; i++ ) {
		myForm.noCtr[ i ].value = setNoCtr( myForm.noCtrOrg[ i ].checked );
	}

}

// 指定インデックスのチェックボックスのみonにする
// (インデックス未指定時はすべてoff)
function checkNoCtrOrg( index ) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	// 負担元が単数の場合
	if ( !myForm.noCtrOrg.length ) {
		myForm.noCtrOrg.checked = ( index != null );
		return;
	}

	// 負担元が複数の場合

	// 一旦全てのチェックボックスをoffにする
	for ( i = 0; i < myForm.noCtrOrg.length; i++ ) {
		myForm.noCtrOrg[ i ].checked = false;
	}

	// 指定インデックスのチェックボックスのみonにする
	if ( index != null ) {
		myForm.noCtrOrg[ index ].checked = true;
	}

}

// hiddenデータのセット
function setNoCtr( check ) {

	return ( check ? '1' : '0' );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">契約外受診項目の負担元指定</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'契約情報の読み込み
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If

	'編集用の契約開始日設定
	If Not IsEmpty(dtmStrDate) Then
		strStrDate = FormatDateTime(dtmStrDate, 1)
	End If

	'編集用の契約終了日設定
	If Not IsEmpty(dtmEndDate) Then
		strEndDate = FormatDateTime(dtmEndDate, 1)
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>対象コース</TD>
			<TD>：</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>契約期間</TD>
			<TD>：</TD>
			<TD><B><%= strStrDate %>～<%= strEndDate %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#CC9999">●</FONT>&nbsp;契約外受診項目の料金を負担する事業所を指定して下さい。<BR><BR>

	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
			<TR BGCOLOR="#eeeeee">
				<TD>負担元</TD>
				<TD COLSPAN="2">負担</TD>
			</TR>
<%
			For i = 0 To Ubound(strApDiv)
%>
				<TR>
					<TD>
						<INPUT TYPE="hidden" NAME="apDiv"     VALUE="<%= strApDiv(i)      %>">
						<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)        %>">
						<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i)  %>">
						<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i)  %>">
						<INPUT TYPE="hidden" NAME="orgName"   VALUE="<%= strArrOrgName(i) %>">
						<INPUT TYPE="hidden" NAME="noCtr"     VALUE="<%= strNoCtr(i)      %>">
						<INPUT TYPE="hidden" NAME="fraction"  VALUE="<%= strFraction(i)   %>">
						<INPUT TYPE="hidden" NAME="orgDiv"    VALUE="<%= strOrgDiv(i)     %>">
						<%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strOrgName, strArrOrgName(i)) %>
					</TD>
					<TD><INPUT TYPE="checkbox" NAME="noCtrOrg" <%= IIf(strNoCtr(i) = "1", "CHECKED", "") & " " & IIf(strOrgDiv(i) <> "0", "DISABLED", "") %> ONCLICK="javascript:checkNoCtr('<%= i %>')"></TD>
					<TD>負担する</TD>
				</TR>
<%
			Next
%>
	</TABLE>

	<BR>

	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
	<INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
