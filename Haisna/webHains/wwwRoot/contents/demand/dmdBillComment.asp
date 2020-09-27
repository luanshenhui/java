<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求書コメント (Ver0.0.1)
'		AUTHER  : M.Gouda@FSIT
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
'定数の定義
Const MODE_INSERT   = "insert"	'処理モード(挿入)
Const MODE_UPDATE   = "update"	'処理モード(更新)
Const ACTMODE_SAVE  = "save"	'動作モード(保存)
Const ACTMODE_SAVED = "saved"	'動作モード(保存完了)

Dim objCommon				'共通クラス
Dim objDemand				'請求アクセス用COMオブジェクト

Dim strBillNo				'請求書番号
Dim strBillComment			'請求書コメント

'請求書基本情報
Dim lngArrBillNo			'請求書番号
Dim strArrCloseDate			'締め日
Dim strArrBillSeq			'請求書Ｓｅｑ
Dim strArrBranchno			'請求書枝番
Dim strArrOrgCd1			'団体コード１
Dim strArrOrgCd2			'団体コード２
Dim strArrOrgName			'団体名
Dim strArrOrgKName			'団体カナ名
Dim strArrPrtDate			'請求書出力日
Dim lngArrSumPriceTotal		'合計
Dim lngArrSumTaxTotal		'税額合計
Dim strArrSeq				'Seq
Dim strArrDispatchDate		'発送日
Dim strArrUpdUser			'更新者ID（発送）
Dim strArrUserName			'更新者名（発送）
Dim strArrUpdDate			'取消伝票フラグ
Dim strArrDelFlg			'取消伝票フラグ
Dim strArrBillComment		'請求書コメント

Dim Ret						'関数戻り値
Dim lngCount				'レコード数

Dim strMode					'処理モード
Dim strAction				'動作モード(保存:"save"、保存完了:"saved")
Dim strMessage				'エラーメッセージ
Dim i						'インデックス
Dim strHTML

strMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")

'引数値の取得

strBillNo      = Request("billno")
strBillComment = Request("comment")

strAction      = Request("action")
strMode        = Request("mode")

Do
	
	'保存ボタン押下時
	If strAction = "save" Then

		'入力チェック
		strMessage = CheckValue()
		If strMessage <> "" Then
			Exit Do
		End If

		'団体請求書コメントの更新
		Ret = objDemand.UpdateDmdBill_comment(strBillNo, strBillComment)

		'保存に失敗した場合
		If Ret <> True Then
			strMessage = "請求書コメントの保存に失敗しました"
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
	
	'団体請求書基本情報の取得
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
								strArrDelFlg, _
								strArrBillComment)

	'請求書基本情報が存在しない場合
	If lngCount = 0 Then
		Err.Raise 1000, , "団体請求書基本情報が取得できません。（請求書No　= " & lngBillNo &" )"
	End If
	
	strBillComment = strArrBillComment(0)

	'請求アクセス用COMオブジェクトの解放
	Set objDemand = Nothing
	Set objCommon = Nothing

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
	Dim strMessage		'エラーメッセージ
	strMessage = ""

	'共通クラスのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'各値チェック処理
	With objCommon
		'請求書コメントチェック
		strMessage = .CheckWideValue("請求書コメント", strBillComment, 100)
	End With

	CheckValue = strMessage

End Function



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>請求書コメント</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 保存
function saveData() {

	// モードを指定してsubmit
	document.entryForm.action.value = 'save';
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 20px 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="action" VALUE="">
	<INPUT TYPE="hidden" NAME="billno" VALUE="<%= strBillNo %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>請求書コメント</B></TD>
		</TR>
	</TABLE>
<%
'メッセージの編集
	If strMessage <> "" Then
		Call EditMessage(strMessage, MESSAGETYPE_WARNING)
	End If

%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP VALIGN="top">コメント</TD>
			<TD VALIGN="top">：</TD>
			<TD><TEXTAREA NAME="comment" ROWS="4" COLS="50"><%= strBillComment %></TEXTAREA></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>

			<TD ALIGN="right">
			<% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
				<A HREF="javascript:saveData()"><IMG SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で保存"></A>
			<%  else    %>
				 &nbsp;
			<%  end if  %>
			<% '2005.08.22 権限管理 Add by 李　--- END %>
			</TD>

		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
