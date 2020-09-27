<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人情報一覧の編集
'
' 引数　　 : (In)     strKey              検索キー
' 　　　　   (In)     lngStartPos         検索開始位置
' 　　　　   (In)     lngGetCount         表示件数
' 　　　　   (In)     strBasedURL         個人選択時にジャンプするURLの共通部
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditPersonList(strKey, lngStartPos, lngGetCount, strBasedURL)

	Const PREFIX_PERID = "ID:"	'検索時の個人ＩＤ指定

	Dim objCommon			'共通クラス
	Dim objPerson			'個人情報アクセス用

	Dim strArrKey			'(分割後の)検索キーの集合
	Dim lngAllCount			'条件を満たす全レコード件数

	Dim strPerId			'個人ＩＤ
	Dim strLastName			'姓
	Dim strFirstName		'名
	Dim strLastKName		'カナ姓
	Dim strFirstKName		'カナ姓
	Dim strRomeName			'ローマ字名
	Dim strBirth			'生年月日
	Dim strAge				'年齢
	Dim strGender			'性別
	Dim lngCount			'レコード件数

	Dim strDispPerId		'編集用の個人ＩＤ
	Dim strDispLastName		'編集用の漢字名称
	Dim strDispFirstName	'編集用の漢字名称
	Dim strDispName			'編集用の漢字名称
	Dim strDispLastKName	'編集用のカナ名称
	Dim strDispFirstKName	'編集用のカナ名称
	Dim strDispKName		'編集用のカナ名称

	Dim strBuffer			'文字列バッファ
	Dim strURL				'URL文字列

	Dim strEditAge			'年齢

	Dim i, j				'インデックス

	Dim strDispRomeName		'ローマ字名
	Dim lngPos				'検索位置

	Dim strRepStr1			'置換用文字列１
	Dim strRepStr2			'置換用文字列２
	Dim strRepPerId			'置換用個人ＩＤ
	Dim lngCnvMode			'置換モード

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")
	Set objPerson = Server.CreateObject("HainsPerson.Person")

	Do
		'検索条件が存在しない場合は何もしない
		If strKey = "" Then
			Exit Do
		End If

		'検索条件を満たすレコード件数を取得
		lngAllCount = objPerson.SelectPersonListCount(strKey)
%>
		<BR>
<%
		'検索結果が存在しない場合はメッセージを編集
		If lngAllCount = 0 Then
%>
			検索条件を満たす個人情報は存在しません。<BR>
			キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
			Exit Do
		End If

		'レコード件数情報を編集
%>
		検索結果は <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR>
<%
		'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
		lngCount = objPerson.SelectPersonList(strKey, 0, lngStartPos, lngGetCount, , , , , strPerId, , strLastName, strFirstName, strLastKName, strFirstKName, strRomeName, strBirth, strAge, strGender)
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>個人ＩＤ</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>氏名</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>ローマ字</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>性別</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>生年月日</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>年齢</TD>
			</TR>
			<TR style="height:1px">
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="11"></TD>
			</TR>
