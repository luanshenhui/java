<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約枠登録・修正 (Ver0.0.1)
'		AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
'## 2004.03.12 Mod By T.Takagi@FSIT 権限が違う
'Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)
'## 2004.03.12 Mod End

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------

Dim objCommon			'共通クラス
Dim objSchedule			'予約情報アクセス用
Dim objCourse			'コース情報アクセス用

Dim Ret						'関数戻り値

Dim lngCount				'取得件数
Dim lngRsvNo				'予約番号
Dim lngRecord				'レコード番号

Dim strCslDate          	'受診日
Dim strCsCd		          	'コースコード
Dim lngRsvGrpCd         	'予約群コード
Dim strCslYear     			'受診年（開始）
Dim strCslMonth     		'受診月（開始）
Dim strCslDay     			'受診日（開始）

Dim vntCslDate          	'受診日
Dim vntCsCd		          	'コースコード
Dim vntCsName           	'コース名
Dim vntWebColor           	'コース色
Dim vntRsvGrpCd         	'予約群コード
Dim vntRsvGrpName         	'予約群名称
Dim vntMngGender			'男女別枠管理
Dim vntMaxCnt				'予約可能人数（共通）
Dim vntMaxCnt_M	    	   	'予約可能人数（男）
Dim vntMaxCnt_F	       		'予約可能人数（女）
Dim vntOverCnt		       	'オーバ可能人数（共通）
Dim vntOverCnt_M	       	'オーバ可能人数（男）
Dim vntOverCnt_F	       	'オーバ可能人数（女）
Dim vntRsvCnt_M	       		'予約済み人数（男）
Dim vntRsvCnt_F		        '予約済み人数（女）

Dim strCsName           	'コース名
Dim strWebColor           	'コース色
Dim strRsvGrpName         	'予約群名称
Dim lngMngGender			'男女別枠管理
Dim lngMaxCnt				'予約可能人数（共通）
Dim lngMaxCnt_M	    	   	'予約可能人数（男）
Dim lngMaxCnt_F	       		'予約可能人数（女）
Dim lngOverCnt		       	'オーバ可能人数（共通）
Dim lngOverCnt_M	       	'オーバ可能人数（男）
Dim lngOverCnt_F	       	'オーバ可能人数（女）
Dim lngRsvCnt_M	       		'予約済み人数（男）
Dim lngRsvCnt_F		        '予約済み人数（女）

Dim lngRsvFraCnt				'予約枠数


Dim strMode					'処理モード
Dim strAction				'動作モード(保存:"save"、保存完了:"saved")
Dim i						'インデックス
Dim strHTML
Dim strArrMessage	'エラーメッセージ

strArrMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objSchedule     = Server.CreateObject("HainsSchedule.Schedule")
Set objCourse       = Server.CreateObject("HainsCourse.Course")

'引数値の取得

strAction      = Request("action")
strMode        = Request("mode")
strCsCd	       = Request("cscd")
lngRsvGrpCd    = Request("rsvGrpCd")

strCslDate     = Request("cslDate")
strCslYear     = Request("cslYear")
strCslMonth    = Request("cslMonth")
strCslDay      = Request("cslDay")

lngMaxCnt	   = Request("maxCnt")
lngMaxCnt_M	   = Request("maxCnt_M")
lngMaxCnt_F	   = Request("maxCnt_F")
lngOverCnt	   = Request("overCnt")
lngOverCnt_M   = Request("overCnt_M")
lngOverCnt_F   = Request("overCnt_F")
'lngRsvCnt_M    = Request("rsvCnt_M"	)
'lngRsvCnt_F    = Request("rsvCnt_F" )

'### 2004/02/05 Deleted by Ishihara@FSIT ん～、微妙。こういう場合はどうなんだ。
'### (Select後でセットしているから不要）
''本当は未来だと思うけど・・・
'If strCslDate <> "" Then
'	strCslYear  = CStr(Year(strCslDate))
'	strCslMonth = CStr(Month(strCslDate))
'	strCslDay   = CStr(Day(strCslDate))
'End If
'### 2004/02/05 Deleted End

'### 2004/02/05 Modifed by Ishihara@FSIT 乱暴すぎ
'If strCslYear = "" Then
'	strCslYear  = CStr(Year(now))
'	strCslMonth = CStr(Month(now))
'	strCslDay   = CStr(Day(now))
'End If
If strCslYear = "" Then
	strCslYear  = CStr(Year(now))
