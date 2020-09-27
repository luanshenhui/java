<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(限度額の設定) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const ACTMODE_SAVE         = "save"	'動作モード(保存)
Const ACTMODE_DELETE       = "del"	'動作モード(削除)

'データベースアクセス用オブジェクト
Dim objContract			'契約情報アクセス用
Dim objContractControl	'契約情報アクセス用
Dim objOrganization		'団体情報アクセス用

'引数値
Dim strActMode			'動作モード

'引数値（契約基本情報）
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCtrPtCd			'契約パターンコード
Dim strLimitRate		'限度率
Dim lngLimitTaxFlg		'限度額消費税フラグ
Dim strLimitPrice		'上限金額

'引数値（負担元情報）
Dim strSeq				'ＳＥＱ
Dim strApDiv			'適用元区分
Dim strBdnOrgCd1		'団体コード１
Dim strBdnOrgCd2		'団体コード２
Dim strOrgSName			'団体略称
Dim strLimitPriceFlg	'団体名

Dim strSeqOrg			'対象負担元ＳＥＱ
Dim strSeqBdnOrg		'減算した金額の負担元ＳＥＱ

Dim strMyOrgSName		'団体略称
Dim strMessage			'エラーメッセージ
Dim strHTML				'HTML編集用
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strActMode     = Request("actMode")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCtrPtCd     = Request("ctrPtCd")
strLimitRate   = Request("limitRate")
lngLimitTaxFlg = CLng("0" & Request("limitTaxFlg"))
strLimitPrice  = Request("limitPrice")
strSeq         = ConvIStringToArray(Request("seq"))
strBdnOrgCd1   = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2   = ConvIStringToArray(Request("bdnOrgCd2"))
strOrgSName    = ConvIStringToArray(Request("orgSName"))
strSeqOrg      = Request("seqOrg")
strSeqBdnOrg   = Request("seqBdnOrg")

'チェック・更新・読み込み処理の制御
Do

	'動作モードごとの制御
	Select Case strActMode

		'削除ボタン押下時
		Case ACTMODE_DELETE

			'限度額情報の更新(全値クリア)
			If objContractControl.UpdateLimitPrice(strOrgCd1 ,strOrgCd2, strCtrPtcd, Empty, Empty, Empty, "", "", 1, 0, "") <> 0 then
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

		'保存ボタン押下時
		Case ACTMODE_SAVE

			'入力チェック
			strMessage = CheckValue()
			If Not IsEmpty(strMessage) Then
				Exit Do
			End If

			'限度額情報の更新
			If objContractControl.UpdateLimitPrice(strOrgCd1 ,strOrgCd2, strCtrPtcd, strSeq, strBdnOrgCd1, strBdnOrgCd2, strSeqOrg, strLimitRate, lngLimitTaxFlg, IIf(strLimitPrice <> "", strLimitPrice, "0"), strSeqBdnOrg) <> 0 then
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

	End Select

	'契約パターン情報の読み込み
	If objContract.SelectCtrPt(strCtrPtCd, , , , , , , , strLimitRate, lngLimitTaxFlg, strLimitPrice) = False Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If

	'負担元および限度額負担フラグの読み込み
	If objContract.SelectCtrPtOrgPrice(strCtrPtCd, , , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, , strOrgSName, , , , , , , , , , , strLimitPriceFlg) <= 0 Then
		Err.Raise 1000, ,"契約パターン負担元情報が存在しません。"
	End If

	'負担元情報の検索
	For i = 0 To UBound(strSeq)

		'契約団体自身の場合は団体名称を取得
		If strApDiv(i) = CStr(APDIV_MYORG) Then
			objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , strMyOrgSName
			strOrgSName(i) = strMyOrgSName
		End If

		'限度額負担フラグ値の変換
		Select Case strLimitPriceFlg(i)
			Case "0"
				strSeqOrg = strSeq(i)
			Case "1"
				strSeqBdnOrg = strSeq(i)
		End Select
	Next

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 入力チェック
'
' 引数　　 :
'
' 戻り値　 : エラーメッセージの配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'共通クラス

	Dim strArrMessage	'エラーメッセージの配列
	Dim strMessage		'エラーメッセージ

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'すべて未入力ならばチェック不要
	If strSeqOrg = "" And strLimitRate = "" And strLimitPrice = "" And strSeqBdnOrg = "" Then
		Exit Function
	End If

	'対象負担元のチェック
	If strSeqOrg = "" Then
		objCommon.AppendArray strArrMessage, "対象負担元を設定してください。"
	End If

	'限度率チェック
	Do

		If strLimitRate = "" Then
			objCommon.AppendArray strArrMessage, "限度率を設定してください。"
			Exit Do
		End If

		'数値チェック
		strMessage = objCommon.CheckNumeric("限度率", strLimitRate, 3)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit Do
		End If

		'限度率は１００％まで
		If CLng(strLimitRate) > 100 Then
			objCommon.AppendArray strArrMessage, "限度率の値が正しくありません。"
		End If

		Exit Do
	Loop

	'上限金額チェック
	objCommon.AppendArray strArrMessage, objCommon.CheckNumeric("上限金額", strLimitPrice, 7)

	'減算した金額の負担元のチェック
	If strSeqBdnOrg = "" Then
		objCommon.AppendArray strArrMessage, "減算した金額の負担元を設定してください。"
	End If

	'ともに設定されている場合、両方に同じ負担元は設定できない
	If strSeqOrg <> "" And strSeqBdnOrg <> "" And strSeqOrg = strSeqBdnOrg Then
		objCommon.AppendArray strArrMessage, "対象負担元、減算した金額の負担元に同じ値を設定することはできません。"
	End If

	'チェック結果を返す
	CheckValue = strArrMessage

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>限度額の設定</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function submitForm( actMode ) {

	// 削除時はメッセージを表示する
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm('この限度額情報を削除します。よろしいですか？') ) {
			return;
		}
	}

	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">
	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">
