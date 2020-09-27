<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       web予約の検索 (Ver1.0.0)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'管理番号：SL-UI-Y0101-107
'修正日  ：2010.06.15（修正）
'担当者  ：TCS)小松
'修正内容：web予約よりキャンセルの取込も可能とする。
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"   -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GETCOUNT_DEFAULT_VALUE = 20    '表示件数のデフォルト値

'データベースアクセス用オブジェクト
Dim objCommon        '共通クラス
Dim objWebRsv        'web予約情報アクセス用

'引数値
Dim lngStrCslYear       '開始受診年
Dim lngStrCslMonth      '開始受診月
Dim lngStrCslDay        '開始受診日
Dim lngEndCslYear       '終了受診年
Dim lngEndCslMonth      '終了受診月
Dim lngEndCslDay        '終了受診日
Dim strKey              '検索キー
Dim lngStrOpYear        '開始処理年
Dim lngStrOpMonth       '開始処理月
Dim lngStrOpDay         '開始処理日
Dim lngEndOpYear        '終了処理年
Dim lngEndOpMonth       '終了処理月
Dim lngEndOpDay         '終了処理日
Dim lngOpMode           '処理モード(1:申込日で検索、2:予約処理日で検索)
Dim lngRegFlg           '本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)
Dim lngOrder            '出力順(1:受診日順、2:個人ID順)
'#### 2010.06.15 SL-UI-Y0101-107 ADD START ####'
Dim lngMosFlg           '申込区分(0:指定なし、1:新規、2:キャンセル)
'#### 2010.06.15 SL-UI-Y0101-107 ADD END ####'
Dim lngStartPos         '表示開始位置
Dim lngGetCount         '表示件数
Dim blnSearch           '検索ボタン押下の有無

Dim strCslDate          '受診年月日
Dim strWebNo            'webNo.
Dim strStartTime        '受付開始時間
Dim strRsvGrpName       '予約群名称
Dim strPerId            '個人ID
Dim strFullName         '姓名
Dim strKanaName         'カナ姓名
Dim strLastName         '(個人情報の)姓
Dim strFirstName        '(個人情報の)名
Dim strLastKName        '(個人情報の)カナ姓
Dim strFirstKName       '(個人情報の)カナ名
Dim strGender           '性別
Dim strBirth            '生年月日
Dim strOrgName          '団体名
Dim strInsDate          '申し込み年月日
'#### 2010.06.15 SL-UI-Y0101-107 ADD START ####'
Dim strCanDate          '申込取消日
'#### 2010.06.15 SL-UI-Y0101-107 ADD END ####'
Dim strUpdDate          '予約処理年月日
Dim strRegFlg           '本登録フラグ(1:未登録者、2:編集済み受診者)
Dim strRsvNo            '予約番号
Dim lngCount            'レコード件数

Dim dtmStrCslDate       '開始受診年月日
Dim dtmEndCslDate       '終了受診年月日
Dim dtmStrOpDate        '開始処理年月日
Dim dtmEndOpDate        '終了処理年月日

Dim strArrMessage       'エラーメッセージの配列
Dim dtmDate             '日付
Dim strName             '氏名
Dim strURL              'ジャンプ先のURL
Dim blnExists           '一覧の有無
Dim i                   'インデックス

''### 2010.09.03 ADD STR TCS)H.F    ※キャンセル実施済みを分かるようにする
Dim strCancelFlg    '予約のキャンセルフラグ
Dim objConsult
Dim strEditDisp         '編集状態の表示
''### 2010.09.03 ADD END TCS)H.F


