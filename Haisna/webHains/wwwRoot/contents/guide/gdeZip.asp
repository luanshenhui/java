<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		郵便番号検索ガイド (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GETCOUNT = 20	'表示件数のデフォルト値

Dim strKeyPrefCd	'都道府県コード
Dim strKey			'検索キー
Dim lngStartPos		'検索開始位置
Dim lngGetCount		'表示件数

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strKeyPrefCd = Request("keyPrefCd") & ""
strKey       = Request("key") & ""
lngStartPos  = Request("startpos") & ""
lngStartPos  = CLng(IIf(lngStartPos = "", 1, lngStartPos))
lngGetCount  = Request("getcount") & ""
lngGetCount  = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))

'-------------------------------------------------------------------------------
'
' 機能　　 : 住所情報一覧の編集
'
' 引数　　 : (In)     strKeyPrefCd  都道府県コード
' 　　　　 : (In)     strKey        検索キー
' 　　　　 : (In)     lngStartPos   検索開始位置
' 　　　　 : (In)     lngGetCount   表示件数
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditZipList(strKeyPrefCd, strKey, lngStartPos, lngGetCount)

	Dim strArrKey		'(分割後の)検索キーの集合

	Dim objZip			'郵便番号情報アクセス用COMオブジェクト
	Dim objPref			'都道府県情報アクセス用COMオブジェクト

	Dim blnZip			'検索条件に郵便番号が存在すればTrue
	Dim strKeyPrefName	'都道府県名
	Dim strCountInf		'レコード件数情報

	Dim strZipCd1		'郵便番号1
	Dim strZipCd2		'郵便番号2
	Dim strPrefCd		'都道府県コード
	Dim strPrefName		'都道府県名
	Dim strCityName		'市区町村名
	Dim strSection		'字

'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加
	Dim strCityKName	'市区町村カナ名
	Dim strSectionKName	'カナ字
'### 2004/3/18 Added End

	Dim lngAllCount		'条件を満たす全レコード件数
	Dim lngCount		'レコード件数

	Dim strHTML			'HTML文字列
	Dim strDispCityName	'編集用の市区町村
	Dim strDispSection	'編集用の字
	Dim strDispPrefName '編集用の都道府県

	Dim strBasedURL		'ナビゲータ用の基本URL

	Dim i, j			'インデックス

	'郵便番号情報アクセス用オブジェクトのインスタンス作成
	Set objZip = Server.CreateObject("HainsZip.Zip")

	'検索条件が指定されている場合
	If strKey <> "" Then

		'検索キーを空白で分割する
		strArrKey = SplitByBlank(strKey)

		'検索条件に郵便番号が存在するかをチェック
		For i = 0 To UBound(strArrKey)
			If objZip.isZipCd(strArrKey(i)) = True Then
				blnZip = True
				Exit For
			End If
		Next

	End If

	'郵便番号指定がなく、かつ都道府県も指定されていない場合は検索しない
	If blnZip = False And strKeyPrefCd = "" Then
		Exit Sub
	End If

	'検索条件を満たすレコード件数を取得
	lngAllCount = objZip.SelectZipListCount(strKeyPrefCd, strArrKey)

	Do
%>
		<FORM NAME="ziplist" action="#">
		<BLOCKQUOTE>
<%
		'検索結果が存在しない場合はメッセージを編集
		If lngAllCount = 0 Then
%>
			検索条件を満たす住所情報は存在しません。<BR>
			キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
			Exit Do
		End If

		'郵便番号が存在しない場合、都道府県名を取得
		If blnZip = False And strKeyPrefCd <> "" Then
			Set objPref = Server.CreateObject("HainsPref.Pref")
			objPref.SelectPref strKeyPrefCd, strKeyPrefName
			set objPref = Nothing
		End If

		'レコード件数情報を編集
		If strKeyPrefName <> "" Then
			strCountInf = "「<FONT COLOR=""#ff6600""><B>" & strKeyPrefName & "</B></FONT>」"
		End If

		If strKey <> "" Then
			strCountInf = strCountInf & "「<FONT COLOR=""#ff6600""><B>" & strKey & "</B></FONT>」"
		End If

		If strKeyPrefName <> "" Or Trim(strKey) <> "" Then
			strCountInf = strCountInf & "の"
		End If

		strCountInf = strCountInf & "検索結果は <FONT COLOR=""#ff6600""><B>" & CStr(lngAllCount) & "</B></FONT>件ありました。<BR>"
