<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       フォロー(依頼状) (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon               '共通クラス
'Dim objConsult              '受診情報アクセス用
'Dim objPerson               '個人情報アクセス用
Dim objFollow               'フォローアップアクセス用
Dim objRequest              '依頼状履歴アクセス用
Dim objHainsUser            'ユーザ情報アクセス用

Dim strMessage              'エラーメッセージ
Dim strMode                 '処理モード
Dim strAct                  '処理状態
Dim strStartCslDate         '検索条件受診年月日（開始）
Dim strStartYear            '検索条件受診年（開始）
Dim strStartMonth           '検索条件受診月（開始）
Dim strStartDay             '検索条件受診日（開始）
Dim strEndCslDate           '検索条件受診年月日（終了）
Dim strEndYear              '検索条件受診年（終了）
Dim strEndMonth             '検索条件受診月（終了）
Dim strEndDay               '検索条件受診日（終了）

Dim dptEndDate              '
Dim dptStartDate

Dim vntRsvNo                '予約番号
Dim vntCslDate              '受診日
Dim vntDayId                '当日ID
Dim vntPerId                '個人ID
Dim vntPerKname             'カナ氏名
Dim vntPerName              '氏名
Dim vntAge                  '年齢
Dim vntGender               '性別
Dim vntBirth                '生年月日
Dim vntCscd                 'コースコード
Dim vntJudClassCd           '判定分類コード
Dim vntJudClassName         '判定分類名
Dim vntJudCd                '判定コード（フォロー登録時判定結果）
Dim vntRslJudCd             '判定コード（健診判定結果）
Dim vntResultDispMode       '検査結果表示モード
Dim vntEquipDiv             '二次検査実施区分
Dim vntAddUser              'フォーロ登録者
Dim vntDocJud               '判定医
Dim vntDocGf                '上部消化管内視鏡医
Dim vntDocCf                '大腸内視鏡医

Dim vntSecPlanDate          '二次検査予定日
Dim vntReqCheckDate1        '第一勧奨日
Dim vntReqCheckDate2        '第二勧奨日
Dim vntReqCheckSeq          '勧奨次数
Dim vntSecTestName          '二次検査予定項目名

Dim strItemCd               '検査条件検査項目
Dim vntItemCd               'フォロー対象検査項目コード
Dim vntItemName             'フォロー対象検査項目名称
Dim lngItemCount            'フォロー対象検査項目数

Dim strUpdUser              '検索条件ユーザ
Dim strUpdUsername          'ユーザ名

Dim lngPastMonth            '受診日からの経過期間
Dim lngArrPastMonth()       '受診日からの経過期間配列
Dim strArrPastMonthName()   '受診日からの経過期間名配列

Dim strCheckDateStat          '結果承認状態("":すべて、"0":未勧奨、"1":1次勧奨済み、"2":2次勧奨済み)

Dim lngStartPos             '表示開始位置
Dim lngPageMaxLine          '１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()     '１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName() '１ページ表示ＭＡＸ行名の配列
Dim strArrMessage           'エラーメッセージ

Dim lngAllCount             '総件数
Dim lngAllRsvCount          '複数予約なし件数
Dim lngPMonth            '受診日からの経過期間

Dim strBeforeRsvNo          '前行の予約番号

Dim strWebCslDate           '受診日
Dim strWebRsvNo             '予約番号
Dim strWebDayId             '当日ID
Dim strWebPerId             '個人ID
Dim strWebPerName           'カナ氏名・氏名
Dim strWebGender            '性別
Dim strWebAge               '年齢
Dim strWebBirth             '生年月日
Dim strWebJudClassName      '判定分類名
Dim strWebJudCd             '判定コード（フォロー登録時判定結果）
Dim strWebRslJudCd          '判定コード（カレント判定結果）
Dim strWebEquipDiv          '二次検査実施区分
Dim strWebEquipDivName      '二次検査実施区分（名称）
Dim strWebAddUser           'フォーロ登録者
Dim strWebDocJud            '判定医
Dim strWebDocGf             '上部消化管内視鏡医
Dim strWebDocCf             '大腸内視鏡医

Dim strWebSecPlanDate          '二次検査予定日
Dim strWebReqCheckDate1        '第一勧奨日
Dim strWebReqCheckDate2        '第二勧奨日
Dim strWebSecTestName          '二次検査予定項目名

Dim strCheckYear
Dim strCheckMonth
Dim strCheckDay

Dim i                       'カウンタ
Dim strURL                  'ジャンプ先のURL

'-------------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
'Set objConsult      = Server.CreateObject("HainsConsult.Consult")
'Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")

'引数値の取得
strMode             = Request("mode")
strAct              = Request("action")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear          = Request("endYear")
strEndMonth         = Request("endMonth")
strEndDay           = Request("endDay")
strItemCd           = Request("itemCd")
strUpdUser          = Request("upduser")
strCheckDateStat    = Request("checkDateStat")

lngPastMonth        = Request("pastMonth")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

vntRsvNo            = ConvIStringToArray(Request("arrRsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("arrJudClassCd"))
vntJudCd            = ConvIStringToArray(Request("arrJudCd"))
vntRslJudCd         = ConvIStringToArray(Request("arrRslJudCd"))
vntEquipDiv         = ConvIStringToArray(Request("arrEquipDiv"))


'検索開始日指定
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
    dptEndDate  = DateAdd("m", -3, Now-1)
    strEndYear    = CStr(Year(dptEndDate))
    strEndMonth   = CStr(Month(dptEndDate))
    strEndDay     = CStr(Day(dptEndDate))

    dptStartDate  = DateAdd("d", -7, dptEndDate)
    strStartYear    = CStr(Year(dptStartDate))
    strStartMonth   = CStr(Month(dptStartDate))
    strStartDay     = CStr(Day(dptStartDate))
End If


'経過期間未指定時のデーフォルトは3ヶ月経過
lngPastMonth = IIf(lngPastMonth = "", 0, lngPastMonth)
lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos )
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine)


'検索期間指定（システム日付から３ヶ月経過の日付）
If lngPastMonth <> 0 Then
    dptEndDate  = DateAdd("m", -lngPastMonth, Now-1)
    strEndYear    = CStr(Year(dptEndDate))
    strEndMonth   = CStr(Month(dptEndDate))
    strEndDay     = CStr(Day(dptEndDate))

    dptStartDate  = DateAdd("d", -7, dptEndDate)
    strStartYear    = CStr(Year(dptStartDate))
    strStartMonth   = CStr(Month(dptStartDate))
    strStartDay     = CStr(Day(dptStartDate))
End If

Call CreatePastMonthInfo()
Call CreatePageMaxLineInfo()
'オブジェクトのインスタンス作成


Do

    'フォロー対象検査項目（判定分類）を取得
    lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName)

    'ユーザー情報取得
    If strUpdUser <> "" Then
        objHainsUser.SelectHainsUser strUpdUser, strUpdUserName
    End If

    '検索ボタンクリック
    If strAct <> "" Then

        '受診日(自)の日付チェック
        If strStartYear <> "" Or strStartMonth <> "" Or strStartDay <> "" Then
            If Not IsDate(strStartYear & "/" & strStartMonth & "/" & strStartDay) Then
                strArrMessage = Array("受診日の指定に誤りがあります。")
                Exit Do
            End If
        End If

        '受診日(至)の日付チェック
        If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then
            If Not IsDate(strEndYear & "/" & strEndMonth & "/" & strEndDay) Then
                strArrMessage = Array("受診日の指定に誤りがあります。")
                Exit Do
            End If
            strEndCslDate   = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
        Else
            strEndCslDate = strStartCslDate
        End If

        '検索開始終了受診日の編集
        strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)

        '受診日範囲（１年以内）チェック
        If strEndCslDate - strStartCslDate > 182 Then
            strArrMessage = Array("受診日範囲は、6ヶ月以内を指定して下さい。")
            Exit Do
        End If

        '全件を取得する
        lngAllCount = objFollow.SelectExhortList( strStartCslDate, strEndCslDate, _
                                                  strItemCd, strUpdUser, _
                                                  lngPastMonth, lngStartPos, _
                                                  lngPageMaxLine, _
                                                  strCheckDateStat, _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  False )

        If lngAllCount > 0 Then

            lngAllRsvCount =objFollow.SelectExhortList( strStartCslDate, strEndCslDate, _
                                                        strItemCd, strUpdUser, _
                                                        lngPastMonth, lngStartPos, _
                                                        lngPageMaxLine, _
                                                        strCheckDateStat, _
                                                        vntCsldate, _
                                                        vntRsvNo, vntPerId, _
                                                        vntDayId, vntPerKname, _
                                                        vntPerName, vntGender, _
                                                        vntAge, vntBirth, _
                                                        vntCscd, vntJudClassCd, _
                                                        vntJudClassName, vntJudCd, _
                                                        vntRslJudCd, vntResultDispMode, _
                                                        vntEquipDiv, vntAddUser, _
                                                        vntDocJud, vntDocGf, vntDocCf, _
                                                        True , _ 
                                                        vntSecPlanDate, _
                                                        vntReqCheckDate1, _
                                                        vntReqCheckDate2, _
                                                        vntSecTestName _
                                                        )
        End If

    End If
    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診日から経過した期間名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePastMonthInfo()

    Redim Preserve lngArrPastMonth(1)
    Redim Preserve strArrPastMonthName(1)

    lngArrPastMonth(0) = 1:strArrPastMonthName(0) = "3ヶ月経過"
    lngArrPastMonth(1) = 2:strArrPastMonthName(1) = "6ヶ月経過"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : １ページ表示ＭＡＸ行の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()


    Redim Preserve lngArrPageMaxLine(4)
    Redim Preserve strArrPageMaxLineName(4)

    lngArrPageMaxLine(0) = 10:strArrPageMaxLineName(0) = "10行ずつ"
    lngArrPageMaxLine(1) = 20:strArrPageMaxLineName(1) = "20行ずつ"
    lngArrPageMaxLine(2) = 50:strArrPageMaxLineName(2) = "50行ずつ"
    lngArrPageMaxLine(3) = 100:strArrPageMaxLineName(3) = "100行ずつ"
    lngArrPageMaxLine(4) = 999:strArrPageMaxLineName(4) = "すべて"