'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lngStrCslYear  = CLng("0" & Request("strCslYear"))
lngStrCslMonth = CLng("0" & Request("strCslMonth"))
lngStrCslDay   = CLng("0" & Request("strCslDay"))
strKey         = Request("key")
lngEndCslYear  = CLng("0" & Request("endCslYear"))
lngEndCslMonth = CLng("0" & Request("endCslMonth"))
lngEndCslDay   = CLng("0" & Request("endCslDay"))
lngStrOpYear   = CLng("0" & Request("strOpYear"))
lngStrOpMonth  = CLng("0" & Request("strOpMonth"))
lngStrOpDay    = CLng("0" & Request("strOpDay"))
lngEndOpYear   = CLng("0" & Request("endOpYear"))
lngEndOpMonth  = CLng("0" & Request("endOpMonth"))
lngEndOpDay    = CLng("0" & Request("endOpDay"))
lngOpMode      = CLng("0" & Request("opMode"))
lngRegFlg      = CLng("0" & Request("regFlg"))
lngOrder       = CLng("0" & Request("order"))
lngStartPos    = CLng("0" & Request("startPos"))
lngGetCount    = CLng("0" & Request("getCount"))
blnSearch      = Not IsEmpty(Request("act"))
'#### 2010.08.07 SL-UI-Y0101-107 ADD START ####'
'申込区分の入力がなければ1:新規をデフォルトに
lngMosFlg      = IIf(Request("mousi") = "", 1, CLng("0" & Request("mousi")))
'#### 2010.08.07 SL-UI-Y0101-107 ADD END ####'

'受診開始、終了日のデフォルト値設定
dtmDate = Date()
lngStrCslYear  = IIf(lngStrCslYear  = 0, Year(Date),  lngStrCslYear)
lngStrCslMonth = IIf(lngStrCslMonth = 0, Month(Date), lngStrCslMonth)
lngStrCslDay   = IIf(lngStrCslDay   = 0, Day(Date),   lngStrCslDay)
lngEndCslYear  = IIf(lngEndCslYear  = 0, Year(Date),  lngEndCslYear)
lngEndCslMonth = IIf(lngEndCslMonth = 0, Month(Date), lngEndCslMonth)
lngEndCslDay   = IIf(lngEndCslDay   = 0, Day(Date),   lngEndCslDay)

'表示開始位置、表示件数のデフォルト値設定
lngStartPos = IIf(lngStartPos = 0, 1, lngStartPos)
lngGetCount = IIf(blnSearch = False And lngGetCount = 0, GETCOUNT_DEFAULT_VALUE, lngGetCount)

'チェック・更新・読み込み処理の制御
Do

    '検索ボタン押下時以外は何もしない
    If Not blnSearch Then
        Exit Do
    End If

    '入力チェック
    strArrMessage = CheckValue()
    If Not IsEmpty(strArrMessage) Then
        Exit Do
    End If

    '各種年月日の編集
    dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
    dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)
    If lngStrOpYear + lngStrOpMonth + lngStrOpDay > 0 Then
        dtmStrOpDate = CDate(lngStrOpYear & "/" & lngStrOpMonth & "/" & lngStrOpDay)
    End If
    If lngEndOpYear + lngEndOpMonth + lngEndOpDay > 0 Then
        dtmEndOpDate = CDate(lngEndOpYear & "/" & lngEndOpMonth & "/" & lngEndOpDay)
    End If

    Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")

    'web予約の検索
