<%@ LANGUAGE="VBScript" %>
<%
'========================================
'管理番号：SL-SN-Y0101-007
'修正日  ：2011.11.17
'担当者  ：FJTH)MURTA
'修正内容：面接支援画面　表示不具合対応
'========================================
'-----------------------------------------------------------------------------
'      総合判定（参照専用画面） (Ver0.0.1)
'      AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc"   -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const JUDDOC_GRPCD          = "X049"    '判定医グループコード

'## 2006.01.04  Add By 李  STR) -------------------------------------->
Const GRPCD_DISEASEHISTORY  = "X026"    '病歴グループコード
Const GRPCD_JIKAKUSYOUJYOU  = "X025"    '自覚症状グループコード
'## 2006.01.04  Add By 李  END) -------------------------------------->

Const AUTOJUD_USER      = "AUTOJUD"     '自動判定ユーザ
Const CHART_NOTEDIV     = "500"         'チャート情報ノート分類コード
Const CAUTION_NOTEDIV   = "100"         '注意事項ノート分類コード
Const PUBNOTE_DISPKBN   = 1             '表示区分＝医療
Const PUBNOTE_SELINFO   = 0             '検索情報＝個人＋受診情報

'## 2009.10.03 張 フォローアップ情報登録有無チェックのため追加
Const FOLLOW_JUDCLASS   = 999           'フォローアップ情報カウント用判定分類子d-お

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objHainsUser        'ユーザー情報アクセス用
Dim objInterview        '面接情報アクセス用
Dim objResult           '検査結果情報アクセス用
Dim objPubNote          'ノートクラス
'2004.11.08 ADD STR ORB)T.Yaguchi フォロー追加
Dim objFollowUp         'フォローアップアクセス用
'2004.11.08 ADD END

Dim objFollow           'フォローアップアクセス用

'*** 2008.02.26 特定健診追加　STR
Dim objSpecialInterview         '特定健診情報アクセス用
'*** 2008.02.26 特定健診追加　END

Dim strAct              '処理状態
Dim strWinMode          'ウインドウ表示モード（1:別ウインドウ、0:同ウインドウ）
Dim strGrpCd            'グループコード

Dim lngRsvNo            '予約番号（今回分）
Dim strCsCd             'コースコード（今回分）

'受診情報取得用
Dim vntCslRsvNo         '予約番号
Dim vntCslCslDate       '受診日
Dim vntCslCsCd          'コースコード
Dim vntCslCsName        'コース名称
Dim vntCslCsSName       'コース名略称

'Dim strPerId           '個人ＩＤ
'Dim dtmCslDate         '受診日
Dim lngLastDspMode      '前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp            'コースコード または　コースグループコード
Dim lngGetSeqMode       '取得順 0:表示順＋日付　1:日付＋表示順
Dim vntRsvNo            '予約番号
Dim vntSeq              '表示位置
Dim vntJudClassCd       '判定分類コード
Dim vntJudClassName     '判定分類名称
Dim vntJudCd            '判定コード
Dim vntJudSName         '判定略称
Dim vntWeight           '判定重み
Dim vntUpdUser          '更新者
Dim vntUpdFlg           '更新フラグ　　2003.12.26
Dim vntResultDispMode   '検査結果表示モード
Dim vntJudCmtCd         '判定コメントコード
Dim vntJudCmtstc        '判定コメント文章

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

Dim lngJudClassCount    '判定分類件数
Dim lngLastJudClassCd   '前判定分類コード

Dim lngCount            '件数

Dim lngDspPoint         '表示位置

Dim vntDocSeq           '判定医　履歴番号
Dim vntDocRsvNo         '判定医　予約番号
Dim vntDocSuffix        '判定医　サフィックス
Dim vntDocItemType      '判定医　項目コード
Dim vntDocItemName      '判定医　項目名
Dim vntDocItemCd        '判定医コード（検査項目コード）
Dim vntDocterName       '判定医氏名
Dim strDocStcCd         '判定医コード（文章コード）

Dim lngJudDocCnt        '判定医　件数

Dim lngDocIndex         '判定医登録位置

'総合コメント
Dim vntCmtSeq           '表示順
Dim vntTtlJudCmtCd      '判定コメントコード
Dim vntTtlJudCmtstc     '判定コメント文章
Dim vntTtlJudClassCd    '判定分類コード
Dim lngTtlCmtCnt        '行数

Dim lngChartCnt         'チャート情報件数
Dim lngCautionCnt       '注意事項件数

'2004.11.21 ADD STR ORB)T.Yaguchi フォロー追加
Dim blnFollowFlg        'フォロー存在フラグ
'2004.11.21 ADD END

'#### 2008.12.01 張 フォローアップ対象者チェックロジック追加 Start ####
Dim blnFollowTarget     'フォロー対象者フラグ
'#### 2008.12.01 張 フォローアップ対象者チェックロジック追加 End   ####

'#### 2009.10.03 張 フォローアップ対象者チェックロジック追加 Start ####
Dim lngFollowTarget     'フォロー対象者フラグ
'#### 2009.10.03 張 フォローアップ対象者チェックロジック追加 End   ####

'#### 2009.10.03 張 前回フォロー情報取得用
Dim lngFolRsvNo         'フォロー前回予約番号
Dim dtmFolCslDate       'フォロー前回受診日
Dim strFolCsCd          'フォロー前回コースコード
Dim blnFollowBefore     'フォロー前回存在フラグ

'UpdateResult_tk パラメータ
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntResult           '検査結果
Dim vntRslCmtCd1        '結果コメント１
Dim vntRslCmtCd2        '結果コメント２
Dim strUpdUser          '更新者
Dim strIPAddress        'IPアドレス

