<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      OCR入力結果確認（ヘッダー）  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
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
'### 2016.01.28 張 個人情報追加の為、修正 STR ##############################################
Const OPT_DSP = 8                           'オプション検査表示の折り返し個数
Const BASEINFO_GRPCD = "X039"               '身体情報　検査項目グループコード
Const IMGFILE_PATH = "../../images/"        'イメージファイルのPATH名
Const IMGFILE_SPECIAL = "physical10.gif"    '特定保健指導
'### 2016.01.28 張 個人情報追加の為、修正 END ##############################################

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objConsult          '受診クラス
Dim objRslOcr           'OCR入力結果アクセス用

'### 2016.01.27 張 個人情報追加の為、修正 STR ##############################################
Dim objPerResult            '個人検査結果情報アクセス用
Dim objFree                 '汎用情報アクセス用
Dim objSpecialInterview     '特定健診情報アクセス用
Dim objInterview            '面接クラス
'### 2016.01.27 張 個人情報追加の為、修正 END ##############################################

'パラメータ
Dim	strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号（今回分）
Dim strGrpNo            'グループNo
Dim strCsCd             'コースコード

Dim strUrlPara          'フレームへのパラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objRslOcr       = Server.CreateObject("HainsRslOcr.OcrNyuryoku")

'### 2016.01.28 張 個人情報追加の為、修正 STR ##############################################
Set objInterview        = Server.CreateObject("HainsInterview.Interview")
Set objPerResult        = Server.CreateObject("HainsPerResult.PerResult")
Set objSpecialInterview = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'### 2016.01.28 張 個人情報追加の為、修正 END ##############################################

'引数値の取得
lngRsvNo            = Request("rsvno")

'受診情報用変数
Dim strPerId            '個人ID

'### 2016.01.28 張 個人情報追加の為、修正 STR ##############################################
'Dim lngAge              '年齢
'Dim lngGender           '性別

Dim strCslDate              '受診日
Dim strCsName               'コース名
Dim strLastName             '姓
Dim strFirstName            '名
Dim strLastKName            'カナ姓
Dim strFirstKName           'カナ名
Dim strBirth                '生年月日
Dim strAge                  '年齢
Dim strGender               '性別
Dim strGenderName           '性別名称
Dim strDayId                '当日ID
Dim strOrgName              '団体名称

'オプション検査情報
Dim strOptCd                'オプションコード
Dim strOptBranchNo          'オプション枝番
Dim strOptName              'オプション名称

'個人検査項目情報用変数
Dim vntItemCd               '検査項目コード
Dim vntSuffix               'サフィックス
Dim vntItemName             '検査項目名
Dim vntResult               '検査結果
Dim vntResultType           '結果タイプ
Dim vntItemType             '項目タイプ
Dim vntStcItemCd            '文章参照用項目コード
Dim vntStcCd                '文章コード
Dim vntShortStc             '文章略称
Dim vntIspDate              '検査日
Dim vntImageFileName        'イメージファイル名
Dim lngPerRslCount          '個人検査項目情報数

Dim strEraBirth             '生年月日(和暦)
Dim strRealAge              '実年齢

Dim lngOptCount             'オプション情報数
Dim lngConsCount            '受診回数
Dim lngHealthCount          '身体情報数
Dim lngSpCheck              '特定保健指導対象かチェック

Dim lngCnt

'### 2016.01.28 張 個人情報追加の為、修正 END ##############################################


Dim vntEditOcrDate      'OCR内容確認修正日時

'### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加
Dim vntGFCheckList      '内視鏡チェックリストの状態
'### 2004/01/23 End

Dim Ret                 '復帰値
Dim i, j                'カウンター

'フレームへのパラメータ設定
strUrlPara = "?rsvno=" & lngRsvNo

Do
    '受診情報検索（予約番号より個人情報取得）

