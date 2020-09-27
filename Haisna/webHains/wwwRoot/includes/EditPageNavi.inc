<%
'-------------------------------------------------------------------------------
'
' 機能　　 : ページングナビゲータの編集
'
' 引数　　 : (In)     strBasedURL  URLの共通部
' 　　　　 : (In)     lngAllCount  全レコード件数
' 　　　　 : (In)     lngStartPos  現在ページに対応する表示開始位置
' 　　　　 : (In)     lngGetCount  表示件数
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditPageNavi(strBasedURL, lngAllCount, lngStartPos, lngGetCount)

	Const PAGECOUNT = 10	'ページングナビゲータで表示するページ数
	Const CENTERPOS = 5		'PAGECOUNT値内で現在ページ番号を表示させる位置

	Dim lngTotalPage		'総ページ数
	Dim lngStartPage		'開始ページ番号
	Dim lngCurrentPage		'現在ページ番号

	Dim strHTML				'HTML文字列
	Dim lngPage				'ページカウンタ
	Dim strURL				'URLの基本形
	Dim lngCurrentStartPos	'URLに編集する検索開始位置

	'検索件数が表示件数以下の場合、ページングナビゲータは表示しない
	If lngAllCount <= lngGetCount Then
		Exit Function
	End If

	'総ページ数・現在ページ番号を求める
	lngTotalPage   = Int(lngAllCount / lngGetCount) + IIf(lngAllCount Mod lngGetCount > 0, 1, 0)
	lngCurrentPage = (lngStartPos - 1) / lngGetCount + 1

	'現在ページ番号が全ページ中最後の(PAGECOUNT - CENTERPOS + 1)ページ内に当てはまる場合
	If lngCurrentPage > lngTotalPage - (PAGECOUNT - CENTERPOS + 1) Then

		'最後の(PAGECOUNT)ページ分を表示させるよう開始ページを制御
		lngStartPage = IIf(lngTotalPage - PAGECOUNT > 0, lngTotalPage - PAGECOUNT + 1, 1)

	'それ以外は現在ページ数がナビゲータの中心に位置するよう開始ページを制御
	Else
		lngStartPage = IIf(lngCurrentPage > 4, lngCurrentPage - 4, 1)
	End If

	'編集ページ番号及びURLに編集する開始検索位置の初期値を設定
	lngPage = lngStartPage
	lngCurrentStartPos = (lngStartPage - 1) * lngGetCount + 1

	'URLの基本形を作成(開始位置のみ可変となるのでこれを"XXXX"で定義し、以降はこの値をReplaceして編集)
'	strURL = strBasedURL & "&startpos=XXXX" & "&getcount=" & lngGetCount
	strURL = "&startpos=XXXX" & "&getcount=" & lngGetCount

	'先頭部の編集
	strHTML = "<BR>"
	strHTML = strHTML & vbLf & "<TABLE BORDER=""0"" CELLPADDING=""2"" CELLSPACING=""2"">"
	strHTML = strHTML & vbLf & "<TR>"
	strHTML = strHTML & vbLf & "<TD NOWRAP><B>Result Page:</B></TD>"
	strHTML = strHTML & vbLf & "<TD WIDTH=""5""></TD>"

	'編集開始ページが2ページ目以降ならば前ページ用のアンカーを編集する
	If lngPage > 1 Then
'		strHTML = strHTML & vbLf & "<TD><B><A HREF=""" & Replace(strURL, "XXXX", CStr((lngCurrentPage - 2) * lngGetCount + 1)) & """>&lt;&lt;Prev</A></B></TD>"
		strHTML = strHTML & vbLf & "<TD><B><A HREF=""" & strBasedURL & Replace(strURL, "XXXX", CStr((lngCurrentPage - 2) * lngGetCount + 1)) & """>&lt;&lt;Prev</A></B></TD>"
		strHTML = strHTML & vbLf & "<TD WIDTH=""10""></TD>"
	End If

	Do
		'ページ番号とそれに対応するURLを編集(ただし現在ページにはアンカーを張らない)
		If lngPage <> lngCurrentPage Then
'			strHTML = strHTML & vbLf & "<TD><A HREF=""" & Replace(strURL, "XXXX", CStr(lngCurrentStartPos)) & """>" & lngPage & "</A></TD>"
			strHTML = strHTML & vbLf & "<TD><A HREF=""" & strBasedURL & Replace(strURL, "XXXX", CStr(lngCurrentStartPos)) & """>" & lngPage & "</A></TD>"
		Else
			strHTML = strHTML & vbLf & "<TD><B>" & lngPage & "</B></TD>"
		End If

		'総ページ数に達した場合は処理を終了
		If lngPage >= lngTotalPage Then
			Exit Do
		End If

		'表示ページ数分編集完了すれば処理を終了
		If lngPage - lngStartPage + 1 >= PAGECOUNT Then
			Exit Do
		End If

		'ページ番号と検索開始位置を更新
		lngPage = lngPage + 1
		lngCurrentStartPos = (lngPage - 1) * lngGetCount + 1

		'セパレータを編集
		strHTML = strHTML & vbLf & "<TD>|</TD>"
	Loop

	'最後に編集したページが最終ページでなければ次ページ用のアンカーを編集する
	If lngPage < lngTotalPage Then
		strHTML = strHTML & vbLf & "<TD WIDTH=""10""></TD>"
'		strHTML = strHTML & vbLf & "<TD><B><A HREF=""" & Replace(strURL, "XXXX", CStr(lngCurrentPage * lngGetCount + 1)) & """>Next&gt;&gt;</A></B></TD>"
		strHTML = strHTML & vbLf & "<TD><B><A HREF=""" & strBasedURL & Replace(strURL, "XXXX", CStr(lngCurrentPage * lngGetCount + 1)) & """>Next&gt;&gt;</A></B></TD>"
	End If

	'末尾の編集
	strHTML = strHTML & vbLf & "</TR>"
	strHTML = strHTML & vbLf & "</TABLE>"

	EditPageNavi = strHTML

End Function
%>