'前回歴コースコンボボックス
Dim strArrLastCsGrp()           'コースグループコード
Dim strArrLastCsGrpName()       'コースグループ名称

Dim i                   'ループカウンタ
Dim j                   'ループカウンタ

Dim strMessage          '結果登録復帰値

'2006.01.04  Add By 李　STR) ----------------------->
Dim lngDisCnt           '病歴情報の件数
Dim lngJikakuCnt        '自覚症状情報の件数
'2006.01.04  Add By 李　END) ----------------------->

'*** 2008.02.26　 特定健診追加　STR
Dim blnSpCheck    '特定健診対象かチェック
'*** 2008.02.26　 特定健診追加　END

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objResult       = Server.CreateObject("HainsResult.Result")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
'2004.11.21 ADD STR ORB)T.Yaguchi フォロー追加
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
'2004.11.21 ADD END

Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'2008.02.26 特定健診追加 STR
Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'2008.02.26 特定健診追加 END

'引数値の取得
strAct          = Request("action")

lngRsvNo        = Request("rsvno")
strCsCd         = Request("cscd")
strWinMode      = Request("winmode")
strGrpCd        = Request("grpcd")

lngDocIndex     = Request("docIndex")

vntDocItemCd    = ConvIStringToArray(Request("docItemCd"))
vntDocSuffix    = ConvIStringToArray(Request("docSuffix"))
strDocStcCd     = Request("docStcCd")

strSelCsGrp     = Request("csgrp")
strSelCsGrp     = IIf( strSelCsGrp="", "0", strSelCsGrp)

Select Case strSelCsGrp
    'すべてのコース
    Case "0"
        lngLastDspMode = 0
        vntCsGrp = ""
    '同一コース
    Case "1"
        lngLastDspMode = 1
        vntCsGrp = strCsCd
    Case Else
        lngLastDspMode = 2
        vntCsGrp = strSelCsGrp
End Select

strUpdUser        = Session.Contents("userId")
strIPAddress      = Request.ServerVariables("REMOTE_ADDR")

Do
    
    '判定医セットまたはクリア
    If strAct = "setAuther"  Or strAct = "clrAuther" Then
        
        vntItemCd = Array()
        Redim Preserve vntItemCd(0)
        vntItemCd(0) = vntDocItemCd(lngDocIndex-1)

        vntSuffix  = Array()
        Redim Preserve vntSuffix(0)
        vntSuffix(0) = vntDocSuffix(lngDocIndex-1)

        If strAct = "clrAuther" Then
            strDocStcCd = ""
        End If
        vntResult  = Array()
        Redim Preserve vntResult(0)
        vntResult(0) = strDocStcCd

        vntRslCmtCd1  = Array()
        Redim Preserve vntRslCmtCd1(0)
        vntRslCmtCd2  = Array()
        Redim Preserve vntRslCmtCd2(0)
'## 2003.11.16 Mod By T.Takagi@FSIT
'       strMessage = objResult.UpdateRsl_tk( _
'                           strUpdUser, _
'                           strIPAddress, _
'                           lngRsvNo, _
'                           vntItemCd, _
'                           vntSuffix, _
'                           vntResult, _
'                           vntRslCmtCd1, _
'                           vntRslCmtCd2 _
'                         ) 
        objResult.UpdateResult lngRsvNo, strIPAddress, strUpdUser, vntItemCd, vntSuffix, vntResult, vntRslCmtCd1, vntRslCmtCd2, strMessage
'## 2003.11.16 Mod End
        strAct = ""
    
    End If

    '検索条件に従い受診情報一覧を抽出する
    lngCount = objInterview.SelectConsultHistory( _
                                lngRsvNo, _
                                 , _
                                lngLastDspMode, _
                                vntCsGrp, _
                                3, _
                                 ,  , _
                                vntCslRsvNo, _
                                vntCslCslDate, _
                                vntCslCsCd, _
                                vntCslCsName, _
                                vntCslCsSName _
                                )

    If lngCount <= 0 Then
        Err.Raise 1000, , "受診情報がありません。RsvNo= " & lngLastDspMode & "(" & lngRsvNo 
    End If

    '今回コースコード退避
    strCsCd = vntCslCsCd(0)

    '検索条件に従い判定結果一覧を抽出する
    ' ## UPDFLG 追加　2003.12.26
    lngCount = objInterview.SelectJudHistoryRslList( _
                                                lngRsvNo, _
                                                3, _
                                                lngLastDspMode, _
                                                vntCsGrp, _
                                                1, _
                                                 , _
                                                 , _
                                                vntRsvNo, _
                                                vntSeq, _
                                                vntJudClassCd, _
                                                vntJudClassName, _
                                                vntJudCd, _
                                                vntJudSName, _
                                                vntWeight, _
                                                vntUpdUser, _
                                                 ,  ,  _
                                                vntResultDispMode, _
                                                vntUpdFlg _
                                                )
    If lngCount <= 0 Then
        Err.Raise 1000, , "判定結果がありません。RsvNo= " & lngRsvNo
    End If


''## 2006.05.10 Mod by 李  *****************************
' Parameter - lngLastDspMode , vntCsGrp 追加

    '判定医検索
