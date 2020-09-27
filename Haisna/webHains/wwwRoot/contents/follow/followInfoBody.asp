<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      フォローアップ検索 (Ver0.0.1)
'      AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const CHART_NOTEDIV   = "500"       'チャート情報ノート分類コード
Const PUBNOTE_DISPKBN = 1           '表示区分＝医療
Const PUBNOTE_SELINFO = 0           '検索情報＝個人＋受診情報

'データベースアクセス用オブジェクト
Dim objCommon               '共通クラス
Dim objConsult              '受診情報アクセス用
Dim objPubNote              'ノートクラス
Dim objFollow               'フォローアップアクセス用

Dim strWinMode              'ウィンドウモード
Dim lngRsvNo                '予約番号
Dim strMotoRsvNo            '初期表示予約番号
Dim strJudFlg               '判定結果が登録されていない検査項目表示有無

Dim strMode                 '処理モード(検索："search"、挿入:"insert"、更新:"update")
Dim strAction               '処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strMessage              'エラーメッセージ

Dim strKey                  '検索キー
Dim strArrKey               '検索キー(空白で分割後のキー）
Dim strStartCslDate         '検索条件受診年月日（開始）
Dim strStartYear            '検索条件受診年（開始）
Dim strStartMonth           '検索条件受診月（開始）
Dim strStartDay             '検索条件受診日（開始）
Dim strEndCslDate           '検索条件受診年月日（終了）
Dim strEndYear              '検索条件受診年（終了）
Dim strEndMonth             '検索条件受診月（終了）
Dim strEndDay               '検索条件受診日（終了）
Dim strUpdUser              '更新者

Dim vntItemName             'フォロー対象検査項目

Dim vntRsvNo                '予約番号
Dim vntCslDate              '受診日
Dim vntDayId                '当日ID
Dim vntPerId                '個人ID
Dim vntPerKName             'カナ氏名
Dim vntPerName              '氏名
Dim vntAge                  '年齢
Dim vntGender               '性別
Dim vntBirth                '生年月日
Dim vntJudClassCd           '判定分類コード
Dim vntJudClassName         '判定分類名
Dim vntJudCd                '判定コード（フォロー登録時判定結果）
Dim vntRslJudCd             '判定コード（カレント判定結果）
Dim vntResultDispMode       '検査結果表示モード
Dim vntCsCd                 'コースコード
Dim vntEquipDiv             '二次検査実施区分
Dim vntStatusCd             'ステータス
Dim vntReqConfirmDate       '結果承認日
Dim vntReqConfirmUser       '結果承認者
Dim vntPrtSeq               '依頼状印刷回数
Dim vntFileName             '依頼状ファイル名
Dim vntDocJud               '判定医
Dim vntDocGf                '上部消化管内視鏡医
Dim vntDocCf                '大腸内視鏡医
Dim vntPrtDate              '依頼状作成日時
Dim vntPrtUser              '依頼状作成者
Dim vntAddUser              'フォローアップ最初登録者
Dim vntUpdUser              '更新者

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
Dim vntDocGyne              '婦人科診察医
Dim vntDocGyneJud           '婦人科判定医
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

Dim strPerId                '個人ID
Dim strCslDate              '受診日
Dim vntArrHistoryRsvno      '受診歴の予約番号の配列
Dim vntArrHistoryCslDate    '受診歴の受診日の配列


Dim strLastName             '検索条件姓
Dim strFirstName            '検索条件名

Dim vntGFFlg                '後日GF受診フラグ
Dim vntCFFlg                '後日GF受診フラグ
Dim vntSeq                  'SEQ

Dim lngItemCount            'フォロー対象検査項目数
Dim lngAllCount             '総件数
Dim lngRsvAllCount          '重複予約なし件数
Dim lngGetCount             '件数
Dim lngCount

Dim i                       'カウンタ
Dim j

Dim lngStartPos             '表示開始位置
Dim lngPageMaxLine          '１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()     '１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName() '１ページ表示ＭＡＸ行名の配列

Dim lngArrSendMode()        '発送日確認状態の配列
Dim strArrSendModeName()    '発送日確認状態名の配列