End If
If strCslMonth = "" Then
	strCslMonth  = CStr(Month(now))
End If
If strCslDay = "" Then
	strCslDay  = CStr(Day(now))
End If
'### 2004/02/05 Modifed End

Do

	'新規モードではないとき
	If strMode <> "insert" And strAction <> "save" Then
'			Err.Raise 1000, , "strCslDate= " & strCslDate & ",strCsCd=" & strCsCd & ", 予約群コード=" & lngRsvGrpCd &" )"
		'検索条件に従い予約人数管理一覧を抽出する
		lngRsvFraCnt = objSchedule.SelectRsvFraMngList( _
                    strCslDate, strCslDate, _
                    strCsCd & "", _
                    lngRsvGrpCd & "", _
                    vntCslDate, _
                    vntCsCd, _
                    vntCsName, _
                    vntWebColor, _
                    vntRsvGrpCd, _
                    vntRsvGrpName, _
                    vntMngGender, _
                    vntMaxCnt, _
                    vntMaxCnt_M, _
                    vntMaxCnt_F, _
                    vntOverCnt, _
                    vntOverCnt_M, _
                    vntOverCnt_F, _
                    vntRsvCnt_M, _
                    vntRsvCnt_F _
                    )
'			Err.Raise 1000, , "lngRsvFraCnt= " & lngRsvFraCnt
		'予約人数情報が取得できない場合
 		If lngRsvFraCnt < 1 Then
			Exit Do
		End If

'			Err.Raise 1000, , "vntCslDate= " & vntCslDate(0)
		strCslYear  = CStr(Year(vntCslDate(0)))
		strCslMonth = CStr(Month(vntCslDate(0)))
		strCslDay   = CStr(Day(vntCslDate(0)))

		If strCsName 		= "" Then strCsName 	= vntCsName(0)
		If strWebColor      = "" Then strWebColor  	= vntWebColor(0)
		If strRsvGrpName    = "" Then strRsvGrpName	= vntRsvGrpName(0)
		If lngMngGender	 	= "" Then lngMngGender	= vntMngGender(0)
		If lngMaxCnt		= "" Then lngMaxCnt		= vntMaxCnt(0)
		If lngMaxCnt_M	    = "" Then lngMaxCnt_M	= vntMaxCnt_M(0)
		If lngMaxCnt_F	    = "" Then lngMaxCnt_F	= vntMaxCnt_F(0)
		If lngOverCnt		= "" Then lngOverCnt	= vntOverCnt(0)
		If lngOverCnt_M	 	= "" Then lngOverCnt_M	= vntOverCnt_M(0)
		If lngOverCnt_F	 	= "" Then lngOverCnt_F	= vntOverCnt_F(0)
		If lngRsvCnt_M	    = "" Then lngRsvCnt_M	= vntRsvCnt_M(0)
		If lngRsvCnt_F		= "" Then lngRsvCnt_F	= vntRsvCnt_F(0)
	End If

	'確定ボタン押下時、保存処理実行
	If strAction = "save" Then

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If


		'受診日の編集
		strCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)

		'予約人数管理情報の登録 ==> 予約済み人数は渡さない 2003.12.16	←いやめちゃ消してますって by Ishihara 2004/02/05
		strArrMessage = objSchedule.UpdateRsvFraMngInfo( _
                    						strMode, _
                    						strCslDate, _
                    						strCsCd, _
                    						lngRsvGrpCd, _
											IIf( lngMaxCnt = "", 0, lngMaxCnt), _
											IIf( lngMaxCnt_M = "", 0, lngMaxCnt_M	), _
											IIf( lngMaxCnt_F = "", 0, lngMaxCnt_F	), _
											IIf( lngOverCnt	 = "", 0, lngOverCnt	), _
											IIf( lngOverCnt_M = "", 0, lngOverCnt_M), _
											IIf( lngOverCnt_F = "", 0, lngOverCnt_F) _
						                    )

'''' 2003.12.16 削除						IIf( lngRsvCnt_M = "", 0, lngRsvCnt_M	), _
'''' 2003.12.16 削除						IIf( lngRsvCnt_F  = "", 0, lngRsvCnt_F ) _


		'更新エラー時は処理を抜ける
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'保存に成功した場合
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

	'削除ボタン押下時、削除処理実行
	If strAction = "delete" Then

		'受診確定金額情報、個人請求明細情報の削除
		Ret = objSchedule.DeleteRsvFraMng( strCslDate, strCsCd, lngRsvGrpCd )


		'削除に失敗した場合
		If Ret <> True Then
			strArrMessage = Array("予約人数管理情報の削除に失敗しました。")
