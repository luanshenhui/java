<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   自覚症状入力画面  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- #include virtual = "/webHains/includes/EditJikakushoujyou.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_JIKAKUSYOUJYOU = "X025"	'自覚症状グループコード


'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用
Dim objResult			'検査結果アクセス用COMオブジェクト

'パラメータ
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim	strWinMode			'ウィンドウモード
Dim lngRsvNo			'予約番号（今回分）
Dim strGrpNo			'グループNo
Dim strCsCd				'コースコード

'検査結果情報
Dim vntPerId			'予約番号
Dim vntCslDate			'検査項目コード
Dim vntHisNo			'履歴No.
Dim vntRsvNo			'予約番号
Dim vntItemCd			'検査項目コード
Dim vntSuffix			'サフィックス
Dim vntResultType		'結果タイプ
Dim vntItemType			'項目タイプ
Dim vntItemName			'検査項目名称
Dim vntResult			'検査結果
Dim vntRslValue			'検査結果
Dim vntUnit				'単位
Dim vntItemQName		'問診文章
Dim vntGrpSeq			'表示順番
Dim vntRslFlg			'検査結果存在フラグ
Dim lngRslCnt			'検査結果数

'検査結果更新情報
Dim vntUpdItemCd		'検査項目コード
Dim vntUpdSuffix		'サフィックス
Dim vntUpdResult		'検査結果
Dim strArrMessage		'エラーメッセージ

Dim strUpdUser			'更新者
Dim strIPAddress		'IPアドレス

Dim lngIndex			'インデックス
Dim Ret					'復帰値
Dim strHTML				'HTML文字列
Dim i, j				'カウンター

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strAction			= Request("act")
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

'検査結果更新情報
vntUpdItemCd		= ConvIStringToArray(Request("ItemCd"))
vntUpdSuffix		= ConvIStringToArray(Request("Suffix"))
vntUpdResult		= ConvIStringToArray(Request("ChgRsl"))

Do
	'保存
	If strAction = "save" Then
		If Not IsEmpty(vntUpdItemCd) Then
			'更新者の設定
			strUpdUser = Session("USERID")
			'IPアドレスの取得
			strIPAddress = Request.ServerVariables("REMOTE_ADDR")

			'オブジェクトのインスタンス作成
			Set objResult  = Server.CreateObject("HainsResult.Result")

			'検査結果更新
			Ret = objResult.UpdateResultNoCmt( lngRsvNo, strIPAddress, strUpdUser, vntUpdItemCd, vntUpdSuffix, vntUpdResult, strArrMessage )

			'オブジェクトのインスタンス削除
			Set objResult = Nothing

			If Ret Then
				'保存完了
				strAction = "saveend"

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
	End If

	'指定対象受診者の検査結果を取得する
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_JIKAKUSYOUJYOU, _
						0, _
						"", _
						0, _
						0, _
						1, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult, _
						vntRslValue, _
						, , , , , _
						vntUnit, _
						, , , , , _
						vntItemQName, _
						vntGrpSeq, _
						vntRslFlg _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	'OCR入力画面と表示処理を共通とするため
	For i = 0 To lngRslCnt-1
		vntResult(i) = vntRslValue(i)
	Next

	'オブジェクトのインスタンス削除
	Set objInterView = Nothing
Exit Do
Loop

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>自覚症状メンテナンス</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//保存
function saveJikakushoujyou() {
	var myForm	= document.entryForm;
	var count;
	var buff	= new Array();
	var i, j;

	if ( myForm.ChgRsl == null ) return;

	// 入力チェック
	for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
		count = 0;
		for( j=0; j < 4; j++ ) {
			if( myForm.ChgRsl[i*4+j].value != "" ) {
				count ++;
			}
		}
		if( count != 0 && count != 4 ) {
			alert( "入力されていない項目があります。" );
			return;
		}
	}

	// 前詰め
	count = 0;
	for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
		if( myForm.ChgRsl[i*4+0].value != "" ) {
			for( j=0; j < 4; j++ ) {
				buff[count*4+j] =  myForm.ChgRsl[i*4+j].value;
			}
			count ++;
		}
	}
	for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
		if( i < count ) {
			for( j=0; j < 4; j++ ) {
				myForm.ChgRsl[i*4+j].value = buff[i*4+j];
			}
		} else {
			for( j=0; j < 4; j++ ) {
				myForm.ChgRsl[i*4+j].value = "";
			}
		}
	}

	// モードを指定してsubmit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

	return;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="act"       VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="">■自覚症状メンテナンス</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
	'メッセージの編集
	If strAction <> "" Then

		'保存完了時は「保存完了」の通知
		If strAction = "saveend" Then
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

		'さもなくばエラーメッセージを編集
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>

<%
	If lngRslCnt = JIKAKUSHOUJYOU_COUNT*4 Then
		'自覚症状の表示
		Call EditJikakushoujyou( 0 )
	End If
%>
	<BR>
	    <% '2005.08.22 権限管理 Add by 李　--- START %>
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="JavaScript:saveJikakushoujyou()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存" BORDER="0"></A>
        <%  else    %>
             &nbsp;
        <%  end if  %>
        <% '2005.08.22 権限管理 Add by 李　--- END %>
	<BR>
<%
	'保存用
	strHtml = ""
	For i=0 To lngRslCnt-1
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ItemCd"" VALUE=""" & vntItemCd(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""Suffix"" VALUE=""" & vntSuffix(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""OrgRsl"" VALUE=""" & vntResult(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ChgRsl"" VALUE=""" & vntResult(i) & """>"
	Next
	Response.Write(strHtml)
%>
</FORM>
</BODY>
</HTML>
