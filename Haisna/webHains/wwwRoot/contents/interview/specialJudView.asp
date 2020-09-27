<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       特定健診面接専用画面　(Ver0.0.1)
'       AUTHER  : 李
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_LEVEL = "X090"          '保健指導レベルグループコード

'### 2009/03/30 張 特定保健指導区分登録有無チェックのため追加 Start ###
Const GUIDANCE_ITEMCD = "64074"     '特定保健指導　検査項目コード
Const GUIDANCE_SUFFIX = "00"        '特定保健指導　サフィックス
'### 2009/03/30 張 特定保健指導区分登録有無チェックのため追加 End   ###

'データベースアクセス用オブジェクト
Dim objCommon               '共通クラス
Dim objSpecialInterview     '特定健診面接情報アクセス用
Dim objResult               '検査結果情報アクセス用

'パラメータ
Dim strAct         '処理状態
Dim strWinMode     'ウィンドウモード
Dim lngRsvNo       '予約番号（今回分）

Dim vntGrpCd       'グループコード
Dim vntGrpName     'グループ名称
Dim vntItemCd      '検査項目コード
Dim vntSuffix      'サフィックス
Dim vntItemName    '検査項目名称
Dim vntResult      '検査結果
Dim vntGrpSeq      '表示順番
Dim vntStopFlg     '検査中止フラグ
Dim vntRslCmtCd1   '結果コメント1
Dim vntRslCmtCd2   '結果コメント2
Dim vntHpoint      'ヘルスポイント
Dim vntStdLead     '保健指導対象基準値
Dim vntStdCare     '受診勧奨対象基準値
Dim vntGrpCount    'グループコード数

Dim vntRsvNo       '予約番号
Dim vntJudCmtCd    '判定コメントコード
Dim vntJudCmtStc   '判定コメント文章

Dim vntItemCd2     '検査項目コード
Dim vntSuffix2     'サフィックス
Dim vntItemName2   '検査項目名称
Dim vntResult2     '検査結果（コード）
Dim vntLongStc2    '検査結果（文章）


Dim lngCount       '件数
Dim lngCmtCount    'コメント件数
Dim lngRslCount    '結果件数
Dim StrSaveGrp     '検査項目グループコードチェック用
Dim strColor       '結果が異常値の場合

Dim i              'ループカウンタ
Dim j              'ループカウンタ

'### 2009/03/30 張 特定保健指導区分登録チェックのため追加 Start ###
Dim lngFlgChk           'フラグチェック
Dim strResult           '特定保健指導区分（結果テーブル参照値：RSL）
Dim strSentenceCd       '文章コード
Dim strSentenceName     '文章名称
Dim RetResult           '結果検索復帰値
'### 2009/03/30 張 特定保健指導区分登録チェックのため追加 End   ###

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon               = Server.CreateObject("HainsCommon.Common")
Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'### 2009/03/30 張 特定保健指導区分登録有無チェックのため追加 ###
Set objResult               = Server.CreateObject("HainsResult.Result")

'引数値の取得
strAct          = Request("action")
strWinMode      = Request("winmode")
lngRsvNo        = Request("rsvno")

