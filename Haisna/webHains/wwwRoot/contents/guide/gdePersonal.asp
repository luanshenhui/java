<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		個人検索ガイド (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"    -->
<!-- #include virtual = "/webHains/includes/common.inc"          -->
<!-- #include virtual = "/webHains/includes/EditEraYearList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"    -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const STARTPOS     = 1		'開始位置のデフォルト値
Const GETCOUNT     = 15		'表示件数のデフォルト値
Const PREFIX_PERID = "ID:"	'検索時の個人ＩＤ指定

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objPerson			'個人情報アクセス用

'引数値
Dim strKey				'検索キー
'#### 2011.01.22 ADD STA TCS)Y.T ####
Dim strKey1				'検索キー
Dim strKey2				'検索キー
Dim strKey3				'検索キー
'#### 2011.01.22 ADD END TCS)Y.T ####
Dim strBirthYear		'生年月日（年）
Dim strBirthMonth		'生年月日（月）
Dim strBirthDay			'生年月日（日）
Dim lngGender			'性別
Dim lngAddrDiv			'住所区分
Dim blnRomeMulti		'ローマ字複合検索を行うか
Dim lngMode				'検索モード(0:通常、1:更に受診歴検索へ遷移可能)
Dim lngStartPos			'検索開始位置
Dim lngGetCount			'表示件数
Dim strDefPerId			'初期表示用個人ＩＤ
Dim strDefGender		'初期表示用性別

'個人情報
Dim strPerId			'個人ＩＤ
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ姓
Dim strRomeName			'ローマ字名
Dim strArrBirth			'生年月日
Dim strAge				'年齢
Dim strGender			'性別
Dim strPrefName			'都道府県名
Dim strCityName			'市区町村名
Dim strAddress1			'住所１
Dim strAddress2			'住所２
Dim strTel1				'電話番号
Dim lngCount			'レコード件数

Dim strArrKey			'(分割後の)検索キーの集合
Dim strBirth			'生年月日
Dim lngAllCount			'条件を満たす全レコード件数
Dim strDispPerId		'編集用の個人ＩＤ
Dim strDispLastName		'編集用の漢字名称
Dim strDispFirstName	'編集用の漢字名称
Dim strDispName			'編集用の漢字名称
Dim strDispLastKName	'編集用のカナ名称
Dim strDispFirstKName	'編集用のカナ名称
Dim strDispKName		'編集用のカナ名称
Dim strCnvKey			'キー変換値
Dim strBuffer			'文字列バッファ
Dim strURL				'URL文字列
Dim i, j				'インデックス
Dim strDispRomeName		'ローマ字名
Dim lngPos				'検索位置
Dim strEditAge			'年齢

Dim strRepStr1			'置換用文字列１
Dim strRepStr2			'置換用文字列２
Dim strRepPerId			'置換用個人ＩＤ
Dim lngCnvMode			'置換モード

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objPerson = Server.CreateObject("HainsPerson.Person")

'引数値の取得
strKey        = Request("key")
strBirthYear  = Request("birthYear")
strBirthMonth = Request("birthMonth")
strBirthDay   = Request("birthDay")
lngGender     = CLng("0" & Request("gender"))
blnRomeMulti  = (Request("romeMulti") <> "")
lngAddrDiv    = Request("addrDiv")
lngMode       = CLng("0" & Request("mode"))
lngStartPos   = Request("startPos")
lngGetCount   = Request("getCount")
strDefPerId   = Request("defPerId")
strDefGender  = Request("defGender")

'検索キー中の半角カナを全角カナに変換する
strKey = objCommon.StrConvKanaWide(strKey)

'検索キー中の小文字を大文字に変換する
strKey = UCase(strKey)

'全角空白を半角空白に置換する
strKey = Replace(Trim(strKey), "　", " ")

'2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
Do Until InStr(1, strKey, "  ") = 0
    strKey = Replace(strKey, "  ", " ")
Loop

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))
lngAddrDiv  = IIf(lngAddrDiv = 0, 1, lngAddrDiv)