'#### 2010.08.07 SL-UI-Y0101-107 MOD START #### 
'lngMosFlg 追加
''#### 2010.06.17 SL-UI-Y0101-107 MOD START ####'
''    lngCount = objWebRsv.SelectWebRsvList( _
''        dtmStrCslDate, _
''        dtmEndCslDate, _
''        strKey,        _
''        dtmStrOpDate,  _
''        dtmEndOpDate,  _
''        lngOpMode,     _
''        lngRegFlg,     _
''        lngOrder,      _
''        lngStartPos,   _
''        lngGetCount,   _
''        strCslDate,    _
''        strWebNo,      _
''        strStartTime,  _
''        strRsvGrpName, _
''        strPerId,      _
''        strFullName,   _
''        strKanaName,   _
''        strLastName,   _
''        strFirstName,  _
''        strLastKName,  _
''        strFirstKName, _
''        strGender,     _
''        strBirth,      _
''        strOrgName,    _
''        strInsDate,    _
''        strUpdDate,    _
''        strRegFlg,     _
''        strRsvNo       _
''    )
'    lngCount = objWebRsv.SelectWebRsvList( _
'        dtmStrCslDate, _
'        dtmEndCslDate, _
'        strKey,        _
'        dtmStrOpDate,  _
'        dtmEndOpDate,  _
'        lngOpMode,     _
'        lngRegFlg,     _
'        lngOrder,      _
'        lngStartPos,   _
'        lngGetCount,   _
'        strCslDate,    _
'        strWebNo,      _
'        strStartTime,  _
'        strRsvGrpName, _
'        strPerId,      _
'        strFullName,   _
'        strKanaName,   _
'        strLastName,   _
'        strFirstName,  _
'        strLastKName,  _
'        strFirstKName, _
'        strGender,     _
'        strBirth,      _
'        strOrgName,    _
'        strInsDate,    _
'        strCanDate,    _
'        strUpdDate,    _
'        strRegFlg,     _
'        strRsvNo       _
'    )
''#### 2010.06.15 SL-UI-Y0101-107 MOD END ####'
    lngCount = objWebRsv.SelectWebRsvList( _
        dtmStrCslDate, _
        dtmEndCslDate, _
        strKey,        _
        dtmStrOpDate,  _
        dtmEndOpDate,  _
        lngOpMode,     _
        lngRegFlg,     _
        lngMosFlg,     _
        lngOrder,      _
        lngStartPos,   _
        lngGetCount,   _
        strCslDate,    _
        strWebNo,      _
        strStartTime,  _
        strRsvGrpName, _
        strPerId,      _
        strFullName,   _
        strKanaName,   _
        strLastName,   _
        strFirstName,  _
        strLastKName,  _
        strFirstKName, _
        strGender,     _
        strBirth,      _
        strOrgName,    _
        strInsDate,    _
        strCanDate,    _
        strUpdDate,    _
        strRegFlg,     _
        strRsvNo       _
    )
'#### 2010.08.07 SL-UI-Y0101-107 MOD END ####'

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 入力チェック
'
' 引数　　 :
'
' 戻り値　 : エラーメッセージの配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon    '共通クラス
    Dim strDate        '日付
    Dim strMessage    'エラーメッセージ

    'オブジェクトのインスタンス作成
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '開始受診日のチェック
    strDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
    If Not IsDate(strDate) Then
        objCommon.appendArray strMessage, "開始受診日の入力形式が正しくありません。"
    End If

    '終了受診日のチェック
    strDate = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay
    If Not IsDate(strDate) Then
        objCommon.appendArray strMessage, "終了受診日の入力形式が正しくありません。"
    End If

    '開始処理日のチェック
    If lngStrOpYear + lngStrOpMonth + lngStrOpDay > 0 Then
        strDate = lngStrOpYear & "/" & lngStrOpMonth & "/" & lngStrOpDay
        If Not IsDate(strDate) Then
            objCommon.appendArray strMessage, "開始処理日の入力形式が正しくありません。"
        End If
    End If

    '終了処理日のチェック
    If lngEndOpYear + lngEndOpMonth + lngEndOpDay > 0 Then
        strDate = lngEndOpYear & "/" & lngEndOpMonth & "/" & lngEndOpDay
        If Not IsDate(strDate) Then
            objCommon.appendArray strMessage, "終了処理日の入力形式が正しくありません。"
        End If
    End If

    'エラーメッセージが存在する場合はその内容を返す
    If Not IsEmpty(strMessage) Then
        CheckValue = strMessage
    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>web予約検索</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsvtab { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winWebRsv;            // web予約情報登録画面

var strCslDate = '';    // 開始受診年月日
var endCslDate = '';    // 終了受診年月日
var strOpDate  = '';    // 開始処理年月日
var endOpDate  = '';    // 終了処理年月日

// web予約情報登録画面呼び出し
function callWebRsvWindow( cslDate, webNo ) {

    var opened = false;    // 画面が開かれているか

    // すでにガイドが開かれているかチェック
    if ( winWebRsv != null ) {
        if ( !winWebRsv.closed ) {
            opened = true;
        }
    }

    // web予約情報登録画面のURL編集
    var url = 'webRsvMain.asp';
    url = url + '?cslDate='    + cslDate;
    url = url + '&webNo='      + webNo;
    url = url + '&strCslDate=' + strCslDate;
    url = url + '&endCslDate=' + endCslDate;
    url = url + '&key='        + '<%= strKey %>';
    url = url + '&strOpDate='  + strOpDate;
    url = url + '&endOpDate='  + endOpDate;
    url = url + '&opMode='     + '<%= lngOpMode %>';
    url = url + '&regFlg='     + '<%= lngRegFlg %>';
    url = url + '&order='      + '<%= lngOrder  %>';
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
    url = url + '&mousi='      + '<%= lngMosFlg  %>';
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winWebRsv.focus();
        winWebRsv.location.replace( url );
    } else {
/* ### 2016.06.24 張 一部隠れて見えない情報があるためサイズ変更 STR ### */
//        winWebRsv = open( url, '', 'width=1000,height=680,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no' );
        winWebRsv = open( url, '', 'width=1000,height=800,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no' );
/* ### 2016.06.24 張 一部隠れて見えない情報があるためサイズ変更 END ### */
//        winWebRsv = open( url );
    }

}

