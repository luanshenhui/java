<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   来院情報設定  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診クラス
Dim objFree				'汎用情報アクセス用

'パラメータ
Dim lngRsvNo			'予約番号
Dim lngMode				'画面モード(1:当日ID, 2:来院, 3:OCR番号, 4:ロッカーキー)
Dim strAction			'処理状態(保存ボタン押下時:"save")

'来院情報用変数
Dim vntDayID			'当日ID
Dim vntComeDate			'来院日時
Dim vntComeUser			'来院処理者
Dim vntOcrNo			'OCR番号
Dim vntLockerKey		'ロッカーキー

Dim strArrMessage		'エラーメッセージ
Dim Ret					'関数戻り値
Dim strHtml				'HTML文字列
Dim strModeName			'画面モード名称
Dim strWelcome			'来院
Dim strUpdUser			'更新者

'## 2004.10.15 Add By T.Takagi@FSIT 誘導キャンセル機能実装
Dim strForce			'強制来院取消フラグ
Dim lngVisitStatus		'来院制御処理戻り値
Dim blnVisitError		'来院制御エラーフラグ
'## 2004.10.15 Add End

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")

'引数値の取得
lngRsvNo			= Request("rsvno")
lngMode				= Request("mode")
strAction			= Request("act")

vntDayID			= Request("DayId")
strWelcome			= Request("Welcome")
vntOcrNo			= Request("OcrNo")
vntLockerKey		= Request("LockerKey")

'## 2004.10.15 Add By T.Takagi@FSIT 誘導キャンセル機能実装
strForce = Request("force")
'## 2004.10.15 Add End

