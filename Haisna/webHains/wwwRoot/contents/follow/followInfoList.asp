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
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon               '共通クラス
Dim objHainsUser            'ユーザ情報アクセス用
Dim objConsult              '受診情報アクセス用
Dim objOrg                  '団体情報アクセス用
Dim objPerson               '個人情報アクセス用
Dim objFollow               'フォローアップアクセス用

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

Dim strPerId
Dim strPerName
Dim strLastName             '検索条件姓
Dim strFirstName            '検索条件名
Dim strItemCd               '検査条件検査項目

Dim strAddUser              '登録ユーザ
Dim strAddUsername          '登録ユーザ名

Dim vntItemCd               'フォロー対象検査項目コード
Dim vntItemName             'フォロー対象検査項目名称

'### 2016.09.13 張 「2:本院」→「2:本院・メディローカス」に変更 #########################################################
Dim strEquipStat            '二次検査区分("":すべて、"0":二次検査場所未定、"1":当センター、"2":本院・メディローカス、"3":他院、"9":対象外)
Dim strConfirmStat          '結果承認状態("":すべて、"0":未承認、"1":承認済み)

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
Dim vntAddUser              'フォローアップ初期登録者

'### 2016.01.21 張 子宮頸部細胞診フォローアップ追加によって追加 STR ###
Dim vntDocGyne              '婦人科診察医
Dim vntDocGyneJud           '婦人科判定医
'### 2016.01.21 張 子宮頸部細胞診フォローアップ追加によって追加 END ###

Dim vntGFFlg                '後日GF受診フラグ
Dim vntCFFlg                '後日GF受診フラグ
Dim vntSeq                  'SEQ

Dim lngItemCount            'フォロー対象検査項目数
Dim lngAllCount             '総件数
Dim lngRsvAllCount          '重複予約なし件数
Dim lngGetCount             '件数
Dim i                       'カウンタ
Dim j
Dim lngItemListCount        '検査項目カウンタ

Dim lngStartPos             '表示開始位置
Dim lngPageMaxLine          '１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()     '１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName() '１ページ表示ＭＡＸ行名の配列
Dim strArrMessage           'エラーメッセージ

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
Dim strWebStatusCd          'ステータス
Dim strWebStatusName        'ステータス（名称）
Dim strWebPrtSeq            '依頼状印刷回数
Dim strWebFileName          '依頼状ファイル名
Dim strWebAddUser           '登録者
Dim strWebDocJud            '判定医
Dim strWebDocGf             '上部消化管内視鏡医
Dim strWebDocCf             '大腸内視鏡医
Dim strWebPrtDate           '依頼状作成日時
Dim strWebPrtUser           '依頼状作成者
Dim strWebRsvNo             '予約番号

'### 2016.01.21 張 子宮頸部細胞診フォローアップ追加によって追加 STR ###
Dim strWebDocGyne           '婦人科診察医
Dim strWebDocGyneJud        '婦人科判定医
'### 2016.01.21 張 子宮頸部細胞診フォローアップ追加によって追加 END ###

'リスト背景色制御用
Dim strBgColor

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPerson       = Server.CreateObject("HainsPerson.Person")
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
strPerId            = Request("perId")
strItemCd           = Request("itemCd")

strEquipStat        = Request("equipStat")
strConfirmStat      = Request("confirmStat")

strAddUser          = Request("adduser")

lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

vntRsvNo            = ConvIStringToArray(Request("arrRsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("arrJudClassCd"))
vntEquipDiv         = ConvIStringToArray(Request("arrEquipDiv"))
vntJudCd            = ConvIStringToArray(Request("arrJudCd"))
vntRslJudCd         = ConvIStringToArray(Request("arrRslJudCd"))


'デフォルトはシステム年月日を適用する
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
    strStartYear    = CStr(Year(Now))
    strStartMonth   = CStr(Month(Now))
    strStartDay     = CStr(Day(Now))
End If

If strAddUser <> "" Then
    objHainsUser.SelectHainsUser strAddUser, strAddUserName
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos )
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine )

Call CreatePageMaxLineInfo()

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
                strArrMessage = Array("保存が完了しました。")
            Else
                strArrMessage = Array("保存に失敗しました。")
            End If
        End If
    End If
    
    'フォロー対象検査項目（判定分類）を取得
    lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName )

    '検索ボタンクリック
    If strAction <> "" Then

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
'        If strEndCslDate - strStartCslDate > 365 Then
'            strArrMessage = Array("受診日範囲は１年以内を指定して下さい。")
'            Exit Do
'        End If
        If strEndCslDate - strStartCslDate > 120 Then
            strArrMessage = Array("受診日範囲は120日以内で指定して下さい。")
            Exit Do
        End If


        '全件を取得する