'    lngJudDocCnt = objInterview.SelectHistoryRslList( _
'                        lngRsvNo, _
'                        1, _
'                        JUDDOC_GRPCD, _
'                        0, _
'                        "", _
'                        0, _
'                        , , _
'                        , , _
'                        vntDocSeq, _
'                        vntDocRsvNo, _
'                        vntDocItemCd, _
'                        vntDocSuffix, _
'                         , _
'                        vntDocItemType, _
'                        vntDocItemName, _
'                        vntDocterName _
'                        )

    lngJudDocCnt = objInterview.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        JUDDOC_GRPCD, _
                        lngLastDspMode, _
                        vntCsGrp, _
                        0, _
                        , , _
                        , , _
                        vntDocSeq, _
                        vntDocRsvNo, _
                        vntDocItemCd, _
                        vntDocSuffix, _
                         , _
                        vntDocItemType, _
                        vntDocItemName, _
                        vntDocterName _
                        )
''## 2006.05.10 Mod End. *********************************



''## 2006/01/04 Add By 李  STR) ---------------------->

'''#### 2013.02.01 張 当日複数予約が存在した場合の不具合対応　MOD START #### **
'''## 病歴検索 
'    lngDisCnt = objInterview.SelectHistoryRslList( _
'                        lngRsvNo, _
'                        1, _
'                        GRPCD_DISEASEHISTORY, _
'                        0, _
'                        "", _
'                        0 )
'
'''## 自覚症状検索 
'    lngJikakuCnt = objInterview.SelectHistoryRslList( _
'                        lngRsvNo, _
'                        1, _
'                        GRPCD_JIKAKUSYOUJYOU, _
'                        0, _
'                        "", _
'                        0 , 0 , 0 )

''## 病歴検索 
    lngDisCnt = objInterview.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        GRPCD_DISEASEHISTORY, _
                        1, _
                        strCsCd, _
                        0 )

''## 自覚症状検索 
    lngJikakuCnt = objInterview.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        GRPCD_JIKAKUSYOUJYOU, _
                        1, _
                        strCsCd, _
                        0 , 0 , 0 )

'''#### 2013.02.01 張 当日複数予約が存在した場合の不具合対応　MOD END   #### **



''## 2006/01/04 Add By 李 END) ---------------------->


    '総合コメント取得
'** #### 2011.11.17 SL-SN-Y0101-007 MOD START #### **
'    lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
'                                        lngRsvNo, 1, _
'                                        1, 0,  , 0, _
'                                        vntCmtSeq, _
'                                        vntTtlJudCmtCd, _
'                                        vntTtlJudCmtstc, _
'                                        vntTtlJudClassCd _
'                                        )
    

    lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
                                        lngRsvNo, 1, _
                                        1, 1, strCsCd, 0, _
                                        vntCmtSeq, _
                                        vntTtlJudCmtCd, _
                                        vntTtlJudCmtstc, _
                                        vntTtlJudClassCd _
                                        )
