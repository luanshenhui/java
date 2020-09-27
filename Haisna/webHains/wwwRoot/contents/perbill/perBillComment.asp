<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求書コメント (Ver0.0.1)
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
'定数の定義
Const MODE_INSERT   = "insert"	'処理モード(挿入)
Const MODE_UPDATE   = "update"	'処理モード(更新)
Const ACTMODE_SAVE  = "save"	'動作モード(保存)
Const ACTMODE_SAVED = "saved"	'動作モード(保存完了)

Dim objCommon				'共通クラス
Dim objPerbill				'受診情報アクセス用

Dim strDmdDate				'請求日
Dim lngBillSeq				'請求書Ｓｅｑ
Dim lngBranchNo				'請求書枝番
Dim strBillComent			'請求書コメント

Dim Ret						'関数戻り値

'個人請求管理情報(BillNo)
Dim vntDelFlg				'取消し伝票フラグ
'Dim vntIcomeDate			'更新日時
'Dim vntUserId				'ユーザＩＤ
'Dim vntUserName			'ユーザ漢字氏名
'Dim vntBillcoment			'請求書コメント
Dim vntPaymentDate			'入金日
Dim vntPaymentSeq			'入金Ｓｅｑ
Dim vntPriceTotal			'金額（請求書合計）
Dim vntEditPriceTotal		'調整金額（請求書合計）
Dim vntTaxPriceTotal		'税額（請求書合計）
Dim vntEditTaxTotal			'調整税額（請求書合計）
Dim vntTotal				'小計（請求書合計）
Dim vntTaxTotal				'税合計（請求書合計）


Dim strMode					'処理モード
Dim strActMode				'動作モード(保存:"save"、保存完了:"saved")
Dim strMessage				'エラーメッセージ
Dim i						'インデックス
Dim strHTML

strMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得

strDmdDate     = Request("dmddate")
lngBillSeq     = Request("billseq")
lngBranchNo    = Request("branchno")
strBillComent  = Request("coment")

strActMode     = Request("act")
strMode        = Request("mode")


'パラメタのデフォルト値設定
'	lngRsvNo   = IIf(IsNumeric(lngRsvNo) = False, 0,  lngRsvNo )

Do

	'保存ボタン押下時
	If strActMode = "save" Then

		'入力チェック
		strMessage = CheckValue()
		If strMessage <> "" Then
			Exit Do
		End If

		'個人請求管理情報の取得
		Ret = objPerbill.UpdatePerBill_coment(strDmdDate, _
												lngBillSeq, _
												lngBranchNo, _
												strBillComent )
		'保存に失敗した場合
		If Ret <> True Then
			srtMessage = "請求書コメントの保存に失敗しました"
'			Err.Raise 1000, , "請求書コメントが保存できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
			Exit Do
		Else
			'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
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


	'個人請求管理情報の取得
	Ret = objPerbill.SelectPerBill_BillNo(strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											, , , , _
											strBillComent, _
											vntPaymentDate, _
											vntPaymentSeq, _
                                            vntPriceTotal, _
											vntEditPriceTotal, _
											vntTaxPriceTotal, _
											vntEditTaxTotal, _
											vntTotal, _
											vntTaxTotal )
	'受診情報が存在しない場合
	If Ret <> True Then
		Err.Raise 1000, , "個人請求管理情報が取得できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
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
	Dim strMessage		'エラーメッセージ
	strMessage = ""

	'共通クラスのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'各値チェック処理
	With objCommon
		'請求書コメントチェック
		strMessage = .CheckWideValue("請求書コメント", strBillComent, 200)
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
	<INPUT TYPE="hidden" NAME="act" VALUE="">

	<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
	<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
	<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">

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
			<TD NOWRAP>コメント</TD>
			<TD>：</TD>
			<TD><TEXTAREA NAME="coment" ROWS="4" COLS="50"><%= strBillComent %></TEXTAREA></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD ALIGN="right"><A HREF="javascript:saveData()"><IMG SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で保存"></A></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
