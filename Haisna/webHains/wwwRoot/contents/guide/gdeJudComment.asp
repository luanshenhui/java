<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		総合コメントの選択 (Ver0.0.1)
'		AUTHER  : Keiko Fujii@ffcs
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const STARTPOS = 1		'開始位置のデフォルト値

Dim strCmtDspMode		'初期表示モード（0:一覧表示無し、1:一覧表示あり）

'データベースアクセス用オブジェクト
Dim objJudCmtStc		'判定コメント情報アクセス用
Dim objJudClass			'判定分類情報アクセス用
Dim objCommon			'共通関数アクセス用

Dim lngCmtCnt			'コメント件数
Dim vntCmtCd			'選択されているコメントコード群
Dim vntArrCmtCd			'選択されているコメントコード配列

Dim strJudClassCd		'検索判定分類コード
Dim strJudClassName		'検索判定分類名称
Dim strKey				'検索キー
Dim lngStartPos			'検索開始位置
Dim lngGetCount			'表示件数
Dim vntSearchModeFlg	'検査条件フラグ（0:判定分類の無いコメントも取得、1:判定分類が一致するもののみ）

'判定コメント情報
Dim strArrJudCmtCd		'判定コメントコード
Dim strArrJudCmtStc		'判定コメント文章
Dim strArrJudClassCd	'判定分類コード
Dim strArrJudClassName	'判定分類名称
Dim strArrJudCd			'判定コード
Dim strArrWeight		'判定重み

Dim strDispJudCmtStc	'編集用の判定コメント文章
Dim strDispJudCmtCd		'編集用の判定コメントコード

Dim strCheckJudCmt		'チェックボックス

Dim strAction			'
Dim strArrKey			'(分割後の)検索キーの集合
Dim lngAllCount			'条件を満たす全レコード件数
Dim lngCount			'レコード件数
Dim strURL				'URL文字列
Dim i, j				'インデックス

Dim strChecked				'チェックボックスのチェック状態
Dim strBgColor				'背景色
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objJudCmtStc = Server.CreateObject("HainsJudCmtStc.JudCmtStc")
Set objJudClass  = Server.CreateObject("HainsJudClass.JudClass")
Set objCommon    = Server.CreateObject("HainsCommon.Common")

'引数値の取得
strAction     = Request("act")
strJudClassCd = Request("judClassCd")
strCmtDspMode = Request("cmtdspmode")
vntCmtCd      = Request("selCmtCd")
lngCmtcnt     = Request("selCmtCnt")
strKey        = Request("key")
lngStartPos   = Request("startPos")
lngGetCount   = Request("getCount")

'コメントコードを配列に
vntArrCmtCd = Array()
vntArrCmtCd = Split(vntCmtCd, "," )

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", objCommon.SelectJudCmtStcPageMaxLine, lngGetCount))