'キーなし、かつデフォ個人ＩＤ存在時、そのローマ字名をセット
If strKey = "" And strDefPerId <> "" Then
'#### 2011.01.22 MOD STA TCS)Y.T ####
'	objPerson.SelectPerson_lukes strDefPerId, , , , , strKey
        'ローマ字名からカナ氏名に変更
	objPerson.SelectPerson_lukes strDefPerId, , , strKey1, strKey2, strKey3
        If strKey1 <> "" Or strKey2 <> "" Then
                'カナ氏名がある場合は姓と名を連結して設定する
                strKey = strKey1 & " " & strKey2
	Else
                'カナ氏名が存在しない場合はローマ字を設定する。
                strKey = strKey3
        End If
'#### 2011.01.22 MOD END TCS)Y.T ####
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受診者の検索</TITLE>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:window.document.entryForm.key.focus();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">受診者の検索</FONT></B></TD>
		</TR>
	</TABLE>
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= lngMode %>">
<% '## 2003.12.15 Add by T.Takagi@FSIT 性別固定 %>
	<INPUT TYPE="hidden" NAME="defGender" VALUE="<%= strDefGender %>">
<% '## 2003.12.15 Add End %>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>検索条件</TD>
			<TD>：</TD>
			<TD COLSPAN="9"><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD ROWSPAN="2" VALIGN="bottom"><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></TD>
		</TR>
		<TR>
			<TD NOWRAP>生年月日</TD>
			<TD>：</TD>
			<TD><%= EditEraYearList("birthYear", strBirthYear, True) %></TD>
			<TD>年</TD>
			<TD><%= EditSelectNumberList("birthMonth", 1, 12, CLng("0" & strBirthMonth)) %></TD>
			<TD>月</TD>
			<TD><%= EditSelectNumberList("birthDay", 1, 31, CLng("0" & strBirthDay)) %></TD>
			<TD>日</TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
			<TD NOWRAP>性別：</TD>
<% '## 2003.12.15 Mod by T.Takagi@FSIT 性別固定 %>
<%
			If strDefGender = "" Then
%>
				<TD>
					<SELECT NAME="gender">
						<OPTION VALUE="0">&nbsp;
						<OPTION VALUE="<%= GENDER_MALE   %>"<%= IIf(lngGender = GENDER_MALE,   " SELECTED", "") %>>男性
						<OPTION VALUE="<%= GENDER_FEMALE %>"<%= IIf(lngGender = GENDER_FEMALE, " SELECTED", "") %>>女性
					</SELECT>
				</TD>
<%
			Else
%>
				<TD NOWRAP><INPUT TYPE="hidden" NAME="gender" VALUE="<%= strDefGender %>"><%= IIf(strDefGender = CStr(GENDER_MALE), "男性", "女性") %></TD>
<%
			End If
%>
<% '## 2003.12.15 Add End %>
		</TR>
		<TR>
			<TD NOWRAP>住所</TD>
			<TD>：</TD>
			<TD>
				<SELECT NAME="addrDiv">
					<OPTION VALUE="1"<%= IIf(lngAddrDiv = 1, " SELECTED", "") %>>住所（自宅）
					<OPTION VALUE="2"<%= IIf(lngAddrDiv = 2, " SELECTED", "") %>>住所（勤務先）
					<OPTION VALUE="3"<%= IIf(lngAddrDiv = 3, " SELECTED", "") %>>住所（その他）
				</SELECT>
			</TD>
			<TD><INPUT TYPE="checkbox" NAME="romeMulti" VALUE="1"<%= IIf(blnRomeMulti, " CHECKED", "") %>></TD>
			<TD COLSPAN="7" NOWRAP>ローマ字の複合検索を行う</TD>
		</TR>
	</TABLE>
<%
	Do
		'検索条件が存在しない場合は何もしない
'## 2003.11.21 Mod by T.Takagi@FSIT 性別のみの検索をさせない
'		If strKey = "" And strBirthYear = "" And strBirthMonth = "" And strBirthDay = "" And lngGender = 0 Then
		If strKey = "" And strBirthYear = "" And strBirthMonth = "" And strBirthDay = "" Then