'** #### 2011.11.17 SL-SN-Y0101-007 MOD END #### **

    'チャート情報の件数取得
    lngChartCnt = objPubNote.SelectPubNote(PUBNOTE_SELINFO,  _
                                        0, "", "",           _
                                        lngRsvNo,            _
                                        "", "", "", "", 0,   _
                                        CHART_NOTEDIV,       _
                                        PUBNOTE_DISPKBN,   	 _
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
    '注意事項の件数取得
    lngCautionCnt = objPubNote.SelectPubNote(PUBNOTE_SELINFO,  _
                                        0, "", "",           _
                                        lngRsvNo,            _
                                        "", "", "", "", 0,   _
                                        CAUTION_NOTEDIV,     _
                                        PUBNOTE_DISPKBN,   	 _
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


'2004.11.08 ADD STR ORB)T.Yaguchi フォロー追加
    'フォローアップ取得
'    blnFollowFlg = objFollowUp.SelectFollow(lngRsvNo)
'2004.11.08 ADD END

'#### 2009.10.03 張 フォローアップ関連ロジック追加 Start ####

    '前回フォロー情報登録有無チェック及びキーデータ取得
    blnFollowBefore = objFollow.SelectFollow_Before(lngRsvNo, lngFolRsvNo, dtmFolCslDate, strFolCsCd)

    'フォローアップ情報登録有無チェック
    blnFollowFlg = objFollow.SelectFollow_Info(lngRsvNo, FOLLOW_JUDCLASS)

    'フォローアップ対象者チェック
    blnFollowTarget = objFollowUp.SelectTargetFollow(lngRsvNo)

    'フォローアップ対象者チェック
    '### 2009.12.16 張 COM+モジュール仕様変更によって修正 Start ###
    'lngFollowTarget = objFollow.SelectTargetFollow(lngRsvNo, , , , , , , , , _
    '                                               , , , , , , , , , , , , , , , , , , True)

    '### 2016.02.18 張 子宮頸部細胞診フォローアップ追加に伴う仕様変更 START ###
    'lngFollowTarget = objFollow.SelectTargetFollow(lngRsvNo, , , , , , , , , _
    '                                               , , , , , , , , , , , , , , , , , , , True)
    lngFollowTarget = objFollow.SelectTargetFollow(lngRsvNo, , , , , , , , , _
                                                   , , , , , , , , , , , , , , , , , , , , , True)
    '### 2016.02.18 張 子宮頸部細胞診フォローアップ追加に伴う仕様変更 START ###

    '### 2009.12.16 張 COM+モジュール仕様変更によって修正 End   ###

'#### 2009.10.03 張 フォローアップ関連ロジック追加 Start ####


'*** 2008.02.26 特定健診追加　STR
    '特定健診対象区分
    blnSpCheck = objSpecialInterview.SelectSetClassCd(lngRsvNo)
'*** 2008.02.26 特定健診追加　END

    Exit Do
Loop

Set objHainsUser    = Nothing
Set objInterview    = Nothing
Set objResult       = Nothing
Set objPubNote      = Nothing
Set objFollowUp     = Nothing

Set objSpecialInterview      = Nothing

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>総合判定入力</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
var winMenResult;               // ウィンドウハンドル
var winFollow;                  // ウィンドウハンドル

//検査結果画面呼び出し
function callMenResult( classgrpno ) {

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
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winMenResult.focus();
        winMenResult.location.replace( url );
    } else {
        //winMenResult = window.open( url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        winMenResult = window.open( url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}

//総合判定入力画面呼び出し
function calltotalJudEdit() {
    var url;                            // URL文字列

    url = '/WebHains/contents/interview/totalJudEdit.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

//虚血性心疾患指導表パターン呼び出し
function callMenKyoketsu() {
    var url;                            // URL文字列

    url = '/WebHains/contents/interview/MenKyoketsu.asp?grpno=13';
    url = url + '&winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

//栄養指導呼び出し
function callMenEiyoShido() {
    var url;                            // URL文字列

    url = '/WebHains/contents/interview/MenEiyoShido.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}
<% '## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替 %>
// 食習慣呼び出し
function callShokushukan() {

    var url;                            // URL文字列

    url = '/WebHains/contents/interview/Shokusyukan.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}
<% '## 2012.09.11 Add End %>
//ＣＵ経年変化呼び出し
function callCUSelectItemsMain() {
    var url;                            // URL文字列

    url = '/WebHains/contents/interview/CUSelectItemsMain.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

//病歴情報呼び出し
function callDiseaseHistory() {
    var url;                            // URL文字列

    url = '/WebHains/contents/interview/DiseaseHistory.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}
//** 2009.10.27 コメント一覧のディフォルト表示期間を受診日を基準とし、過去5年前からに変更 Start **//
//コメント一覧（チャート情報、注意事項）呼び出し
function callCommentList( noteDiv ) {
    var url;                            // URL文字列

    url = '/WebHains/contents/comment/commentMainFlame.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&PubNoteDivCd=' + noteDiv;
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&strYear=' + '<%= Year(DateAdd("yyyy",-5,vntCslCslDate(0))) %>';
    url = url + '&strMonth=' + '<%= Month(DateAdd("yyyy",-5,vntCslCslDate(0))) %>';
    url = url + '&strDay=' + '<%= Day(DateAdd("yyyy",-5,vntCslCslDate(0))) %>';
    url = url + '&endYear=' + '<%= Year(vntCslCslDate(0)) %>';
    url = url + '&endMonth=' + '<%= Month(vntCslCslDate(0)) %>';
    url = url + '&endDay=' + '<%= Day(vntCslCslDate(0)) %>';

    parent.location.href(url);

}

////コメント一覧（チャート情報、注意事項）呼び出し
//function callCommentList( noteDiv ) {
//    var url;                            // URL文字列
//
//    url = '/WebHains/contents/comment/commentMainFlame.asp?';
//    url = url + 'winmode=' + '<%= strWinMode %>';
//    url = url + '&rsvno=' + '<%= lngRsvNo %>';
//    url = url + '&grpcd=' + '<%= strGrpCd %>';
//    url = url + '&PubNoteDivCd=' + noteDiv;
//    url = url + '&DispMode=2';
//    url = url + '&DispKbn=1';
//    url = url + '&cmtMode=1,1,0,0';
//    url = url + '&cscd=' + '<%= strCsCd %>';
//    url = url + '&strYear=' + '<%= Year(vntCslCslDate(0)) %>';
//    url = url + '&strMonth=' + '<%= Month(vntCslCslDate(0)) %>';
//    url = url + '&strDay=' + '<%= Day(vntCslCslDate(0)) %>';
//    url = url + '&endYear=' + '<%= Year(vntCslCslDate(0)) %>';
//    url = url + '&endMonth=' + '<%= Month(vntCslCslDate(0)) %>';
//    url = url + '&endDay=' + '<%= Day(vntCslCslDate(0)) %>';
//
//    parent.location.href(url);
//
//}
//** 2009.10.27 コメント一覧のディフォルト表示期間を受診日を基準とし、過去5年前からに変更 End **//

//問診画面呼び出し
function callMonshinNyuryoku() {
    var url;                            // URL文字列

    url = '/WebHains/contents/interview/MonshinNyuryoku.asp?grpno=24';
    url = url + '&winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}
//特定健診専用面接画面呼び出し
var winSpecialResult; 

function callSpecialKenshin() {
    
    var url;               //URL文字列
    var opened = false;    //画面がすでに開かれているか

    //すでにガイドが開かれているかチェック
    if ( winSpecialResult != null ) {
        if ( !winSpecialResult.closed ) {
            opened = true;
        }
    }

//    url = '/WebHains/contents/interview/specialJudView.asp?';
    url = '/WebHains/contents/interview/specialInterviewTop.asp?';
    url = url + 'winmode=1';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';

    //開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winSpecialResult.focus();
        winSpecialResult.location.replace( url );
    } else {
        winSpecialResult = window.open( url,'','width=1000,height=750,location=yes,status=yes,directories=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes');
    }
}

//特定健診専用面接画面呼び出し
/*　function showSpecialKenshin() {
    var url;	// URL文字列

    url = '/WebHains/contents/interview/specialJudView.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';

    parent.location.href(url);
}
*/

// '2004.10.21 MOD STR ORB)T.Yaguchi 
//フォローアップ入力画面呼び出し
//function callfollowupNyuryoku( noteDiv ) {
//    var url;                            // URL文字列
//
//    url = '/WebHains/contents/followup/followupTop.asp';
//    url = url + '?winmode=' + '<%= strWinMode %>';
//    url = url + '&PubNoteDivCd=' + noteDiv;
//    url = url + '&DispMode=2';
//    url = url + '&DispKbn=1';
//    url = url + '&cmtMode=1,1,0,0';
//    url = url + '&cscd=' + '<%= strCsCd %>';
//    url = url + '&strYear=' + '<%= Year(vntCslCslDate(0)) %>';
//    url = url + '&strMonth=' + '<%= Month(vntCslCslDate(0)) %>';
//    url = url + '&strDay=' + '<%= Day(vntCslCslDate(0)) %>';
//    url = url + '&endYear=' + '<%= Year(vntCslCslDate(0)) %>';
//    url = url + '&endMonth=' + '<%= Month(vntCslCslDate(0)) %>';
//    url = url + '&endDay=' + '<%= Day(vntCslCslDate(0)) %>';
//    url = url + '&rsvno=' + '<%= lngRsvNo %>';
//    url = url + '&grpcd=' + '<%= strGrpCd %>';
//
//    parent.location.href(url);
//
//}
// '2004.10.21 MOD END

// 2009.10.03 張 フォローアップ登録画面呼び出し
function callfollowupNyuryoku( noteDiv ) {
    var url;                            // URL文字列

    url = '/WebHains/contents/follow/followInfoTop.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&PubNoteDivCd=' + noteDiv;
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&strYear=' + '<%= Year(vntCslCslDate(0)) %>';
    url = url + '&strMonth=' + '<%= Month(vntCslCslDate(0)) %>';
    url = url + '&strDay=' + '<%= Day(vntCslCslDate(0)) %>';
    url = url + '&endYear=' + '<%= Year(vntCslCslDate(0)) %>';
    url = url + '&endMonth=' + '<%= Month(vntCslCslDate(0)) %>';
    url = url + '&endDay=' + '<%= Day(vntCslCslDate(0)) %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';

    parent.location.href(url);

}

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


/** 2008.04.10 張 山川さんからの依頼によって追加（暫定処理） Start **/
/** フォローアップ画面呼び出し **/
function callfollowupNew( noteDiv ) {
    var url;                            // URL文字列

    url = 'http://157.104.16.154/Dock/FollowUp/SummaryFH.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';
    url = url + '&userid=' + '<%= strUpdUser %>';

    parent.location.href(url);

}
/** 2008.04.10 張 山川さんからの依頼によって追加（暫定処理） End   **/


//変更履歴画面呼び出し
function callrslUpdateHistory() {
    var url;                            // URL文字列

    url = '/WebHains/contents/interview/rslUpdateHistory.asp?grpno=20';
    url = url + '&winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';

    parent.location.href(url);

}

//過去総合コメント一覧画面呼び出し
function callOldJudComment() {
    var url;                            // URL文字列

    url = '/WebHains/contents/interview/viewOldJudComment.asp?';
    url = url + 'winmode=0';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

var winEntryAuther;                     // ウィンドウハンドル
//担当者登録ウインドウ呼び出し
function showTantouWindow() {

    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか


    // すでにガイドが開かれているかチェック
    if ( winEntryAuther != null ) {
        if ( !winEntryAuther.closed ) {
            opened = true;
        }
    }
    url = '/WebHains/contents/interview/EntryAuther.asp?rsvno=' + <%= lngRsvNo %>;

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winEntryAuther.focus();
        winEntryAuther.location.replace( url );
    } else {
        winEntryAuther = window.open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}


// 2006.01.04 Add By 李  STR. -------------------------------------->
//自覚症状ウインドウ呼び出し
var winJikakushoujyou;                  // ウィンドウハンドル
function showJikakushoujyou() {

    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか


    // すでにガイドが開かれているかチェック
    if ( winJikakushoujyou != null ) {
        if ( !winJikakushoujyou.closed ) {
            opened = true;
        }
    }
    url = '/WebHains/contents/interview/jikakushoujyou.asp?rsvno=' + <%= lngRsvNo %>;

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winJikakushoujyou.focus();
        winJikakushoujyou.location.replace( url );
    } else {
        winJikakushoujyou = window.open( url, '', 'width=900,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}
// 2006.01.04 Add By 李  END. -------------------------------------->


var lngSelectedIndex1;  // ガイド表示時に選択されたエレメントのインデックス

//判定医選択ウインドウ表示
function showUserWindow(index, docItemCd) {

    var objForm = document.entryForm;	// 自画面のフォームエレメント

    // 選択されたエレメントのインデックスを退避(定性結果のセット用関数にて使用する)
    lngSelectedIndex1 = index;


    // ガイド画面の連絡域に検査項目コード（判定医）を設定する
    stcGuide_ItemCd = docItemCd;

    // ガイド画面の連絡域に項目タイプ（標準）を設定する
    stcGuide_ItemType = 0;

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

    var myForm = document.entryForm;    // 自画面のフォームエレメント
    var objDocCd, objDocName;           // 結果・文章のエレメント
    var stcNameElement;                 // 文章のエレメント

    // 編集エレメントの設定
    objDocCd   = myForm.docStcCd;
    objDocName = myForm.docName[ index-1 ];

    stcNameElement = 'docName' + index;

    // 値の編集
    objDocCd.value   = stcCd;
    objDocName.value = shortStc;


//  if ( document.getElementById(stcNameElement) ) {
//      document.getElementById(stcNameElement).innerHTML = shortStc;
//  }

    myForm.docIndex.value = index;
    myForm.action.value = "setAuther";
    myForm.submit();

}

//判定医クリア
function clrUser(index, docname) {

    var myForm = document.entryForm;    // 自画面のフォームエレメント

    if ( !confirm( docname + "をクリアしますか？" )){
        return;
    }
    myForm.docIndex.value = index;
    myForm.action.value = "clrAuther";
    myForm.submit();

}

function windowClose() {

    // 担当者登録ウインドウを閉じる
    if ( winEntryAuther != null ) {
        if ( !winEntryAuther.closed ) {
            winEntryAuther.close();
        }
    }
    winEntryAuther = null;

    // 検査結果ウインドウを閉じる
    if ( winMenResult != null ) {
        if ( !winMenResult.closed ) {
            winMenResult.close();
        }
    }
    winMenResult = null;

    // 2006.01.04 Add By 李　STR) --------------->
    // 自覚症状ウインドウを閉じる
    if ( winJikakushoujyou != null ) {
        if ( !winJikakushoujyou.closed ) {
            winJikakushoujyou.close();
        }
    }
    winJikakushoujyou = null;
    // 2006.01.04 Add By 李　END) --------------->


    //文章ガイドを閉じる
    closeGuideStc();
}

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">

    <INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd" VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpcd" VALUE="<%= strGrpCd %>">
    <INPUT TYPE="hidden" NAME="docIndex" VALUE="<%= lngDocIndex %>">
    <INPUT TYPE="hidden" NAME="docStcCd" VALUE="<%= strDocStcCd %>">

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD VALIGN="TOP">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD ROWSPAN="2" WIDTH="119">分類</TD>
                        <TD COLSPAN="3" WIDTH="180">判定結果</TD>
                        <TD ROWSPAN="2" WIDTH="106">分類</TD>
                        <TD COLSPAN="3" WIDTH="190">判定結果</TD>
                    </TR>
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD WIDTH="50">今回</TD>
                        <TD WIDTH="60">前回</TD>
                        <TD WIDTH="60">前々回</TD>
                        <TD WIDTH="60">今回</TD>
                        <TD WIDTH="60">前回</TD>
                        <TD WIDTH="60">前々回</TD>
                    </TR>
<%
                    lngJudClassCount = 0
                    lngLastJudClassCd = 0
                    lngDspPoint = 0
                    For i = 0 To lngCount - 1
                        '判定分類が変わった？
                        If lngLastJudClassCd <> vntJudClassCd(i) Then
                            lngJudClassCount = lngJudClassCount + 1
                            lngLastJudClassCd = vntJudClassCd(i)
                        End If
                        
                        If (CLng(lngDspPoint) Mod 6) = 0 Then
%>
                            <TR BGCOLOR="#eeeeee" HEIGHT="18">
<%
                        End If

%>
<%
                        If (CLng(lngDspPoint) Mod 3) = 0 Then
                            If IsNumeric( vntResultDispMode(i) ) = True Then
%>
                                <TD WIDTH="119"><A HREF="javascript:callMenResult(<%= vntResultDispMode(i) %>)"><%= vntJudClassName(i) %></A></TD>
<%
                            Else
%>
                                <TD WIDTH="119"><%= vntJudClassName(i) %></A></TD>
<%
                            End If
                        End If

                        If vntSeq(i) = 1 Then
                            '依頼無し
                            If vntRsvNo(i) = "" Then
%>
                                <TD ALIGN="center" WIDTH="50"><FONT COLOR="999999"><B>***</B></FONT></TD>
<%
                            Else
                                '修正された？
                                ' ## 更新フラグで見る 2003.12.26
'''                             If Trim(vntUpdUser(i)) <> Trim(AUTOJUD_USER) And _
                                If Trim(vntUpdFlg(i)) = "1" And _
                                   vntRsvNo(i) <> "" And _
                                   vntJudCd(i) <> "" Then
%>
                                    <!--### 2006.03.08 張 変更判定に対する背景色変更（ピンク色⇒灰色) Start ###-->
                                    <!--TD BGCOLOR="#ffc0cb" ALIGN="center" WIDTH="50"><B><%= vntJudCd(i) %></B></TD-->
                                    <TD BGCOLOR="#cccccc" ALIGN="center" WIDTH="50"><B><%= vntJudCd(i) %></B></TD>
                                    <!--### 2006.03.08 張 変更判定に対する背景色変更（ピンク色⇒灰色) End   ###-->
<%
                                Else
%>
                                    <TD ALIGN="center" WIDTH="50"><B><%= vntJudCd(i) %></B></TD>
<%
                                End If
                            End If
                        Else
                            '依頼無し
                            If vntRsvNo(i) = "" Then
%>
                                <TD ALIGN="center" WIDTH="60"><FONT COLOR="999999"><B>***</B></FONT></TD>
<%
                            Else
                                '修正された？
                                ' ## 更新フラグで見る 2003.12.26
'                               If Trim(vntUpdUser(i)) <> Trim(AUTOJUD_USER)  And _
                                If Trim(vntUpdFlg(i)) = "1" And _
                                   vntRsvNo(i) <> "" And _
                                   vntJudCd(i) <> "" Then
%>
                                    <!--### 2006.03.08 張 変更判定に対する背景色変更（ピンク色⇒灰色) Start ###-->
                                    <!--TD BGCOLOR="#ffc0cb" ALIGN="center" WIDTH="60"><B><%= vntJudCd(i) %></B></TD-->
                                    <TD BGCOLOR="#cccccc" ALIGN="center" WIDTH="60"><B><%= vntJudCd(i) %></B></TD>
                                    <!--### 2006.03.08 張 変更判定に対する背景色変更（ピンク色⇒灰色) End   ###-->
<%
                                Else
%>
                                    <TD ALIGN="center" WIDTH="60"><B><%= vntJudCd(i) %></B></TD>
<%
                                End If
                            End If
                        End If

                        lngDspPoint = CLng(lngDspPoint) + 1
                    Next
%>
                </TABLE>
            </TD>

            
            <!--## 担当者表示領域 病歴情報、チャート情報、注意事項、問診内容ボタンをこのエリアに移る Start ##-->
            <!--## 2006/02/16 張                                                                     ##-->
            <TD height="1">
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3" height="100%">

                    <TR height="40%">
                        <TD align="center" VALIGN="top">
                            <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
                            
                                <TR>
            <%
                                    '病歴情報あり？
                                    If lngDisCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callDiseaseHistory()"><FONT  SIZE="+1" COLOR="FF00FF">病歴情報</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callDiseaseHistory()"><IMAGE SRC="/webHains/images/diseasehistory.gif" ALT="病歴情報画面を表示します" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>

                                <TR>
            <%
                                    'チャート情報あり？
                                    If lngChartCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callCommentList( '<%= CHART_NOTEDIV %>' )"><FONT  SIZE="+1" COLOR="FF00FF">チャート情報</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callCommentList( '<%= CHART_NOTEDIV %>')"><IMAGE SRC="/webHains/images/chartinfo.gif" ALT="チャート情報を表示します" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>
                                <TR>
            <%
                                    '注意事項あり？
                                    If lngCautionCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callCommentList( '<%= CAUTION_NOTEDIV %>' )"><FONT SIZE="+1" COLOR="FF00FF">注意事項</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callCommentList( '<%= CAUTION_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/caution.gif" ALT="注意事項を表示します" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>
                                
                                <TR>
                                    <TD ALIGN="center" BGCOLOR="ffffff">
                                        <A HREF="javascript:callMonshinNyuryoku()"><IMAGE SRC="/webHains/images/monshin.gif" ALT="問診を表示します" BORDER="0"></A></TD>
                                </TR>
                                <TR>
            <%
                                    '自覚症状あり？
                                    If lngJikakuCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150">
                                            <A HREF="javascript:showJikakushoujyou()"><FONT SIZE="+1" COLOR="FF00FF">自覚症状</FONT></A></TD>
            <%
                                    Else
            %>
                                    <TD ALIGN="center" NOWRAP>　</TD>
            <%
                                    End If
            %>
                                </TR>

                                <TR>
            <%
                                  '特定健診対象
                                  IF blnSpCheck = true  Then
            %>
                                    <TD ALIGN="center" BGCOLOR="ffffff">
                                        <A HREF="javascript:callSpecialKenshin()"><IMAGE SRC="/webHains/images/special.gif" ALT="特定健診対象のみ表示します" BORDER="0"></A></TD>
            <%                    
                                  Else
            %>
                                    <TD ALIGN="center" NOWRAP>  </TD>
            <%                       
                                  End IF
            %>
                                </TR>

                            </TABLE>
                        </TD>
                    </TR>


                    <TR HEIGHT="60%">
                        <TD VALIGN="bottom">
                            <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">

        <%
                            If lngJudDocCnt > 0 Then
                                For i = 1 To lngJudDocCnt
        %>
                                    <INPUT TYPE="hidden" NAME="docItemCd" VALUE="<%= vntDocItemCd(i-1) %>">
                                    <INPUT TYPE="hidden" NAME="docSuffix" VALUE="<%= vntDocSuffix(i-1) %>">
                                    <INPUT TYPE="hidden" NAME="docName" VALUE="<%= vntDocterName(i-1) %>">
                                
                                    <TR BGCOLOR="#eeeeee" HEIGHT="21">
                                        <TD NOWRAP><%= vntDocItemName(i-1) %></TD>
        <!--
                                        <TD><A HREF="javascript:showUserWindow(<%= i %>, <%= vntDocItemCd(i-1) %>)"><IMG SRC="../../images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                                        <TD><A HREF="javascript:clrUser(<%= i %>, '<%= vntDocItemName(i-1) %>')"><IMG SRC="../../images/delicon.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
        -->
                                        <TD NOWRAP><SPAN ID="docName<%= i %>"><%= vntDocterName(i-1) %></SPAN></TD>
                                    </TR>
        <%
                                Next
                            End If
        %>
                            </TABLE>
                        </TD>
                    </TR>

                </TABLE>
            </TD>
            <!--## 2006/02/16 張                                                                     ##-->
            <!--## 担当者表示領域 病歴情報、チャート情報、注意事項、問診内容ボタンをこのエリアに移る End   ##-->

            
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD>

            <!--## 各ボタンの領域 Start ########################################################-->
            <TD ROWSPAN="2" height="1">
                <TABLE WIDTH="64" BORDER="0" CELLSPACING="3" CELLPADDING="2" height="100%">

                    <TR HEIGHT="70%">
                        <TD VALIGN="top">
                            <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">


                                <TR>
                                    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:calltotalJudEdit()"><IMAGE SRC="/webHains/images/judedit.gif" ALT="判定修正画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                    <%  end if  %>
                                </TR>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callMenKyoketsu()"><IMAGE SRC="/webHains/images/kyoketsu.gif" ALT="虚血性心疾患画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
                                <TR>
<%
'## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替
								'切替日以降の受診日であれば食習慣ボタンを表示
								If IsVer201210(lngRsvNo) Then
'## 2012.09.11 Add End
%>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callShokushukan()"><IMAGE SRC="/webHains/images/shokushukan.gif" ALT="食習慣画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
<%
'## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替
								Else
'## 2012.09.11 Add End
%>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callMenEiyoShido()"><IMAGE SRC="/webHains/images/eiyoshido.gif" ALT="栄養指導画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
<%
'## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替
								End If
'## 2012.09.11 Add End
%>
                                </TR>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCUSelectItemsMain()"><IMAGE SRC="/webHains/images/cuselect.gif" ALT="CU経年変化画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callrslUpdateHistory()"><IMAGE SRC="/webHains/images/updatehistory.gif" ALT="変更履歴画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
                                
            <!--## 担当者表示領域 病歴情報、チャート情報、注意事項、問診内容ボタンをこのエリアに移る Start ##-->
            <!--## 2006/02/16 張                                                                     ##-->
                                <!--TR>
            <%
                                    '病歴情報あり？
                                    If lngDisCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callDiseaseHistory()"><FONT  SIZE="+1" COLOR="FF00FF">病歴情報</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callDiseaseHistory()"><IMAGE SRC="/webHains/images/diseasehistory.gif" ALT="病歴情報画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>

                                <TR>
            <%
                                    'チャート情報あり？
                                    If lngChartCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCommentList( '<%= CHART_NOTEDIV %>' )"><FONT  SIZE="+1" COLOR="FF00FF">チャート情報</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCommentList( '<%= CHART_NOTEDIV %>')"><IMAGE SRC="/webHains/images/chartinfo.gif" ALT="チャート情報を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>
                                <TR>
            <%
                                    '注意事項あり？
                                    If lngCautionCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCommentList( '<%= CAUTION_NOTEDIV %>' )"><FONT SIZE="-1" COLOR="FF00FF">注意事項</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCommentList( '<%= CAUTION_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/caution.gif" ALT="注意事項を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>
                                
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callMonshinNyuryoku()"><IMAGE SRC="/webHains/images/monshin.gif" ALT="問診を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
                                
                                <TR>
            <%
                                    '自覚症状あり？
                                    If lngJikakuCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:showJikakushoujyou()"><FONT SIZE="+1" COLOR="FF00FF">自覚症状</FONT></A></TD>
            <%
                                    Else
            %>
                                    <TD ALIGN="center" NOWRAP>　</TD>
            <%
                                    End If
            %>
                                </TR-->
            <!--## 2006/02/16 張                                                                     ##-->
            <!--## 担当者表示領域 病歴情報、チャート情報、注意事項、問診内容ボタンをこのエリアに移る End   ##-->

                            </TABLE>
                        </TD>
                    </TR>


                    <TR HEIGHT="30%">
                        <TD VALIGN="bottom">
                            <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">

                                    <% '2004.10.21 MOD STR ORB)T.Yaguchi %>
                                <!--TR>
                                    <TD><IMAGE SRC="/webHains/images/spacer.gif" HEIGHT="10" WIDTH="1"></TD>-->
                                </TR>

            <!--## 2009/10/03 張 前回フォローアップ画面にリンク Start ##-->
            <%
                            '#### 2009.10.03 張 前回フォロー情報が登録されている場合、ボタン表示
                            If blnFollowBefore = True Then
            %>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callfollowupBefore( '<%= CHART_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/followup_before.gif" ALT="前回フォローアップ画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
            <%
                            End If
            %>
            <!--## 2009/10/03 張 前回フォローアップ画面にリンク End   ##-->

                                <TR>
            <%
                                    'フォロ－あり？
                            If blnFollowFlg = True Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callfollowupNyuryoku( '<%= CHART_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/followup_up.gif" ALT="フォローアップ画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                            Else
                                '#### 2008.12.01 張 フォローアップ登録されていなかった場合、フォロー対象基準に当てはまる受診者のみボタン表示
                                'If blnFollowTarget = True Then
                                '#### 2008.10.03 張 仕様変更
                                If lngFollowTarget > 0 Then
            %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callfollowupNyuryoku( '<%= CHART_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/followup.gif" ALT="フォローアップ画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                                End If
                            End If
            %>
                                    <% '2004.10.21 MOD END %>

                                </TR>

            <!--## 2008/04/10 張 フォローアップ新規画面にリンク先変更 Start ##-->
            <%
                            '#### 2008.12.01 張 フォローアップ登録されていなかった場合、フォロー対象基準に当てはまる受診者のみボタン表示
                            'If blnFollowTarget = True Then
                            '#### 2008.10.03 張 仕様変更
                            If lngFollowTarget > 0 Then
            %>
                                <!--TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callfollowupNew()"><IMAGE SRC="/webHains/images/followupSec.gif" ALT="フォローアップ画面（開発バージョン）を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR-->
            <%
                            End If
            %>
            <!--## 2008/04/10 張 フォローアップ新規画面にリンク先変更 End   ##-->

                                <TR><TD><IMG SRC="../../images/spacer.gif" WIDTH="30" HEIGHT="10" ALT=""></TD></TR>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:showTantouWindow()"><IMAGE SRC="/webHains/images/tantou.gif" ALT="担当者登録ガイドを表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>

                            </TABLE>
                        </TD>
                    </TR>

                </TABLE>
            </TD>
            <!--## 各ボタンの領域 Start ########################################################-->

        </TR>

        
        
        <TR>
            <TD COLSPAN="2"></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="835">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="700">
                    <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">総合コメント</FONT></B></TD>
                </TABLE>
            </TD>
            <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callOldJudComment()"><IMAGE SRC="/webHains/images/oldjudcmnt.gif" ALT="過去総合コメント一覧を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="835">
<%
        For i = 0 To lngTtlCmtCnt - 1
%>
            <TR>
                <TD><%= vntTtlJudCmtstc(i) %></TD>
            </TR>
<%
        Next
%>
    </TABLE>
    <BR>
</FORM>
</BODY>
</HTML>