'判定分類名取得
If Not IsEmpty(strJudClassCd) Then
	Call objJudClass.SelectJudClass(strJudClassCd, strJudClassName)
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>判定コメントガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 判定コメントコード・判定コメント文章のセット
function selectList( ) {

	var icnt;			//ループカウント
	var jcnt;			//ループカウント
	var kcnt;			//ループカウント
	var judCmtCd_length;

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、判定コメントコード・判定コメント文章を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	jcnt = 0;
	opener.varSelCmtCd.length = 0;
	opener.varSelCmtStc.length = 0;
	opener.varSelClassCd.length = 0;
	opener.varSelJudCd.length = 0;
	opener.varSelWeight.length = 0;
	judCmtCd_length = document.kensakulist.judCmtCd.length;
	if ( judCmtCd_length == null ){
		judCmtCd_length = 1;
	}
	for ( icnt = 0; icnt < judCmtCd_length; icnt++ ){
		//既に登録済のコメント？
		for( kcnt = 0; kcnt < document.entryForm.selCmtCnt.value; kcnt++ ){
			if ( document.kensakulist.judCmtCd.length != null ) {
				if ( document.entryForm.selCmtCnt.value == 1 ){
					if ( document.kensakulist.judCmtCd[icnt].value == document.entryForm.selArrCmtCd.value ){
						break;
					}
				} else {
					if ( document.kensakulist.judCmtCd[icnt].value == document.entryForm.selArrCmtCd[kcnt].value ){
						break;
					}
				}
			} else {
				if ( document.entryForm.selCmtCnt.value == 1 ){
					if ( document.kensakulist.judCmtCd.value == document.entryForm.selArrCmtCd.value ){
						break;
					}
				} else {
					if ( document.kensakulist.judCmtCd.value == document.entryForm.selArrCmtCd[kcnt].value ){
						break;
					}
				}
			}
		}
		if (kcnt < document.entryForm.selCmtCnt.value){
			continue;
		}
		if ( document.kensakulist.judCmtCd.length != null ) {
			if ( document.kensakulist.judCmtCd[icnt].checked ) {
				opener.varSelCmtCd.length ++;
				opener.varSelCmtStc.length ++;
		    	opener.varSelClassCd.length ++;
		    	opener.varSelJudCd.length ++;
		    	opener.varSelWeight.length ++;
		    	opener.varSelCmtCd[jcnt] = document.kensakulist.judCmtCd[icnt].value;
		    	opener.varSelCmtStc[jcnt] = document.kensakulist.judCmtStc[icnt].value;
		    	opener.varSelClassCd[jcnt] = document.kensakulist.judClassCd[icnt].value;
		    	opener.varSelJudCd[jcnt] = document.kensakulist.judCd[icnt].value;
		    	opener.varSelWeight[jcnt] = document.kensakulist.weight[icnt].value;
		    	jcnt++;
			}
		} else {
			if ( document.kensakulist.judCmtCd.checked ) {
				opener.varSelCmtCd.length ++;
				opener.varSelCmtStc.length ++;
		    	opener.varSelClassCd.length ++;
		    	opener.varSelJudCd.length ++;
		    	opener.varSelWeight.length ++;
		    	opener.varSelCmtCd[jcnt] = document.kensakulist.judCmtCd.value;
		    	opener.varSelCmtStc[jcnt] = document.kensakulist.judCmtStc.value;
		    	opener.varSelClassCd[jcnt] = document.kensakulist.judClassCd.value;
		    	opener.varSelJudCd[jcnt] = document.kensakulist.judCd.value;
		    	opener.varSelWeight[jcnt] = document.kensakulist.weight.value;
		    	jcnt++;
			}
		}
	}


	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.jcmGuide_CalledFunction != null ) {
		opener.jcmGuide_CalledFunction();
	}

	opener.winJudComment = null;
	close();

	return;
}

//チェックボックス選択処理
//既に登録済のコメントのチェックははずさない
function checkJudCmtAct( index ) {
	var icnt;			//ループカウント
	var jcnt;			//ループカウント

	//既に登録済のコメント？
	if( document.entryForm.selCmtCnt.value == 1 ) {
		if ( document.kensakulist.judCmtCd.length != null ) {
			if ( document.kensakulist.judCmtCd[index].value == document.entryForm.selArrCmtCd.value ){
				document.kensakulist.judCmtCd[index].checked = " CHECKED";
			}
		} else {
			if ( document.kensakulist.judCmtCd.value == document.entryForm.selArrCmtCd.value ){
				document.kensakulist.judCmtCd.checked = " CHECKED";
			}
		}
	} else {
		for( icnt = 0; icnt < document.entryForm.selCmtCnt.value; icnt++ ){
			if ( document.kensakulist.judCmtCd.length != null ) {
				if ( document.kensakulist.judCmtCd[index].value == document.entryForm.selArrCmtCd[icnt].value ){
					document.kensakulist.judCmtCd[index].checked = " CHECKED";
					break;
				}
			} else {
				if ( document.kensakulist.judCmtCd.value == document.entryForm.selArrCmtCd[icnt].value ){
					document.kensakulist.judCmtCd.checked = " CHECKED";
					break;
				}
			}
		}
	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:window.document.entryForm.key.focus();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<INPUT TYPE="hidden" NAME="act" VALUE="select">
	<INPUT TYPE="hidden" NAME="cmtdspmode" VALUE="<%= strCmtDspMode %>">
	<INPUT TYPE="hidden" NAME="selCmtCd" VALUE="<%= vntCmtCd %>">
	<INPUT TYPE="hidden" NAME="selCmtCnt" VALUE="<%= lngCmtCnt %>">
<%
	For i = 0 To lngCmtCnt-1
%>
		<INPUT TYPE="hidden" NAME="selArrCmtCd" VALUE="<%= vntArrCmtCd(i) %>">
<%
	Next		
%>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">判定コメントの検索</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	Do
		If strCmtDspMode = 0 Then
			Exit Do
		End If

		'検索キーを空白で分割する
		strArrKey = SplitByBlank(strKey)

		'' 検索条件を追加する 2003.12.18 modify start 
		'すべての分類
		If strJudClassCd = "" Then
			vntSearchModeFlg = 0
		Else
			vntSearchModeFlg = 1
		End If

		'検索条件を満たすレコード件数を取得
'		lngAllCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey)
		lngAllCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey, vntSearchModeFlg)


		'検索条件を満た全件数分のレコードを取得
		lngGetCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey)
