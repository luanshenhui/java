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
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
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

Dim	strWinMode              'ウィンドウモード
Dim lngRsvNo                '予約番号
Dim strMotoRsvNo            '初期表示予約番号

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
Dim strUpdUser          '更新者

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
Dim vntPrtSeq               '依頼状印刷回数
Dim vntFileName             '依頼状ファイル名
Dim vntDocJud               '判定医
Dim vntDocGf                '上部消化管内視鏡医
Dim vntDocCf                '大腸内視鏡医

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

'画面表示制御用検査項目
Dim strBeforeRsvNo          '前行の予約番号

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
Dim strWebPrtSeq            '依頼状印刷回数
Dim strWebFileName          '依頼状ファイル名
Dim strWebDocJud            '判定医
Dim strWebDocGf             '上部消化管内視鏡医
Dim strWebDocCf             '大腸内視鏡医
Dim strWebRsvNo             '予約番号

'ノート情報件数獲得用
Dim vntNoteSeq          'seq
Dim vntPubNoteDivCd     '受診情報ノート分類コード
Dim vntPubNoteDivName   '受診情報ノート分類名称
Dim vntDefaultDispKbn   '表示対象区分初期値
Dim vntOnlyDispKbn      '表示対象区分しばり
Dim vntDispKbn          '表示対象区分
Dim vntUpdDate          '登録日時
Dim vntNoteUpdUser      '登録者
Dim vntUserName         '登録者名
Dim vntBoldFlg          '太字区分
Dim vntPubNote          'ノート
Dim vntDispColor        '表示色
Dim lngChartCnt         'チャート情報件数

'リスト背景色制御用
Dim strBgColor

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
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
strUpdUser          = Session.Contents("userId")