'## 2003.11.21 Mod End
			Exit Do
		End If

		'生年月日指定時
		If strBirthYear <> "" Or strBirthMonth <> "" Or strBirthDay <> "" Then

			'生年月日の編集
			strBirth = strBirthYear & "/" & strBirthMonth & "/" & strBirthDay

			'生年月日の日付チェック
			If Not IsDate(strBirth) Then
				Response.Write "<BR>生年月日の入力形式が正しくありません。"
				Exit Do
			End If

		End If

		'検索条件を満たすレコード件数を取得
		lngAllCount = objPerson.SelectPersonListCount(strKey, strBirth, lngGender, blnRomeMulti)
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
		lngCount = objPerson.SelectPersonList(strKey,       lngAddrDiv,  lngStartPos,  lngGetCount,  strBirth,      lngGender, blnRomeMulti, , _
											  strPerId, ,   strLastName, strFirstName, strLastKName, strFirstKName, strRomeName, _
											  strArrBirth,  strAge,      strGender, ,  strPrefName,  strCityName,   strAddress1, _
											  strAddress2,  strTel1)
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>個人ＩＤ</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>氏名</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>ローマ字</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>生年月日</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>性別</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>年齢</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>電話番号</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>住所</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD></TD>
			</TR>
			<TR>
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="19"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
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

				strDispName  = Trim(strDispLastName  & "　" & strDispFirstName)
				strDispKName = Trim(strDispLastKName & "　" & strDispFirstKName)

				'個人選択時のURLを編集
				strURL = "gdeSelectPerson.asp?perId=" & strPerId(i)

				If strAge(i) <> "" Then
					strEditAge = Int(strAge(i)) & "歳"
				Else
					strEditAge = ""
				End If

				'個人情報の編集
%>
				<TR VALIGN="bottom">
					<TD></TD>
					<TD NOWRAP><%= strDispPerId %></TD>
					<TD></TD>
					<TD NOWRAP><SPAN STYLE="font-size:9px;"><%= strDispKName %><BR></SPAN><A HREF="<%= strURL %>"><%= strDispName %></A></TD>
					<TD></TD>
					<TD NOWRAP><%= strDispRomeName %></TD>
					<TD></TD>
					<TD ALIGN="right" NOWRAP><%= objCommon.FormatString(strArrBirth(i), "gee.mm.dd") %></TD>
					<TD></TD>
					<TD NOWRAP><%= IIf(strGender(i) = CStr(GENDER_MALE), "男性", "女性") %></TD>
					<TD></TD>
					<TD ALIGN="right" NOWRAP><%= strEditAge %></TD>
					<TD></TD>
					<TD NOWRAP><%= strTel1(i) %></TD>
					<TD></TD>
					<TD NOWRAP><%= strPrefName(i) & strCityName(i) & strAddress1(i) & strAddress2(i) %></TD>
<%
					'更に受診歴検索へ遷移可能な場合
					If lngMode = 1 Then

						'受診歴一覧用のURLを編集
						strURL = "gdeCslList.asp?perId=" & strPerId(i)
%>
						<TD></TD>
						<TD><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/cue.gif" WIDTH="14" HEIGHT="14" ALT="この個人の受診歴を検索します"></A></TD>
<%
					End If
%>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'ページングナビゲータの編集
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?key="        & Server.URLEncode(strKey)
		strURL = strURL & "&birthYear="  & strBirthYear
		strURL = strURL & "&birthMonth=" & strBirthMonth
		strURL = strURL & "&birthDay="   & strBirthDay
		strURL = strURL & "&gender="     & lngGender
		strURL = strURL & "&addrDiv="    & lngAddrDiv
		strURL = strURL & "&mode="       & lngMode
		strURL = strURL & "&romeMulti="  & IIf(blnRomeMulti, "1", "")
'## 2005.03.16 Add by T.Takagi@FSIT ナビゲータをクリックすると固定条件が外れる
		strURL = strURL & "&defPerId="   & strDefPerId
		strURL = strURL & "&defGender="  & strDefGender
'## 2005.03.16 Add End
%>
		<%= EditPageNavi(strURL, lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