<%
	For i = 0 To UBound(strSeq)
%>
	<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)       %>">
	<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i) %>">
	<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i) %>">
	<INPUT TYPE="hidden" NAME="orgSName"  VALUE="<%= strOrgSName(i)  %>">
<%
	Next
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">限度額の設定</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	EditMessage strMessage, MESSAGETYPE_WARNING
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>
            <% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
                <A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="削除"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
            </TD>

			
            <TD>
            <% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <A HREF="javascript:javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
            </TD>
			
            
            <TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD>対象負担元</TD>
			<TD>：</TD>
			<TD><%= EditDropDownListFromArray("seqOrg", strSeq, strOrgSName, strSeqOrg, NON_SELECTED_ADD) %></TD>
		</TR>
		<TR>
			<TD>限度額</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP>総金額に対する限度率</TD>
						<TD><INPUT TYPE="text" NAME="limitRate" SIZE="4" MAXLENGTH="3" STYLE="text-align:right;ime-mode:disabled;" VALUE="<%= strLimitRate %>"></TD>
						<TD>％</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD><TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP>総金額：</TD>
						<TD><INPUT TYPE="radio" NAME="limitTaxFlg" VALUE="1"<%= IIf(lngLimitTaxFlg = 1, " CHECKED", "") %>></TD>
						<TD NOWRAP>消費税を含む
						<TD><INPUT TYPE="radio" NAME="limitTaxFlg" VALUE="0"<%= IIf(lngLimitTaxFlg = 0, " CHECKED", "") %>></TD>
						<TD NOWRAP>消費税を含まない</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>上限金額</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="limitPrice" SIZE="11" MAXLENGTH="7" STYLE="text-align:right;ime-mode:disabled;" VALUE="<%= strLimitPrice %>"></TD>
						<TD>円</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>減算した金額の負担元</TD>
			<TD>：</TD>
			<TD><%= EditDropDownListFromArray("seqBdnOrg", strSeq, strOrgSName, strSeqBdnOrg, NON_SELECTED_ADD) %></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>