'### 2016.01.28 張 個人情報追加の為、修正 STR ##############################################
'    Ret = objConsult.SelectConsult(lngRsvNo, _
'                                    , , _
'                                    strPerId, _
'                                    , , , , , , , _
'                                    lngAge, _
'                                    , , , , , , , , , , , , , , , _
'                                    0, , , , , , , , , , , , , , , _
'                                    , , , , , _
'                                    lngGender _
'                                    )

    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , _
                                    strCslDate, _
                                    strPerId, _
                                    strCsCd, _
                                    strCsName, _
                                    , , _
                                    strOrgName, _
                                    , , _
                                    strAge, _
                                    , , , , , , , , , , , , _
                                    strDayId, _
                                    , , 0, , , , , , , , , , , , , , , _
                                    strLastName, _
                                    strFirstName, _
                                    strLastKName, _
                                    strFirstKName, _
                                    strBirth, _
                                    strGender, _
                                    , , , , , , lngConsCount )
'### 2016.01.28 張 個人情報追加の為、修正 END ##############################################

    '受診情報が存在しない場合はエラーとする
    If Ret = False Then
        Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
    End If

'### 2016.01.28 張 個人情報追加の為、修正 STR ##############################################

    '生年月日(西暦＋和暦)の編集
    strEraBirth = objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d")

    '実年齢の計算
    If strBirth <> "" Then
        Set objFree = Server.CreateObject("HainsFree.Free")
        strRealAge = objFree.CalcAge(strBirth)
        Set objFree = Nothing
    Else
        strRealAge = ""
    End If

    '小数点以下の切り捨て
    If IsNumeric(strRealAge) Then
        strRealAge = CStr(Int(strRealAge))
    End If

    'オプション検査名称読み込み
    lngOptCount = objInterview.SelectInteviewOptItem( lngRsvNo, strOptName )

    '特定保険指導対象者チェック
    lngSpCheck = objSpecialInterview.CheckSpecialTarget(lngRsvNo)


    '個人検査結果情報取得
    lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerID, _
                                                        BASEINFO_GRPCD, _
                                                        2, 0, _
                                                        vntItemCd, _
                                                        vntSuffix, _
                                                        vntItemName, _
                                                        vntResult, _
                                                        vntResultType, _
                                                        vntItemType, _
                                                        vntStcItemCd, _
                                                        vntShortStc, _
                                                        vntIspDate, _
                                                        vntImageFileName _
                                                        )
    If lngPerRslCount < 0 Then
        Err.Raise 1000, , "個人検査結果情報が存在しません。（個人ID= " & strPerID & " )"
    End If

'### 2016.01.28 張 個人情報追加の為、修正 END ##############################################


    'OCR内容確認修正日時を取得する
    Ret = objRslOcr.SelectEditOcrDate( _
                                        lngRsvNo, _
                                        vntEditOcrDate _
                                        )
    If Ret = False Then
        Err.Raise 1000, , "OCR内容確認修正日時が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If

'### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加
    '内視鏡チェックリストの状態取得
    Ret = objRslOcr.CheckGF( _
                            lngRsvNo, _
                            vntGFCheckList _
                            )
    If Ret < 0 Then
        Err.Raise 1000, , "内視鏡チェックリストの状態が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If
'### 2004/01/23 End

    'オブジェクトのインスタンス削除
    Set objConsult = Nothing
    Set objRslOcr = Nothing

'### 2016.01.28 張 個人情報追加の為、修正 STR ##############################################
    Set objInterview = Nothing
    Set objSpecialInterview = Nothing
    Set objPerResult = Nothing
'### 2016.01.28 張 個人情報追加の為、修正 END ##############################################

    Exit Do