'        lngAllCount = objFollow.SelectTargetFollowList( strStartCslDate, strEndCslDate, strPerId, _
'                                                        strItemCd, strEquipStat, strConfirmStat, _
'                                                        lngPageMaxLine, lngStartPos, _
'                                                        vntRsvNo, vntCsldate, _
'                                                        vntDayId, vntPerId, _
'                                                        vntPerKName, vntPerName, _
'                                                        vntAge, vntGender, _
'                                                        vntBirth, vntJudCd, _
'                                                        vntRslJudCd, vntJudClassName, _
'                                                        vntJudClassCd, vntResultDispMode, _
'                                                        vntCsCd, vntEquipDiv, vntStatusCd, _
'                                                        vntReqConfirmDate, vntReqConfirmUser, _
'                                                        vntPrtSeq, vntFileName, vntPrtDate, vntPrtUser, _
'                                                        vntDocJud, vntDocGf, _
'                                                        vntDocCf, False )

'### 2016.01.23 張 子宮頸部細胞診フォローアップ追加によって追加 STR ######################################################

'        lngAllCount = objFollow.SelectTargetFollowList( strStartCslDate, strEndCslDate, strPerId, _
'                                                        strItemCd, strEquipStat, strConfirmStat, strAddUser, _
'                                                        lngPageMaxLine, lngStartPos, _
'                                                        vntRsvNo, vntCsldate, _
'                                                        vntDayId, vntPerId, _
'                                                        vntPerKName, vntPerName, _
'                                                        vntAge, vntGender, _
'                                                        vntBirth, vntJudCd, _
'                                                        vntRslJudCd, vntJudClassName, _
'                                                        vntJudClassCd, vntResultDispMode, _
'                                                        vntCsCd, vntEquipDiv, vntStatusCd, _
'                                                        vntReqConfirmDate, vntReqConfirmUser, _
'                                                        vntPrtSeq, vntFileName, vntPrtDate, vntPrtUser, _
'                                                        vntAddUser, vntDocJud, vntDocGf, vntDocCf, _
'                                                        False )

        lngAllCount = objFollow.SelectTargetFollowList( strStartCslDate, strEndCslDate, strPerId, _
                                                        strItemCd, strEquipStat, strConfirmStat, strAddUser, _
                                                        lngPageMaxLine, lngStartPos, _
                                                        vntRsvNo, vntCsldate, _
                                                        vntDayId, vntPerId, _
                                                        vntPerKName, vntPerName, _
                                                        vntAge, vntGender, _
                                                        vntBirth, vntJudCd, _
                                                        vntRslJudCd, vntJudClassName, _
                                                        vntJudClassCd, vntResultDispMode, _
                                                        vntCsCd, vntEquipDiv, vntStatusCd, _
                                                        vntReqConfirmDate, vntReqConfirmUser, _
                                                        vntPrtSeq, vntFileName, vntPrtDate, vntPrtUser, _
                                                        vntAddUser, vntDocJud, vntDocGf, vntDocCf, _
                                                        vntDocGyne, vntDocGyneJud, _
                                                        False )

'### 2016.01.23 張 子宮頸部細胞診フォローアップ追加によって追加 END ######################################################

        '個人IDの指定がある場合、名称取得
        If strPerId <> "" Then
            ObjPerson.SelectPerson_lukes strPerId, strLastName, strFirstName 
            strPerName = strLastName & "　" & strFirstName
        Else
            strPerName = ""
        End If 

    End If

    Exit Do
Loop

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

    Redim Preserve lngArrFollowMode(2)
    Redim Preserve strArrFollowModeName(2)

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
<TITLE>フォローアップ検索</TITLE>
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
    '### 保存処理後親画面も最新情報で表示し、自分の画面を閉じる
    If strAction = "saveend"  Then
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
    document.entryFollowInfo.action.value = ""
//-->
</SCRIPT>
<%
    End If