// 画面を閉じる
function closeWindow() {

    // 日付ガイドを閉じる
    calGuide_closeGuideCalendar();

    // web予約情報登録画面を閉じる
    if ( winWebRsv != null ) {
        if ( !winWebRsv.closed ) {
            winWebRsv.close();
        }
    }

    winWebRsv = null;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="act" VALUE="1">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="700">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">web予約の検索</FONT></B></TD>
    </TR>
</TABLE>
<%
    'エラーメッセージの編集
    EditMessage strArrMessage, MESSAGETYPE_WARNING
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
    <TR>
        <TD NOWRAP>受診日</TD>
        <TD>：</TD>
        <TD COLSPAN="3">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                    <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCslYear, False) %></TD>
                    <TD>年</TD>
                    <TD><%= EditNumberList("strCslMonth", 1, 12, lngStrCslMonth, False) %></TD>
                    <TD>月</TD>
                    <TD><%= EditNumberList("strCslDay", 1, 31, lngStrCslDay, False) %></TD>
                    <TD>日</TD>
                    <TD>～</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                    <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCslYear, False) %></TD>
                    <TD>年</TD>
                    <TD><%= EditNumberList("endCslMonth", 1, 12, lngEndCslMonth, False) %></TD>
                    <TD>月</TD>
                    <TD><%= EditNumberList("endCslDay", 1, 31, lngEndCslDay, False) %></TD>
                    <TD>日</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD NOWRAP>検索キー</TD>
        <TD>：</TD>
        <TD COLSPAN="3"><INPUT TYPE="text" NAME="key" SIZE="45" VALUE="<%= strKey %>"></TD>
    </TR>
    <TR>
        <TD NOWRAP>処理日</TD>
        <TD>：</TD>
        <TD COLSPAN="3">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('strOpYear', 'strOpMonth', 'strOpDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('strOpYear', 'strOpMonth', 'strOpDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                    <TD><%= EditNumberList("strOpYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrOpYear, True) %></TD>
                    <TD>年</TD>
                    <TD><%= EditNumberList("strOpMonth", 1, 12, lngStrOpMonth, True) %></TD>
                    <TD>月</TD>
                    <TD><%= EditNumberList("strOpDay", 1, 31, lngStrOpDay, True) %></TD>
                    <TD>日</TD>
                    <TD>～</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endOpYear', 'endOpMonth', 'endOpDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('endOpYear', 'endOpMonth', 'endOpDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                    <TD><%= EditNumberList("endOpYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndOpYear, True) %></TD>
                    <TD>年</TD>
                    <TD><%= EditNumberList("endOpMonth", 1, 12, lngEndOpMonth, True) %></TD>
                    <TD>月</TD>
                    <TD><%= EditNumberList("endOpDay", 1, 31, lngEndOpDay, True) %></TD>
                    <TD>日</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD COLSPAN="2"></TD>
        <TD COLSPAN="3">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                <TR>
                    <TD><INPUT TYPE="radio" NAME="opMode" VALUE="1"<%= IIf(lngOpMode <> 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>申込日で検索</TD>
                    <TD><INPUT TYPE="radio" NAME="opMode" VALUE="2"<%= IIf(lngOpMode  = 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>予約処理日で検索</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD NOWRAP>状態</TD>
        <TD>：</TD>
        <TD COLSPAN="2">
            <SELECT NAME="regFlg">
                <OPTION VALUE="0"<%= IIf(lngRegFlg <> 0 And lngRegFlg <> 1, " SELECTED", "") %>>指定なし
                <OPTION VALUE="1"<%= IIf(lngRegFlg = 1, " SELECTED", "") %>>未登録者
                <OPTION VALUE="2"<%= IIf(lngRegFlg = 2, " SELECTED", "") %>>編集済み受診者
            </SELECT>
        </TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD START ####' -->
<!--
        <TD ROWSPAN="2" VALIGN="bottom"><INPUT TYPE="image" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="指定条件で検索"></TD>
-->
    </TR>
    <TR>
        <TD NOWRAP>申込区分</TD>
        <TD>：</TD>
        <TD WIDTH="460">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                <TR>
<!--　#### 2010.08.07 SL-UI-Y0101-107 MOD START ####'
                    <# lngMosFlg = 1 #>     デフォルトを｢新規｣にする。-->
<!--
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="1"<#= IIf(lngMosFlg = 0, " CHECKED", "") #>></TD>
                    <TD NOWRAP>すべて</TD>
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="2"<#= IIf(lngMosFlg = 1, " CHECKED", "") #>></TD>
                    <TD NOWRAP>新規</TD>
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="3"<#= IIf(lngMosFlg = 2, " CHECKED", "") #>></TD>
                    <TD NOWRAP>キャンセル</TD>
-->
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="0" <%= IIf(lngMosFlg = 0, " CHECKED", "") %>></TD>
                    <TD NOWRAP>すべて</TD>
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="1" <%= IIf(lngMosFlg = 1, " CHECKED", "") %>></TD>
                    <TD NOWRAP>新規</TD>
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="2" <%= IIf(lngMosFlg = 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>キャンセル</TD>
<!--　#### 2010.08.07 SL-UI-Y0101-107 MOD END ####' -->
                </TR>
            </TABLE>
        </TD>
        <TD ROWSPAN="2" VALIGN="bottom"><INPUT TYPE="image" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="指定条件で検索"></TD>
<!--'#### 2010.06.15 SL-UI-Y0101-107 MOD END ####'-->
    </TR>
    <TR>
        <TD NOWRAP>出力順</TD>
        <TD>：</TD>
        <TD WIDTH="460">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                <TR>
                    <TD><INPUT TYPE="radio" NAME="order" VALUE="1"<%= IIf(lngOrder <> 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>受診日順</TD>
                    <TD><INPUT TYPE="radio" NAME="order" VALUE="2"<%= IIf(lngOrder  = 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>個人ＩＤ順</TD>
                </TR>
            </TABLE>
        </TD>
        <TD>
            <SELECT NAME="getCount">
                <OPTION VALUE="20"<%= IIf(lngGetCount <> 0 And lngGetCount <> 50, " SELECTED", "") %>>20件ずつ
                <OPTION VALUE="50"<%= IIf(lngGetCount = 50, " SELECTED", "") %>>50件ずつ
                <OPTION VALUE="0"<%= IIf(lngGetCount = 0, " SELECTED", "") %>>すべて
            </SELECT>
        </TD>
    </TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<%
Do

    '検索ボタン押下時以外は何もしない
    If Not blnSearch Then
        Exit Do
    End If

    'エラー時は何もしない
    If Not IsEmpty(strArrMessage) Then
        Exit Do
    End If

    'レコードが存在しない場合
    If lngCount <= 0 Then
%>
        <BLOCKQUOTE>検索条件を満たす受診情報は存在しません。</BLOCKQUOTE>
<%
        Exit Do
    End If

    Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
    <BLOCKQUOTE>
    「<FONT COLOR="#ff6600"><B><%= objCommon.FormatString(dtmStrCslDate, "yyyy年m月d日") %>～<%= objCommon.FormatString(dtmEndCslDate, "yyyy年m月d日") %></B></FONT>」のweb予約者一覧を表示しています。<BR>
    <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件の予約情報があります。<BR><BR>
    <FONT COLOR="#cc9999">●</FONT>氏名を選択すると、該当するweb予約情報の登録画面が表示されます。<BR>
    <FONT COLOR="#cc9999">●</FONT>すでに編集済みの予約情報については、「受診情報へ」を選択すると受診情報詳細画面が表示されます。<BR><BR>

    <TABLE ID="webRsv" BORDER="0" CELLPADDING="2" CELLSPACING="2">
        <TR BGCOLOR="#cccccc">
            <TD NOWRAP>受診希望日</TD>
            <TD NOWRAP>受診希望時間</TD>
            <TD NOWRAP>個人ＩＤ</TD>
            <TD NOWRAP>氏名</TD>
            <TD NOWRAP>性別</TD>
            <TD NOWRAP>生年月日</TD>
            <TD NOWRAP>契約団体名</TD>
            <TD NOWRAP>申込日</TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD START ####' -->
            <TD NOWRAP>申込取消日</TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD END ####' -->
            <TD NOWRAP>処理日</TD>
            <TD NOWRAP>状態</TD>
            <TD NOWRAP>処理</TD>
        </TR>
<%
        'web予約一覧情報が存在する場合
        If IsArray(strCslDate) Then

            '一覧の有無のフラグが成立
            blnExists = True

            '一覧の編集
            For i = 0 To UBound(strCslDate)
%>
                <TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">
                    <TD NOWRAP><%= strCslDate(i) %></TD>
                    <TD NOWRAP><%= strRsvGrpName(i) %></TD>
                    <TD NOWRAP><%= strPerId(i) %></TD>
<%
                    '氏名については、個人ID存在時は個人情報から、さもなくばweb予約情報から取得
                    strName = ""

                    If strPerId(i) <> "" Then
                        strName = Trim(strLastName(i) & "　" & strFirstName(i))
                    End If

                    If strName = "" Then
                        strName = strFullName(i)
                    End If
%>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD START ####' -->
<!--                <TD NOWRAP><A HREF="javascript:callWebRsvWindow('<%= strCslDate(i) %>','<%= strWebNo(i) %>')"><%= strName %></A></TD>
-->
<!-- '#### 2010.11.12 SL-UI-Y0101-107 MOD START ####' -->

<!--
<%
                    If strCanDate(i) <> "" Then
%>
                        <TD NOWRAP><%= strName %></A></TD>
<%
                    Else
%>
                        <TD NOWRAP><A HREF="javascript:callWebRsvWindow('<%= strCslDate(i) %>','<%= strWebNo(i) %>')"><%= strName %></A></TD>
<%
                    End If
%>
-->
                    <TD NOWRAP><A HREF="javascript:callWebRsvWindow('<%= strCslDate(i) %>','<%= strWebNo(i) %>')"><%= strName %></A></TD>
<!-- '#### 2010.11.12 SL-UI-Y0101-107 MOD END ####' -->
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD END ####' -->

<!-- '#### 2010.09.03 SL-UI-Y0101-107 ADD START ####' -->
<%
                    strEditDisp = ""
                    strCancelFlg = Empty
                    If strCanDate(i) <> "" And strRsvNo(i)<> "" Then
                        
                        'オブジェクトのインスタンス作成
                        Set objConsult = Server.CreateObject("HainsConsult.Consult")
                        '受診情報読み込み
                         objConsult.SelectConsult CLng(strRsvNo(i)), strCancelFlg 

                    End If

                    If strRegFlg(i) = "1" Then
                        strEditDisp = "未編集"
                    Else

'#### 2010.11.12 SL-UI-Y0101-107 MOD START ####' 
'                        If strCancelFlg = "0" Or strCancelFlg = "" Then
'                            strEditDisp = "編集済み"
'                        Else
'                            strEditDisp = "取消済み"
'                        End If
                        If strCanDate(i) <> "" Then
                            If strCancelFlg = "0" Or strCancelFlg = "" Then
                                If strRsvNo(i) <> "" Then
                                    strEditDisp = "編集済み"
                                Else
                                    strEditDisp = "削除済み"
                                End If
                            Else
                                strEditDisp = "取消済み"
                            End If
                        Else
                            'If strCancelFlg = "0" Or strCancelFlg = "" Then
                                strEditDisp = "編集済み"
                            'Else
                            '    strEditDisp = "取消済み"
                            'End If
                        End If
'#### 2010.11.12 SL-UI-Y0101-107 MOD END ####'
                    End If

%>
<!-- '#### 2010.09.03 SL-UI-Y0101-107 ADD END ####' -->


                    <TD ALIGN="center"><%= IIf(CLng(strGender(i)) = GENDER_MALE, "男性", "女性") %></TD>
                    <TD NOWRAP><%= objCommon.FormatString(CDate(strBirth(i)), "gee.mm.dd") %></TD>
                    <TD NOWRAP><%= strOrgName(i) %></TD>
                    <TD NOWRAP><%= strInsDate(i) %></TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 ADD START ####' -->
                    <TD ALIGN="center" NOWRAP><%= strCanDate(i) %></TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 ADD END ####' -->
                    <TD NOWRAP><%= strUpdDate(i) %></TD>

<!-- '#### 2010.09.03 SL-UI-Y0101-107 MOD START ####' -->
<!--
                    <TD NOWRAP><%= IIf(strRegFlg(i) = "1", "未編集", "編集済み") %></TD>
-->
                    <TD NOWRAP><%= strEditDisp %></TD>
<!-- '#### 2010.09.03 SL-UI-Y0101-107 MOD END ####' -->
<%
                    If strRsvNo(i) <> "" Then

                        '受診情報詳細画面のURL編集
                        strURL = "/webHains/contents/reserve/rsvMain.asp"
                        strURL = strURL & "?rsvNo=" & strRsvNo(i)
%>
                        <TD NOWRAP><A HREF="<%= strURL %>" TARGET="_blank">受診情報へ</A></TD>
<%
                    Else
%>
                        <TD></TD>
<%
                    End If
%>
                </TR>
<%
            Next

        End If
%>
    </TABLE>
<%

    Set objCommon = Nothing

    '全件検索時以外は
       If lngGetCount > 0 Then

        'URLの編集
        strURL = Request.ServerVariables("SCRIPT_NAME")
        strURL = strURL & "?strCslYear="  & lngStrCslYear
        strURL = strURL & "&strCslMonth=" & lngStrCslMonth
        strURL = strURL & "&strCslDay="   & lngStrCslDay
        strURL = strURL & "&endCslYear="  & lngEndCslYear
        strURL = strURL & "&endCslMonth=" & lngEndCslMonth
        strURL = strURL & "&endCslDay="   & lngEndCslDay
        strURL = strURL & "&key="         & strKey
        strURL = strURL & "&strOpYear="   & lngStrOpYear
        strURL = strURL & "&strOpMonth="  & lngStrOpMonth
        strURL = strURL & "&strOpDay="    & lngStrOpDay
        strURL = strURL & "&endOpYear="   & lngEndOpYear
        strURL = strURL & "&endOpMonth="  & lngEndOpMonth
        strURL = strURL & "&endOpDay="    & lngEndOpDay
        strURL = strURL & "&opMode="      & lngOpMode
        strURL = strURL & "&regFlg="      & lngRegFlg
        strURL = strURL & "&order="       & lngOrder
        strURL = strURL & "&act="         & "1"
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
        strURL = strURL & "&mousi="     & lngMosFlg
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

        'ページングナビゲータの編集
%>
        <%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
    End If
%>
    </BLOCKQUOTE>
<%
    Exit Do
Loop
%>
<%
'一覧が存在する場合、検索条件をJavaScriptの変数として保持する(web予約情報登録画面を開く際の引数として使用)
If blnExists Then
%>
<SCRIPT TYPE="text/javascript">
<!--
strCslDate = '<%= dtmStrCslDate %>';
endCslDate = '<%= dtmEndCslDate %>';
strOpDate  = '<%= dtmStrOpDate  %>';
endOpDate  = '<%= dtmEndOpDate  %>';
//-->
</SCRIPT>
<%
End If
%>
</BODY>
</HTML>
