<%
'-----------------------------------------------------------------------------
'		共通関数(団体情報一覧編集) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
%>
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 団体情報一覧の編集
'
' 引数　　 : (In)     strKey             検索キー
' 　　　　 : (In)     lngStartPos        検索開始位置
' 　　　　 : (In)     lngGetCount        表示件数
' 　　　　 : (In)     strBasedURL        団体選択時にジャンプするURLの共通部
' 　　　　 : (In)     blnNoAnchorPerson  True時、個人・web予約にはアンカーを張らない
' 　　　　 : (In)     blnNoAnchorIsr     True時、健保にはアンカーを張らない
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditOrgList(strKey, lngStartPos, lngGetCount, strBasedURL, blnNoAnchorPerson, blnNoAnchorIsr)

	Dim strArrKey			'(分割後の)検索キーの集合

	Dim objCommon			'共通クラス
	Dim objOrganization		'団体情報アクセス用COMオブジェクト

	Dim strPerOrgCd1		'個人受診用団体コード1
	Dim strPerOrgCd2		'個人受診用団体コード2
	Dim strWebOrgCd1		'Web用団体コード1
	Dim strWebOrgCd2		'Web用団体コード2

	Dim strOrgCd1			'団体コード1
	Dim strOrgCd2			'団体コード2
	Dim strOrgName			'団体名称
	Dim strOrgSName			'略称
	Dim strOrgKanaName		'団体カナ名称

	Dim lngCount			'レコード件数

	Dim strDispOrgCd1		'編集用の団体コード1
	Dim strDispOrgCd2		'編集用の団体コード2
	Dim strDispOrgName		'編集用の漢字名称
	Dim strDispOrgKanaName	'編集用のカナ名称

	Dim strCnvKey			'キー変換値

	Dim i, j				'インデックス

	'個人受診、web用団体コードの取得
	Set objCommon = Server.CreateObject("HainsCommon.Common")
	objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
	objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2
	Set objCommon = Nothing

	'検索キーを空白で分割する
	strArrKey = SplitByBlank(strKey)

	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

	'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
	lngCount = objOrganization.SelectOrgList(strArrKey, lngStartPos, lngGetCount, strOrgCd1, strOrgCd2, strOrgName, strOrgSName, strOrgKanaName)

	Set objOrganization = Nothing
%>
	<BR>
	<BR>
<%
	'検索結果が存在しない場合はメッセージを編集
	If lngCount = 0 Then
%>
		検索条件を満たす団体情報は存在しません。<BR>
		キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
		Exit Sub
	End If

	If strKey <> "" Then
%>
		「<FONT COLOR="#ff6600"><B><%= strKey %></B></FONT>」の検索結果は <FONT COLOR="#ff6600"><B><%= CStr(lngCount) %></B></FONT>件ありました。<BR><BR>
<%
	Else
%>
		検索結果は <FONT COLOR="#ff6600"><B><%= CStr(lngCount) %></B></FONT>件ありました。<BR><BR>
<%
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
<%
		For i = 0 To UBound(strOrgCd1)

			'団体情報の取得
			strDispOrgCd1      = strOrgCd1(i)
			strDispOrgCd2      = strOrgCd2(i)
			strDispOrgName     = strOrgName(i)
			strDispOrgKanaName = strOrgKanaName(i)

			'検索キーに合致する部分に<B>タグを付加
			If Not IsEmpty(strArrKey) Then

				For j = 0 To UBound(strArrKey)

					If Instr(strDispOrgCd1, strArrKey(j)) = 1 Then
						strDispOrgCd1 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd1, Len(strDispOrgCd1) - Len(strArrKey(j)))
					End If

					If Instr(strDispOrgCd2, strArrKey(j)) = 1 Then
						strDispOrgCd2 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd2, Len(strDispOrgCd2) - Len(strArrKey(j)))
					End If

					strDispOrgName     = Replace(strDispOrgName,     strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispOrgKanaName = Replace(strDispOrgKanaName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")

					'小さいカナを変換したパターン
					strCnvKey = strArrKey(j)
					strCnvKey = Replace(strCnvKey, "ァ", "ア")
					strCnvKey = Replace(strCnvKey, "ィ", "イ")
					strCnvKey = Replace(strCnvKey, "ゥ", "ウ")
					strCnvKey = Replace(strCnvKey, "ェ", "エ")
					strCnvKey = Replace(strCnvKey, "ォ", "オ")
					strCnvKey = Replace(strCnvKey, "ッ", "ツ")
					strCnvKey = Replace(strCnvKey, "ャ", "ヤ")
					strCnvKey = Replace(strCnvKey, "ュ", "ユ")
					strCnvKey = Replace(strCnvKey, "ョ", "ヨ")

					'変換後の値が元の値と異なる場合は更に置換する
					If strCnvKey <> strArrKey(j) Then

						strDispOrgName     = Replace(strDispOrgName,     strCnvKey, "<B>" & strCnvKey & "</B>")
						strDispOrgKanaName = Replace(strDispOrgKanaName, strCnvKey, "<B>" & strCnvKey & "</B>")

					End If

				Next

			End If

			'団体情報の編集
%>
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><%= strDispOrgCd1 %>-<%= strDispOrgCd2 %></TD>
				<TD WIDTH="10"></TD>
<%
				'個人・web予約または健保の場合はアンカーを張らない
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'				If (blnNoAnchorPerson And ((strOrgCd1(i) = strPerOrgCd1 And strOrgCd2(i) = strPerOrgCd2) Or (strOrgCd1(i) = strWebOrgCd1 And strOrgCd2(i) = strWebOrgCd2))) Or _
'				   (blnNoAnchorIsr And strOrgDiv(i) = "1") Then
				If blnNoAnchorPerson And ((strOrgCd1(i) = strPerOrgCd1 And strOrgCd2(i) = strPerOrgCd2) Or (strOrgCd1(i) = strWebOrgCd1 And strOrgCd2(i) = strWebOrgCd2)) Then
'## 2003.11.18 Mod End
%>
					<TD NOWRAP><%= strDispOrgName %></TD>
<%
				Else
%>
					<TD NOWRAP><A HREF="<%= strBasedURL %>orgCd1=<%= strOrgCd1(i) %>&orgCd2=<%= strOrgCd2(i) %>"><%= strDispOrgName %></A></TD>
<%
				End If
%>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><FONT COLOR="666666">（<%= strDispOrgKanaName %>）</FONT></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'ページングナビゲータの編集
%>
	<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?act=1&key=" & Server.URLEncode(strKey), lngCount, lngStartPos, lngGetCount) %>
<%
End Sub
%>
