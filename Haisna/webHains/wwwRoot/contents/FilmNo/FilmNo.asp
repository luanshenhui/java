<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		フィルム番号発番 (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
'## 2003.02.12 Mod 2Lines By T.Takagi@FSIT 権限がおかしい
'Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)
'## 2003.02.12 Mod End

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const FREECD = "FILM"	'汎用コード

Dim objCommon		'共通クラス
Dim objFree	 		'汎用テーブル
Dim objConsult		'受診情報アクセス用
Dim objFilmNo		'フィルム番号更新用オブジェクト

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Dim strKey			'バーコード入力データ

'受診情報
Dim lngRsvNo		'予約番号
'Dim strCancelFlg	'キャンセルフラグ
Dim strCslDate		'受診年月日
Dim strPerId		'個人ＩＤ
Dim strCsCd			'コースコード
Dim strCsName		'コース名
Dim strAge			'受診時年齢
Dim strDayId		'当日ＩＤ
Dim strOrgSName		'団体略称
Dim strUpdDate		'(受付情報の)更新日時
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strGender		'性別

'サブコース情報
Dim strSubCsName	'サブコース名
Dim lngCount		'レコード数


'汎用テーブル
Dim strKeyFreeCd  		'汎用コード（キー）
Dim strFreeCd			'汎用コード
Dim strFreeClassCd		'汎用分類コード
Dim strFreeName			'汎用名

Dim strToday			'本日日付（システム日付）
Dim strDispPerName		'個人名称（漢字）
Dim strDispPerKName		'個人名称（カナ）
Dim strDispAge			'年齢（表示用）
Dim strDispBirth		'生年月日（表示用）

Dim strHtml         	'html出力用ワーク
Dim strBuffer       	'html出力用ワーク
Dim lngPerCount			'戻り値（個人テーブル）
Dim lngFreeCount		'戻り値（汎用テーブル）
Dim lngStatus			'ステータス

Dim strFilmKind     	'選択種類保存用ワーク
Dim i	  				'ループカウント

'*****  2002/01/17  ADD  START  E.Yamamoto
Dim strOldFilmNo		'検査結果テーブルのフィルム番号（２度読み対応）
'*****  2002/01/17  ADD  END    E.Yamamoto
'## 2003.01.17 Add 1Line By T.Takagi@FSIT 撮影日対応
Dim strOldFilmDate		'検査結果テーブルの撮影日（２度読み対応）
'## 2003.01.17 Add End

'*****  2003/01/21  ADD  START  E.Yamamoto
Dim strMachineCls		'号機区分
Dim strMachineNo		'号機番号
Dim blnMachineCls		'号機区分フラグ
Dim strSrchKeyFreeCd  	'汎用コード（検索用）
'*****  2003/01/21  ADD  END    E.Yamamoto

Dim strURL				'ジャンプ先のURL

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objFree 	= Server.CreateObject("HainsFree.Free")
Set objConsult	= Server.CreateObject("HainsConsult.Consult")
	Set objFilmNo 	= Server.CreateObject("HainsFilmNo.FilmNo")

'引数値の取得
strKey 			= Request("key")
strKeyFreeCd	= Request("freeCd")

lngStatus = 0

'*****  2003/01/22  ADD  START  E.Yamamoto
'号機区分チェック
blnMachineCls = EditFreeCd(strKeyFreeCd)
'*****  2003/01/22  ADD  END    E.Yamamoto

'チェック・更新・読み込み処理の制御
Do
	'バーコード値が存在しない場合は何もしない
	If( strKey = "" )Then
		Exit Do
	End If

	'バーコード文字列より受診情報の予約番号を取得
	lngRsvNo = objConsult.GetRsvNoFromBarCode(strKey)
'## 2003.02.15 Add 16Lines By T.Takagi@FSIT 予約番号の取得はASP側で行う
	Select Case lngRsvNo
		Case 0	'受診情報が存在しない
			lngStatus = -20
		Case -1	'バーコード文字列が存在しない
			lngStatus = -2
		Case -2	'文字列が不正
			lngStatus = -3
		Case -3	'受診年月日が日付として認識できない
			lngStatus = -4
		Case -4	'区分の値が不正
			lngStatus = -5
	End Select

	If lngRsvNo <= 0 Then
		Exit Do
	End If
'## 2003.02.15 Add End

	'フィルム番号の更新
'## 2003.01.17 Mod 2Lines By T.Takagi@FSIT 撮影日対応
'	lngStatus = objFilmNo.UpdateFilmNo(strKey, strKeyFreeCd, strOldFilmNo )
'## 2003.02.15 Mod 2Lines By T.Takagi@FSIT 予約番号の取得はASP側で行う
'	lngStatus = objFilmNo.UpdateFilmNo(strKey, strKeyFreeCd, strOldFilmNo, strOldFilmDate)
	lngStatus = objFilmNo.UpdateFilmNo(lngRsvNo, strKeyFreeCd, strOldFilmNo, strOldFilmDate)
'## 2003.02.15 Mod End
'## 2003.01.17 Mod End

	Exit Do
Loop

If( strKeyFreeCd <> "" ) Then
'*****  2003/01/22  ADD  START  E.Yamamoto
	If( blnMachineCls = False ) Then
		strSrchKeyFreeCd = FREECD & strMachineCls
	Else
		strSrchKeyFreeCd = strKeyFreeCd
	End If
'*****  2003/01/22  ADD  END    E.Yamamoto

	'汎用テーブルよりフィルム種別名を取得
	lngFreeCount = objFree.SelectFree( 1,strSrchKeyFreeCd,strFreeCd,strFreeName)

End If

'*****  2003/01/21  ADD  START  E.Yamamoto
'-------------------------------------------------------------------------------
'
' 機能　　 : フリーコードをから号機区分，号機番号を取得する
'
' 引数　　 : 
'
' 戻り値　 : なし
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function EditFreeCd(strFreeCd)

	Dim lngStrLength
	Dim lngConstStrLength
	
	lngStrLength = len(strFreeCd)
	lngConstStrLength = len(FREECD) + 1
	
	strMachineCls = mid(strFreeCd,lngConstStrLength,1)
	lngConstStrLength = lngConstStrLength + 1
	
	strMachineNo = mid(strFreeCd,lngConstStrLength,1)

	'前回読み込んだ号機区分と異なる場合または「０」の場合はtrue、それ以外はfalseとする。
	If( strMachineCls = "0" )Then
		EditFreeCd = True
	else
		EditFreeCd = false
	End If
 	
End Function
'*****  2003/01/21  ADD  END    E.Yamamoto

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>フィルム番号発番</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// フィルム番号修正画面呼び出し
function callRevFilmNo(fileNo) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント
	var url		= '/webHains/contents/FilmNo/';		// 呼び出し先ｕｒｌ
	var filename1	= 'RevFilmNo.asp?freeCd=';		// ファイル名１
	var filename2	= 'RevPerFilmNo.asp?freeCd=';	// ファイル名２

	switch ( fileNo ) {
		case 1 :
			 url = url + filename1 + objForm.freeCd.value;
			 break;
		case 2 :
			 url = url + filename2 + objForm.freeCd.value;
			 break;
	}
	
	location.href(url);
	
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="document.entryForm.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="GET">
<BLOCKQUOTE>
<!--  2003/01/22  DEL  START  E.Yamamoto  -->
<!--  <INPUT TYPE="hidden" NAME="freeCd" SIZE="24" VALUE="<%= strKeyFreeCd %>" >  -->
<!--  2003/01/22  DEL  END    E.Yamamoto  -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">フィルム番号発番</FONT></B></TD>
	</TR>
</TABLE>
<!-- 2003/01/17  ADD  START  E.Yamamoto  操作ボタン -->
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="650">
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD ALIGN="left">
			<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
				<TR>
					<TD><A HREF="SltFilmkind.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="フィルム番号選択画面に戻ります"></A></TD>
					<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
	</TR>
</TABLE>
<!-- 2003/01/17  ADD  END    E.Yamamoto  操作ボタン -->
<!--	<IMG SRC="/webHains/images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left">-->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
<%
'*****  2003/01/22  ADD  START  E.Yamamoto
			If blnMachineCls = True Then
%>
				<TD VALIGN="bottom"><FONT SIZE="6"><%= strFreeName(0) %><BR><INPUT TYPE="hidden" NAME="freeCd" SIZE="24" VALUE="<%= strKeyFreeCd %>"></FONT></TD>
<%
			Else

				'フィルム名称編集　号機番号を付加する
				For i = 0 To UBound(strFreeCd)
					If( Not EditFreeCd(strFreeCd(i)) ) Then
						strFreeName(i) = strFreeName(i) & "（ " & strMachineNo & "号機）"
					End If
				Next
%>
				<TD VALIGN="bottom"><%= EditDropDownListFromArray("freeCd", strFreeCd, strFreeName , strKeyFreeCd, NON_SELECTED_DEL) %></TD>
<%
			End If
'*****  2003/01/22  ADD  END    E.Yamamoto
%>
		</TR>
	</TABLE>
<BR>
<%
	Do

		'案内メッセージの編集
		Select Case lngStatus

			Case -2
%>
				<FONT SIZE="6">バーコード情報が存在しません。<BR>再度バーコードを読み込ませてください。</FONT>
<%
			Case -3
%>
				<FONT SIZE="6">バーコード情報が間違っています。<BR>再度バーコードを読み込ませてください。</FONT>
<%
			Case -4
%>
				<FONT SIZE="6">バーコードの受診日が認識できません。<BR>再度バーコードを読み込ませてください。</FONT>
<%
			Case -5
%>
				<FONT SIZE="6">バーコードの区分が間違っています。<BR>再度バーコードを読み込ませてください。</FONT>
<%
			Case -10
%>
				<FONT SIZE="6">汎用テーブル情報に該当データが存在しません。<BR>システム担当者に連絡してください。</FONT>
<%
			Case -20
%>
				<FONT SIZE="6">受診情報が存在しません。</FONT>
<%
			Case -30
%>
				<FONT SIZE="6">この受診者は撮影対象になっていません。</FONT>
<%
			Case -40
%>
				<FONT SIZE="6">フィルム番号の更新に失敗しました。<BR>システム担当者に連絡してください。</FONT>
<%
			Case -50
%>
				<FONT SIZE="6">本日発番された番号と重複しました。<BR>システム担当者に連絡してください。</FONT>
<%
			Case -60
%>
				<FONT SIZE="6">発番可能番号の最大に達しました。<BR>システム担当者に連絡してください。</FONT>
<%
			Case 0
%>
				<FONT SIZE="6">バーコードを読み込ませてください。</FONT>
<%
			Case -15
%>
				<FONT SIZE="6">検査項目またはサフィックスが定義されていません。（汎用テーブル）</FONT>
<%
			Case Else

				'受診情報読み込み
				objConsult.SelectConsult lngRsvNo, ,   _
										 strCslDate,   _
										 strPerId,     _
										 strCsCd,      _
										 strCsName, , , , , , _
										 strAge, , , , , , , , , , , , , _
										 strDayId, , , , , , _
										 strOrgSName , , , , , , , , , , , _
										 strUpdDate,    _
										 strLastName,   _
										 strFirstName,  _
										 strLastKName,  _
										 strFirstKName, _
										 strBirth,      _
										 strGender

				If lngStatus = -35 Then
%>
					<FONT SIZE="5" COLOR="RED">フィルム番号：<%= IIf(strOldFilmNo <> "", strOldFilmNo, "なし") %><BR>撮影日：<%= IIf(strOldFilmDate <> "", strOldFilmDate, "なし") %><BR>で読込み済みです。</FONT>
<%
				Else
%>
					<FONT SIZE="5"><%= strLastName %>　<%= strFirstName %>さんに<BR>フィルム番号　<B><%= lngStatus %></B>　で発番しました。<BR></FONT>
<%
				End If

		End Select
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
			<TR>
				<TD NOWRAP>BarCode：</TD>
				<TD WIDTH="100%"><INPUT TYPE="text" NAME="key" SIZE="30"></TD>
			</TR>
		</TABLE>

		<BR>
<%
		'表示制御（発番済みも属性情報表示）
		If ( lngStatus <= 0 ) And ( lngStatus <> -35 )Then
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
			<TR>
				<TD NOWRAP>
					<%= strPerId %>&nbsp;
				</TD>
				<TD NOWRAP COLSPAN="2">
					<B><%= strLastName %>&nbsp;<%= strFirstName %></B>（<%= strLastKName %>&nbsp;<%= strFirstKName %>）
				</TD>
			</TR>
			<TR>
				<TD></TD>
				<TD>
					<%= objCommon.FormatString(strBirth, "ge.m.d") %>生&nbsp;<%= strAge %>歳&nbsp;<%= IIf(strGender = CStr(GENDER_MALE), "男性", "女性") %>
				</TD>
			</TR>
<%
			strBuffer = ""

			'受診オプション管理情報をもとに受診サブコースを取得
			lngCount = objConsult.SelectConsult_O_SubCourse(lngRsvNo, strSubCsName)

			'レコードが存在する場合は全サブコース名を読点で連結
			If lngCount > 0 Then
				strBuffer = "&nbsp;（" & Join(strSubCsName, "、") & "&nbsp;同時受診）"
			End If
%>
			<TR>
				<TD></TD>
				<TD NOWRAP><B><%= strCsName %></B><%= strBuffer %></TD>
				<TD NOWRAP><%= strOrgSName %></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
		</TABLE>
<%
		Exit Do
	Loop
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP><A HREF="JavaScript:callRevFilmNo(1)">現在の発番情報を修正&nbsp;</A></TD>
		</TR>
		<TR><TD><BR></TD>
		</TR>
<%
			'ステータス正常時(この場合受診情報が読まれている)
			If ( lngStatus > 0 ) Or ( lngStatus = -35 ) Then

				'結果入力画面のURL編集
				strURL = "/webHains/contents/result/rslMain.asp"
				strURL = strURL & "?rsvNo="    & lngRsvNo
				strURL = strURL & "&cslYear="  & Year(CDate(strCslDate))
				strURL = strURL & "&cslMonth=" & Month(CDate(strCslDate))
				strURL = strURL & "&cslDay="   & Day(CDate(strCslDate))
				strURL = strURL & "&dayId="    & strDayId
				strURL = strURL & "&noPrevNext=1"
%>
		<TR>
				<TD NOWRAP><A HREF="<%= strURL %>" TARGET="_blank">結果入力画面へ（フィルム番号修正）</A></TD>
		</TR>
<%
			End IF
%>
	</TABLE>
	<BR>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
