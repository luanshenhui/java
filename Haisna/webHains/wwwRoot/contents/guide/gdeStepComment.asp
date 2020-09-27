<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		特定健診階層化コメントの選択 (Ver0.0.1)
'		AUTHER  :
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
Const STARTPOS = 1      '開始位置のデフォルト値
'データベースアクセス用オブジェクト
Dim objJudCmtStc        '判定コメント情報アクセス用
Dim objJudClass         '判定分類情報アクセス用
Dim objCommon           '共通関数アクセス用

Dim lngCmtCnt           'コメント件数
Dim vntCmtCd            '選択されているコメントコード群
Dim vntArrCmtCd         '選択されているコメントコード配列

Dim strJudClassCd       '検索判定分類コード
Dim strJudClassName     '検索判定分類名称
Dim lngStartPos         '検索開始位置
Dim lngGetCount         '表示件数

'判定コメント情報
Dim strArrJudCmtCd      '判定コメントコード
Dim strArrJudCmtStc     '判定コメント文章
Dim strArrJudClassCd    '判定分類コード
Dim strArrJudClassName  '判定分類名称

Dim strDispJudCmtStc    '編集用の判定コメント文章
Dim strDispJudCmtCd     '編集用の判定コメントコード

Dim strCheckJudCmt      'チェックボックス

Dim strAction           '
Dim strArrKey           '(分割後の)検索キーの集合
Dim lngAllCount         '条件を満たす全レコード件数
Dim lngCount            'レコード件数
Dim strURL              'URL文字列
Dim i, j                'インデックス

Dim strChecked          'チェックボックスのチェック状態
Dim strBgColor          '背景色
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
vntCmtCd      = Request("selCmtCd")
lngCmtcnt     = Request("selCmtCnt")
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
Else
    Err.Raise 1000, , "指定の判定分類コードは存在しません。JudClassCd=" & strJudClassCd

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>コメントの選択</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 判定コメントコード・判定コメント文章のセット

function selectList( ) {

    var icnt;           //ループカウント
    var jcnt;           //ループカウント
    var kcnt;           //ループカウント

    // 呼び元ウィンドウが存在しなければ何もしない
    if ( opener == null ) {
        return false;
    }

    // 親画面の連絡域に対し、判定コメントコード・判定コメント文章を編集(リストが単数の場合と複数の場合とで処理を振り分け)

    jcnt = 0;
    opener.cmtGuide_varSelCmtCd.length = 0;
    opener.cmtGuide_varSelCmtStc.length = 0;
    opener.cmtGuide_varSelClassCd.length = 0;

    for ( icnt = 0; icnt < document.kensakulist.judCmtCd.length; icnt++ ){
        //既に登録済のコメント？
        for( kcnt = 0; kcnt < document.entryForm.selCmtCnt.value; kcnt++ ){
            if ( document.entryForm.selCmtCnt.value == 1 ){
                if ( document.kensakulist.judCmtCd[icnt].value == document.entryForm.selArrCmtCd.value ){
                    break;
                }
            } else {
                if ( document.kensakulist.judCmtCd[icnt].value == document.entryForm.selArrCmtCd[kcnt].value ){
                    break;
                }
            }
        }
        if (kcnt < document.entryForm.selCmtCnt.value){
            continue;
        }
        if ( document.kensakulist.judCmtCd[icnt].checked ) {
            opener.cmtGuide_varSelCmtCd.length ++;
            opener.cmtGuide_varSelCmtStc.length ++;
            opener.cmtGuide_varSelClassCd.length ++;
            opener.cmtGuide_varSelCmtCd[jcnt] = document.kensakulist.judCmtCd[icnt].value;
            opener.cmtGuide_varSelCmtStc[jcnt] = document.kensakulist.judCmtStc[icnt].value;
            opener.cmtGuide_varSelClassCd[jcnt] = document.kensakulist.judClassCd[icnt].value;
            jcnt++;
        }
    }

    // 連絡域に設定されてある親画面の関数呼び出し
    if ( opener.cmtGuide_CalledFunction != null ) {
        opener.cmtGuide_CalledFunction();
    }

    opener.winStepComment = null;
    close();

    return;
}