Do
    lngCount = objSpecialInterview.SelectSpecialRslView( _
                            lngRsvNo, _
                            vntGrpCd, _
                            vntGrpName ,_
                            vntItemCd, _
                            vntSuffix, _
                            vntItemName, _
                            vntResult, _
                            vntGrpSeq, _
                            vntStopFlg, _
                            vntRslCmtCd1, _
                            vntRslCmtCd2, _
                            vntHpoint, _
                            vntStdLead, _
                            vntStdCare, _
                            vntGrpCount _
                            )
    If lngCount < 1 Then
        Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & "）"
    End If

    lngCmtCount = objSpecialInterview.SelectSpecialJudCmt( _
                            lngRsvNo, 5, ,_
                            vntJudCmtCd, _
                            vntJudCmtStc _
                            )
    
    If lngCount < 1 Then
        Err.Raise 1000, , "判定コメントが取得できません。（予約番号 = " & lngRsvNo & "）"
    End If

    '### 2009.03.24 張 保健指導レベル（階層化結果：ステップ３、ステップ４）表示のため追加 Start ###
    lngRslCount = objSpecialInterview.SelectSpecialResult( _
                            lngRsvNo,_
                            GRPCD_LEVEL,_
                            vntItemCd2, _
                            vntSuffix2, _
                            vntItemName2, _
                            vntResult2, _
                            vntLongStc2 _
                            )
    '### 2009.03.24 張 保健指導レベル（階層化結果：ステップ３、ステップ４）表示のため追加 End   ###

    '### 2009/03/30 張 特定保健指導区分登録有無チェックのため追加 Start ###
    lngFlgChk = 0
    strSentenceCd = ""
    strSentenceName = ""
    '特定保健指導区分結果データ取得
    RetResult = objResult.SelectRsl( lngRsvNo, GUIDANCE_ITEMCD, GUIDANCE_SUFFIX, strResult )
    If RetResult = True Then
        If strResult <> "" Then
            strSentenceCd   = strResult
            Select Case strResult
                '対象外
                Case "1"
                    strSentenceName = "対象外"
                '対象
                Case "2"
                    strSentenceName = "対象"
                Case Else
                    strSentenceName = ""
            End Select

            lngFlgChk = lngFlgChk + 1
        End If
    End If
    '### 2009/03/30 張 特定保健指導区分登録有無チェックのため追加 End   ###


    Exit Do
Loop

Set objResult               = Nothing
Set objspecialInterview     = nothing

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>特定健診専用面接</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
//特定健診コメント入力画面呼び出し

var winSpJudComment;
var winEntrySpecial;