vntRsvNo            = ConvIStringToArray(Request("rsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("judClassCd"))
vntEquipDiv         = ConvIStringToArray(Request("equipDiv"))
vntJudCd            = ConvIStringToArray(Request("judCd"))


'予約番号が指定されている場合
If lngRsvNo <> "" Then

    '受診情報読み込み
    Ret = objConsult.SelectConsult(lngRsvNo, , strCslDate, strPerId)

    '一度も表示していない場合は予約番号を退避する
    If strMotoRsvNo = "" Then
        strMotoRsvNo = lngRsvNo
    End If
    '受診歴情報読み込み
    lngCount = objFollow.SelectFollowHistory(strPerId, strMotoRsvNo, vntArrHistoryRsvno, vntArrHistoryCslDate)

    '受診歴がない場合は引数の予約番号、受診日を表示する
    If lngCount = 0 Then
        vntArrHistoryRsvno   = Array()
        vntArrHistoryCslDate = Array()
        Redim Preserve vntArrHistoryRsvno(0)
        Redim Preserve vntArrHistoryCslDate(0)
        vntArrHistoryRsvno(0)   = lngRsvNo
        vntArrHistoryCslDate(0) = strCslDate
    End If

    'チャート情報の件数取得
    lngChartCnt = objPubNote.SelectPubNote(PUBNOTE_SELINFO,  _
                                        0, "", "",           _
                                        lngRsvNo,            _
                                        "", "", "", "", 0,   _
                                        CHART_NOTEDIV,       _
                                        PUBNOTE_DISPKBN,     _
                                        strUpdUser,          _
                                        vntNoteSeq,          _
                                        vntPubNoteDivCd,     _
                                        vntPubNoteDivName,   _
                                        vntDefaultDispKbn,   _
                                        vntOnlyDispKbn,      _
                                        vntDispKbn,          _
                                        vntUpdDate,          _
                                        vntNoteUpdUser,      _
                                        vntUserName,         _
                                        vntBoldFlg,          _
                                        vntPubNote,          _
                                        vntDispColor )

End If


Do

'    '保存ボタンクリック時
'    If strAction = "save"  Then
'        'フォローの保存
'        If strMessage = ""  Then
''           '更新対象データが存在するときのみ判定結果保存
'            Ret = objFollow.InsertFollow_Info(vntRsvNo, vntJudClassCd, vntEquipDiv, vntJudCd, _
'                                              Session.Contents("userId"))
'            If Ret = True Then
'                strAction = "saveend"
'                strMessage = "正常に保存できました。"
'            Else
'                strMessage = "保存に失敗しました"
'            End If
'        End If
'    End If
    
    'フォロー対象検査項目（判定分類）を取得
    lngItemCount = objFollow.SelectFollowItem( vntItemName )

    '検索ボタンクリック
'    If strAction <> "" Then
       '全件を取得する
       lngAllCount = objFollow.SelectTargetFollow(lngRsvNo, _
                                                  vntRsvNo, vntCsldate, _
                                                  vntDayId, vntPerId, _
                                                  vntPerKName, vntPerName, _
                                                  vntAge, vntGender, _
                                                  vntBirth, vntJudCd, _
                                                  vntRslJudCd, vntJudClassName, _
                                                  vntJudClassCd, vntResultDispMode, _
                                                  vntCsCd, vntEquipDiv, _
                                                  vntPrtSeq, vntFileName, _
                                                  vntDocJud, vntDocGf, vntDocCf)

'    End If

    Exit Do
Loop

'    Set objConsult = Nothing
'    Set objPubNote = Nothing
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<HEAD>
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
        url = 'followRslEdit.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd;

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
        if ( myForm.equipDiv.length != null ) {
            myForm.equipDiv[index].value = selObj.value;
        } else {
            myForm.equipDiv.value = selObj.value;
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

    //コメント一覧（チャート情報）呼び出し
    function callCommentList() {
        alert("チャート情報表示画面");
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
        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                winRslFol.close();
            }
        }

        winGuideFollow = null;
        winMenResult = null;
        winRslFol = null;

        return false;
    }
//-->
</SCRIPT>
<style type="text/css">
	body { margin: <%= IIF(strWinMode = 1,"12","0") %>px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<%
    '「別ウィンドウで表示」の場合、ヘッダー部分表示
    If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>
<FORM NAME="entryFollowInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="motoRsvNo"   VALUE="<%=strMotoRsvNo%>">
<INPUT TYPE="hidden" NAME="action"      VALUE=""> 
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD WIDTH="100%">
            <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                <TR>
                    <TD NOWRAP BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="15"><B><SPAN CLASS="follow">■</SPAN><FONT COLOR="#000000">フォローアップ照会</FONT></B></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
strCslDate=<%= strCslDate%><BR>
strPerId=<%=strPerId%>



<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD NOWRAP WIDTH="150" ALIGN="left" VALIGN="top">※<FONT style="background-color:#CCCCCC;">フォロー対象検査項目</FONT>&nbsp;：&nbsp;</TD>
        <TD>
        <%
                '## 汎用マスターに登録されているフォロー対象健康項目（判定分類）表示
                If lngItemCount > 0 Then

                    For i = 0 To UBound(vntItemName)
                        IF i = 0 Then
        %>
                            <%= vntItemName(i)%>
        <%
                        Else
        %>
                            、<%= vntItemName(i)%>
        <%
                        End if
                    Next
                Else
        %>
                &nbsp;
        <%
                End If
        %>
        </TD>
    </TR>
</TABLE>

<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
<%
    'チャート情報あり？
    If lngChartCnt > 0 Then
%>
        <TD ALIGN="left" BGCOLOR="ffffff"><A HREF="javascript:callCommentList()"><FONT  SIZE="-1" COLOR="FF00FF">チャート情報</FONT></A></TD>
<%
    Else
%>
        <TD ALIGN="left" BGCOLOR="ffffff"><A HREF="javascript:callCommentList()"><IMAGE SRC="/webHains/images/chartinfo.gif" ALT="チャート情報を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
<%
    End If
%>
        <TD WIDTH="100" ALIGN="right">表示受診日</TD>
        <TD WIDTH="100" ALIGN="right"><%= EditDropDownListFromArray("rsvHistory", vntArrHistoryRsvno, vntArrHistoryCslDate, lngRsvNo, NON_SELECTED_DEL) %></TD>
        <TD WIDTH="170" ALIGN="right">
            <A HREF="javascript:submitForm('search')"><IMG SRC="../../images/b_search.gif" ALT="この条件で検索" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <A HREF="javascript:submitForm('save')"><IMG SRC="../../images/save.gif" ALT="フォロー保存" HEIGHT="24" WIDTH="77" BORDER="0"></A>
        </TD>

    </TR>
</TABLE>

<BR>
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
                        <IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="依頼状印刷">：依頼状印刷
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                        <IMG SRC="/webHains/images/follow_result.gif"  WIDTH="20" HEIGHT="20" ALT="結果入力">：結果入力
                    </TD>
                </TR>
            </TABLE>
            <BR>

            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">受診日</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">検査項目<BR>（判定分類）</TD>
                    <TD ALIGN="center" NOWRAP COLSPAN="2">判定</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="200">フォロー</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">判定医</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">内視鏡医<BR>(上部)</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">内視鏡医<BR>(下部)</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="80">操作</TD>
                </TR>
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP>フォロー</TD>
                    <TD ALIGN="center" NOWRAP>現在判定</TD>
                </TR>
<%
        If lngAllCount > 0 Then
            strBeforeRsvNo = ""

            For i = 0 To UBound(vntRsvNo)

                strWebCslDate       = ""
                strWebDayId         = ""
                strWebPerId         = ""
                strWebPerName       = ""
                strWebAge           = ""
                strWebGender        = ""
                strWebBirth         = ""
                strWebJudClassName  = vntJudClassName(i)
                strWebJudCd         = vntJudCd(i)
                strWebRslJudCd      = vntRslJudCd(i)
                strWebEquipDiv      = vntEquipDiv(i)
                strWebEquipDivName  = ""
                strWebFileName      = vntFileName(i)
                strWebRsvNo         = ""
                strWebDocJud        = ""
                strWebDocGf         = ""
                strWebDocCf         = ""

                strBgColor          = "#FFFFFF"
                If strBeforeRsvNo <> vntRsvNo(i) Then

                    strWebCslDate   = vntCslDate(i)
                    strWebDayId     = objCommon.FormatString(vntDayId(i), "0000")
                    strWebPerId     = vntPerId(i)
                    strWebPerName   = "<SPAN STYLE=""font-size:9px;"">" & vntPerKName(i) & "</SPAN><BR>" & vntPerName(i)
                    strWebAge       = vntAge(i) & "歳"
                    strWebGender    = vntGender(i)
                    strWebBirth     = vntBirth(i)
                    strWebRsvNo     = vntRsvNo(i)
                    strWebDocJud    = vntDocJud(i)
                    strWebDocGf     = vntDocGf(i)
                    strWebDocCf     = vntDocCf(i)

                    strBgColor          = "#EEEEEE"
                End If
%>
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'"; onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate        %></TD>
                    <TD NOWRAP>
                        <A HREF="javascript:callMenResult(<%= vntRsvNo(i) %>,'',<%= vntCsCd(i) %>,<%= vntResultDispMode(i) %>)" TARGET="_top"><%= strWebJudClassName   %></A>
                        <INPUT TYPE="hidden"    NAME="rsvNo"        VALUE="<%= vntRsvNo(i) %>">
                        <INPUT TYPE="hidden"    NAME="judClassCd"   VALUE="<%= vntJudClassCd(i) %>">
                    </TD>
                    <TD ALIGN="center" NOWRAP  <% If vntJudCd(i) <> "" and vntJudCd(i) <> vntRslJudCd(i) Then %>BGCOLOR="#FFC0CB"<% End If %> >
                        <%= strWebJudCd          %>
                        <INPUT TYPE="hidden"    NAME="judCd"   VALUE="<%= vntJudCd(i) %>">
                    </TD>
                    <TD ALIGN="center" NOWRAP  <% If vntJudCd(i) <> "" and vntJudCd(i) <> vntRslJudCd(i) Then %>BGCOLOR="#FFC0CB"<% End If %> >
                        <%= strWebRslJudCd       %>
                        <INPUT TYPE="hidden"    NAME="rslJudCd"   VALUE="<%= vntRslJudCd(i) %>">
                    </TD>
                    <TD NOWRAP>
                    <%
                        If vntEquipDiv(i) = ""  Then
                    %>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="0" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "0", " CHECKED", "") %>>二次検査場所未定<BR>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="1" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "1", " CHECKED", "") %>>当センター
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="2" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "2", " CHECKED", "") %>>本院
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="3" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "3", " CHECKED", "") %>>他院
                    <%  Else
                            Select Case vntEquipDiv(i)
                               Case 0
                                    strWebEquipDivName = "二次検査場所未定"
                               Case 1
                                    strWebEquipDivName = "当センター"
                               Case 2
                                    strWebEquipDivName = "本院"
                               Case 3
                                    strWebEquipDivName = "他院"
                            End Select
                    %>
                              <%= strWebEquipDivName    %>
                    <%  End If  %>
                        <INPUT TYPE="hidden" NAME="equipDiv">
                    </TD>
                    <TD NOWRAP><%= strWebDocJud         %></TD>
                    <TD NOWRAP><%= strWebDocGf          %></TD>
                    <TD NOWRAP><%= strWebDocCf          %></TD>
                    <TD NOWRAP>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADING="1">
                            <TR>
                                <%
                                    If vntEquipDiv(i) = "3" Then
                                %>
                                        <TD><IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="依頼状作成"></TD>
                                <%  Else    %>
                                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
                                <%  End If  %>

                                <%
                                    If vntEquipDiv(i) = "0" or vntEquipDiv(i) = "1" or vntEquipDiv(i) = "2" or (vntEquipDiv(i) = "2" and vntFileName(i) <> "") Then
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
                strBeforeRsvNo = vntRsvno(i)
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
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>