End Sub

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>勧奨対象照会</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->
    var winGuideFollow;     //フォローアップ画面ハンドル
    var winMenResult;       // ドック結果参照ウィンドウハンドル
    var winRslFol;          // フォロー結果登録ウィンドウハンドル
    var winReqCheck;

    // エレメント参照用変数
    var calCheck_Year;				// 年
    var calCheck_Month;				// 月
    var calCheck_Day;				// 日
    var calCheck_CalledFunction;	// 日付選択時に呼び出される関数オブジェクト
    var winGuideCalendar;			// ウィンドウハンドル

    // ユーザーガイド呼び出し
    function callGuideUsr() {

        usrGuide_CalledFunction = SetUpdUser;

        // ユーザーガイド表示
        showGuideUsr();

    }

    // ユーザーセット
    function SetUpdUser() {

        document.entryForm.upduser.value = usrGuide_UserCd;
        document.entryForm.updusername.value = usrGuide_UserName;
        document.getElementById('username').innerHTML = usrGuide_UserName;
    }

    function setSearchDate(pMonth) {
        document.entryForm.pastMonth.value = pMonth;
        document.entryForm.action.value = "";
        document.entryForm.submit();
    }

    // ユーザー指定クリア
    function clearUpdUser() {

        document.entryForm.upduser.value = '';
        document.entryForm.updusername.value = '';
        document.getElementById('username').innerHTML = '';

    }


    // 日付ガイド呼び出し
    function callCalGuide(year, month, day) {

        // 日付ガイド表示
        calGuide_showGuideCalendar( year, month, day);

    }

    //検査結果画面呼び出し
    function callMenResult( lngRsvNo, strGrpCd, strCsCd, classgrpno ) {

        var url;            // URL文字列
        var opened = false; // 画面がすでに開かれているか


        // すでにガイドが開かれているかチェック
        if ( winMenResult != null ) {
            if ( !winMenResult.closed ) {
                opened = true;
            }
        }

        url = '/WebHains/contents/interview/MenResult.asp?grpno=' + classgrpno;
        url = url + '&winmode=1';
        url = url + '&rsvno=' + lngRsvNo;
        url = url + '&grpcd=' + strGrpCd;
        url = url + '&cscd=' + strCsCd;

        // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
        if ( opened ) {
            winMenResult.focus();
            winMenResult.location.replace( url );
        } else {
            winMenResult = window.open( url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }

    function submitForm(act) {

        with ( document.entryForm) {
            if (act == "search" ) {
                startPos.value = 1 ;
                pastMonth.value = '';
            }
            action.value = act;
            submit();
        }
        return false;
    }

    // ガイド画面を表示
    function follow_openWindow( url ) {

        var opened = false; // 画面が開かれているか

        var dialogWidth = 1000, dialogHeight = 600;
        var dialogTop, dialogLeft;

        // すでにガイドが開かれているかチェック
        if ( winGuideFollow ) {
            if ( !winGuideFollow.closed ) {
                opened = true;
            }
        }

        // 画面を中央に表示するための計算
        dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
        dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

        // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
        if ( opened ) {
            winGuideFollow.focus();
            winGuideFollow.location.replace( url );
        } else {
            winGuideFollow = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
        }

    }

    /** フォローアップ情報編集画面呼び出し **/
    function showFollowInfo(rsvNo, judClassCd) {

        var opened = false; // 画面が開かれているか
        var url;            // URL文字列
        var myForm = document.entryFollowInfo;

        // すでに画面が開かれているかチェック
        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                opened = true;
            }
        }

        // フォロー結果登録画面呼び出し
        url = 'followInfoEdit.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd;

        // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
        if ( opened ) {
            winRslFol.focus();
            winRslFol.location.replace(url);
        } else {
            winRslFol = window.open(url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }





// 結果コメントのクリア
function clearCheckDate(index) {
    //document.getElementById('cDate' + index).innerHTML = '';
    document.getElementsByName('cYear' + index)[0].value  = '';
    document.getElementsByName('cMonth' + index)[0].value  = '';
    document.getElementsByName('cDay' + index)[0].value  = '';

    //document.getElementsByName('cYear' + index)[0].innerHTML  = '';
    //document.getElementsByName('cMonth' + index)[0].innerHTML  = '';
    //document.getElementsByName('cDay' + index)[0].innerHTML  = '';
    
    //document.getElementById('ccYear' + index)[0].innerHTML  = '';
    //document.getElementById('ccMonth' + index)[0].innerHTML  = '';
    //document.getElementById('ccDay' + index)[0].innerHTML  = '';

}

// 結果コメントのクリア
function callChkDateEdit(rsvNo, judClassCd, strCheckDate,mode) {
    
    var opened = false;     // 画面が開かれているか
    var url;                // URL文字列
    var dialogTop, dialogLeft;

    // すでに画面が開かれているかチェック
    if ( winReqCheck != null ) {
        if ( !winReqCheck.closed ) {
            opened = true;
        }
    }

    // フォロー結果登録画面呼び出し
    url = 'followCheckDateEdit.asp?mode='+ mode+'&rsvno='+rsvNo+ '&judClassCd='+judClassCd+'&reqCheckDate='+ strCheckDate;

    // 画面を中央に表示するための計算
    dialogTop  = ( screen.height - 380 ) / 2;
    dialogLeft = ( screen.width  - 485  ) / 2;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winReqCheck.focus();
        winReqCheck.location.replace(url);
    } else {
        winReqCheck = window.open(url, '', 'width=480,height=300, top=' + dialogTop + ',left=' + dialogLeft + ',' +  'status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}

function replaceForm() {
    submitForm('search');
}


//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
<!--
td.flwtab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
    <INPUT TYPE="hidden" NAME="action"      VALUE="">
    <INPUT TYPE="hidden" NAME="startPos"    VALUE="<%= lngStartPos %>">
    <INPUT TYPE="hidden" NAME="pastMonth"   VALUE="<%= lngPastMonth %>">

<%
    'メッセージの編集
    Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>


<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">勧奨対象照会</FONT></B></TD>
    </TR>
</TABLE>
<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="70">受診日</TD>
        <TD WIDTH="10">：</TD>
        <TD>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
                    <TD>&nbsp;年&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
                    <TD>&nbsp;月&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
                    <TD>&nbsp;日～&nbsp;</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" BORDER="0" ALT="日付ガイドを表示"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" BORDER="0" ALT="設定日付をクリア"></TD>
                    <TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
                    <TD>&nbsp;年&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
                    <TD>&nbsp;月&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
                    <TD>&nbsp;日</TD>
                    <TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
                    <TD><INPUT TYPE="BUTTON" VALUE="3ヶ月経過" STYLE="width:75px;height:26px" ALT="" ONCLICK="javascript:setSearchDate(3)"></TD>
                    <TD>&nbsp;</TD>
                    <TD><INPUT TYPE="BUTTON" VALUE="6ヶ月経過" STYLE="width:75px;height:26px" ALT="" ONCLICK="javascript:setSearchDate(6)"></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="70">検査項目</TD>
        <TD WIDTH="10">：</TD>
        <TD><%= EditDropDownListFromArray("itemCd", vntItemCd, vntItemName, strItemCd, NON_SELECTED_ADD) %></TD>

        <TD WIDTH="60" NOWRAP>勧奨区分 </TD>
        <TD WIDTH="10">：</TD>
        <TD WIDTH="110">
            <SELECT NAME="checkDateStat">
                <OPTION VALUE=""  <%= IIf(strCheckDateStat = "",  "SELECTED", "") %>>
                <OPTION VALUE="0" <%= IIf(strCheckDateStat = "0", "SELECTED", "") %>>未勧奨
                <OPTION VALUE="1" <%= IIf(strCheckDateStat = "1", "SELECTED", "") %>>1次勧奨済み
                <OPTION VALUE="2" <%= IIf(strCheckDateStat = "2", "SELECTED", "") %>>2次勧奨済み
            </SELECT>
        </TD>
    </TR>

    <TR>
        <TD WIDTH="70">更新ユーザ</TD>
        <TD WIDTH="10">：</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <INPUT TYPE="hidden" NAME="upduser"     VALUE="<%= strUpdUser %>">
                <INPUT TYPE="hidden" NAME="updusername" VALUE="<%= strUpdUserName %>">
                <TR>
                    <TD NOWRAP><A HREF="javascript:callGuideUsr()"><IMG SRC="/webHains/images/question.gif" ALT="ユーザガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD NOWRAP><A HREF="javascript:clearUpdUser()"><IMG SRC="/webHains/images/delicon.gif" ALT="ユーザ指定削除" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD NOWRAP><SPAN ID="username"><%= strUpdUserName %></SPAN></TD>
                </TR>
            </TABLE>
        </TD>
        <TD WIDTH="10"></TD>
        <TD WIDTH="10"></TD>
        <TD align="right">
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <!--TD WIDTH="70">受診日から</TD>
                    <TD WIDTH="10">：</TD>
                    <TD WIDTH="100"><%= EditDropDownListFromArray("pastMonth", lngArrPastMonth, strArrPastMonthName, lngPastMonth, NON_SELECTED_DEL) %></TD-->
                    <TD WIDTH="100"><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %></TD>

                    <TD align="right">
                        <A HREF="javascript:submitForm('search')"><IMG SRC="../../images/b_search.gif" ALT="この条件で検索" HEIGHT="24" WIDTH="77" BORDER="0"></A>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<%
    Do
    'メッセージの編集
        If strAct <> "" Then
%>
            <BR>
            <TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
                <TR>
                    <TD>
                        「<FONT COLOR="#ff6600"><B><%= strStartYear %>年<%= strStartMonth %>月<%= strStartDay %>日<%  If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then %>～<%= strEndYear %>年<%= strEndMonth %>月<%= strEndDay %>日<% End IF%></B></FONT>」の勧奨対象者一覧を表示しています。<BR>
                                対象受診者は&nbsp;<FONT COLOR="#ff6600"><B><%= lngAllRsvCount %></B></FONT>&nbsp;名です。&nbsp;（検索結果&nbsp;：&nbsp;<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>&nbsp;件）
                    </TD>
                </TR>
            </TABLE>

            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">受診日</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">当日ＩＤ</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">個人ＩＤ</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">受診者名</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">性別</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">年齢</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="100">検査項目<BR>（判定分類）</TD>
                    <TD ALIGN="center" NOWRAP COLSPAN="2">判定</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">検査予定項目</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="120">フォロー</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="60">登録者</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="60">判定医</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="75">検査予定日</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" >1次勧奨</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" >2次勧奨</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="30">結果</TD>
                </TR>
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP>フォロー</TD>
                    <TD ALIGN="center" NOWRAP>現在判定</TD>
                </TR>
<%
        End If

        If lngAllCount > 0 Then
            strBeforeRsvNo = ""

            For i = 0 To UBound(vntRsvNo)

                strWebCslDate       = ""
                strWebDayId         = ""
                strWebPerId         = ""
                strWebPerName       = ""
                strWebGender        = ""
                strWebAge           = ""
                strWebBirth         = ""
                strWebJudClassName  = vntJudClassName(i)
                strWebJudCd         = vntJudCd(i)
                strWebRslJudCd      = vntRslJudCd(i)
                strWebEquipDiv      = vntEquipDiv(i)
                strWebEquipDivName  = ""
                strWebRsvNo         = ""
                strWebAddUser       = vntAddUser(i)
                strWebDocJud        = ""
                strWebDocGf         = ""
                strWebDocCf         = ""
                strWebSecPlanDate   = ""
                strWebReqCheckDate1 = ""
                strWebReqCheckDate2 = ""
                strWebSecTestName   = ""
                strCheckYear        = ""
                strCheckMonth       = ""
                strCheckDay         = ""

                If strBeforeRsvNo <> vntRsvNo(i) Then
                    strWebCslDate   = vntCslDate(i)
                    strWebDayId     = objCommon.FormatString(vntDayId(i), "0000")
                    strWebPerId     = vntPerId(i)
                    strWebPerName   = "<SPAN STYLE=""font-size:9px;"">" & vntPerKname(i) & "</SPAN><BR>" & vntPerName(i)
                    strWebGender    = vntGender(i)
                    strWebAge       = vntAge(i) & "歳"
                    strWebBirth     = vntBirth(i)
                    strWebRsvNo     = vntRsvNo(i)
                    strWebAddUser   = vntAddUser(i)
                    strWebDocJud    = vntDocJud(i)
                    strWebDocGf     = vntDocGf(i)
                    strWebDocCf     = vntDocCf(i)
                    
                    strWebSecPlanDate   = vntSecPlanDate(i)
                    strWebReqCheckDate1 = vntReqCheckDate1(i)
                    strWebReqCheckDate2 = vntReqCheckDate2(i)
                    strWebSecTestName   = vntSecTestName(i)

                    if strWebReqCheckDate1 <> "" Then
                        strCheckYear = Mid(strWebReqCheckDate1, 1, 4) 
                        strCheckMonth = Mid(strWebReqCheckDate1, 6, 2) 
                        strCheckDay = Mid(strWebReqCheckDate1, 9, 2) 
                    Else
                        strWebReqCheckDate1 = "未勧奨"
                    End If


                    strURL = "/webHains/contents/follow/followInfoTop.asp"
                    strURL = strURL & "?rsvno="     & vntRsvNo(i)
                    strURL = strURL & "&winmode="   & "1"

                    strURL = strURL & "&strYear="   & Year(vntCslDate(i))
                    strURL = strURL & "&strMonth="  & Month(vntCslDate(i))
                    strURL = strURL & "&strDay="    & Day(vntCslDate(i))
                    strURL = strURL & "&endYear="   & Year(vntCslDate(i))
                    strURL = strURL & "&endMonth="  & Month(vntCslDate(i))
                    strURL = strURL & "&endDay="    & Day(vntCslDate(i))
                End If
%>
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'"; onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate        %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebDayId          %></TD>
                    <TD NOWRAP><%= strWebPerId          %></TD>
                    <TD NOWRAP><A HREF="javascript:follow_openWindow('<%= strURL %>')" TARGET="_top"><%= strWebPerName %></A></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebGender         %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebAge            %></TD>

<%
                    strBeforeRsvNo = vntRsvno(i)
%>

                    <TD NOWRAP>
                        <A HREF="javascript:callMenResult(<%= vntRsvNo(i) %>,'',<%= vntCsCd(i) %>,<%= vntResultDispMode(i) %>)"><%= strWebJudClassName   %></A>
                        <INPUT TYPE="hidden"    NAME="arrRsvNo"         VALUE="<%= vntRsvNo(i) %>">
                        <INPUT TYPE="hidden"    NAME="arrJudClassCd"    VALUE="<%= vntJudClassCd(i) %>">
                        <INPUT TYPE="hidden"    NAME="arrJudCd"         VALUE="<%= vntJudCd(i) %>">
                        <INPUT TYPE="hidden"    NAME="arrRslJudCd"      VALUE="<%= vntRslJudCd(i) %>">
                        <INPUT TYPE="hidden"    NAME="arrEquipDiv">
                    </TD>

                    <TD ALIGN="center" NOWRAP  <% If vntJudCd(i) <> "" and vntJudCd(i) <> vntRslJudCd(i) Then %>BGCOLOR="#FFC0CB"<% End If %> >
                        <%= strWebJudCd          %>
                    </TD>
                    <TD ALIGN="center" NOWRAP  <% If vntJudCd(i) <> "" and vntJudCd(i) <> vntRslJudCd(i) Then %>BGCOLOR="#FFC0CB"<% End If %> >
                        <%= strWebRslJudCd       %>
                    </TD>

                    <TD NOWRAP <% If vntSecTestName(i)   = "" Then %>ALIGN="center"<% End If %>><%= strWebSecTestName     %></TD>

                    <TD NOWRAP>
                    <%
                        If vntEquipDiv(i) <> ""  Then

                            Select Case vntEquipDiv(i)
                               Case 0
                                    strWebEquipDivName = "二次検査場所未定"
                               Case 1
                                    strWebEquipDivName = "当センター"
                               Case 2
                                    '### 2016.09.13 張 本院→本院・メディローカスに変更 ###
                                    'strWebEquipDivName = "本院"
                                    strWebEquipDivName = "本院・メディローカス"
                               Case 3
                                    strWebEquipDivName = "他院"
                            End Select
                    %>
                        <%= strWebEquipDivName    %>
                    <%
                        End If
                    %>
                    </TD>
                    <TD NOWRAP <% If vntAddUser(i)  = ""  Then %>ALIGN="center"<% End If %>><%= strWebAddUser    %></TD>
                    <TD NOWRAP <% If vntDocJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocJud     %></TD>
                    <TD NOWRAP <% If vntSecPlanDate(i) = "-" Then %>ALIGN="center"<% End If %>><%= strWebSecPlanDate  %></TD>
                    
                    <TD NOWRAP ALIGN="center" WIDTH="80"> <A HREF="javascript:callChkDateEdit(<%= vntRsvNo(i) %>,<%= vntJudClassCd(i) %>,'<%= vntReqCheckDate1(i) %>',1 )">  <%= IIf(vntReqCheckDate1(i) <> "", vntReqCheckDate1(i), "未勧奨") %> </A> 
                    </TD>
                    
                    <TD NOWRAP ALIGN="center" WIDTH="80"> <A HREF="javascript:callChkDateEdit(<%= vntRsvNo(i) %>,<%= vntJudClassCd(i) %>,'<%= vntReqCheckDate2(i) %>',2 )">  <%= IIf(vntReqCheckDate2(i) <> "", vntReqCheckDate2(i), "未勧奨") %> </A> 
                    </TD>

                    <%
                        If vntEquipDiv(i) <> "" Then
                    %>
                        <TD ALIGN="center"> 
                                <A HREF="javaScript:showFollowInfo('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>') ">
                                <IMG SRC="/webHains/images/follow_result.gif" WIDTH="20" HEIGHT="20" ALT="結果入力">
                                </A>
                        </TD>
                    <%  Else    %>
                            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
                    <%  End If  %>

                </TR>
<%
                    strBeforeRsvNo = vntRsvno(i)
            Next
        End If
%>

        </TABLE>

<%
        If lngAllCount > 0 Then
            '全件検索時はページングナビゲータ不要
                If lngPageMaxLine <= 0 Then
            Else
                'URLの編集
                strURL = Request.ServerVariables("SCRIPT_NAME")
                strURL = strURL & "?mode="        & strMode
                strURL = strURL & "&action="      & "search"
                strURL = strURL & "&startYear="   & strStartYear
                strURL = strURL & "&startMonth="  & strStartMonth
                strURL = strURL & "&startDay="    & strStartDay
                strURL = strURL & "&endYear="     & strEndYear
                strURL = strURL & "&endMonth="    & strEndMonth
                strURL = strURL & "&endDay="      & strEndDay
                strURL = strURL & "&itemCd="      & strItemCd
                strURL = strURL & "&upduser="     & strUpdUser
                strURL = strURL & "&pastMonth="   & lngPastMonth
                strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
                'ページングナビゲータの編集
%>
                <%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
            End If
%>
            <BR>
<%
        End If
        Exit Do
    Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