function callSpJudComment() {
    var url;
    var opened = false;
    var i;

//    if ( winSpJudComment != null ) {
//        if ( !win)
    url = '/WebHains/contents/interview/SpecialJudComment.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';

    winSpJudComment = window.open( url, 'SpJudComment', 'width=750,height=270,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    winSpJudComment.focus();

}

//特定保健指導区分登録ウインドウ呼び出し
function showSpecialWindow() {

    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか


    // すでにガイドが開かれているかチェック
    if ( winEntrySpecial != null ) {
        if ( !winEntrySpecial.closed ) {
            opened = true;
        }
    }
    url = '/WebHains/contents/interview/EntrySpecial.asp?rsvno=' + <%= lngRsvNo %>;

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winEntrySpecial.focus();
        winEntrySpecial.location.replace( url );
    } else {
        winEntrySpecial = window.open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}


// 階層化コメント入力画面を閉じる
function closeSpJudComment() {

    if ( winSpJudComment != null ) {
        if ( !winSpJudComment.closed ) {
            winSpJudComment.close();
        }
    }
    if ( winEntrySpecial != null ) {
        if ( !winEntrySpecial.closed ) {
            winEntrySpecial.close();
        }
    }

    winSpJudComment = null;
    winEntrySpecial = null;

}

function refreshForm(){
        document.entryForm.submit();
}


//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeSpJudComment()">
<FORM NAME="entryForm" ACTION="" METHOD="post" STYLE="margin: 0px;">
    <!-- 引数値 -->
    <INPUT TYPE="hidden" NAME="action"    VALUE="<%= strAct %>">	
    <INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">

    <!-- タイトルの表示 -->
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" WIDTH="930" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">特定健診専用面接</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<!--## 繰り返し開始 ##-->
<%
    strSaveGrp = ""
    For i = 0 To lngCount - 1

        If i = 0 Then
%>
        <TR>
            <TD VALIGN="TOP">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD WIDTH="100">検査項目</TD>
                        <TD WIDTH="130">項目</TD>
                        <TD WIDTH="70">検査結果</TD>
                        <TD WIDTH="70">保健指導</TD>
                        <TD WIDTH="70">受診勧奨</TD>
                    </TR>
<%
        End If
        '検査グループコード変更チェック
        '検査グループコードが変わった時点で検査グループ名称を表示
        If strSaveGrp <> vntGrpCd(i) Then
            If vntGrpCd(i) = "X079" Then '検査グループコードが「肝機能」なのかをチェック
%>
                </TABLE>
            </TD>

            <TD WIDTH="5">&nbsp;</TD>

            <TD VALIGN="TOP">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD WIDTH="100">検査項目</TD>
                        <TD WIDTH="130">項目</TD>
                        <TD WIDTH="70">検査結果</TD>
                        <TD WIDTH="70">保健指導</TD>
                        <TD WIDTH="70">受診勧奨</TD>
                    </TR>
                    <TR>
                        <TD ROWSPAN="<%=vntGrpCount(i)%>" BGCOLOR="#cccccc" ALIGN="center"><%=vntGrpName(i)%></TD>
<%
            Else
%>
                    <TR>
                        <TD ROWSPAN="<%=vntGrpCount(i)%>" BGCOLOR="#cccccc" ALIGN="center"><%=vntGrpName(i)%></TD>
<%
            End If
            strSaveGrp = vntGrpCd(i)
        Else
%>
                    <TR>
<%
        End If

                    If vntHpoint(i) = 0 Then
                        strColor = "#eeeeee"
                    Else
                        strColor = "#ffc0cb"
                    End If
%>
                        <TD BGCOLOR="#eeeeee" HEIGHT="22" ALIGN="left"><%=iif(vntItemCd(i)="15022","血色素量("&vntItemName(i)&")",vntItemName(i))%></TD>
                        <TD BGCOLOR="<%=strColor%>" HEIGHT="22" ALIGN="right"><B><%=vntResult(i)%></B></TD>
                        <TD BGCOLOR="#eeeeee" HEIGHT="22" ALIGN="center"><%=vntStdLead(i)%></TD>
                        <TD BGCOLOR="#eeeeee" HEIGHT="22" ALIGN="center"><%=vntStdCare(i)%></TD>
                    </TR>
<%
    Next
%>
                </TABLE>
            </TD>
        </TR>
<!--## 繰り返し終了 ##-->
    </TABLE>
<%'### 2009/03/24 張 保健指導レベル階層化結果表示のため追加 Start ### %>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR><TD>&nbsp;</TD></TR>
<%
    For i = 0 To lngRslCount - 1
%>
        <TR>
            <TD><%= vntItemName2(i) %>&nbsp;：&nbsp;<b><%= vntLongStc2(i) %></b></TD>
        </TR>
<%
    Next
%>
<%'### 2009/03/24 張 保健指導レベル階層化結果表示のため追加 End   ### %>
        <TR><TD>&nbsp;</TD></TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="760">
                    <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">階層化コメント</FONT></B></TD>
                </TABLE>
            </TD>
            <TD ALIGN="right" BGCOLOR="ffffff"><A HREF="javascript:callSpJudComment()">
                <IMAGE SRC="/webHains/images/modifycomment.gif" ALT="特定健診コメント入力" BORDER="0"></A>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR><TD>&nbsp;</TD></TR>
<%
        For i = 0 To lngCmtCount - 1
%>
        <TR>
            <TD><%= vntJudCmtStc(i) %></TD>
        </TR>
<%
        Next
%>
    </TABLE>
    <BR><BR>

<%
    '### 結果テーブル（RSL）に特定保健指導区分検査項目（64074-00）が存在する受診者のみ表示 ###
    If RetResult = True Then
%>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="760">
                    <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">特定保健指導区分</FONT></B></TD>
                </TABLE>
            </TD>
            <TD ALIGN="left" width="120" BGCOLOR="ffffff"><A HREF="javascript:showSpecialWindow()">
                <IMAGE SRC="/webHains/images/changeper.gif" ALT="特定保健指導区分入力" BORDER="0"></A>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR><TD COLSPAN="4">&nbsp;</TD></TR>
        <TR>
    <%
        '### 特定保健指導区分が登録されていなかった場合、未登録メッセージ表示
        If lngFlgChk = 0 Then
    %>
            <TD COLSPAN="4"><FONT COLOR="#ff6600"><B>現在、特定保健指導区分が登録されていません。</B></FONT></TD>
    <% 
        Else
    %>
            <TD WIDTH="90">&nbsp;特定保健指導</TD>
            <TD WIDTH="10">&nbsp;：&nbsp;</TD>
            <TD WIDTH="150">&nbsp;<B><%= strSentenceName %></B></TD>
            <TD>&nbsp;</TD>
    <% 
        End If
    %>
        <TR>
    </TABLE>
    <BR>
<%
    End If
%>
</FORM>
</BODY>
</HTML>