'		lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, strArrKey, lngStartPos, lngGetCount, strArrJudCmtCd, strArrJudCmtStc, strArrJudClassCd, strArrJudClassName, , , , strArrJudCd, strArrWeight)
		lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, strArrKey, lngStartPos, lngGetCount, strArrJudCmtCd, strArrJudCmtStc, strArrJudClassCd, strArrJudClassName, , , vntSearchModeFlg, strArrJudCd, strArrWeight)
		'' 検索条件を追加する 2003.12.18 modify end  

		strCheckJudCmt = Array()
		Redim Preserve strCheckJudCmt(lngCount-1)
%>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR><TD COLSPAN="2">検索条件を入力して下さい。</TD></TR>
		<TR><TD HEIGHT="5"></TD></TR>
		<TR>
			<TD><%= EditJudClassList("judClassCd", strJudClassCd, "全ての判定分類") %></TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.cmtdspmode.value=1;document.entryForm.submit();return false" CLASS="guideItem"><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></A></TD>
<%
		'データが無い場合は確定ボタンは表示しない
		If lngCount <= 0 Then
%>
			<TD><IMG SRC="/webHains/images/spacer.gif" BORDER="0" WIDTH="77" HEIGHT="24" ></TD>
<%
		Else
%>
			<TD>
            <% '2005.08.22 権限管理 Add by 李　--- START %>
        	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
                <A HREF="javascript:selectList()"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="確定します"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
            </TD>
<%
		End If
%>
		</TR>
	</TABLE>

</FORM>

<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<%
		'検索結果が存在しない場合はメッセージを編集
		If lngAllCount = 0 Then
%>
			検索条件を満たす判定コメント情報は存在しません。<BR>
			キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1

			'表示用判定コメント文章の編集
			strDispJudCmtStc = strArrJudCmtStc(i)
			strDispJudCmtCd  = strArrJudCmtCd(i)

			If strKey <> "" Then

				'検索キーに合致する部分に<B>タグを付加
				For j = 0 To UBound(strArrKey)
					strDispJudCmtStc = Replace(strDispJudCmtStc, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispJudCmtCd  = Replace(strDispJudCmtCd, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next

			End If

			'既に選択済かチェック
			strChecked = ""
			strBgColor = ""
			For j = 0 to lngCmtCnt-1
				If strArrJudCmtCd(i) = vntArrCmtCd(j) Then
					strChecked = " CHECKED"
					strBgColor="#eeeeee" 
					Exit For
				End If
			Next
%>
			<TR VALIGN="top">
				<TD>
					<INPUT TYPE="hidden" NAME="judCmtStc" VALUE="<%= strArrJudCmtStc(i) %>">
					<INPUT TYPE="hidden" NAME="judClassCd" VALUE="<%= strArrJudClassCd(i) %>">
					<INPUT TYPE="hidden" NAME="judCd" VALUE="<%= strArrJudCd(i) %>">
					<INPUT TYPE="hidden" NAME="weight" VALUE="<%= strArrWeight(i) %>">
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0">
				</TD>
				<TD><INPUT TYPE="checkbox" NAME="judCmtCd" VALUE="<%= strArrJudCmtCd(i) %>" <%= strChecked %> ONCLICK="javascript:checkJudCmtAct( <%= i %> )" BORDER="0"></TD>
				<TD BGCOLOR="<%= strBgColor %>"><%= strDispJudCmtStc %></TD>
				<TD NOWRAP>
				</TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