Loop

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>OCR入力結果確認</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// ジャンプ
function jumpOcrNyuryoku( index ) {
    var strAnchor

    switch ( index ) {
        case 1:
            strAnchor = "Anchor-DiseaseHistory";
            break;
        case 2:
            strAnchor = "Anchor-LifeHabit1";
            break;
        case 3:
            strAnchor = "Anchor-LifeHabit2";
            break;
        case 4:
            strAnchor = "Anchor-Fujinka";
            break;
        case 5:
            strAnchor = "Anchor-Syokusyukan";
            break;
        case 6:
            strAnchor = "Anchor-Morning";
            break;
        case 7:
            strAnchor = "Anchor-Lunch";
            break;
        case 8:
            strAnchor = "Anchor-Dinner";
            break;
        default:
            return;
    }

    parent.list.document.entryForm.anchor.value = strAnchor;
    parent.list.JumpAnchor();

    return;
}

var winMonshinChangeOption; // ウィンドウハンドル
var winNaishikyou;          // ウィンドウハンドル

//受診検査項目変更画面呼び出し
function callMonshinChangeOption() {
    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか

    var i;

    // すでにガイドが開かれているかチェック
    if ( winMonshinChangeOption != null ) {
        if ( !winMonshinChangeOption.closed ) {
            opened = true;
        }
    }

//  url = '/WebHains/contents/interview/MonshinChangeOption.html';
    url = 'changeOption.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winMonshinChangeOption.focus();
        winMonshinChangeOption.location.replace( url );
    } else {
//      winMonshinChangeOption = window.open( url, '', 'width=650,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        /** 2016.02.01 張 検査セット変更画面サイズ変更 **/
        //winMonshinChangeOption = window.open( url, '', 'width=800,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        winMonshinChangeOption = window.open( url, '', 'width=800,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}

//内視鏡チェックリスト入力画面呼び出し
function callNaishikyou() {
    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか

    var i;

    // すでにガイドが開かれているかチェック
    if ( winNaishikyou != null ) {
        if ( !winNaishikyou.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/interview/NaishikyouCheck.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winNaishikyou.focus();
        winNaishikyou.location.replace( url );
    } else {
        /** 2006/09/25 張 内視鏡チェックリスト画面の項目追加による画面サイズ拡大 Start **/
        //winNaishikyou = window.open( url, '', 'width=650,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        winNaishikyou = window.open( url, '', 'width=650,height=650,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        /** 2006/09/25 張 内視鏡チェックリスト画面の項目追加による画面サイズ拡大 End   **/
    }

}

// ウィンドウを閉じる
function windowClose() {

    if( top.params.nomsg != 1 ) {
        if( '<%= vntEditOcrDate %>' == '' ) {
            alert("ＯＣＲ結果が格納されていません。エラー内容を確認し、保存処理を必ず実行してください。");
        }
    }
//### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加
    if( document.entryForm.GFCheckList.value == '0' ) {
        alert("ＧＦコース受診の場合は、内視鏡チェックリストの保存処理を必ず実行してください。");
    }
//### 2004/01/23 End

    // 受診検査項目変更画面を閉じる
    if ( winMonshinChangeOption != null ) {
        if ( !winMonshinChangeOption.closed ) {
            winMonshinChangeOption.close();
        }
    }

    winMonshinChangeOption = null;

    // 内視鏡チェックリスト入力画面を閉じる
    if ( winNaishikyou != null ) {
        if ( !winNaishikyou.closed ) {
            winNaishikyou.close();
        }
    }

    winNaishikyou = null;
}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
    body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<!-- 引数値 -->
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
<!-- ### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加 -->
    <INPUT TYPE="hidden" NAME="GFCheckList"   VALUE="<%= vntGFCheckList %>">
<!-- ### 2004/01/23 End -->

<!-- タイトルの表示 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR HEIGHT="14">
            <TD NOWRAP HEIGHT="14" BGCOLOR="#ffffff"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">OCR入力結果確認</B></FONT></TD>
            <TD NOWRAP BGCOLOR="#ffffff" WIDTH="250">
<%
If vntEditOcrDate = "" Then
%>
                <FONT SIZE="-1" COLOR="red">OCR結果未登録です。</FONT>
<%
Else
%>
                <FONT SIZE="-1">OCR結果登録済み:(<%= vntEditOcrDate %>)</FONT>
<%
End If
%>
            </TD>
        </TR>
    </TABLE>

<%'### 2016.01.27 張 個人情報追加の為、修正 STR ############################################## %>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="3"></TD>
        </TR>
        <TR>
            <TD NOWRAP>受診日：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;コース：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;当日ＩＤ：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayID, "0000") %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;団体：</TD>
            <TD NOWRAP><%= strOrgName %></TD>
            <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="80" HEIGHT="1" ALT=""></TD>
            <TD NOWRAP>
<%
            If lngSpCheck > 0 Then 
%>
                <IMG SRC="../../images/physical10.gif"  HEIGHT="22" WIDTH="22" BORDER="0" ALT="特定保健指導対象"><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT="">
<%
            End If
%>
            </TD>
<%
            lngCnt = 0
            For i=0 To lngOptCount - 1
                lngCnt = i + 1
                If lngCnt > OPT_DSP Then
                    lngCnt = lngCnt - 1
                    Exit For
                End If
%>
                <TD NOWRAP><%= strOptName(i) %></TD>
                <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
<%
            Next
%>
        </TR>
<%
        For i=1 To (Int(Abs(lngOptCount/OPT_DSP) * -1 ) * -1) 
            If lngCnt > lngOptCount Then Exit For
%>
        <TR>
            <TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD>
<%
            For j=0 To OPT_DSP - 1
                lngCnt = lngCnt + 1
                If lngCnt > lngOptCount Then Exit For
%>
                <TD NOWRAP><%= strOptName(lngCnt-1) %></TD>
                <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
<%
            Next
%>
        </TR>
<%
        Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="3"></TD>
        </TR>
        <TR>
            <TD NOWRAP><B><%= strPerId %></B>&nbsp;&nbsp;</TD>
            <TD NOWRAP><B><%= strLastName & " " & strFirstName %></B> （<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>）&nbsp;&nbsp;</TD>
            <TD NOWRAP><%= FormatDateTime(strBirth, 1) %>生　<%= strRealAge %>歳（<%= Int(strAge) %>歳）&nbsp;&nbsp;<%= IIf(strGender = "1", "男性", "女性") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP>&nbsp;&nbsp;受診回数：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngConsCount %></B></FONT>&nbsp;&nbsp;</TD>
            <TD NOWRAP><IMG SRC="../../images/spacer.gif"></TD>
            <TD NOWRAP ALIGN="RIGHT">&nbsp;&nbsp;身体情報：</TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
                    <TR>

<%
    For i=0 To lngPerRslCount-1
        If vntImageFileName(i) <> "" Then
%>
                        <TD><IMG SRC="<%= IMGFILE_PATH & vntImageFileName(i) %>" ALT="<%= vntItemName(i) %>" HEIGHT="22" WIDTH="22" BORDER="0"></TD>
<%
        End If
    Next
%>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<%'### 2016.01.27 張 個人情報追加の為、修正 END ############################################## %>


    <!-- アンカーの表示 -->
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
<% 
    '### 女性受診者の場合 ###

'### 2016.01.27 張 個人情報追加作業で修正 STR ###
'    If lngGender = 2 Then
    If strGender = "2" Then
'### 2016.01.27 張 個人情報追加作業で修正 END ###
%>
            <TD ALIGN="LEFT">
                <IMG SRC="../../images/queNavi2.gif" ALT="" BORDER="0" WIDTH=567 HEIGHT=28 USEMAP="#queNavi2">
                <MAP NAME="queNavi2">
                <AREA SHAPE="RECT" COORDS="0,   0,104,28" HREF="JavaScript:jumpOcrNyuryoku(1)" ALT="現病歴既往歴">
                <AREA SHAPE="RECT" COORDS="107, 0,194,28" HREF="JavaScript:jumpOcrNyuryoku(2)" ALT="生活習慣問診１">
                <AREA SHAPE="RECT" COORDS="199, 0,284,28" HREF="JavaScript:jumpOcrNyuryoku(3)" ALT="生活習慣問診２">
                <AREA SHAPE="RECT" COORDS="288, 0,348,28" HREF="JavaScript:jumpOcrNyuryoku(4)" ALT="婦人科問診">
                <AREA SHAPE="RECT" COORDS="351, 0,411,28" HREF="JavaScript:jumpOcrNyuryoku(5)" ALT="食習慣問診">
                <AREA SHAPE="RECT" COORDS="413, 0,460,28" HREF="JavaScript:jumpOcrNyuryoku(6)" ALT="朝食">
                <AREA SHAPE="RECT" COORDS="461, 0,509,28" HREF="JavaScript:jumpOcrNyuryoku(7)" ALT="昼食">
                <AREA SHAPE="RECT" COORDS="513, 0,562,28" HREF="JavaScript:jumpOcrNyuryoku(8)" ALT="夕食">
                </MAP>
            </TD>
<%
    '### 男性受診者の場合 ###
    Else
%>
            <TD ALIGN="LEFT">
                <IMG SRC="../../images/queNavi.gif" ALT="" BORDER="0" WIDTH=512 HEIGHT=28 USEMAP="#queNavi">
                <MAP NAME="queNavi">
                <AREA SHAPE="RECT" COORDS="8,   0,106,28" HREF="JavaScript:jumpOcrNyuryoku(1)" ALT="現病歴既往歴">
                <AREA SHAPE="RECT" COORDS="114, 0,196,28" HREF="JavaScript:jumpOcrNyuryoku(2)" ALT="生活習慣問診１">
                <AREA SHAPE="RECT" COORDS="206, 0,285,28" HREF="JavaScript:jumpOcrNyuryoku(3)" ALT="生活習慣問診２">
                <AREA SHAPE="RECT" COORDS="292, 0,349,28" HREF="JavaScript:jumpOcrNyuryoku(5)" ALT="食習慣問診">
                <AREA SHAPE="RECT" COORDS="353, 0,401,28" HREF="JavaScript:jumpOcrNyuryoku(6)" ALT="朝食">
                <AREA SHAPE="RECT" COORDS="403, 0,448,28" HREF="JavaScript:jumpOcrNyuryoku(7)" ALT="昼食">
                <AREA SHAPE="RECT" COORDS="452, 0,501,28" HREF="JavaScript:jumpOcrNyuryoku(8)" ALT="夕食">
                </MAP>
            </TD>
<%
    End If
%>
            <TD ALIGN="RIGHT">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT="" BORDER="0"></TD>
                        <TD NOWRAP><A HREF="JavaScript:callMonshinChangeOption()"><IMG SRC="../../images/chgInspect.gif" WIDTH="110" HEIGHT="24" ALT="受診検査項目の状態を変更します" BORDER="0"></A></TD>
                        <TD NOWRAP><A HREF="JavaScript:callNaishikyou()"><IMG SRC="../../images/cameraCheck.gif" WIDTH="110" HEIGHT="24" ALT="内視鏡チェックリストを登録します" BORDER="0"></A></TD>
                        
                        <TD NOWRAP>
                        <% '2005.08.22 権限管理 Add by 李　--- START %>
                        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                            <A HREF="JavaScript:function voi(){};voi()"><IMG SRC="../../images/saveLong.gif" WIDTH="110" HEIGHT="24" ALT="OCR入力内容を保存します" BORDER="0" ONCLICK="JavaScript:parent.list.saveOcrNyuryoku()"></A>
                        <%  else    %>
                             &nbsp;
                        <%  end if  %>
                        <% '2005.08.22 権限管理 Add by 李　--- END %>
                        </TD>

                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
</FORM>
</BODY>
</HTML>