<%
			'何を置換するか決定
			Select Case True
				Case objPerson.IsWide(strKey)
					lngCnvMode = 0
				Case objPerson.IsPerId(strKey)
					lngCnvMode = 1
				Case Else
					lngCnvMode = 2
			End Select

			For i = 0 To lngCount - 1

				'表示用個人名称の編集
				strDispPerId      = strPerID(i)
				strDispLastName   = strLastName(i)
				strDispFirstName  = strFirstName(i)
				strDispLastKName  = strLastKName(i)
				strDispFirstKName = strFirstKName(i)
				strDispRomeName   = strRomeName(i)

				Do

					'１つ目の空白を検索。見つからない場合は姓のみ。
					lngPos = InStr(1, strKey, " ")
					If lngPos <= 0 Then
						strRepStr1 = Trim(strKey)
						strRepStr2 = ""
						Exit Do
					End If

					'１つ目の空白以降の部分文字列を取得。なければ複合検索を行わない場合と同じ
					strBuffer = Trim(Right(strKey, Len(strKey) - lngPos))
					If strBuffer = "" Then
						strRepStr1 = Trim(strKey)
						strRepStr2 = ""
						Exit Do
					End If

					'姓名に分離
					strRepStr1 = Trim(Left(strKey, lngPos - 1))
					strRepStr2 = strBuffer

					Exit Do
				Loop

				'検索キーに合致する部分に<B>タグを付加

				'個人ＩＤ
				If lngCnvMode = 1 Then

					'先頭３文字が"ID:"である場合は先頭部を取り除いた部分を個人IDとして取得、それ以外は引数値をそのまま使用
					If UCase(Left(strKey, Len(PREFIX_PERID))) = PREFIX_PERID Then
						strRepPerId = Right(strKey, Len(strKey) - Len(PREFIX_PERID))
					Else
						strRepPerId = strKey
					End If

					'文字列の末尾が"*"ならカット
					If Right(strRepPerId, 1) = "*" Then
						strRepPerId = Left(strRepPerId, Len(strRepPerId) - 1)
					End If

					strDispPerId = Replace(strDispPerId, strRepPerId, "<B>" & strRepPerId & "</B>", 1, 1)

				End If

				'ローマ字名
				If lngCnvMode = 2 Then

					lngPos = InStr(1, strDispRomeName, " ", 1)

					If strRepStr2 <> "" And lngPos > 0 Then
						strDispRomeName = Left(strDispRomeName, lngPos) & Replace(strDispRomeName, strRepStr2, "<FONT COLOR=""#ff6600""><B>" & strRepStr2 & "</B></FONT>", lngPos + 1, 1, 1)
					End If

					strDispRomeName = Replace(strDispRomeName, strRepStr1, "<FONT COLOR=""#ff6600""><B>" & strRepStr1 & "</B></FONT>", 1, 1)

				End If

				'姓名
				If lngCnvMode = 0 Then

					If InStr(1, strDispLastName, strRepStr1, 1) = 1 Then
						strDispLastName   = Replace(strDispLastName,   strRepStr1, "<B>" & strRepStr1 & "</B>", 1, 1, 1)
					End If

					If InStr(1, strDispFirstName, strRepStr2, 1) = 1 Then
						strDispFirstName  = Replace(strDispFirstName,  strRepStr2, "<B>" & strRepStr2 & "</B>", 1, 1, 1)
					End If

					If InStr(1, strDispLastKName, strRepStr1, 1) = 1 Then
						strDispLastKName  = Replace(strDispLastKName,  strRepStr1, "<B>" & strRepStr1 & "</B>", 1, 1, 1)
					End If

					If InStr(1, strDispFirstKName, strRepStr2, 1) = 1 Then
						strDispFirstKName = Replace(strDispFirstKName, strRepStr2, "<B>" & strRepStr2 & "</B>", 1, 1, 1)
					End If

				End If

				strDispName  = strDispLastName  & "　" & strDispFirstName
				strDispKName = strDispLastKName & "　" & strDispFirstKName

				'個人選択時のURLを編集
				strURL = strBasedURL & strPerId(i)

				If strAge(i) <> "" Then
					strEditAge = Int(strAge(i)) & "歳"
				Else
					strEditAge = ""
				End If

				'個人情報の編集
%>
				<TR VALIGN="bottom">
					<TD></TD>
<% '### 2005/5/1 Updated by Ishihara@FSIT 医事から全角空白が飛んでくるため %>
<!--					<TD NOWRAP><%= strDispPerId %></TD> -->
					<TD NOWRAP><A HREF="<%= strURL %>"><%= strDispPerId %></A></TD>
					<TD></TD>
					<TD NOWRAP><SPAN STYLE="font-size:9px;"><%= strDispKName %><BR></SPAN><A HREF="<%= strURL %>"><%= strDispName %></TD>
					<TD></TD>
					<TD NOWRAP><%= strDispRomeName %></TD>
					<TD></TD>
					<TD NOWRAP><%= IIf(strGender(i) = CStr(GENDER_MALE), "男性", "女性") %></TD>
					<TD></TD>
					<TD ALIGN="right" NOWRAP><%= objCommon.FormatString(strBirth(i), "gee.mm.dd") %></TD>
					<TD></TD>
					<TD ALIGN="right" NOWRAP><%= strEditAge %></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'ページングナビゲータの編集
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop

End Sub
%>
