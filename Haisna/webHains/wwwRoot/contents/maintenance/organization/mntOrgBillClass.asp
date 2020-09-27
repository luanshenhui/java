<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		団体請求書分類メンテナンス (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto K-MIX
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc" -->
<!-- #include virtual = "/webHains/includes/EditIsrDivList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objOrganization		'団体テーブルアクセス用
Dim objOrgBillClass		'団体請求書分類アクセス用

Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget			'ターゲット先のURL
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strOrgKName			'団体カナ名
Dim strOrgName			'団体名
Dim strOrgSName			'団体略称

Dim blnOpAnchor			'操作用アンカー制御
Dim strArrMessage		'エラーメッセージ
Dim strMessage			'エラーメッセージ（編集用）
Dim lngStatus			'関数戻り値
Dim i					'インデックス

Dim strBillClassCd		'請求書分類コード
Dim strOrgBillName		'請求書用名称
Dim strArrBillClassCd	'請求書分類（表示用）
Dim strArrBillClassName	'請求書名（表示用）
Dim strArrOrgCd			'団体コード（表示用）
Dim strArrCheckFlg		'
Dim strCheckFlg			'
Dim strCsCd				'
Dim strLngCount			'
Dim vntArrMessage		'エラーメッセージの集合

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBillClass = Server.CreateObject("HainsOrgBillClass.OrgBillClass")

'引数値の取得
strMode        = Request("mode")
strAction      = Request("action")
strTarget      = Request("target")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")

strBillClassCd = Request("billClassCd")
strArrBillClassCd	= IIf( strBillClassCd = "" , Empty  , ConvIStringToArray(strBillClassCd) )
strArrCheckFlg		= IIf( strBillClassCd = "" , Empty  , ConvIStringToArray(strBillClassCd) )

'チェック・更新・読み込み処理の制御
Do
	'保存ボタン押下時
	If strAction = "save" Then

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'保存処理
		If strMode = "update" Then

			'請求書分類管理コーステーブル重複チェック
			if( Not IsEmpty(strArrBillClassCd) ) Then
				lngStatus = objOrgBillClass.SelectBillClass_c( _
													strArrBillClassCd, _
													strCsCd, _
													strLngCount _
															 )
															 
				'インサートエラーとなった場合はエラーメッセージを追加する。
				If( Not IsEmpty(strCsCd) ) Then
						strMessage = "請求書分類管理のコースが重複しています。"
						For i = 0 To Ubound(strCsCd)
							strMessage = strMessage & "( " & strCsCd(i) & " ) <BR>"
							objCommon.AppendArray strArrMessage, strMessage
						Next
						Exit Do
				End If
			End If

			'団体請求書分類テーブルレコード更新
			lngStatus = objOrgBillClass.InsertOrgBillClass( _
												strOrgCd1, _
												strOrgCd2, _
												strArrBillClassCd _
											  			  )
			'インサートエラーとなった場合はエラーメッセージを追加する。
			If( lngStatus < 0 ) Then
				objCommon.AppendArray strArrMessage, "団体請求書分類テーブルへのデータ追加に失敗しました。"
				Exit Do
			End If

		End If

		'保存に成功した場合、ターゲット指定時は指定先のURLへジャンプし、未指定時は更新モードでリダイレクト
		If strTarget <> "" Then
			Response.Redirect strTarget & "?orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2
		Else
			Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&action=saveend&orgcd1=" & strOrgCd1 & "&orgcd2=" & strOrgCd2
		End If
		Response.End
	End If

	Exit Do
Loop

	'団体テーブルレコード読み込み
	objOrganization.SelectOrg strOrgCd1, strOrgCd2, strOrgKName, strOrgName, strOrgBillName, strOrgSName

	'団体請求書分類テーブルレコード読み込み
	objOrgBillClass.SelectBillClass _
										strOrgCd1, _
										strOrgCd2, _
										strArrBillClassCd, _
										strArrBillClassName, _
										strArrCheckFlg

									   
'-------------------------------------------------------------------------------
'
' 機能　　 : 団体情報各値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()
'
'	Dim objCommon		'共通クラス
'
'	Dim vntArrMessage	'エラーメッセージの集合
'	Dim strMessage		'エラーメッセージ
'	Dim i				'インデックス
'
'	'共通クラスのインスタンス作成
'	Set objCommon = Server.CreateObject("HainsCommon.Common")
'
'	'各値チェック処理
'	With objCommon
'
'
'	End With
'
'	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
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
<TITLE>団体請求書分類メンテナンス</TITLE>
<!-- #include virtual = "/webHains/includes/zipGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--


//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:zipGuide_closeGuideZip()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"   VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="action" VALUE="save">
	<INPUT TYPE="hidden" NAME="target" VALUE="<%= strTarget %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">団体請求書分類メンテナンス</FONT></B></TD>
		</TR>
	</TABLE>

<!-- 操作ボタン -->
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="650">
<TR>
	<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
</TR>
<TR>
	<TD ALIGN="right">
		<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
			<TR>
<!--  2003/01/22  EDIT  START  E.Yamamoto  -->
<!-- 				<TD><A HREF="../mntMenu.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A></TD>  -->
				<TD><A HREF="mntOrganization.asp?mode=update&orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A></TD>
<!--  2003/01/22  EDIT  END    E.Yamamoto  -->
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>

				<TD><INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>

			</TR>
		</TABLE>
	</TD>
</TR>
<TR>
	<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
</TR>
</TABLE>

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
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">団体コード</TD>
			<TD WIDTH="5"></TD>
			<TD><%= strOrgCd1 %>－<%= strOrgCd2 %>
				<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>"><INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">団体カナ名称</TD>
			<TD></TD>
			<TD><%= strOrgKName %></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">団体名称</TD>
			<TD></TD>
			<TD><%= strOrgName %></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">団体略称</TD>
			<TD></TD>
			<TD><%= strOrgSName %></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">請求書分類名称</TD>
			<TD></TD>
			<TD><%= strOrgBillName %></TD>
		</TR>
		<TR>
			<TD ROWSPAN="<%= UBound(strArrBillClassCd) + 1 %>"HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">請求書分類</TD>
<%
		For i = 0 To UBound(strArrBillClassCd)
%>
		<%= IIf( i <> 0 ,"		<TR>" , "") %>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
					<TR>
						<TD><INPUT TYPE="CHECKBOX" NAME="billClassCd" VALUE="<%= strArrBillClassCd(i) %>" <%= IIf( strArrCheckFlg(i) <> "" , "CHECKED" , ""  ) %>><%= strArrBillClassName(i) %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<% 
		Next
%>
					</TR>
				</TABLE>
		</TR>
	</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