Dim Ret                     '関数戻り値
Dim strURL                  'ジャンプ先のURL

Dim strWebCslDate           '受診日
Dim strWebDayId             '当日ID
Dim strWebPerId             '個人ID
Dim strWebPerName           'カナ氏名・氏名
Dim strWebAge               '年齢
Dim strWebGender            '性別
Dim strWebBirth             '生年月日
Dim strWebJudClassName      '判定分類名
Dim strWebJudCd             '判定コード（フォロー登録時判定結果）
Dim strWebRslJudCd          '判定コード（カレント判定結果）
Dim strWebEquipDiv          '二次検査実施区分
Dim strWebEquipDivName      '二次検査実施区分（名称）
Dim strWebStatusCd          'ステータス
Dim strWebStatusName        'ステータス（名称）
Dim strWebPrtSeq            '依頼状印刷回数
Dim strWebFileName          '依頼状ファイル名
Dim strWebDocJud            '判定医
Dim strWebDocGf             '上部消化管内視鏡医
Dim strWebDocCf             '大腸内視鏡医
Dim strWebPrtDate           '依頼状作成日時
Dim strWebPrtUser           '依頼状作成者
Dim strWebRsvNo             '予約番号
Dim strWebAddUser           'フォローアップ最初登録者
Dim strWebUpdUser           '更新者

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
Dim strWebDocGyne           '婦人科診察医
Dim strWebDocGyneJud        '婦人科判定医
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

'リスト背景色制御用
Dim strBgColor

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'引数値の取得
strMode             = Request("mode")
strAction           = Request("action")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear          = Request("endYear")
strEndMonth         = Request("endMonth")
strEndDay           = Request("endDay")
lngPageMaxLine      = Request("pageMaxLine")

strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
strMotoRsvNo        = Request("motoRsvNo")
strJudFlg           = Request("judFlg")
strUpdUser          = Session.Contents("userId")

