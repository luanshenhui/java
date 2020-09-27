<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       フォローガイド (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objFollowUp     'フォローアップアクセス用
Dim objJud          '判定情報アクセス用
Dim objSentence     '文章情報アクセス用

'パラメータ
Dim lngFollowKbn        'フォロー施設区分
Dim lngRsvNo            '予約番号
Dim lngJudClassCd       '判定コード
Dim strJudClassName     '検診項目
Dim strJudCd            '判定
Dim strSecCslDate       '二次検査日
Dim strComeFlg          '状況
Dim strSecItemCd        '検査項目
Dim strRsvInfoCd        '予約情報
Dim strJudCd2           '結果
Dim strQuestionCd       'アンケート
Dim strfolNote          '備考

Dim strSecCslYear       '二次検査日（年）
Dim strSecCslMonth      '二次検査日（月）
Dim strSecCslDay        '二次検査日（日）

Dim lngUS               '文章コード
Dim lngCT               '文章コード
Dim lngMRI              '文章コード
Dim lngEF               '文章コード
Dim lngBE               '文章コード
Dim lngTM               '文章コード
Dim lngETC              '文章コード
Dim strETC              '文章コード

Dim strStcCd1           '文章コード
Dim strShortstc1        '略称
Dim strStcCd2           '文章コード
Dim strShortstc2        '略称
Dim strStcCd3           '文章コード
Dim strShortstc3        '略称
Dim strStcCd4           '文章コード
Dim strShortstc4        '略称
Dim strStcCd5           '文章コード
Dim strShortstc5        '略称
Dim strRsvInfoName      '予約情報名
Dim strQuestionName     'アンケート名

'判定コンボボックス
Dim strArrJudCdSeq      '判定連番
Dim strArrJudCd         '判定コード
Dim strArrWeight        '判定用重み
Dim lngJudListCnt       '判定件数

Dim lngCount            'レコード件数

Dim i                   'インデックス
Dim Ret                 '復帰値
Dim rslCnt              '結果入力欄インデックス

Dim vntArrSecItemCd     '
Dim vntArrSecItemCd2    '

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
Set objJud          = Server.CreateObject("HainsJud.Jud")
Set objSentence     = Server.CreateObject("HainsSentence.Sentence")

'パラメータ値の取得
lngJudClassCd   = Request("judClassCd")
strJudClassName = Request("judClassName")
strJudCd        = Request("judCd")
strSecCslDate   = Request("secCslDate")
If strSecCslDate <> "" Then
    strSecCslYear   = Year(strSecCslDate)
    strSecCslMonth  = Month(strSecCslDate)
    strSecCslDay    = Day(strSecCslDate)
End If
rslCnt          = Request("rslCnt")
'if rslCnt = 0 Then
'   rslCnt = 1
'End If


strComeFlg          = Request("comeFlg")
strSecItemCd        = Request("secItemCd")
vntArrSecItemCd     = Split(strSecItemCd,"Z")
vntArrSecItemCd2    = Array()
Redim Preserve vntArrSecItemCd2(5)
i = 0
Do Until i > Ubound(vntArrSecItemCd)
    vntArrSecItemCd2(i) = Trim(vntArrSecItemCd(i))
    i = i +1
Loop
strStcCd1       = vntArrSecItemCd2(0)
strStcCd2       = vntArrSecItemCd2(1)
strStcCd3       = vntArrSecItemCd2(2)
strStcCd4       = vntArrSecItemCd2(3)
strStcCd5       = vntArrSecItemCd2(4)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd1, strShortstc1)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd2, strShortstc2)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd3, strShortstc3)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd4, strShortstc4)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd5, strShortstc5)
strRsvInfoCd    = Request("rsvInfoCd")
Ret         = objSentence.SelectSentence("89002", 0, strRsvInfoCd, strRsvInfoName)
strJudCd2   = Request("judCd2")
strQuestionCd   = Request("questionCd")
Ret         = objSentence.SelectSentence("89003", 0, strQuestionCd, strQuestionName)
strFolNote  = Request("folNote")
'判定取得
Call EditJudListInfo

'-------------------------------------------------------------------------------
'
' 機能　　 : 判定の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditJudListInfo()

    '判定一覧取得
    lngJudListCnt = objJud.SelectJudList(strArrJudCd, , , strArrWeight )

    strArrJudCdSeq = Array()
    Redim Preserve strArrJudCdSeq(lngJudListCnt-1)
    For i = 0 To lngJudListCnt-1
        strArrJudCdSeq(i) = i
    Next


