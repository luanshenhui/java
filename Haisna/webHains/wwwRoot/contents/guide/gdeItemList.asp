<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		項目ガイド(リスト部) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_R        = 1			'｢依頼モード｣
Const MODE_I        = 2			'｢結果モード｣
Const TABLEDIV_I    = 1			'｢検査項目｣
Const TABLEDIV_G    = 2			'｢グループ｣
Const SELECT_ALL    = "すべて"	'選択条件名｢すべて｣
Const SELECT_OTHERS = "その他"	'選択条件名｢その他｣

Const DATADIV_P     = "P"		'項目分類｢依頼項目｣
Const DATADIV_C     = "C"		'項目分類｢検査項目｣
Const DATADIV_G     = "G"		'項目分類｢グループ｣

Const ROWCOUNT      = 2			'項目表示列数　２列

Dim objItem						'項目ガイドアクセス用COMオブジェクト
Dim objGrp						'項目ガイドアクセス用COMオブジェクト

Dim strArrItemCd				'項目コード
Dim strArrSuffix				'サフィックス
Dim strArrItemName				'項目名称
Dim strArrResultType			'結果タイプ
Dim strArrItemType				'項目タイプ

Dim lngMode						'依頼／結果モード　1:依頼、2:結果
Dim lngQuestion					'問診項目表示有無　0:表示しない、1:表示する
Dim lngTableDiv					'テーブル選択区分　1:検査項目、　2:グループ　(0:デフォルト値)
Dim strClassCd					'検索分野コード
Dim strClassName				'検索分野名
Dim strSearchChar				'検索用先頭文字列

Dim strDataDiv					'項目分類

Dim strDispClassName			'表示用選択分野
Dim strDispSearchChar			'表示用先頭文字
Dim strHTML						'HTML文字列
Dim lngCount					'レコード件数
Dim i							'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objItem = Server.CreateObject("HainsItem.Item")
Set objGrp  = Server.CreateObject("HainsGrp.Grp")

'引数値の取得
lngMode       = CLng(Request("mode"    ))
lngQuestion   = CLng(Request("question"))
lngTableDiv   = CLng(Request("tableDiv"))
strClassCd    = Request("classCd"   ) & ""
strClassName  = Request("className" ) & ""
strSearchChar = Request("searchChar") & ""

'レコード件数初期化
lngCount = 0

'検索条件表示名称の編集(選択分野)
Select Case strClassCd
	Case ""				'すべて
		strDispClassName = SELECT_ALL
	Case Else			'指定の選択分野
		strDispClassName = strClassName
End Select

'検索条件表示名称の編集(先頭文字)
Select Case strSearchChar
	Case ""				'すべて
		strDispSearchChar = SELECT_ALL
	Case "*"			'その他
		strDispSearchChar = SELECT_OTHERS
	Case Else			'指定の先頭文字
		strDispSearchChar = strSearchChar
End Select

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>項目ガイド</TITLE>
</HEAD>

<BODY>

<FORM NAME="entryform" ACTION="">
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD><SPAN STYLE="font-size:9pt;font-weight:bolder">検索条件</SPAN></TD>
		</TR>
		<TR>
			<TD>
				<SPAN STYLE="font-size:9pt;">選択分野：<FONT COLOR="#FF6600"><B><%= strDispClassName %></B></FONT></SPAN>&nbsp;
				<SPAN STYLE="font-size:9pt;">先頭文字：<FONT COLOR="#FF6600"><B><%= strDispSearchChar %></B></FONT></SPAN>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" STYLE="font-size:13px;">
		<TD></TD>
		<TD WIDTH="50%"></TD>
		<TD></TD>
		<TD WIDTH="50%"></TD>
<%
	Do
		'項目コード、名称の抽出
		Select Case lngTableDiv 

			'検査項目選択時
			Case TABLEDIV_I

				'｢依頼モード｣
				If lngMode = MODE_R Then

					'項目分類｢依頼項目｣
					strDataDiv = DATADIV_P
					lngCount = objItem.SelectItem_pList(strClassCd, strSearchChar, ITEM_NOTDISP, strArrItemCd, strArrSuffix, strArrItemName)

				'｢結果モード｣
				ElseIf lngMode = MODE_I Then

					'項目分類｢検査項目｣
					strDataDiv = DATADIV_C
					lngCount = objItem.SelectItem_cList(strClassCd, strSearchChar, lngQuestion, strArrItemCd, strArrSuffix, strArrItemName, , strArrResultType, , , strArrItemType)

				'モードが選択できなければ何もしない
				Else
					Exit Do
				End If

			'グループ選択時
			Case TABLEDIV_G

				'項目分類｢グループ｣
				strDataDiv = DATADIV_G

				'｢依頼モード｣
				If lngMode = MODE_R Then
'### 2003.02.17 Updated by Ishihara@FSIT システムグループは非表示
'					lngCount = objGrp.SelectGrp_pList(GRPDIV_R, strClassCd, strSearchChar, strArrItemCd, strArrSuffix, strArrItemName)
					lngCount = objGrp.SelectGrp_pList(GRPDIV_R, strClassCd, strSearchChar, strArrItemCd, strArrSuffix, strArrItemName, True)

				'｢結果モード｣
				ElseIf lngMode = MODE_I Then
'### 2003.02.17 Updated by Ishihara@FSIT システムグループは非表示
'					lngCount = objGrp.SelectGrp_pList(GRPDIV_I, strClassCd, strSearchChar, strArrItemCd, strArrSuffix, strArrItemName)
					lngCount = objGrp.SelectGrp_pList(GRPDIV_I, strClassCd, strSearchChar, strArrItemCd, strArrSuffix, strArrItemName, True)

				'モードが選択できなければ何もしない
				Else
					Exit Do
				End If

			'検査項目／グループが選択されていなければ何もしない
			Case Else
				Exit Do

		End Select

		'該当項目がない場合表示しない
		If lngCount = 0 Then
			Exit Do
		End If

		'検査分類テーブルの編集
		For i = 0 To lngCount - 1

			strHTML = ""

			'左端列処理
			If (i mod ROWCOUNT) = 0 Then
%>
				<TR>
<%
			End If

			'検査項目の結果モードの場合のみ結果タイプ・項目タイプを編集
			If lngTableDiv = TABLEDIV_I And lngMode = MODE_I Then
%>
				<TD><INPUT TYPE="checkbox" NAME="rinam" VALUE="<%= strArrItemCd(i) & "," & strArrSuffix(i) & "," & strDataDiv & "," & strArrItemName(i) & "," & strArrResultType(i) & "," & strArrItemType(i) %>" ONCLICK="top.controlSelectedItem(this)"></TD>
<%
			Else
%>
				<TD><INPUT TYPE="checkbox" NAME="rinam" VALUE="<%= strArrItemCd(i) & "," & strArrSuffix(i) & "," & strDataDiv & "," & strArrItemName(i) & ",," %>" ONCLICK="top.controlSelectedItem(this)"></TD>
<%
			End If
%>
			<TD NOWRAP><%= strArrItemCd(i) & " " & strArrSuffix(i) & " " & strArrItemName(i) %></TD>
<%
			'右端列処理
			If (i mod ROWCOUNT) = ROWCOUNT - 1 Then
%>
				</TR>
<%
			End If

		Next

		'端数列処理
		If ((lngCount - 1) mod ROWCOUNT) < ROWCOUNT - 1 Then
%>
			</TR>
<%
		End If

		Exit Do
	Loop
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
