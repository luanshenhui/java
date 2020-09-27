<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		家族歴入力 (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditConditionList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim strMode                             '処理モード(挿入:"insert"、更新:"update")
Dim strAction                           '処理状態(登録ボタン押下時:"save"、保存完了後:"saveend")
Dim strButton                           'ボタン種別(登録ボタン押下時:"登　録"、戻るボタン押下時:"戻　る")
Dim strPerID                            '個人ＩＤ
Dim strRelation                         '続柄
Dim strDisCd                            '病名コード
Dim strDisName                          '病名
Dim lngStrYear                          '発病年月（年）
Dim lngStrMonth                         '発病年月（月）
Dim lngEndYear                          '治癒年月（年）
Dim lngEndMonth                         '治癒年月（月）
Dim strCondition                        '状態
Dim strMedical                          '医療機関
Dim strStrDate                          '発病年月（編集用）
Dim strEndDate                          '治癒年月（編集用）

Dim strLastName                         '姓
Dim strFirstName                        '名
Dim strLastKName                        'カナ姓
Dim strFirstKName                       'カナ名
Dim strBirth                            '生年月日
Dim strGenderName                       '性別名称

Dim objCommon                           '共通関数アクセス用COMオブジェクト
Dim objDisease                          '既往歴家族歴情報アクセス用COMオブジェクト

Dim strArrMessage                       'エラーメッセージ
Dim Ret                                 '関数戻り値
Dim i                                   'インデックス
Dim strHTML                             'HTML文字列

Dim strArrRelation		'続柄
Dim strArrRelationName	'続柄名称

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strMode       = Request("mode") & ""
strAction     = Request("action") & ""
strButton     = Request("submit") & ""
strPerID      = Request("perid") & ""
strRelation   = Request("relation") & ""
strDisCd      = Request("discd") & ""
strDisName    = Request("disname") & ""
lngStrYear    = CLng("0" & Request("stryear"))
lngStrMonth   = CLng("0" & Request("strmonth"))
lngEndYear    = CLng("0" & Request("endyear"))
lngEndMonth   = CLng("0" & Request("endmonth"))
strCondition  = Request("condition") & ""
strMedical    = Request("medical") & ""

'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objDisease = Server.CreateObject("HainsDisease.Disease")

'チェック・更新・読み込み処理の制御
Do 
        '戻るボタン押下時
        If strButton = "戻　る" Then
                '既往歴・家族歴一覧画面にリダイレクト
                Response.Redirect "perDisease.asp?perID=" & strPerID
                Response.End
        End If

        '発病年月、治癒年月編集
        strStrDate = lngStrYear & "/" & lngStrMonth & "/1"
        strEndDate = lngEndYear & "/" & lngEndMonth & "/1"

        '保存ボタン押下時
        If strAction = "save" Then

                '入力チェック
                strArrMessage = objDisease.CheckValue(strPerID, _
                                                      strRelation, _
                                                      strDisCd, _
                                                      lngStrYear, _
                                                      lngStrMonth, _
                                                      lngEndYear, _
                                                      lngEndMonth,_
                                                      strCondition, _
                                                      strMedical, _
                                                      strStrDate, _
                                                      strEndDate _
                                                     )

                'チェックエラー時は処理を抜ける
                If Not IsEmpty(strArrMessage) Then
                    Exit Do
                End If

                '保存処理
                If strMode = "update" Then

                        '既往歴家族歴テーブルレコード更新
                        Ret = objDisease.UpdateDisHistory(strPerID, _
                                                          strRelation, _
                                                          strDisCd, _
                                                          strStrDate, _
                                                          strEndDate, _
                                                          strCondition, _
                                                          strMedical _
                                                         )

                        'データなし時はエラーメッセージを編集する
                        If Ret = UPDATE_NOTFOUND Then
                                strArrMessage = Array("該当するデータは既に削除されています。")
                                Exit Do
                        End If

                Else
                        '既往歴家族歴テーブルレコード挿入
                        Ret = objDisease.InsertDisHistory(strPerID, _
                                                          strRelation, _
                                                          strDisCd, _
                                                          strStrDate, _
                                                          strEndDate, _
                                                          strCondition, _
                                                          strMedical _
                                                         )

                        'キー重複時はエラーメッセージを編集する
                        If Ret = INSERT_DUPLICATE Then
                                strArrMessage = Array("同一続柄，病名，発病年月の家族歴情報がすでに存在します。")
                                Exit Do
                        End If

                End If

                '病名コードの整合性エラー時はエラーメッセージを編集する
                If Ret = ALERT_FKEY2 Then
                        strArrMessage = Array("存在しない病名です。")
                        Exit Do
                End If

                '保存に成功した場合、更新モードでリダイレクト
                Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&action=saveend&perID=" & strPerID & "&relation=" & strRelation & "&disCd=" & strDisCd & "&stryear=" & lngStrYear & "&strmonth=" & lngStrMonth
                Response.End

        End If

        '新規モードの場合は読み込みを行わない
        If strMode = "insert" Then
            '初期表示設定
            lngStrYear = Year(Now)
            lngStrMonth = Month(Now)
            Exit Do
        End If

        '既往歴家族歴テーブルレコード読み込み
        Call objDisease.SelectDisHistory(strPerID, _
                                         strRelation, _
                                         strDisCd, _
                                         strStrDate, _
                                         lngEndYear, _
                                         lngEndMonth, _
                                         strCondition, _
                                         strMedical, _
                                         strDisName _
                                        )

        Exit Do
Loop

'-----------------------------------------------------------------------------
' メッセージの編集
'-----------------------------------------------------------------------------
Function EditMessage()

        Dim strHTML     'HTML文字列
        Dim i           'インデックス

        '処理状態未指定時以外は何もしない
        If strAction = "" Then
                Exit Function
        End If

        Do
                '保存完了時は「保存完了」の通知
                If strAction = "saveend" Then
                        strHTML = "<FONT COLOR=""#ff6600"" SIZE=""+1""><B>保存しました。</B></FONT><BR><BR>"
                        Exit Do
                End If

                'エラーメッセージの編集
                strHTML = "<UL>"

                For i = 0 To UBound(strArrMessage)
                        strHTML = strHTML & vbLf & "<LI>" & strArrMessage(i)
                Next

                strHTML = strHTML & vbLf & "</UL>"

                Exit Do
        Loop

        EditMessage = strHTML

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>家族歴入力画面</TITLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryfamily" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

        <INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
        <INPUT TYPE="hidden" NAME="action" VALUE="save">
		<INPUT TYPE="hidden" NAME="perID" VALUE="<%= strPerID %>">
		<INPUT TYPE="hidden" NAME="medical" VALUE="">
		<INPUT TYPE="hidden" NAME="disname" VALUE="<%= strDisName %>">

<%
        '修正時のキー項目は入力不可のためhiddenでもつ
        If strMode = "update" Then
%>
			<INPUT TYPE="hidden" NAME="relation" VALUE="<%= strRelation %>">
			<INPUT TYPE="hidden" NAME="disCd" VALUE="<%= strDisCd %>">
			<INPUT TYPE="hidden" NAME="stryear" VALUE="<%= lngStrYear %>">
			<INPUT TYPE="hidden" NAME="strmonth" VALUE="<%= lngStrMonth %>">
<%
        End If

		'個人情報のレコードを取得
		If objDisease.SelectPerson(strPerID, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGenderName) Then

			'個人情報の編集
%>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="626">
				<TR>
					<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="TOP"><%= strPerID %></TD>
					<TD NOWRAP><B><%= strLastName & "　" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
				</TR>
				<TR>
					<TD NOWRAP><%= strBirth %>生　<%= strGenderName %></TD>
				</TR>
			</TABLE>
<%
		End If
%>
		<BR>

		<BR>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="100%">
			<TR VALIGN="bottom">
				<TD COLSPAN="2"><FONT SIZE="+2"><B>家族歴の入力</B></FONT></TD>
			</TR>
			<TR HEIGHT="2">
				<TD COLSPAN="2" BGCOLOR="#CCCCCC"><IMG SRC="webHains/images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
			</TR>
		</TABLE>
		<BR> 

        <%= EditMessage() %>

		<BR> 
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
			<TR>
				<TD><FONT color="#666666">■</FONT>続柄</TD>
				<TD>：</TD>
				<TD>
<%
					'修正時はキー項目変更不可（表示のみ）
					If strMode = "update" Then
%>
						<%= objCommon.SelectRelationName(strRelation) %>
<%
					Else

						'続柄情報の編集
						If objCommon.SelectRelationList(strArrRelation, strArrRelationName) > 0 Then
%>
							<%= EditDropDownListFromArray("relation", strArrRelation, strArrRelationName, strRelation, NON_SELECTED_ADD) %>
<%
						End If

					End If
%>
				</TD>
			</TR>
			<TR>
				<TD><FONT color="#666666">■</FONT>病名</TD>
				<TD>：</TD>
				<TD>
<%
					'修正時はキー項目変更不可（表示のみ）
					If strMode = "update" Then
%>
						<%= strDisName %>
<%
					Else
%>
						<INPUT TYPE="text" NAME="disCd" SIZE="<%= TextLength(9) %>" MAXLENGTH="<%= TextMaxLength(18) %>" VALUE="<%= strDisCd %>" >
<%
					End If
%>
				</TD>
			</TR>
			<TR>
				<TD><FONT color="#666666">■</FONT>発病年月</TD>
				<TD>：</TD>
				<TD>
<%
					'修正時はキー項目変更不可（表示のみ）
					If strMode = "update" Then
%>
						<%= objCommon.FormatString(lngStrYear & "/" & lngStrMonth & "/1", "yyyy年mm月") %>
<%
					Else
%>
						<%= EditSelectYearList(YEARS_BIRTH, "stryear", lngStrYear) %>年
						<%= EditSelectNumberList("strmonth", 1, 12, lngStrMonth) %>月
<%
					End If
%>
				</TD>
			</TR>
			<TR>
				<TD><FONT color="#666666">■</FONT>治癒年月</TD>
				<TD>：</TD>
				<TD>
					<%= EditSelectYearList(YEARS_BIRTH, "endyear", lngEndYear) %>年
					<%= EditSelectNumberList("endmonth", 1, 12, lngEndMonth) %>月
				</TD>
			</TR>
			<TR>
				<TD><FONT color="#666666">■</FONT>状態</TD>
				<TD>：</TD>
				<TD>
					<%= EditConditionList("condition", strCondition) %>
				</TD>
			</TR>
		</TABLE>
		<BR>
		<BR>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="150">		
			<TR>
				<TD ALIGN="left">
					<INPUT TYPE="submit" NAME="submit" VALUE="登　録">
					<INPUT TYPE="submit" NAME="submit" VALUE="戻　る">
				</TD>
			</TR>
		</TABLE>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>