End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>二次検診結果登録</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
    var lngSelectedIndex1;  // ガイド表示時に選択されたエレメントのインデックス
    var curYear, curMonth, curDay;  // 日付ガイド呼び出し直前の日付退避用変数

    // 日付ガイドまたはカレンダー検索画面呼び出し
    function callCalGuide(index) {

        var myForm = document.folList;  // 自画面のフォームエレメント

        // ガイド呼び出し直前の日付を退避
        curYear  = eval(myForm.secCslYear + index).value;
        curMonth = eval(myForm.secCslMonth + index).value;
        curDay   = eval(myForm.secCslDay + index).value;

        // 日付ガイド表示
        calGuide_showGuideCalendar( 'secCslYear'+index, 'secCslMonth'+index, 'secCslday'+index, dateSelected );

    }

    function dateSelected() {

    }

    // 文章ガイド呼び出し
    function callStcGuide( index ) {

        var myForm = document.folList;

        // 選択されたエレメントのインデックスを退避(文章コード・略文章のセット用関数にて使用する)
        lngSelectedIndex1 = index;

        // ガイド画面の連絡域に検査項目コードを設定する
        if ( index == 1 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 2 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 3 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 4 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 5 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 6 ) {
            stcGuide_ItemCd ='89002';
        }
        if ( index == 7 ) {
            stcGuide_ItemCd ='89003';
        }

        // ガイド画面の連絡域に項目タイプ（標準）を設定する
        stcGuide_ItemType = '0';

        // ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
        stcGuide_CalledFunction = setStcInfo;

        // 文章ガイド表示
        showGuideStc();
    }

    // 文章コード・略文章のセット
    function setStcInfo() {

        setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );

    }

    // 文章の編集
    function setStc( index, stcCd, shortStc ) {

        var myForm = document.folList;      // 自画面のフォームエレメント
        var objStcCd, objShortStc;          // 結果・文章のエレメント
        var stcNameElement;                 // 文章のエレメント

        // 編集エレメントの設定
        if ( index == 1 ) {
            objStcCd        = myForm.stcCd1;
            objShortStc     = myForm.shortStc1;
        }
        if ( index == 2 ) {
            objStcCd        = myForm.stcCd2;
            objShortStc     = myForm.shortStc2;
        }
        if ( index == 3 ) {
            objStcCd        = myForm.stcCd3;
            objShortStc     = myForm.shortStc3;
        }
        if ( index == 4 ) {
            objStcCd        = myForm.stcCd4;
            objShortStc     = myForm.shortStc4;
        }
        if ( index == 5 ) {
            objStcCd        = myForm.stcCd5;
            objShortStc     = myForm.shortStc5;
        }
        if ( index == 6 ) {
            objStcCd        = myForm.rsvInfoCd;
            objShortStc     = myForm.rsvInfoName;
        }
        if ( index == 7 ) {
            objStcCd        = myForm.questionCd;
            objShortStc     = myForm.questionName;
        }

        stcNameElement = 'stcName' + index;

        // 値の編集
        objStcCd.value   = stcCd;
        objShortStc.value = shortStc;

        if ( document.getElementById(stcNameElement) ) {
            document.getElementById(stcNameElement).innerHTML = shortStc;
        }

    }

    // 文章のクリア
    function callStcClr( index ) {

        var myForm = document.folList;      // 自画面のフォームエレメント
        var objStcCd, objShortStc;          // 結果・文章のエレメント
        var stcNameElement;                 // 文章のエレメント

        // 編集エレメントの設定
        if ( index == 1 ) {
            objStcCd        = myForm.stcCd1;
            objShortStc     = myForm.shortStc1;
        }
        if ( index == 2 ) {
            objStcCd        = myForm.stcCd2;
            objShortStc     = myForm.shortStc2;
        }
        if ( index == 3 ) {
            objStcCd        = myForm.stcCd3;
            objShortStc     = myForm.shortStc3;
        }
        if ( index == 4 ) {
            objStcCd        = myForm.stcCd4;
            objShortStc     = myForm.shortStc4;
        }
        if ( index == 5 ) {
            objStcCd        = myForm.stcCd5;
            objShortStc     = myForm.shortStc5;
        }
        if ( index == 6 ) {
            objStcCd        = myForm.rsvInfoCd;
            objShortStc     = myForm.rsvInfoName;
        }
        if ( index == 7 ) {
            objStcCd        = myForm.questionCd;
            objShortStc     = myForm.questionName;
        }
        stcNameElement = 'stcName' + index;

        // 値の編集
        objStcCd.value   = '';
        objShortStc.value = '';

        if ( document.getElementById(stcNameElement) ) {
            document.getElementById(stcNameElement).innerHTML = '';
        }

    }


    // 入力領域データのセット
    function selectList() {

        window.close();

    }


    function saveFollowRsl(){
    }


    function showFollowRsl(rslCnt){
        var myForm = document.folList;      // 自画面のフォームエレメント
        myForm.rslCnt.value = rslCnt;
        myForm.submit();
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">フォローアップ結果登録</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
        Call followupHeader(lngRsvNo)
%>
    <!--BR-->
<FORM NAME="folList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="rsvno"           VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= lngJudClassCd %>">
    <INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= lngJudClassCd %>">
    <INPUT TYPE="hidden" NAME="judClassName"    VALUE="<%= strJudClassName %>">
    <INPUT TYPE="hidden" NAME="judCd"           VALUE="<%= strJudCd %>">
    <INPUT TYPE="hidden" NAME="rslCnt"          VALUE="<%= rslCnt %>">

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR ALIGN="left">
            <TD width="*">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR align="center">
                        <TD BGCOLOR="#cccccc" width="120">健診項目</TD>
                        <TD BGCOLOR="#eeeeee" width="120"><%= strJudClassName %></TD>
                        <TD width="20">&nbsp;</TD>
                        <TD BGCOLOR="#cccccc" width="120">判定</TD>
                        <TD BGCOLOR="#eeeeee" width="120"><%= strJudCd %></TD>
                    </TR>
                </TABLE>
            </TD>
            <TD width="400" align="right">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR align="right">
                        <TD ALIGN="right">&nbsp;<A HREF="javascript:function voi(){};voi()" ONCLICK="return saveFollowRsl()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="二次検査結果情報保存"></A>
                        <A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#cccccc" ALIGN="center">医療施設</TD>
            <TD NOWRAP>
                <INPUT TYPE="radio" NAME="followKbn" VALUE="<%= lngFollowKbn %>" <%= IIf(lngFollowKbn = "0", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(0)"  BORDER="0">二次検査場所未定&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="followKbn" VALUE="<%= lngFollowKbn %>" <%= IIf(lngFollowKbn = "1", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(1)"  BORDER="0">当センター&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="followKbn" VALUE="<%= lngFollowKbn %>" <%= IIf(lngFollowKbn = "2", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(2)"  BORDER="0">本院&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="followKbn" VALUE="<%= lngFollowKbn %>" <%= IIf(lngFollowKbn = "3", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(3)"  BORDER="0">他院
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">検査結果</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>

    
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="100%">
<%
    For i = 0 To rslCnt
%>
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE>
                <TR>
                    <TD NOWRAP BGCOLOR=<%= IIf( i mod 2 = 0, "#cccccc", "#eeeeee") %> WIDTH="120">検査年月日&nbsp;<%= IIf( rslCnt >= 1, i+1, "") %></TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                            <TR>
                                <TD NOWRAP ID="gdeDate"><A HREF="javascript:callCalGuide(<%=i%>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示します"></A></TD>
                                <TD NOWRAP><A HREF="javascript:calGuide_clearDate('secCslYear', 'secCslMonth', 'secCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
                                <TD COLSPAN="4">
                                    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
                                        <TR>
                                            <TD><%= EditNumberList("secCslYear"&i, YEARRANGE_MIN, YEARRANGE_MAX, strSecCslYear, True) %></TD>
                                            <TD>年</TD>
                                            <TD><%= EditNumberList("secCslMonth"&i, 1, 12, strSecCslMonth, True) %></TD>
                                            <TD>月</TD>
                                            <TD><%= EditNumberList("secCslDay"&i, 1, 31, strSecCslDay, True) %></TD>
                                            <TD>日</TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR=<%= IIf( i mod 2 = 0, "#cccccc", "#eeeeee") %>>検査方法&nbsp;<%= IIf( rslCnt >= 1, i+1, "") %></TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                            <TR>
                                <TD NOWRAP>
                                    <INPUT TYPE="checkbox" NAME="chkUS" VALUE="1" <%= IIf( lngUS = "1", "CHECKED", "") %>>US&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkCT" VALUE="1" <%= IIf( lngCT = "1", "CHECKED", "") %>>CT&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkMRI" VALUE="1" <%= IIf( lngMRI = "1", "CHECKED", "") %>>MRI&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkEF" VALUE="1" <%= IIf( lngEF = "1", "CHECKED", "") %>>内視鏡&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkBE" VALUE="1" <%= IIf( lngEF = "1", "CHECKED", "") %>>注腸&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkTM" VALUE="1" <%= IIf( lngEF = "1", "CHECKED", "") %>>腫瘍マーカー&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkETC" VALUE="1" <%= IIf( lngETC = "1", "CHECKED", "") %>>その他&nbsp;
                                    <INPUT TYPE="text" NAME="txtETC" SIZE="50" MAXLENGTH="50" VALUE="<%=strEtc%>" STYLE="ime-mode:active;">
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR=<%= IIf( i mod 2 = 0, "#cccccc", "#eeeeee") %>>診断名&nbsp;<%= IIf( rslCnt >= 1, i+1, "") %></TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                            <TR>
                                <TD NOWRAP>
                                    臓器名：&nbsp;
                                    <SELECT NAME="secArea">
                                        <OPTION VALUE="">未選択</OPTION>
                                    </SELECT>&nbsp;&nbsp;&nbsp;&nbsp;
                                    疾患名：&nbsp;
                                    <SELECT NAME="secDisease">
                                        <OPTION VALUE="">未選択</OPTION>
                                    </SELECT>&nbsp;&nbsp;&nbsp;&nbsp;
                                    その他：&nbsp;
                                    <INPUT TYPE="text" NAME="txtShindan" SIZE="50" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;">
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR=<%= IIf( i mod 2 = 0, "#cccccc", "#eeeeee") %>>治療方針&nbsp;<%= IIf( rslCnt >= 1, i+1, "") %></TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                            <TR>
                                <TD NOWRAP>
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="1" BORDER="0">精査通院中&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="2" BORDER="0">処置不要&nbsp;&nbsp;<br>
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="3" BORDER="0">経過観察&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="4" BORDER="0">1年後健診&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="5" BORDER="0">他院紹介&nbsp;&nbsp;<br>
                                    <INPUT TYPE="radio" NAME="care"       VALUE="1" BORDER="0">貴院&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="care"       VALUE="2" BORDER="0">他院&nbsp;&nbsp;（&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="6" BORDER="0">通院治療&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="7" BORDER="0">入院治療&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="8" BORDER="0">外科治療&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="9" BORDER="0">内視鏡的治療&nbsp;&nbsp;）<br>
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="99" BORDER="0">その他&nbsp;&nbsp;
                                    <INPUT TYPE="text" NAME="txtReload" SIZE="50" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;">
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                </TABLE>
            </TD>
        </TR>

<%
    Next
%>
    
    </TABLE>

    <TABLE CELLSPACING="2" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><INPUT TYPE="button" NAME="rslAdd" VALUE="疾患の追加" size="50" onClick="javascript:showFollowRsl(<%=rslCnt+1%>)"></TD>
        </TR>
    </TABLE>
    
    
    
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">ステータス</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="followStatus" VALUE="" BORDER="0">異常なし&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="followStatus" VALUE="" BORDER="0">異常あり（フォローなし）&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="followStatus" VALUE="" BORDER="0">異常あり（継続フォロー）&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="followStatus" VALUE="" BORDER="0">その他終了（連絡とれず）
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">備考</TD>
                        <TD COLSPAN="7"><TEXTAREA NAME="folNote" style="ime-mode:active"  COLS="70" ROWS="4"><%= strfolNote %></TEXTAREA></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">医療機関</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">病医院名</TD>
                        <TD><INPUT TYPE="text" NAME="followHospital" SIZE="70" MAXLENGTH="70" VALUE="" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">担当医師</TD>
                        <TD><INPUT TYPE="text" NAME="followDoctor" SIZE="50" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">住所</TD>
                        <TD><INPUT TYPE="text" NAME="followAddr" SIZE="100" MAXLENGTH="100" VALUE="" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">電話番号</TD>
                        <TD><INPUT TYPE="text" NAME="followTel" SIZE="50" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

</FORM>
</BODY>
</HTML>