'			Err.Raise 1000, , "予約人数管理情報を削除できません。"
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

	Exit Do
Loop

'### 2004/02/05 Added by Ishihara@FSIT 更新時にエラーになると画面表示がむちゃくちゃ(--;)
'更新モード（この更新モードの判断もクセモノだけど）、かつエラー存在時のみこの処理を行う
If Not IsEmpty(strArrMessage) And strMode = "update" Then

	'エラー時に名称などが全部ロストする
	'（あまり効率のいい方法ではないが、もう考える気力なし）
	lngRsvFraCnt = objSchedule.SelectRsvFraMngList( _
	            strCslDate, strCslDate, _
	            strCsCd & "", _
	            lngRsvGrpCd & "", _
	            vntCslDate, _
	            vntCsCd, _
	            vntCsName, _
	            vntWebColor, _
	            vntRsvGrpCd, _
	            vntRsvGrpName, _
	            vntMngGender, _
                , _
                , _
                , _
                , _
                , _
                , _
                vntRsvCnt_M, _
                vntRsvCnt_F _
                )


	'表示制御に必要なものだけ再セット
	If strCsName 		= "" Then strCsName 	= vntCsName(0)
	If strRsvGrpName    = "" Then strRsvGrpName	= vntRsvGrpName(0)
	If lngMngGender	 	= "" Then lngMngGender	= vntMngGender(0)
	If lngRsvCnt_M	    = "" Then lngRsvCnt_M	= vntRsvCnt_M(0)
	If lngRsvCnt_F		= "" Then lngRsvCnt_F	= vntRsvCnt_F(0)

End If

'### 2004/02/05 Added End

'-------------------------------------------------------------------------------
'
' 機能　　 : 入力データの妥当性チェックを行う
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
	Dim vntArrMessage	'エラーメッセージの集合

	'共通クラスのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'各値チェック処理
	With objCommon
		.AppendArray vntArrMessage, .CheckNumeric("予約可能人数（共通）", lngMaxCnt, 3)
		.AppendArray vntArrMessage, .CheckNumeric("予約可能人数（男）", lngMaxCnt_M, 3)
		.AppendArray vntArrMessage, .CheckNumeric("予約可能人数（女）", lngMaxCnt_F, 3)
		.AppendArray vntArrMessage, .CheckNumeric("オーバ可能人数（共通）", lngOverCnt, 3)
		.AppendArray vntArrMessage, .CheckNumeric("オーバ可能人数（男）", lngOverCnt_M, 3)
		.AppendArray vntArrMessage, .CheckNumeric("オーバ可能人数（女）", lngOverCnt_F, 3)
'		.AppendArray vntArrMessage, .CheckNumeric("予約済み人数（男）", lngRsvCnt_M, 3)
'		.AppendArray vntArrMessage, .CheckNumeric("予約済み人数（女）", lngRsvCnt_F, 3)
	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : コースコードのドロップダウンリスト編集