%>
		<%= strCountInf %>
<%

		'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加
'		lngCount = objZip.SelectZipList(strKeyPrefCd, strArrKey, lngStartPos, lngGetCount, strZipCd1, strZipCd2, strPrefCd, strPrefName, strCityName, strSection)
		lngCount = objZip.SelectZipList(strKeyPrefCd, strArrKey, lngStartPos, lngGetCount, strZipCd1, strZipCd2, strPrefCd, strPrefName, strCityName, strSection, strCityKName, strSectionKName)
'### 2004/3/18 Added End

		'住所一覧の編集開始
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
<%
		For i = 0 To lngCount - 1

			'住所情報の取得
			strDispCityName = strCityName(i)
			strDispSection  = strSection(i)
			strDispPrefName = strPrefName(i)

			'検索キーに合致する部分に<B>タグを付加
			If Not IsEmpty(strArrKey) Then
				For j = 0 To UBound(strArrKey)
					strDispCityName = Replace(strDispCityName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispSection  = Replace(strDispSection,  strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next
			End If

			'住所情報の編集
%>
			<INPUT TYPE="hidden" NAME="zipcd1"   VALUE="<%= strZipCd1(i)   %>">
			<INPUT TYPE="hidden" NAME="zipcd2"   VALUE="<%= strZipCd2(i)   %>">
			<INPUT TYPE="hidden" NAME="prefcd"   VALUE="<%= strPrefCd(i)   %>">
			<INPUT TYPE="hidden" NAME="prefname" VALUE="<%= strPrefName(i) %>">
			<INPUT TYPE="hidden" NAME="cityname" VALUE="<%= strCityName(i) %>">
			<INPUT TYPE="hidden" NAME="section"  VALUE="<%= strSection(i)  %>">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><%= strZipCd1(i) %>-<%= strZipCd2(i) %></TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><A HREF="JavaScript:selectList(<%= i %>)" CLASS="guideItem"><%= strDispPrefName %>　<%= strDispCityName %>　<%= strDispSection %></A></TD>
				<TD WIDTH="10"></TD>
				<TD><FONT COLOR="#666666"><%= strCityKName(i) & "　" & strSectionKName(i) %></FONT></TD>
			</TR>
<%
		Next

		'末尾部の編集
%>
		</TABLE>
<%
		'ページングナビゲータ用のURL基本部を編集
		strBasedURL = Request.ServerVariables("SCRIPT_NAME") & "?"
		If strKeyPrefCd <> "" Then
			strBasedURL = strBasedURL & "keyPrefCd=" & strKeyPrefCd & "&"
		End If
		strBasedURL = strBasedURL & "key=" & Server.URLEncode(strKey)

		'ページングナビゲータの編集
%>
		<%= EditPageNavi(strBasedURL, lngAllCount, lngStartPos, lngGetCount) %>

		</BLOCKQUOTE>
		</FORM>
<%
		Exit Do
	Loop

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>住所の検索</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 検索開始処理
function startSearching() {

	var word;		// 検索文字の配列
	var wideOnly;	// 検索文字に全角文字しか存在しない
	var i;			// インデックス

	// 検索条件を空白で分割
	word = document.entryForm.key.value.replace(/[　 ]+/g, ' ').split(' ');
	if ( word.length == 0 ) {
		return false;
	}

	// 検索条件に認識できない郵便番号形式が存在するかを判定
	for ( i = 0, wideOnly = true; i < word.length; i++ ) {

		// 文字列が存在しなければスキップ
		if ( word[i] == '' ) {
			continue;
		}

		// 全角文字が含まれている場合はスキップ
		if ( isWide(word[i]) ) {
			continue;
		}

		// 3桁の数字列であれば正常
		if ( word[i].length == 3 && word[i].match(/[0-9]{3}/) != null ) {
			wideOnly = false;
			continue;
		}

		// 7桁の数字列であれば正常
		if ( word[i].length == 7 && word[i].match('[0-9]{7}') != null ) {
			wideOnly = false;
			continue;
		}

		// 999-9999の形式であれば正常
		if ( word[i].length == 8 && word[i].match(/[0-9]{3}-[0-9]{4}/) != null ) {
			wideOnly = false;
			continue;
		}

		// どの条件にも合致しない場合はエラー
		alert('郵便番号の指定形式に誤りがあります。');
		return false;

	}

	// 全角文字が含まれている場合、都道府県は必須
	if ( wideOnly && document.entryForm.keyPrefCd.value == '' ) {
		alert('都道府県は必ず指定して下さい。');
		return false;
	}

	// 検索開始
	return true;
}

/* 全角文字が含まれているか */
function isWide(expression) {

	var token;
	var ret = false;
	var i;

	// 1文字単位でチェック
	for ( i = 0; i < expression.length; i++ ) {

		token = escape(expression.charAt(i));

		// IEの場合(UniCodeで判断)
		if ( document.all ) {

			// 全角文字・半角カナの判断
			if ( token.length == 6 ) {
				ret = true;
				break;
			}

			continue;
		}

		// NC4の場合(SJISで判断)
		if ( document.layers || document.getElementById ) {

			// 全角文字・半角カナの判断
			if ( token.length >= 3 && token.indexOf('%') != -1 ) {
				ret = true;
				break;
			}

		}

	}

	return ret;
}

// 郵便番号・住所のセット
function selectList( index ) {

	var objForm;		// 自画面のフォームエレメント
	var zipCd1   = '';	// 郵便番号1
	var zipCd2   = '';	// 郵便番号2
	var zipCd    = '';	// 郵便番号    2003.09.01 聖路加対応　追加
	var prefCd   = '';	// 都道府県コード
	var cityName = '';	// 市区町村名
	var section  = '';	// 字

	objForm = document.ziplist;

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return;
	}

	// 郵便番号1の取得
	if ( objForm.zipcd1.length != null ) {
		zipCd1 = objForm.zipcd1[ index ].value;
	} else {
		zipCd1 = objForm.zipcd1.value;
	}

	// 郵便番号2の取得
	if ( objForm.zipcd2.length != null ) {
		zipCd2 = objForm.zipcd2[ index ].value;
	} else {
		zipCd2 = objForm.zipcd2.value;
	}

	// 都道府県コードの取得
	if ( objForm.prefcd.length != null ) {
		prefCd = objForm.prefcd[ index ].value;
	} else {
		prefCd = objForm.prefcd.value;
	}

	// 市区町村名の取得
	if ( objForm.cityname.length != null ) {
		cityName = objForm.cityname[ index ].value;
	} else {
		cityName = objForm.cityname.value;
	}

	// 字の取得
	if ( objForm.section.length != null ) {
		if ( objForm.section[ index ].value != '以下に掲載がない場合' ) {
			section = objForm.section[ index ].value;
		}
	} else {
		if ( objForm.section.value != '以下に掲載がない場合' ) {
			section = objForm.section.value;
		}
	}

	// 住所編集用関数呼び出し
//	opener.zipGuide_setZipInfo( zipCd1, zipCd2, prefCd, cityName, section );
	// 聖路加対応 start 2003.09.01 =======>
	zipCd = zipCd1 + zipCd2;
	opener.zipGuide_setZipInfo( zipCd, prefCd, cityName, section );
	// <======== 聖路加対応　end 

	// 画面を閉じる
	opener.winGuideZip = null;
	close();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 0; }
	td.mnttab  { background-color:#FFFFFF }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="return startSearching();">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">住所の検索</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD>都道府県：</TD>
			<TD COLSPAN="2"><%= EditPrefList("keyPrefCd", strKeyPrefCd) %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>検索条件：</TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<%
	'住所情報一覧の編集
	Call EditZipList(strKeyPrefCd, strKey, lngStartPos, lngGetCount)
%>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