vntRsvNo            = ConvIStringToArray(Request("arrRsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("arrJudClassCd"))
vntEquipDiv         = ConvIStringToArray(Request("arrEquipDiv"))
vntJudCd            = ConvIStringToArray(Request("arrJudCd"))
vntRslJudCd         = ConvIStringToArray(Request("arrRslJudCd"))

Do

    '保存ボタンクリック時
    If strAction = "save"  Then
        'フォローの保存
        If strMessage = ""  Then
           '更新対象データが存在するときのみ判定結果保存
            Ret = objFollow.InsertFollow_Info(vntRsvNo, vntJudClassCd, vntEquipDiv, vntRslJudCd, _
                                              Session.Contents("userId"))
            If Ret = True Then
                strAction = "saveend"
                strMessage = "正常に保存できました。"
            Else
                strMessage = "保存に失敗しました"
            End If
        End If
    End If


    '検索ボタンクリック
'    If strAction <> "" Then
       '全件を取得する
'       lngAllCount = objFollow.SelectTargetFollow(lngRsvNo, _
'                                                  vntRsvNo, vntCsldate, _
'                                                  vntDayId, vntPerId, _
'                                                  vntPerKName, vntPerName, _
'                                                  vntAge, vntGender, _
'                                                  vntBirth, vntJudCd, _
'                                                  vntRslJudCd, vntJudClassName, _
'                                                  vntJudClassCd, vntResultDispMode, _
'                                                  vntCsCd, vntEquipDiv, vntStatusCd, _
'                                                  vntReqConfirmDate, vntReqConfirmUser, _
'                                                  vntPrtSeq, vntFileName, _
'                                                  vntPrtDate, vntPrtUser, _
'                                                  vntDocJud, vntDocGf, vntDocCf, (strJudFlg <> ""))

'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 STR ######################################################
'       lngAllCount = objFollow.SelectTargetFollow(lngRsvNo, _
'                                                  vntRsvNo, vntCsldate, _
'                                                  vntDayId, vntPerId, _
'                                                  vntPerKName, vntPerName, _
'                                                  vntAge, vntGender, _
'                                                  vntBirth, vntJudCd, _
'                                                  vntRslJudCd, vntJudClassName, _
'                                                  vntJudClassCd, vntResultDispMode, _
'                                                  vntCsCd, vntEquipDiv, vntStatusCd, _
'                                                  vntReqConfirmDate, vntReqConfirmUser, _
'                                                  vntPrtSeq, vntFileName, _
'                                                  vntPrtDate, vntPrtUser, vntAddUser, _
'                                                  vntDocJud, vntDocGf, vntDocCf, (strJudFlg <> ""), vntUpdUser )

       lngAllCount = objFollow.SelectTargetFollow(lngRsvNo, _
                                                  vntRsvNo, vntCsldate, _
                                                  vntDayId, vntPerId, _
                                                  vntPerKName, vntPerName, _
                                                  vntAge, vntGender, _
                                                  vntBirth, vntJudCd, _
                                                  vntRslJudCd, vntJudClassName, _
                                                  vntJudClassCd, vntResultDispMode, _
                                                  vntCsCd, vntEquipDiv, vntStatusCd, _
                                                  vntReqConfirmDate, vntReqConfirmUser, _
                                                  vntPrtSeq, vntFileName, _
                                                  vntPrtDate, vntPrtUser, vntAddUser, _
                                                  vntDocJud, vntDocGf, vntDocCf, vntDocGyne, vntDocGyneJud, _
                                                  (strJudFlg <> ""), vntUpdUser )
'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 END ######################################################

'    End If

    Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>フォローアップ検索</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
    var winGuideFollow;     //フォローアップ画面ハンドル
    var winMenResult;       // ドック結果参照ウィンドウハンドル
    var winRslFol;          // フォロー結果登録ウィンドウハンドル

    //検査結果画面呼び出し
    function callMenResult( inRsvNo, inGrpCd, inCsCd, classgrpno ) {
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
        url = url + '&rsvno=' + inRsvNo;
        url = url + '&grpcd=' + inGrpCd;
        url = url + '&cscd=' + inCsCd;

        // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
        if ( opened ) {
            winMenResult.focus();
            winMenResult.location.replace( url );
        } else {
            winMenResult = window.open( url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }

    function showFollowRsl(rsvNo, judClassCd, judClassName, judCd) {

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
            winRslFol = window.open(url, '', 'width=1000,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }


    // チェックされた(ラジオボタン)二次検査施設区分の値を代入
    function setRadio(index, selObj) {

        var myForm = document.entryFollowInfo;

//        alert('selObj.value = '+selObj.value);
//        alert('index = '+index);
        if ( myForm.arrEquipDiv.length != null ) {
            myForm.arrEquipDiv[index].value = selObj.value;
        } else {
            myForm.arrEquipDiv.value = selObj.value;
        }

    }


    // 検索ボタンクリック
    function submitForm(act) {

        with ( document.entryFollowInfo ) {
//            action.value = act;
            submit();
        }
        return false;

    }

    function replaceForm() {

        with ( document.entryFollowInfo ) {
            submit();
        }
        return false;

    }

    // ガイド画面を表示
    function follow_openWindow( url ) {

        var opened = false; // 画面が開かれているか

        var dialogWidth = 1024, dialogHeight = 768;
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

    function showRequestEdit(rsvNo, judClassCd) {

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
        url = 'followReqEdit.asp?rsvno='+rsvNo+'&judClassCd=' + judClassCd;

        // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
        if ( opened ) {
            winRslFol.focus();
            winRslFol.location.replace(url);
        } else {
            winRslFol = window.open(url, '', 'width=1000,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }


    // アンロード時の処理
    function closeGuideWindow() {

        //日付ガイドを閉じる
        calGuide_closeGuideCalendar();

        if ( winGuideFollow != null ) {
            if ( !winGuideFollow.closed ) {
                winGuideFollow.close();
            }
        }
        if ( winMenResult != null ) {
            if ( !winMenResult.closed ) {
                winMenResult.close();
            }
        }
//        if ( winRslFol != null ) {
//            if ( !winRslFol.closed ) {
//                winRslFol.close();
//            }
//        }

        winGuideFollow = null;
        winMenResult = null;
//        winRslFol = null;

        return false;
    }
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<FORM NAME="entryFollowInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="motoRsvNo"   VALUE="<%= strMotoRsvNo%>">
<INPUT TYPE="hidden" NAME="action"      VALUE=""> 
<INPUT TYPE="hidden" NAME="judFlg"      VALUE="<%= strJudFlg
%>">
<!--ここは検索件数結果-->
<%
    Do
        'メッセージが発生している場合は編集して処理終了
        If strMessage <> "" Then
%>
            <BR>&nbsp;<%= strMessage %>
<%
        End If
%>
            <TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
                <TR>
                    <TD ALIGN="right" VALIGN="middle">
                    <%
                        '「別ウィンドウで表示」の場合、面接支援画面参照できるようにする
                        If strWinMode = 1 Then
                    %>
                        <IMG SRC="/webHains/images/jud.gif"     WIDTH="20" HEIGHT="20" ALT="面接支援">：面接支援
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                    <%  End If %>
                        <IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="依頼状印刷">：依頼状印刷
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                        <IMG SRC="/webHains/images/follow_result.gif"  WIDTH="20" HEIGHT="20" ALT="結果入力">：結果入力
                    </TD>
                </TR>
            </TABLE>
            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">受診日</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="100">検査項目<BR>（判定分類）</TD>
                    <TD ALIGN="center" NOWRAP COLSPAN="2">判定</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="250">フォロー</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">登録者</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">更新者</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">判定医</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">内視鏡医<BR>(上部)</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">内視鏡医<BR>(下部)</TD>
<%'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 STR ### %>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">婦人科診察医</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">婦人科判定医</TD>
<%'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 END ### %>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">操作</TD>
                </TR>
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP>フォロー</TD>
                    <TD ALIGN="center" NOWRAP>現在判定</TD>
                </TR>
<%
        If lngAllCount > 0 Then

            For i = 0 To UBound(vntRsvNo)

                strWebCslDate   = vntCslDate(i)
                strWebDayId     = objCommon.FormatString(vntDayId(i), "0000")
                strWebPerId     = vntPerId(i)
                strWebPerName   = "<SPAN STYLE=""font-size:9px;"">" & vntPerKName(i) & "</SPAN><BR>" & vntPerName(i)
                strWebAge       = vntAge(i) & "歳"
                strWebGender    = vntGender(i)
                strWebBirth     = vntBirth(i)

                strWebJudClassName  = vntJudClassName(i)
                strWebJudCd         = vntJudCd(i)
                strWebRslJudCd      = vntRslJudCd(i)
                strWebEquipDiv      = vntEquipDiv(i)
                strWebEquipDivName  = ""
                strWebStatusCd      = vntStatusCd(i)
                strWebStatusName    = ""
                strWebFileName      = vntFileName(i)
                strWebPrtSeq        = vntPrtSeq(i)
                strWebPrtDate       = vntPrtDate(i)
                strWebPrtUser       = vntPrtUser(i)
                strWebRsvNo         = vntRsvNo(i)
                strWebDocJud        = vntDocJud(i)
                strWebDocGf         = vntDocGf(i)
                strWebDocCf         = vntDocCf(i)
                strWebAddUser       = vntAddUser(i)
                strWebUpdUser       = vntUpdUser(i)
'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 STR ###
                strWebDocGyne       = vntDocGyne(i)
                strWebDocGyneJud    = vntDocGyneJud(i)
'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 END ###
%>
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'"; onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate        %></TD>
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
                    <TD NOWRAP>
                    <%
                        If vntEquipDiv(i) = ""  Then
                    %>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="9" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "9", " CHECKED", "") %>>対象外<BR>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="0" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "0", " CHECKED", "") %>>二次検査場所未定<BR>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="1" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "1", " CHECKED", "") %>>当センター
                        <%'### 2016.09.13 張 本院→本院・メディローカスに変更 ###%>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="2" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "2", " CHECKED", "") %>>本院・メディローカス
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="3" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "3", " CHECKED", "") %>>他院
                    <%  Else
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
                               Case 9
                                    strWebEquipDivName = "<FONT COLOR='#666666'>対象外</FONT>"
                            End Select
                    %><B><%= strWebEquipDivName    %></B>
                    <%      If vntStatusCd(i) <> "" Then  
'                                Select Case vntStatusCd(i)
'                                   Case 1
'                                        strWebStatusName = "異常なし"
'                                   Case 2
'                                        strWebStatusName = "異常あり：フォローなし"
'                                   Case 3
'                                        strWebStatusName = "異常あり：継続フォロー"
'                                   Case 4
'                                        strWebStatusName = "その他終了：連絡とれず"
'                                End Select

                                Select Case vntStatusCd(i)
                                   Case 11
                                        strWebStatusName = "診断確定：異常なし"
                                   Case 12
                                        strWebStatusName = "診断確定：異常あり"
                                   Case 21
                                        strWebStatusName = "診断未確定(受診施設)：センター"
                                   Case 22
                                    '### 2016.09.13 張 本院→本院・メディローカスに変更 ###
                                        strWebStatusName = "診断未確定(受診施設)：本院・メディローカス"
                                   Case 23
                                        strWebStatusName = "診断未確定(受診施設)：他院"
                                   Case 29
                                        strWebStatusName = "診断未確定(受診施設)：その他（未定・不明）"
                                   Case 99
                                        strWebStatusName = "その他(フォローアップ登録終了)"
                                End Select

                    %>(<%= strWebStatusName %>)
                    <%      End If  %>
                    <%      If vntPrtSeq(i) <> "" Then  %>
                                <BR><A HREF="/webHains/contents/follow/prtPreview.asp?documentFileName=<%= strWebFileName %>" TARGET="_blank">依頼状(<%=vntPrtSeq(i)%>版)：<%= strWebPrtUser %>&nbsp;<%= strWebPrtDate %></A>

                    <%      End If  %>
                    <%      If vntReqConfirmDate(i) <> "" Then  %>
                                <BR>結果承認済(<%=vntReqConfirmUser(i)%>)
                    <%      End If
                        End If
                    %>

                    </TD>
                    <TD NOWRAP <% If vntAddUser(i)  = ""  Then %>ALIGN="center"<% End If %>><%= strWebAddUser    %></TD>
                    <TD NOWRAP <% If vntUpdUser(i)  = ""  Then %>ALIGN="center"<% End If %>><%= strWebUpdUser    %></TD>
                    <TD NOWRAP <% If vntDocJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocJud     %></TD>
                    <TD NOWRAP <% If vntDocGf(i)    = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGf      %></TD>
                    <TD NOWRAP <% If vntDocCf(i)    = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocCf      %></TD>
<%'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 STR ### %>
                    <TD NOWRAP <% If vntDocGyne(i)      = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGyne       %></TD>
                    <TD NOWRAP <% If vntDocGyneJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGyneJud    %></TD>
<%'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 END ### %>

                    <TD NOWRAP>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADING="1">
                            <TR>
                                <%
                                    '「別ウィンドウで表示」の場合、面接支援画面参照できるようにする
                                    If strWinMode = 1 Then
                                %>
                                        <TD><A HREF="/webHains/contents/interview/interviewTop.asp?rsvNo=<%= vntRsvno(i) %>" TARGET="_blank"><IMG SRC="/webHains/images/jud.gif" WIDTH="20" HEIGHT="20" ALT="面接支援"></A></TD>
                                <%  End If  %>
                                <%
                                    If vntEquipDiv(i) = "3" or vntEquipDiv(i) = "0" Then
                                %>
                                        <TD>
                                            <A HREF="javaScript:showRequestEdit('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>') ">
                                            <IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="依頼状作成">
                                            </A>
                                        </TD>
                                <%  Else    %>
                                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
                                <%  End If  %>



                                <%
                                    If vntEquipDiv(i) <> "" Then
                                %>
                                        <TD><A HREF="javaScript:showFollowRsl('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>', '<%= vntJudClassName(i) %>', '<%= vntJudCd(i) %>') "><IMG SRC="/webHains/images/follow_result.gif" WIDTH="20" HEIGHT="20" ALT="結果入力"></A></TD>

                                <%  Else    %>

                                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>

                                <%  End If  %>
                            </TR>
                        </TABLE>
                    </TD>


                </TR>
<%
            Next
        End If
%>
            </TABLE>
<%
        Exit do
    Loop
%>
<BR>

</FORM>
</BODY>
</HTML>