%>
<SCRIPT TYPE="text/javascript">
<!--
<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->
    var winGuideFollow;     //フォローアップ画面ハンドル
    var winMenResult;       // ドック結果参照ウィンドウハンドル
    var winRslFol;          // フォロー結果登録ウィンドウハンドル

    // ユーザーガイド呼び出し
    function callGuideUsr() {

        usrGuide_CalledFunction = SetAddUser;

        // ユーザーガイド表示
        showGuideUsr( );

    }

    // ユーザーセット
    function SetAddUser() {

        document.entryFollowInfo.adduser.value = usrGuide_UserCd;
        document.entryFollowInfo.addusername.value = usrGuide_UserName;
        document.getElementById('username').innerHTML = usrGuide_UserName;

    }

    // ユーザー指定クリア
    function clearAddUser() {

        document.entryFollowInfo.adduser.value = '';
        document.entryFollowInfo.addusername.value = '';
        document.getElementById('username').innerHTML = '';

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
            winRslFol = window.open(url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
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

    // チェックされた(ラジオボタン)二次検査施設区分の値を代入
    function setRadio(index, selObj) {

        var myForm = document.entryFollowInfo;

        if ( myForm.arrEquipDiv.length != null ) {
            myForm.arrEquipDiv[index].value = selObj.value;
        } else {
            myForm.arrEquipDiv.value = selObj.value;
        }

    }


    // ボタンクリック
    function submitForm(act) {

        with ( document.entryFollowInfo ) {
            if (act == "search" ) {
                startPos.value = 1
            } else if (act == "save" ) {
                if ( !confirm('この内容で保存します。よろしいですか？') ) return;
            }
            action.value = act;
            submit();
        }
        return false;
    }

    // ボタンクリック
    function replaceForm() {

        with ( document.entryFollowInfo ) {
            action.value = "search";
            submit();
        }
        return false;
    }


    // ガイド画面を表示
    function follow_openWindow( url ) {

        var opened = false; // 画面が開かれているか

        //var dialogWidth = 1000, dialogHeight = 600;
        var dialogWidth = 1200, dialogHeight = 600;
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

    // アンロード時の処理
    function closeGuideWindow() {

        //日付ガイドを閉じる
        calGuide_closeGuideCalendar();

//        if ( winGuideFollow != null ) {
//            if ( !winGuideFollow.closed ) {
//                winGuideFollow.close();
//            }
//        }
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

//        winGuideFollow = null;
//        winMenResult = null;
        winRslFol = null;

        closeGuideDoc();
        winGuideUsr = null;

        return false;
    }
//-->
</SCRIPT>
<style type="text/css">
	td.flwtab { background-color:#ffffff }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryFollowInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
    <INPUT TYPE="hidden" NAME="action" VALUE=""> 
    <INPUT TYPE="hidden" NAME="startPos" VALUE="<% = lngStartPos %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">フォローアップ検索</FONT></B></TD>
    </TR>
</TABLE>
<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="60">受診日</TD>
        <TD WIDTH="10">：</TD>
        <TD>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0" /></A></TD>
                    <TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
                    <TD>&nbsp;年&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
                    <TD>&nbsp;月&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
                    <TD>&nbsp;日～&nbsp;</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" BORDER="0" ALT="日付ガイドを表示" /></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" BORDER="0" ALT="設定日付をクリア"></A></TD>
                    <TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
                    <TD>&nbsp;年&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
                    <TD>&nbsp;月&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
                    <TD>&nbsp;日</TD>
                    <TD></TD>
                </TR>
            </TABLE>
        </TD>
        <TD ALIGN="right">
            <%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %>
        </TD>
        <TD WIDTH="170" ALIGN="right">
            <A HREF="javascript:submitForm('search')"><IMG SRC="../../images/b_search.gif" ALT="この条件で検索" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <% '2010.01.12 権限管理 追加 by 李
                If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
            <A HREF="javascript:submitForm('save')"><IMG SRC="../../images/save.gif" ALT="フォロー保存" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <% End If %>
        </TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="60">検査項目</TD>
        <TD WIDTH="10">：</TD>
        <TD WIDTH="140"><%= EditDropDownListFromArray("itemCd", vntItemCd, vntItemName, strItemCd, NON_SELECTED_ADD) %></TD>
        <TD WIDTH="110" NOWRAP>二次検査施設区分</TD>
        <TD WIDTH="10">：</TD>
        <TD WIDTH="170">
            <SELECT NAME="equipStat">
                <OPTION VALUE=""  <%= IIf(strEquipStat = "",  "SELECTED", "") %>>
                <OPTION VALUE="0" <%= IIf(strEquipStat = "0", "SELECTED", "") %>>二次検査場所未定
                <OPTION VALUE="1" <%= IIf(strEquipStat = "1", "SELECTED", "") %>>当センター
                <%'### 2016.09.13 張 本院→本院・メディローカスに変更 ###%>
                <OPTION VALUE="2" <%= IIf(strEquipStat = "2", "SELECTED", "") %>>本院・メディローカス
                <OPTION VALUE="3" <%= IIf(strEquipStat = "3", "SELECTED", "") %>>他院
                <OPTION VALUE="9" <%= IIf(strEquipStat = "9", "SELECTED", "") %>>対象外
                <OPTION VALUE="999" <%= IIf(strEquipStat = "999", "SELECTED", "") %>>未登録
            </SELECT>
        </TD>
        <TD WIDTH="90" NOWRAP>結果承認状態</TD>
        <TD WIDTH="10">：</TD>
        <TD WIDTH="*" ALIGN="LEFT">
            <SELECT NAME="confirmStat">
                <OPTION VALUE=""  <%= IIf(strConfirmStat = "",  "SELECTED", "") %>>
                <OPTION VALUE="0" <%= IIf(strConfirmStat = "0", "SELECTED", "") %>>未承認
                <OPTION VALUE="1" <%= IIf(strConfirmStat = "1", "SELECTED", "") %>>承認済み
            </SELECT>
        </TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD NOWRAP WIDTH="60">登録者</TD>
        <TD NOWRAP WIDTH="10">：</TD>
        <TD NOWRAP WIDTH="*" ALIGN="LEFT">
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><A HREF="javascript:callGuideUsr()"><IMG SRC="/webHains/images/question.gif" ALT="ユーザガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD><A HREF="javascript:clearAddUser()"><IMG SRC="/webHains/images/delicon.gif" ALT="ユーザ指定クリア" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD WIDTH="5"></TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="adduser"     VALUE="<%= strAddUser %>">
                        <INPUT TYPE="hidden" NAME="addusername" VALUE="<%= strAddUserName %>">
                        <SPAN ID="username"><%= strAddUserName %></SPAN>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD NOWRAP WIDTH="60">個人ID</TD>
        <TD NOWRAP WIDTH="10">：</TD>
        <TD NOWRAP WIDTH="*" ALIGN="LEFT">
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryFollowInfo.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD><A HREF="javascript:perGuide_clearPerInfo(document.entryFollowInfo.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD WIDTH="5"></TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
                        <INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
                        <SPAN ID="perName"><%= strPerName %></SPAN>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<BR>

<p>
※フォロー対象検査項目:
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
</p>
<%
    Do
    'メッセージの編集
        If strAction <> "" Then

            Select Case strAction

                '保存完了時は「保存完了」の通知
                Case "saveend"
                    Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)
                'さもなくばエラーメッセージを編集
                Case Else
                    Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

            End Select
%>
            <BR>
            <TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
                <TR>
                    <TD>
                        「<FONT COLOR="#ff6600"><B><%= strStartYear %>年<%= strStartMonth %>月<%= strStartDay %>日<%  If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then %>～<%= strEndYear %>年<%= strEndMonth %>月<%= strEndDay %>日<% End IF%></B></FONT>」のフォローアップ対象者一覧を表示しています。<BR>
                                検索件数は&nbsp;<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>&nbsp;件です。
                    </TD>
                    <TD ALIGN="right" VALIGN="middle">
                        <IMG SRC="/webHains/images/jud.gif"     WIDTH="20" HEIGHT="20" ALT="面接支援">：面接支援
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                        <IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="依頼状印刷">：依頼状作成
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                        <IMG SRC="/webHains/images/follow_result.gif"  WIDTH="20" HEIGHT="20" ALT="結果入力">：結果入力
                    </TD>
                </TR>
            </TABLE>
            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">受診日</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">当日ＩＤ</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">個人ＩＤ</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">受診者名</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">性</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">年齢</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">生年月日</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">検査項目<BR>（判定分類）</TD>
                    <TD ALIGN="center" NOWRAP COLSPAN="2">判定</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="200">フォロー</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">登録者</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">判定医</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">内視鏡医<BR>(上部)</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">内視鏡医<BR>(下部)</TD>
<%'### 2016.01.23 張 子宮頸部細胞診フォローアップ追加によって追加 STR ### %>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">婦人科診察医</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">婦人科判定医</TD>
<%'### 2016.01.23 張 子宮頸部細胞診フォローアップ追加によって追加 END ### %>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">操作</TD>
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
                strWebAge           = ""
                strWebGender        = ""
                strWebBirth         = ""
                strWebJudClassName  = vntJudClassName(i)
                strWebJudCd         = vntJudCd(i)
                strWebRslJudCd      = vntRslJudCd(i)
                strWebEquipDiv      = vntEquipDiv(i)
                strWebEquipDivName  = ""
                strWebStatusCd      = vntStatusCd(i)
                strWebStatusName    = ""
                strWebPrtSeq        = vntPrtSeq(i)
                strWebFileName      = vntFileName(i)
                strWebPrtDate       = vntPrtDate(i)
                strWebPrtUser       = vntPrtUser(i)
                strWebRsvNo         = ""
                strWebAddUser       = vntAddUser(i)
                strWebDocJud        = ""
                strWebDocGf         = ""
                strWebDocCf         = ""

'### 2016.01.23 張 子宮頸部細胞診フォローアップ追加によって追加 STR ###
                strWebDocGyne       = ""
                strWebDocGyneJud    = ""
'### 2016.01.23 張 子宮頸部細胞診フォローアップ追加によって追加 END ###

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

'### 2016.01.23 張 子宮頸部細胞診フォローアップ追加によって追加 STR ###
                    strWebDocGyne   = vntDocGyne(i)
                    strWebDocGyneJud= vntDocGyneJud(i)
'### 2016.01.23 張 子宮頸部細胞診フォローアップ追加によって追加 END ###

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
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC';" onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate        %></TD>
                    <TD NOWRAP><%= strWebDayId          %></TD>
                    <TD NOWRAP><%= strWebPerId          %></TD>
                    <TD NOWRAP><A HREF="javascript:follow_openWindow('<%= strURL %>')" TARGET="_top"><%= strWebPerName %></A></TD>
                    <TD NOWRAP><%= strWebGender         %></TD>
                    <TD NOWRAP><%= strWebAge            %></TD>
                    <TD NOWRAP><%= strWebBirth          %></TD>
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
                                        'strWebStatusName = "診断未確定(受診施設)：本院"
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
                    <TD NOWRAP <% If vntDocJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocJud     %></TD>
                    <TD NOWRAP <% If vntDocGf(i)    = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGf      %></TD>
                    <TD NOWRAP <% If vntDocCf(i)    = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocCf      %></TD>
<%'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 STR ### %>
                    <TD NOWRAP <% If vntDocGyne(i)      = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGyne       %></TD>
                    <TD NOWRAP <% If vntDocGyneJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGyneJud    %></TD>
<%'### 2016.01.23 張 婦人科診察フォローアップ追加によって追加 END ### %>

                    <TD NOWRAP>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                            <TR>
                                <TD><A HREF="/webHains/contents/interview/interviewTop.asp?rsvNo=<%= vntRsvno(i) %>" TARGET="_blank"><IMG SRC="/webHains/images/jud.gif" WIDTH="20" HEIGHT="20" ALT="面接支援"></A></TD>
                                <%
'### 2016.02.02 張 子宮頸部細胞診の場合、結果登録画面表示しない（暫定） STR ###
'                                    If vntEquipDiv(i) = "3" or  vntEquipDiv(i) = "0"  Then
                                    If vntEquipDiv(i) = "3" or  vntEquipDiv(i) = "0" or (vntEquipDiv(i) = "2" and vntJudClassCd(i) = "31") Then
'### 2016.02.02 張 子宮頸部細胞診の場合、結果登録画面表示しない（暫定） END ###
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
'### 2016.01.23 張 子宮頸部細胞診の場合、結果登録画面表示しない（暫定） STR ###
                                    If vntEquipDiv(i) <> "" Then
'                                    If vntEquipDiv(i) <> ""  and vntJudClassCd(i) <> 31 Then
'### 2016.01.23 張 子宮頸部細胞診の場合、結果登録画面表示しない（暫定） END ###
                                %>
                                        <TD>
                                            <!--A HREF="javaScript:showFollowRsl('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>', '<%= vntJudClassName(i) %>', '<%= vntJudCd(i) %>') "-->
                                            <A HREF="javaScript:showFollowInfo('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>') ">
                                            <IMG SRC="/webHains/images/follow_result.gif" WIDTH="20" HEIGHT="20" ALT="結果入力">
                                            </A>
                                        </TD>

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
                strURL = strURL & "&perId="       & strPerId
                strURL = strURL & "&itemCd="      & strItemCd
                strURL = strURL & "&equipStat="   & strEquipStat
                strURL = strURL & "&confirmStat=" & strConfirmStat
                strURL = strURL & "&adduser="     & strAddUser
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
        Exit do
    Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>