//チェックボックス選択処理
//既に登録済のコメントのチェックははずさない
function checkJudCmtAct( index ) {
    var icnt;           //ループカウント
    var jcnt;           //ループカウント

    //既に登録済のコメント？
    if( document.entryForm.selCmtCnt.value == 1 ) {
        if ( document.kensakulist.judCmtCd[index].value == document.entryForm.selArrCmtCd.value ){
                document.kensakulist.judCmtCd[index].checked = " CHECKED";
        }
    } else {
        for( icnt = 0; icnt < document.entryForm.selCmtCnt.value; icnt++ ){
            if ( document.kensakulist.judCmtCd[index].value == document.entryForm.selArrCmtCd[icnt].value ){
                 document.kensakulist.judCmtCd[index].checked = " CHECKED";
                break;
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
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

    <INPUT TYPE="hidden" NAME="act" VALUE="select">
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">コメントの選択</FONT></B></TD>
        </TR>
    </TABLE>

    <BR>

    <TABLE BORDER="0" CELLPADDING="2" CELLPADDING="2" WIDTH="100%">
        <TR>
            <TD HEIGHT="30" NOWRAP><B><%= strJudClassName %>コメント</B></TD>
<!-- ### 2004/11/12 Add End --> 
            <TD WIDTH="100%" ALIGN="right"><A HREF="javascript:selectList()"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="確定します"></A></TD>
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" ALT="キャンセルします" HEIGHT="24" WIDTH="77"></A></TD>
        </TR>
    </TABLE>
</FORM>

<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<%
    Do

        strArrKey = Array()
        Redim strArrKey(0)

        '検索条件を満たすレコード件数を取得
        lngAllCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey, 1)

        '検索結果が存在しない場合はメッセージを編集
        If lngAllCount = 0 Then
%>
            検索条件を満たす判定コメント情報は存在しません。<BR>
            キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
            Exit Do
        End If
        
        '検索条件を満た全件数分のレコードを取得
        lngGetCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey, 1)

        lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, _
                                                    strArrKey, _
                                                    lngStartPos, _
                                                    lngGetCount, _
                                                    strArrJudCmtCd, _
                                                    strArrJudCmtStc, _
                                                    strArrJudClassCd, _
                                                    strArrJudClassName, _
                                                    , , 1 )

        strCheckJudCmt = Array()
        Redim Preserve strCheckJudCmt(lngCount-1)
%>
        <TABLE BORDER="0" CELLSPACING="4" CELLPADDING="0">
<%
        For i = 0 to lngCount - 1

            '表示用判定コメント文章の編集
            strDispJudCmtStc = strArrJudCmtStc(i)
            strDispJudCmtCd  = strArrJudCmtCd(i)
    
    
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
    <%
            If i > 0 Then
    %>
                <TR>
                    <TD COLSPAN="3" HEIGHT="1" BGCOLOR="#999999"></TD>
                </TR>
    <%
            End If
    %>
            <TR>
                <TD>
                    <INPUT TYPE="hidden" NAME="judCmtStc" VALUE="<%= strArrJudCmtStc(i) %>">
                    <INPUT TYPE="hidden" NAME="judClassCd" VALUE="<%= strArrJudClassCd(i) %>">
                    <IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0">
                </TD>
                <TD BGCOLOR="<%= strBgColor %>" VALIGN="top"><INPUT TYPE="checkbox" NAME="judCmtCd" VALUE="<%= strArrJudCmtCd(i) %>" <%= strChecked %> ONCLICK="javascript:checkJudCmtAct( <%= i %> )" BORDER="0"></TD>
                <TD BGCOLOR="<%= strBgColor %>" WIDTH="100%"><%= strDispJudCmtStc %></TD>
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
