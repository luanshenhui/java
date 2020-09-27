<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診）入力 ヘッダー  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objRslOcr           'OCR入力結果アクセス用
'2004.11.08 ADD STR ORB)T.Yaguchi フォロー追加
Dim objFollowUp         'フォローアップアクセス用
'2004.11.08 ADD END
Dim objFollow           'フォローアップアクセス用

'パラメータ
Dim lngRsvNo            '予約番号

Dim vntEditOcrDate      'OCR内容確認修正日時
Dim Ret                 '復帰値
'2004.11.21 ADD STR ORB)T.Yaguchi フォロー追加
Dim lngFolRsvNo         'フォロー前回予約番号
Dim dtmFolCslDate       'フォロー前回受診日
Dim strFolCsCd          'フォロー前回コースコード
Dim blnFollowFlg        'フォロー存在フラグ
'2004.11.21 ADD END

'#### 2009.10.03 張 追加
Dim blnFollowBefore     '前回フォロー情報チェックフラグ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objRslOcr   = Server.CreateObject("HainsRslOcr.OcrNyuryoku")
'2004.11.21 ADD STR ORB)T.Yaguchi フォロー追加
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
'2004.11.21 ADD END
Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'引数値の取得
lngRsvNo            = Request("rsvno")

Do
    'OCR内容確認修正日時を取得する
    Ret = objRslOcr.SelectEditOcrDate( _
                                        lngRsvNo, _
                                        vntEditOcrDate _
                                        )
    If Ret = False Then
        Err.Raise 1000, , "OCR内容確認修正日時が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If

    'オブジェクトのインスタンス削除
    Set objRslOcr = Nothing

'''2004.11.08 ADD STR ORB)T.Yaguchi フォロー追加
''    'フォローアップ取得
''    blnFollowFlg = objFollowUp.SelectFollow_Before(lngRsvNo, lngFolRsvNo, dtmFolCslDate, strFolCsCd)
'''2004.11.08 ADD END

'#### 2009.10.03 張 フォローアップ関連ロジック追加 Start ####

    '前回フォロー情報登録有無チェック及びキーデータ取得
    blnFollowBefore = objFollow.SelectFollow_Before(lngRsvNo, lngFolRsvNo, dtmFolCslDate, strFolCsCd)

'#### 2009.10.03 張 フォローアップ関連ロジック追加 End   ####

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>問診入力</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winEditCsvDat;          // ウィンドウハンドル
//'2004.11.08 ADD STR ORB)T.Yaguchi フォロー追加
var winFollow;              // フォローアップ画面ウィンドウハンドル
//'2004.11.08 ADD END

// CSVファイル作成画面呼び出し
function callEditCsvDatMonshin() {
    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか


    if( !confirm('ＭＣＨ連携用ファイルを作成します。よろしいですか？') ) return;

    // すでにガイドが開かれているかチェック
    if (winEditCsvDat != null ) {
        if ( !winEditCsvDat.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/monshin/EditCsvDatMonshin.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winEditCsvDat.focus();
        winEditCsvDat.location.replace( url );
    } else {
        winEditCsvDat = window.open( url, '', 'width=400,height=400,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=no');
    }

}

// '2004.11.08 ADD STR ORB)T.Yaguchi 
//フォローアップ入力画面呼び出し
function callfollowupNyuryoku( noteDiv ) {
    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか

    // すでにガイドが開かれているかチェック
    if (winFollow != null ) {
        if ( !winFollow.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/followup/followupTop.asp';
    url = url + '?winmode=' + '1';
    url = url + '&PubNoteDivCd=500';
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strFolCsCd %>';
    url = url + '&strYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&strMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&strDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&endYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&endMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&endDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&rsvno=' + '<%= lngFolRsvNo %>';

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winFollow.focus();
        winFollow.location.replace( url );
    } else {
        winFollow = window.open( url, '', 'width=950,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }


}
// '2004.11.08 ADD END

// 2009.10.03 張 前回フォローアップ情報画面呼び出し
function callfollowupBefore( noteDiv ) {
    var url;                // URL文字列
    var opened = false;     // 画面がすでに開かれているか

    // すでにガイドが開かれているかチェック
    if (winFollow != null ) {
        if ( !winFollow.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/follow/followInfoTop.asp';
    url = url + '?winmode=' + '1';
    url = url + '&PubNoteDivCd=' + noteDiv;
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strFolCsCd %>';
    url = url + '&strYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&strMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&strDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&endYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&endMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&endDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&rsvno=' + '<%= lngFolRsvNo %>';

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winFollow.focus();
        winFollow.location.replace( url );
    } else {
        winFollow = window.open( url, '', 'width=1000,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}


function windowClose() {

    //  CSVファイル作成画面を閉じる
    if ( winEditCsvDat != null ) {
        if ( !winEditCsvDat.closed ) {
            winEditCsvDat.close();
        }
    }

    winEditCsvDat = null;

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BODY  ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="3"></TD>
            <TD WIDTH="100%">
                <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">問診入力</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
            <TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="8"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
        <TR>
            <TD WIDTH="116"></TD>
        </TR>
        <TR>
            <TD NOWRAP><A HREF="ocrNyuryoku.asp?rsvno=<%= lngRsvNo %>" TARGET="_blank"><IMG SRC="../../images/b_ocrResult.gif" HEIGHT="24" WIDTH="110" ALT="OCRから入力された内容を表示します。"></A></TD>
<%
'2004.11.08 ADD STR ORB)T.Yaguchi フォロー追加
'### 2009.10.03 張 前回フォロー情報チェックし様変更
    'If blnFollowFlg = True Then
    If blnFollowBefore = True Then
%>
            <!--TD NOWRAP><A HREF="JavaScript:callfollowupNyuryoku()"><IMG SRC="../../images/followup.gif" HEIGHT="24" WIDTH="110" ALT="フォローアップ画面を表示します"></A></TD-->
            <TD NOWRAP><A HREF="JavaScript:callfollowupBefore('500')"><IMG SRC="../../images/followup_before.gif" HEIGHT="24" WIDTH="110" ALT="前回フォローアップ情報画面を表示します"></A></TD>
<%
    End If
'2004.11.08 ADD END
%>
<%
    If vntEditOcrDate <> "" Then
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:callEditCsvDatMonshin()"><IMG SRC="../../images/mentalKick.gif" HEIGHT="24" WIDTH="110" ALT="ＭＣＨ連携用ファイル作成します。"></A></TD>
<%
    End If
%>
        </TR>
    </TABLE>
</FORM>
</BODY>
</HTML>