'
' 引数　　 :
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CsCdList()

	Dim strArrCsCdID		'コースコード
	Dim strArrCsCdName		'コース名

	Dim lngCsCsCnt			'件数

	lngCsCsCnt = objCourse.SelectCourseList ( strArrCsCdID, strArrCsCdName )

	If lngCsCsCnt = 0 Then
		strArrCsCdID = Array()
		Redim Preserve strArrCsCdID(0)
		strArrCsCdName = Array()
		Redim Preserve strArrCsCdName(0)
	End If

	CsCdList = EditDropDownListFromArray("cscd", strArrCsCdID, strArrCsCdName, strCsCd, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 予約群のドロップダウンリスト編集
'
' 引数　　 :
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function RsvGrpList()

	Dim strArrRsvGrpID			'予約群コード
	Dim strArrRsvGrpName		'予約群名

	Dim lngRsvGrpCnt			'件数

	lngRsvGrpCnt = objSchedule.SelectRsvGrpList ( 0, strArrRsvGrpID, strArrRsvGrpName )

	If lngRsvGrpCnt = 0 Then
		strArrRsvGrpID = Array()
		Redim Preserve strArrRsvGrpID(0)
		strArrRsvGrpName = Array()
		Redim Preserve strArrRsvGrpName(0)
	End If

	RsvGrpList = EditDropDownListFromArray("rsvGrpCd", strArrRsvGrpID, strArrRsvGrpName, lngRsvGrpCd, NON_SELECTED_ADD)

End Function


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>予約枠修正</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function saveData() {

	// モードを指定してsubmit
	document.entryForm.action.value = 'save';
	document.entryForm.submit();

}

// 削除確認メッセージ
function deleteData() {

	if ( !confirm( 'この予約枠情報を削除します。よろしいですか？' ) ) {
		return;
	}


	// モードを指定してsubmit
	document.entryForm.action.value = 'delete';
	document.entryForm.submit();

}

function windowClose() {

	// 日付ガイドを閉じる
	calGuide_closeGuideCalendar();

}
//-->

</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="POST">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN>予約枠登録・修正</B></TD>
	</TR>
</TABLE>
<!-- 引数情報 -->
<INPUT TYPE="hidden" NAME="action"   VALUE="<%= strAction %>">
<INPUT TYPE="hidden" NAME="mode"     VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="cslDate"  VALUE="<%= strCslDate %>">
<BR>
<%
	'メッセージの編集
	Select Case strAction

		Case ""

		'保存完了時は「保存完了」の通知
		Case "saveend"
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

		'削除完了時は「削除完了」の通知
		Case "deleteend"
			Call EditMessage("削除が完了しました。", MESSAGETYPE_NORMAL)

		'さもなくばエラーメッセージを編集
		Case Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	End Select
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
	'新規登録モードのとき
	If strMode = "insert" Then
%>
		<TR>
			<TD WIDTH="132">受診日</TD>
			<TD>：</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strCslYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("cslMonth", 1, 12, Clng("0" & strCslMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("cslDay",   1, 31, Clng("0" & strCslDay  )) %></TD>
					<TD>&nbsp;日</TD>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD WIDTH="132">コース</TD>
			<TD>：</TD>
			<TD><%= CsCdList() %></TD>
		</TR>
		<TR>
			<TD WIDTH="132">予約群</TD>
			<TD>：</TD>
			<TD><%= RsvGrpList() %></TD>
		</TR>
<%
	Else
%>
		<TR>
			<TD WIDTH="132">受診日</TD>
			<TD>：</TD>
			<TD NOWRAP><%= strCslYear %>&nbsp;年&nbsp;<%= strCslMonth %>&nbsp;月&nbsp;<%= strCslDay %>&nbsp;日
<!-- 2004/02/05 Added by Ishihara@FSIT -->
			<INPUT TYPE="hidden" VALUE="<%= strCslYear %>"  NAME="cslYear">
			<INPUT TYPE="hidden" VALUE="<%= strCslMonth %>" NAME="cslMonth">
			<INPUT TYPE="hidden" VALUE="<%= strCslDay %>"   NAME="cslDay">
			</TD>
		</TR>
		<TR>
			<TD WIDTH="132">コース</TD>
			<TD>：</TD>
			<TD><%= strCsName %></TD>
			<INPUT TYPE="hidden" NAME="cscd"  VALUE="<%= strCsCd %>">
		</TR>
		<TR>
			<TD WIDTH="132">予約群</TD>
			<TD>：</TD>
			<TD><%= strRsvGrpName %></TD>
			<INPUT TYPE="hidden" NAME="rsvGrpCd"  VALUE="<%= lngRsvGrpCd %>">
		</TR>
<%
	End If
%>
	<TR>
		<TD WIDTH="132"><IMG SRC="../../images/spacer.gif" BORDER="0" WIDTH="10" HEIGHT="10" </TD>
		<TD></TD>
		<TD NOWRAP></TD>
	</TR>
	<TR>
		<TD WIDTH="132">予約可能人数（共通）</TD>
		<TD>：</TD>
<%
		'男女別枠管理しない または新規
		If lngMngGender = 0 Or strMode = "insert" Then
%>
			<TD NOWRAP><INPUT TYPE="text" NAME="maxCnt" SIZE="10" MAXLENGTH="8" VALUE="<%= lngMaxCnt %>" STYLE="ime-mode:disabled;"></TD>
<%
		Else
%>
			<TD>指定不可能</TD>
<%
		End If
%>
	</TR>
<%
	'男女別枠管理しない（更新のとき）
	If lngMngGender = 0 And strMode = "update" Then
%>
		<TR>
			<TD WIDTH="132">予約可能人数（男性）</TD>
			<TD>：</TD>
			<TD>指定不可能</TD>
		</TR>
		<TR>
			<TD WIDTH="132">予約可能人数（女性）</TD>
			<TD>：</TD>
			<TD>指定不可能</TD>
		</TR>
<%
	Else
%>
		<TR>
			<TD WIDTH="132">予約可能人数（男性）</TD>
			<TD>：</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="maxCnt_M" SIZE="10" MAXLENGTH="3" VALUE="<%= lngMaxCnt_M %>" STYLE="ime-mode:disabled;"></TD>
		</TR>
		<TR>
			<TD WIDTH="132">予約可能人数（女性）</TD>
			<TD>：</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="maxCnt_F" SIZE="10" MAXLENGTH="3" VALUE="<%= lngMaxCnt_F %>" STYLE="ime-mode:disabled;"></TD>
		</TR>
<%
	End If
%>
	<TR>
		<TD WIDTH="132"><IMG SRC="../../images/spacer.gif" BORDER="0" WIDTH="10" HEIGHT="10" </TD>
		<TD></TD>
		<TD NOWRAP></TD>
	</TR>
	<TR>
		<TD WIDTH="132">オーバ可能人数（共通）</TD>
		<TD>：</TD>
<%
		'男女別枠管理しない または新規
		If lngMngGender = 0 Or strMode = "insert" Then
%>
			<TD NOWRAP><INPUT TYPE="text" NAME="overCnt" SIZE="10" MAXLENGTH="3" VALUE="<%= lngOverCnt %>" STYLE="ime-mode:disabled;"></TD>
<%
		Else
%>
			<TD>指定不可能</TD>
<%
		End If
%>
	</TR>
<%
	'男女別枠管理しない（更新のとき）
	If lngMngGender = 0 And strMode = "update" Then
%>
		<TR>
			<TD WIDTH="132">オーバ可能人数（男性）</TD>
			<TD>：</TD>
			<TD>指定不可能</TD>
		</TR>
		<TR>
			<TD WIDTH="132">オーバ可能人数（女性）</TD>
			<TD>：</TD>
			<TD>指定不可能</TD>
		</TR>
<%
	Else
%>
		<TR>
			<TD WIDTH="132">オーバ可能人数（男性）</TD>
			<TD>：</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="overCnt_M" SIZE="10" MAXLENGTH="3" VALUE="<%= lngOverCnt_M %>" STYLE="ime-mode:disabled;"></TD>
		</TR>
		<TR>
			<TD WIDTH="132">オーバ可能人数（女性）</TD>
			<TD>：</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="overCnt_F" SIZE="10" MAXLENGTH="3" VALUE="<%= lngOverCnt_F %>" STYLE="ime-mode:disabled;"></TD>
		</TR>
<%
	End If
%>
	<TR>
		<TD WIDTH="132"><IMG SRC="../../images/spacer.gif" BORDER="0" WIDTH="10" HEIGHT="10" </TD>
		<TD></TD>
		<TD NOWRAP></TD>
	</TR>
	<TR>
		<TD WIDTH="132">予約済み人数（男）</TD>
		<TD>：</TD>
		<TD NOWRAP><%= lngRsvCnt_M %>人</TD>
		<INPUT TYPE="hidden" NAME="rsvCnt_M"  VALUE="<%= lngRsvCnt_M %>">
	</TR>
	<TR>
		<TD WIDTH="132">予約済み人数（女）</TD>
		<TD>：</TD>
		<TD NOWRAP><%= lngRsvCnt_F %>人</TD>
		<INPUT TYPE="hidden" NAME="rsvCnt_F"  VALUE="<%= lngRsvCnt_F %>">
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<TR><!-- 修正時 -->
<%
	If strMode = "update" Then
%>
	    <% If Session("PAGEGRANT") = "4" Then %>	
            <TD WIDTH="190"><A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容を削除します"></A></TD>
        <% End IF %>

<%
	Else
%>
		<TD WIDTH="190"></TD>
<%
	End If
%>
	<TD WIDTH="5"></TD>
	<TD>
	<% '2005.08.22 権限管理 Add by 李　--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
		<A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で確定します"></A>
	<%  else    %>
		 &nbsp;
	<%  end if  %>
	<% '2005.08.22 権限管理 Add by 李　--- END %>
	</TD>


	<TD WIDTH="5"></TD>
	<TD>
		<A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルします"></A></TD>
	</TD>
</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