Do
	Select Case lngMode
	Case "1"
		strModeName = "当日ID"
	Case "2"
		strModeName = "来院"
	Case "3"
		strModeName = "OCR番号"
	Case "4"
		strModeName = "ロッカーキー"
	Case Else
		strModeName = ""
	End Select

	If strAction = "save" Then
		'値のチェック(当日ID)
		If vntDayID <> "" Then
			strArrMessage = objCommon.CheckNumeric("当日ＩＤ", vntDayID, LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
			If strArrMessage <> "" Then
				Exit Do
			End If
		End If
		'値のチェック(OCR番号)
		If vntOcrNo <> "" Then
			strArrMessage = objCommon.CheckAlphabetAndNumeric("ＯＣＲ番号", vntOcrNo, 10, CHECK_NECESSARY)
			If strArrMessage <> "" Then
				Exit Do
			End If
		End If
		'値のチェック(ロッカーキー)
		If vntLockerKey <> "" Then
			strArrMessage = objCommon.CheckAlphabetAndNumeric("ロッカーキー", vntLockerKey, 5, CHECK_NECESSARY)
			If strArrMessage <> "" Then
				Exit Do
			End If
		End If

		'更新者の設定
		strUpdUser = Session("USERID")

		'来院情報の更新
'## 2004.10.15 Mod By T.Takagi@FSIT 誘導キャンセル機能実装
'		Ret = objConsult.UpdateWelComeInfo(lngRsvNo, _
'											lngMode, _
'											strUpdUser, _
'											vntDayID, _
'											strWelcome, _
'											vntOcrNo, _
'											vntLockerKey _
'											)
		Ret = objConsult.UpdateWelComeInfo(lngRsvNo, lngMode, strUpdUser, vntDayID, strWelcome, vntOcrNo, vntLockerKey, strForce, lngVisitStatus, strArrMessage)

		'エラー時
		If Ret = False Then

			'来院制御エラー時はフラグ成立
			If lngMode = "2" And lngVisitStatus <= 0 Then
				blnVisitError = True
			End If

		End If
'## 2004.10.15 Mod End

		'更新エラー時は処理を抜ける
		If Ret <> True Then
			Exit Do
		Else
			'ロッカーキーが正常に更新されたとき（ロッカーキーの消去[=値なし]は除く）
			If lngMode = "4" And vntLockerKey <> "" Then
				strHtml = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHtml = strHtml & vbCrLf & "<HTML lang=""ja"">"
				strHtml = strHtml & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.setLockerKey(); close()"">"
				strHtml = strHtml & "</BODY>"
				strHtml = strHtml & "</HTML>"
				Response.Write strHtml
				Response.End
				Exit Do
			End If

			'エラーがなければ呼び元画面を再表示して自身を閉じる
			strHtml = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHtml = strHtml & vbCrLf & "<HTML lang=""ja"">"
			strHtml = strHtml & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.parent.location.reload(); close()"">"
			strHtml = strHtml & "</BODY>"
			strHtml = strHtml & "</HTML>"
			Response.Write strHtml
			Response.End
			Exit Do
		End If
	End If

	'来院情報検索
	Ret = objConsult.SelectWelComeInfo(lngRsvNo, _
										, , , , , , , , , , , , , , , , , , , _
										vntDayID,		_
										vntComeDate,	_
										vntComeUser,	_
										vntOcrNo,		_
										vntLockerKey	_
										)
	If Ret = False Then
		Err.Raise 1000, , "来院情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	'来院(0:無処理, 1:来院状態, 2:未来院状態)
	If lngMode = "2" Then
		strWelcome = IIf(vntComeDate<>"", "1", "2")
	Else
		strWelCome = "0"
	End If

	'オブジェクトのインスタンス削除
	Set objConsult = Nothing

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE><%= strModeName %>の設定</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 初期処理
function loadPage() {
	var myForm = document.entryForm;
	var url;							// URL文字列
	var i;

	if( myForm.elements == null ) return;

	for( i=0; i < myForm.elements.length; i++ ) {
		if ( myForm.elements[i].type == 'text' ) {
			myForm.elements[i].focus();
			return;
		}
	}
}

//保存処理
function saveWelComeInfo() {
	var myForm = document.entryForm;

	// 来院情報を来院→未来院にしたときは確認メッセージを表示
	if( myForm.mode.value == '2' ) {
		if( myForm.orgWelcome.value == '1' && myForm.Welcome.value == '2' ) {
			if( !confirm('未来院にします。よろしいですか？') ) {
				return;
			}
		}
	}

	// モードを指定してsubmit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

	return;
}

// キー押下時の処理
function Key_Press(){
	var myForm = document.entryForm;
	var i;

	// Enterキー
	if ( event.keyCode == 13 ) {
		if( myForm.elements == null ) return;

		for( i=0; i < myForm.elements.length; i++ ) {
			if ( myForm.elements[i].type == 'text' ) {
				if ( myForm.elements[i].value == '' ) {
					myForm.elements[i].focus();
					return;
				}
			}
		}

		// 保存処理を行う
		saveWelComeInfo();
	}
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:loadPage()" ONKEYPRESS="JavaScript:Key_Press()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="mode"  VALUE="<%= lngMode %>">
	<INPUT TYPE="hidden" NAME="act"   VALUE="<%= strAction %>">

	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000"><%= strModeName %>の設定</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
		If Not IsEmpty(strArrMessage) Then
			'エラーメッセージを編集
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="10"><%= strModeName %></TD>
			<TD>：</TD>
<%
	Select Case lngMode
	Case "1"		'当日ID
%>
			<TD>
				<INPUT TYPE="text" NAME="DayId" VALUE="<%= vntDayID %>" SIZE="4" MAXLENGTH="4" BORDER="0" STYLE="ime-mode:disabled" ONFOCUS="this.select()">
			</TD>
<%
	Case "2"		'来院情報
%>
			<TD>
				<INPUT TYPE="radio" NAME="radio_Welcome" VALUE="1" <%= IIf(strWelcome="1", "CHECKED", "") %> STYLE="ime-mode:disabled" ONCHANGE="javascript:document.entryForm.Welcome.value = this.value">来院
				<INPUT TYPE="radio" NAME="radio_Welcome" VALUE="2" <%= IIf(strWelcome="2", "CHECKED", "") %> STYLE="ime-mode:disabled" ONCHANGE="javascript:document.entryForm.Welcome.value = this.value">未来院
				<INPUT TYPE="hidden" NAME="orgWelcome" VALUE="<%= strWelcome %>">
				<INPUT TYPE="hidden" NAME="Welcome" VALUE="<%= strWelcome %>">
			</TD>
<%
	Case "3"		'OCR番号
%>
			<TD>
				<INPUT TYPE="text" NAME="OcrNo" VALUE="<%= vntOcrNo %>" SIZE="10" MAXLENGTH="10" BORDER="0" STYLE="ime-mode:disabled" ONFOCUS="this.select()">
			</TD>
<%
	Case "4"		'ロッカーキー
%>
			<TD>
				<INPUT TYPE="text" NAME="LockerKey" VALUE="<%= vntLockerKey %>" SIZE="5" MAXLENGTH="5" BORDER="0" STYLE="ime-mode:disabled" ONFOCUS="this.select()">
			</TD>
<%
	End Select
%>
		</TR>
<%
'## 2004.10.15 Add By T.Takagi@FSIT 誘導キャンセル機能実装
	'来院解除処理にてエラーが発生した場合のみ強制処理用チェックボックスを表示する
	If lngMode = "2" And blnVisitError = True And lngVisitStatus = -1 Then
%>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD HEIGHT="40"><INPUT TYPE="checkbox" NAME="force" VALUE="1">強制的に未来院処理を行う</TD>
		</TR>
<%
	End If
'## 2004.10.15 Add End
%>
	</TABLE>
	<BR>
	<TABLE WIDTH="169" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR>
            <TD>
            <% '2005.08.22 権限管理 Add by 李　--- START %>
           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  
                <A HREF="javascript:saveWelComeInfo()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存" border="0"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
            </TD>
			
            
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル" border="0"></A></TD>
		</TR>
	</TABLE>
	<BR>
</FORM>
</BODY>
</HTML>
