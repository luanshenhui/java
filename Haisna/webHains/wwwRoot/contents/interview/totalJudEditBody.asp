<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   総合判定（判定修正画面） (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const AUTOJUD_USER = "AUTOJUD"      '自動判定ユーザ

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objHainsUser        'ユーザー情報アクセス用
Dim objInterview        '面接情報アクセス用
Dim objJud              '判定情報アクセス用
Dim objJudgement        '判定結果アクセス用

Dim strAct              '処理状態
Dim strCmtMode          '総合コメント処理モード
Dim strWinMode          'ウインドウ表示モード（1:別ウインドウ、0:同ウインドウ）
Dim strGrpCd            'グループコード

Dim lngRsvNo            '予約番号（今回分）
Dim strCsCd             'コースコード（今回分）

Dim blnUpdated          'TRUE:変更あり、FALSE:変更なし

Dim lngEditFlg          '修正有無

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
Dim vntWebColor         '表示色
Dim vntUpdUser          '更新者
Dim vntUpdFlg           '更新フラグ   2003.12.26 add
Dim vntResultDispMode   '検査結果表示モード
Dim vntJudCmtCd         '判定コメントコード
Dim vntJudCmtstc        '判定コメント文章

'eGFR計算結果取得用
Dim vntHisNo            '表示位置
Dim vntHisCslDate       '受診日
Dim vntEGFR             'eGFR計算結果
Dim vntMDRD             'eGFR(MDRD式)計算結果
Dim vntNewGFR           'GFR(新しい日本人の推算式)計算結果


Dim lngJudClassCount    '判定分類件数
Dim lngLastJudClassCd   '前判定分類コード

Dim lngCount            '件数

Dim lngDspPoint         '表示位置

Dim lngEGFRCount        'EGFR取得件数
Dim lngMDRDCount        'EGFR(MDRD式)取得件数
Dim lngNewGFRCount      'GFR(新しい日本人の推算式)取得件数

'判定結果編集用領域
Dim vntEditJudClassCd   '判定分類コード
Dim vntEditJudCd        '判定コード
Dim vntEditJudCmtCd     '判定コメントコード

'実際に更新する項目情報
Dim strUpdRsvNo         '予約番号
Dim strUpdJudClassCd    '判定分類コード
Dim strUpdJudCd         '判定コード
Dim strUpdJudCmtCd      '判定コメントコード
Dim lngUpdCount         '更新項目数

'保存直前のサーバ内データ
Dim vntNewRsvNo         '予約番号
Dim vntNewSeq           '表示位置
Dim vntNewJudClassCd    '判定分類コード
Dim vntNewJudClassName  '判定分類名称
Dim vntNewJudCd         '判定コード
Dim vntNewJudSName      '判定略称
Dim vntNewWeight        '判定重み
Dim vntNewUpdUser       '更新者
Dim vntNewUpdFlg        '更新フラグ 2003.12.26
Dim vntNewUpdJudCmtCd   '判定コメントコード
Dim lngNewCount         '更新項目数

'総合コメント（編集開始時）
Dim vntCmtSeq           '表示順
Dim vntTtlJudCmtCd      '判定コメントコード
Dim vntTtlJudCmtstc     '判定コメント文章
Dim vntTtlJudClassCd    '判定分類コード
Dim vntTtlJudCd         '判定コード
Dim vntTtlWeight        '判定重み
Dim lngTtlCmtCnt        '行数

'総合コメント編集用領域
Dim vntEditCmtSeq           '表示順
Dim vntEditTtlCmtCd         '判定コメントコード
Dim vntEditJudCmtstc        '判定コメント文章
Dim vntEditJudCmtClassCd    '判定分類コード
Dim vntEditTtlJudCd         '判定コード
Dim vntEditTtlWeight        '判定重み
Dim lngEditCmtCnt           '行数

'総合コメント比較用領域（保存直前）
Dim vntNewCmtSeq        '表示順
Dim vntNewTtlCmtCd      '判定コメントコード
Dim vntNewJudCmtstc     '判定コメント文章
Dim vntNewTtlClassCd    '判定分類コード
Dim vntNewTtlJudCd      '判定コード
Dim vntNewTtlWeight     '判定重み
Dim lngNewCmtCnt        '行数

Dim strJudClassCd       '判定分類コード（総合コメント表示用）

'UpdateResult_tk パラメータ
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntResult           '検査結果
Dim vntRslCmtCd1        '結果コメント１
Dim vntRslCmtCd2        '結果コメント２

'前回歴コースコンボボックス
Dim strArrLastCsGrp()           'コースグループコード
Dim strArrLastCsGrpName()       'コースグループ名称

'判定コンボボックス
Dim strArrJudCdSeq      '判定連番
Dim strArrJudCd         '判定コード
Dim strArrWeight        '判定用重み
Dim lngJudListCnt       '判定件数

Dim i                   'ループカウンタ
Dim j                   'ループカウンタ

Dim strArrMessage       'エラーメッセージ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objJud          = Server.CreateObject("HainsJud.Jud")
Set objJudgement    = Server.CreateObject("HainsJudgement.Judgement")

'引数値の取得
strAct           = Request("action")
strCmtMode       = Request("cmtmode")

lngRsvNo         = Request("rsvno")
strCsCd          = Request("cscd")
strWinMode       = Request("winmode")
strGrpCd         = Request("grpcd")

'初期表示時の判定
vntSeq          = ConvIStringToArray(Request("orgSeq"))
vntJudClassCd   = ConvIStringToArray(Request("orgJudClassCd"))
vntJudCd        = ConvIStringToArray(Request("orgJudCd"))
lngCount        = CLng(Request("orgCount"))

vntEditJudClassCd   = ConvIStringToArray(Request("editJudclass"))
vntEditJudCd        = ConvIStringToArray(Request("editJudcd"))
vntEditJudCmtCd     = ConvIStringToArray(Request("editJudCmtCd"))

vntCmtSeq        = ConvIStringToArray(Request("orgCmtSeq"))
vntTtlJudCmtCd   = ConvIStringToArray(Request("orgTtlJudCmtCd"))
vntTtlJudCmtstc  = ConvIStringToArray(Request("orgTtlJudCmtstc"))
vntTtlJudClassCd    = ConvIStringToArray(Request("orgTtlJudClassCd"))
lngTtlCmtCnt     = CLng(Request("orgCmtCnt"))

vntEditCmtSeq    = ConvIStringToArray(Request("editCmtSeq"))
vntEditTtlCmtCd  = ConvIStringToArray(Request("editTtlCmtCd"))
vntEditJudCmtstc = ConvIStringToArray(Request("editJudCmtstc"))
vntEditJudCmtClassCd= ConvIStringToArray(Request("editJudCmtClassCd"))
lngEditCmtCnt    = CLng(Request("editTtlCnt"))

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

'判定取得
Call EditJudListInfo

Do
    
    '保存
    If strAct = "save"  Then
        
        '判定結果の保存
        ' ## UPDFLG 追加　2003.12.26
        '最新の判定結果再取得
        lngNewCount = objInterview.SelectJudHistoryRslList( _
                                                lngRsvNo, _
                                                3, _
                                                lngLastDspMode, _
                                                vntCsGrp, _
                                                1, _
                                                 , _
                                                 , _
                                                vntNewRsvNo, _
                                                vntNewSeq, _
                                                vntNewJudClassCd, _
                                                vntNewJudClassName, _
                                                vntNewJudCd, _
                                                vntNewJudSName, _
                                                vntNewWeight, _
                                                vntNewUpdUser, _
                                                vntNewUpdJudCmtCd _
                                                )
        strArrMessage = ""
        '修正前とサーバー内の状態が変わっているかチェック
        If lngNewCount <> lngCount Then
            strArrMessage = "判定データが他の人によって更新されているため保存できません。"
        Else
            For i = 0 To lngNewCount-1
                If  vntNewSeq(i) = 1 And _
                    vntNewJudCd(i) <> vntJudCd(i)  Then
                    strArrMessage = "判定データが他の人によって更新されているため保存できません。"
                    Exit For
                End If
            Next
        End If

        If strArrMessage = ""  Then
            '実際に更新を行う項目のみを抽出(初期表示データと異なるデータが更新対象)
            lngUpdCount = 0
            strUpdRsvNo       = Array()
            strUpdJudClassCd  = Array()
            strUpdJudCd       = Array()
            strUpdJudCmtCd    = Array()

            For i = 0 To UBound(vntEditJudClassCd)

                '判定が更新されていたらデータ更新
                blnUpdated = False
                If vntEditJudClassCd(i) <> "" Then
                    For j = 0 To lngNewCount-1
                        If vntNewSeq(j) = 1 And _
                           vntNewJudClassCd(j) = vntEditJudClassCd(i) And _
                           vntNewJudCd(j) <> vntEditJudCd(i) Then
                            blnUpdated = True
                            Exit For
                        End If
                    Next
                End If
            

                'データ更新状態なら配列を拡張して保存状態をセット
                If blnUpdated = True Then

                    ReDim Preserve strUpdRsvNo(lngUpdCount)
                    ReDim Preserve strUpdJudClassCd(lngUpdCount)
                    ReDim Preserve strUpdJudCd(lngUpdCount)
                    ReDim Preserve strUpdJudCmtCd(lngUpdCount)

                    strUpdRsvNo(lngUpdCount)  = lngRsvNo
                    strUpdJudClassCd(lngUpdCount)  = vntEditJudClassCd(i)
                    strUpdJudCd(lngUpdCount)       = vntEditJudCd(i)
                    strUpdJudCmtCd(lngUpdCount)    = vntNewUpdJudCmtCd(j)


                    lngUpdCount = lngUpdCount + 1

                End If
            Next


            '更新対象データが存在するときのみ判定結果保存
            If ( lngUpdCount > 0 ) Then
                objJudgement.InsertJudRslWithUpdate strUpdRsvNo, _
                                                strUpdJudClassCd, _
                                                strUpdJudCd, _
                                                strUpdJudCmtCd, _
                                                Session.Contents("userId"), 1
                strAct = "saveend"
            Else
                strAct = ""
            End If
        End If


        If strArrMessage = "" And strCmtMode = "save" Then

            '最新の総合コメント再取得
'** #### 2011.11.17 SL-SN-Y0101-006 MOD START #### **
'            lngNewCmtCnt = objInterview.SelectTotalJudCmt( _
'                                        lngRsvNo, 1, _
'                                        1, 0,  , 0, _
'                                        vntNewCmtSeq, _
'                                        vntNewTtlCmtCd, _
'                                        vntNewJudCmtstc, _
'                                        vntNewTtlClassCd, _
'                                        , , , , _
'                                        vntNewTtlJudCd, _
'                                        vntNewTtlWeight _
'                                        )
            lngNewCmtCnt = objInterview.SelectTotalJudCmt( _
                                        lngRsvNo, 1, _
                                        1, 1, strCsCd, 0, _
                                        vntNewCmtSeq, _
                                        vntNewTtlCmtCd, _
                                        vntNewJudCmtstc, _
                                        vntNewTtlClassCd, _
                                        , , , , _
                                        vntNewTtlJudCd, _
                                        vntNewTtlWeight _
                                        )
'** #### 2011.11.17 SL-SN-Y0101-006 MOD END #### **


            strArrMessage = ""
            '修正前とサーバー内の状態が変わっているかチェック
            If lngNewCmtCnt <> lngTtlCmtCnt Then
                strArrMessage = "総合コメントが他の人によって更新されているため保存できません。"
            Else
                For i = 0 To lngNewCmtCnt-1
                    If  CLng(vntNewCmtSeq(i)) <> CLng(vntCmtSeq(i)) Or _
                        vntNewTtlCmtCd(i) <> vntTtlJudCmtCd(i) Then
                        strArrMessage = "総合コメントが他の人によって更新されているため保存できません。"
                        Exit For
                    End If
                Next
            End If

            blnUpdated = False
            If lngEditCmtCnt <> lngNewCmtCnt Then
                blnUpdated = True
            Else
                For i = 0 To lngEditCmtCnt-1
                    If vntEditTtlCmtCd(i) <> vntNewTtlCmtCd(i) Then
                        blnUpdated = True
                        Exit For
                    End If
                Next
            End If
            If strArrMessage = ""   And blnUpdated = True Then
                '総合コメントの保存
                '## 2004.01.07 更新履歴用に文章とユーザＩＤ追加
                objInterview.UpdateTotalJudCmt _
                                        lngRsvNo, 1, _
                                        vntEditCmtSeq, _
                                        vntEditTtlCmtCd, _
                                        vntEditJudCmtstc, _
                                        Session.Contents("userId")
                strAct = "saveend"
                strCmtMode = ""
            End If
        End If
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
        Err.Raise 1000, , "受診情報がありません。RsvNo= " & lngRsvNo
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
                                                vntJudCmtCd, , _
                                                vntResultDispMode, _
                                                vntUpdFlg _
                                                )
    If lngCount <= 0 Then
        Err.Raise 1000, , "判定結果がありません。RsvNo= " & lngRsvNo
    End If

    vntEditJudCd = vntJudCd

'#### 2008.07.01 張 「新しい日本人のGFR推算式」適用の為、削除 Start ####
'    '検索条件に従いeGFR計算結果一覧を抽出する
'    lngEGFRCount = objInterview.SelectEGFRHistory( _
'                                                lngRsvNo, _
'                                                3, _
'                                                vntCsGrp, _
'                                                vntHisNo, _
'                                                vntHisCslDate, _
'                                                vntEGFR _
'                                                )
'#### 2008.07.01 張 「新しい日本人のGFR推算式」適用の為、削除 End   ####

    '検索条件に従いeGFR(MDRD式）計算結果一覧を抽出する
    lngMDRDCount = objInterview.SelectMDRDHistory( _
                                                lngRsvNo, _
                                                3, _
                                                vntCsGrp, _
                                                vntHisNo, _
                                                vntHisCslDate, _
                                                vntMDRD _
                                                )

'#### 2008.07.01 張 「新しい日本人のGFR推算式」適用の為、追加 Start ####
    '検索条件に従いGFR(日本人推算式）計算結果一覧を抽出する
    lngNewGFRCount = objInterview.SelectNewGFRHistory( _
                                                lngRsvNo, _
                                                3, _
                                                vntCsGrp, _
                                                vntHisNo, _
                                                vntHisCslDate, _
                                                vntNewGFR _
                                                )
'#### 2008.07.01 張 「新しい日本人のGFR推算式」適用の為、追加 End   ####

    '総合コメント取得
'** #### 2011.11.17 SL-SN-Y0101-006 MOD START #### **
'    lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
'                                        lngRsvNo, 1, _
'                                        1, 0,  , 0, _
'                                        vntCmtSeq, _
'                                        vntTtlJudCmtCd, _
'                                        vntTtlJudCmtstc, _
'                                        vntTtlJudClassCd, _
'                                        , , , , _
'                                        vntTtlJudCd, _
'                                        vntTtlWeight _
'                                        )
    lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
                                        lngRsvNo, 1, _
                                        1, 1, strCsCd, 0, _
                                        vntCmtSeq, _
                                        vntTtlJudCmtCd, _
                                        vntTtlJudCmtstc, _
                                        vntTtlJudClassCd, _
                                        , , , , _
                                        vntTtlJudCd, _
                                        vntTtlWeight _
                                        )
'** #### 2011.11.17 SL-SN-Y0101-006 MOD END #### **

    '編集領域へセット
    lngEditCmtCnt = lngTtlCmtCnt
    vntEditCmtSeq = vntCmtSeq
    vntEditTtlCmtCd = vntTtlJudCmtCd
    vntEditJudCmtstc = vntTtlJudCmtstc
    vntEditJudCmtClassCd = vntTtlJudClassCd
    vntEditTtlJudCd = vntTtlJudCd
    vntEditTtlWeight = vntTtlWeight

    Exit Do
Loop

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
    lngJudListCnt = objJud.SelectJudList( _
                                        strArrJudCd, _
                                         , , strArrWeight)

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
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>総合判定入力</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
var winMenResult;               // ウィンドウハンドル
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
        winMenResult = window.open( url, '', 'width=1000,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}


var winJudComment;              // ウィンドウハンドル
var lngSelectedIndex1;          // ガイド表示時に選択されたエレメントのインデックス
var jcmGuide_CalledFunction;
var jcmGuide_CmtMode;

var varEditCmtSeq;
var varEditCmtCd;
var varEditCmtstc;
var varEditClassCd;
var varEditJudCd;
var varEditWeight;

var editcnt;

var orgSetFlg;
//総合コメントウインドウ呼び出し
function showJudCommentWindow(index, judclscd, cmtmode) {

    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか

    var i;

    if ( cmtmode == 'insert' || cmtmode == 'edit' ){
        if ( index == 0 ){
            alert( "編集する行が選択されていません。" );
            return;
        }
    }

    if ( index == 0 ){
        index = document.resultList.editTtlCnt.value;
    }

    lngSelectedIndex1 = index;

    // ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
    jcmGuide_CalledFunction = setTotalCmt;
    // 操作モードを設定する
    jcmGuide_CmtMode = cmtmode;

    if ( orgSetFlg != 1 ) {
        editCmtSet();
    }

    // すでにガイドが開かれているかチェック
    if ( winJudComment != null ) {
        if ( !winJudComment.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/guide/gdeJudComment.asp?cmtdspmode=1';
    // 判定分類指定
    if ( judclscd != 0 ) {
        url = url + '&judClassCd=' + judclscd;
    }

    url = url + '&selCmtCnt=' + editcnt;
    for( i = 0; i < editcnt; i++ ){
        if ( i == 0 ){
            url = url + '&selCmtCd=' + varEditCmtCd[i];
        } else {
            url = url + ',' + varEditCmtCd[i];
        }
    }


    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winJudComment.focus();
        winJudComment.location.replace( url );
    } else {
        winJudComment = window.open( url, '', 'width=600,height=280,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}

var varSelCmtCd = new Array();
var varSelCmtStc = new Array();
var varSelClassCd = new Array();
var varSelJudCd = new Array();
var varSelWeight = new Array();

// 総合コメントセット
function setTotalCmt() {

    var i, j;

    var optList;    // SELECTオブジェクト

    var varBack1CmtSeq = new Array();
    var varBack1CmtCd = new Array();
    var varBack1Cmtstc = new Array();
    var varBack1ClassCd = new Array();
    var varBack1JudCd = new Array();
    var varBack1Weight = new Array();
    
    var varBack2CmtSeq = new Array();
    var varBack2CmtCd = new Array();
    var varBack2Cmtstc = new Array();
    var varBack2ClassCd = new Array();
    var varBack2JudCd = new Array();
    var varBack2Weight = new Array();
    

    optList = document.resultList.selectLine;

    if ( jcmGuide_CmtMode == 'add' ) {
        startline = (lngSelectedIndex1-0) + 1;
    } else {
        startline = lngSelectedIndex1;
    }
    
    editcnt = document.resultList.editTtlCnt.value;

    j = 0;
    //対象行より前退避
    for ( i = 0; i < startline-1; i++ ) {
        varBack1CmtSeq.length ++;
        varBack1CmtCd.length ++;
        varBack1Cmtstc.length ++;
        varBack1ClassCd.length ++;
        varBack1JudCd.length ++;
        varBack1Weight.length ++;

        varBack1CmtSeq[j] = varEditCmtSeq[i];
        varBack1CmtCd[j] = varEditCmtCd[i];
        varBack1Cmtstc[j] = varEditCmtstc[i];
        varBack1ClassCd[j] = varEditClassCd[i];
        varBack1JudCd[j] = varEditJudCd[i];
        varBack1Weight[j] = varEditWeight[i];
        j++;
    }

    j = 0;
    //対象行以降退避
    /** 2007.07.03 張 総合コメントが10個以上の場合発生している不具合対応 **/
    for ( i = startline-1; i < eval(editcnt); i++ ) {
        // 修正のときは置き換えなので該当行は退避しない
        if (jcmGuide_CmtMode == 'edit' && 
            i == startline - 1 ) {
            continue;
        }
        varBack2CmtSeq.length ++;
        varBack2CmtCd.length ++;
        varBack2Cmtstc.length ++;
        varBack2ClassCd.length ++;
        varBack2JudCd.length ++;
        varBack2Weight.length ++;

        varBack2CmtSeq[j] = varEditCmtSeq[i];
        varBack2CmtCd[j] = varEditCmtCd[i];
        varBack2Cmtstc[j] = varEditCmtstc[i];
        varBack2ClassCd[j] = varEditClassCd[i];
        varBack2JudCd[j] = varEditJudCd[i];
        varBack2Weight[j] = varEditWeight[i];
        j++;
    }

    // オブジェクトの初期化
    while ( optList.length > 0 ) {
        optList.options[0] = null;
    }

    varEditCmtSeq = new Array();
    varEditCmtCd = new Array();
    varEditCmtstc = new Array();
    varEditClassCd = new Array();
    varEditJudCd = new Array();
    varEditWeight = new Array();

    varEditCmtSeq.length = 0;
    varEditCmtCd.length = 0;
    varEditCmtstc.length = 0;
    varEditClassCd.length = 0;
    varEditJudCd.length = 0;
    varEditWeight.length = 0;

    j = 0;
    for ( i = 0; i < varBack1CmtSeq.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varBack1Cmtstc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varBack1CmtCd[i];
        varEditCmtstc[j] = varBack1Cmtstc[i];
        varEditClassCd[j] = varBack1ClassCd[i];
        varEditJudCd[j] = varBack1JudCd[i];
        varEditWeight[j] = varBack1Weight[i];
        j++;

    }
    for ( i = 0; i < varSelCmtStc.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varSelCmtStc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varSelCmtCd[i];
        varEditCmtstc[j] = varSelCmtStc[i];
        varEditClassCd[j] = varSelClassCd[i];
        varEditJudCd[j] = varSelJudCd[i];
        varEditWeight[j] = varSelWeight[i];
        j++;
    }

    for ( i = 0; i < varBack2CmtSeq.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varBack2Cmtstc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varBack2CmtCd[i];
        varEditCmtstc[j] = varBack2Cmtstc[i];
        varEditClassCd[j] = varBack2ClassCd[i];
        varEditJudCd[j] = varBack2JudCd[i];
        varEditWeight[j] = varBack2Weight[i];
        j++;
    }

    if ( jcmGuide_CmtMode != 'edit' ){
        editcnt = (editcnt-0) + (varSelCmtStc.length-0);
    } else {
        editcnt = (editcnt-0) - 1 + (varSelCmtStc.length-0);
    }
    document.resultList.editTtlCnt.value = editcnt;

}

//判定チェック
function JudCheck( judclass, judcdElement, classindex ) {

    var myForm;

    var i, j;

    var selJudCd;
    
    myForm = document.resultList;

    selJudCd = judcdElement.value;

    myForm.editJudclass[classindex-1].value = judclass;
    myForm.editJudcd[classindex-1].value = selJudCd;
    
    for ( i = 0; i < myForm.tblJudcd.length; i++ ){
        if ( myForm.tblJudcd[i].value == selJudCd ){
            //判定の重みが　20　より大
            if( myForm.tblWeight[i].value > 20 ){
                //総合コメントガイドを表示する
                showJudCommentWindow(myForm.editTtlCnt.value, judclass, 'add')
            } else {
                // 編集エリアに未セットならセット
                if ( orgSetFlg != 1 ) {
                    editCmtSet();
                }
                for ( j = 0; j < editcnt; j++ ){
                    // 判定分類一致で判定の重いコメントは削除
                    if ( varEditClassCd[j] == judclass && varEditWeight[j] > 20){
                        deleteJudComment( j+1, 0 );
                        j = j - 1;
                    }
                }
            }
            break;
        }
    }
}

//総合コメント削除
function deleteJudComment( index, msgflg ) {

    var optList;	// SELECTオブジェクト

    if ( index == 0 ){
        alert( "編集する行が選択されていません。" );
        return;
    }

    if ( msgflg == 1 ){
        if ( !confirm('選択されたコメントを削除します。よろしいですか？')) {
            return;
        }
    }
    if ( orgSetFlg != 1 ) {
        editCmtSet();
    }

    var varBack1CmtSeq = new Array();
    var varBack1CmtCd = new Array();
    var varBack1Cmtstc = new Array();
    var varBack1ClassCd = new Array();
    var varBack1JudCd = new Array();
    var varBack1Weight = new Array();
    
    var varBack2CmtSeq = new Array();
    var varBack2CmtCd = new Array();
    var varBack2Cmtstc = new Array();
    var varBack2ClassCd = new Array();
    var varBack2JudCd = new Array();
    var varBack2Weight = new Array();
    

    optList = document.resultList.selectLine;
    
    editcnt = document.resultList.editTtlCnt.value;


    j = 0;
    //対象行より前退避
    /** 2007.07.03 張 総合コメントが10個以上の場合発生している不具合対応 **/
    //for ( i = 0; i < index-1; i++ ) {
    for ( i = 0; i < eval(index)-1; i++ ) {
        varBack1CmtSeq.length ++;
        varBack1CmtCd.length ++;
        varBack1Cmtstc.length ++;
        varBack1ClassCd.length ++;
        varBack1JudCd.length ++;
        varBack1Weight.length ++;

        varBack1CmtSeq[j] = varEditCmtSeq[i];
        varBack1CmtCd[j] = varEditCmtCd[i];
        varBack1Cmtstc[j] = varEditCmtstc[i];
        varBack1ClassCd[j] = varEditClassCd[i];
        varBack1JudCd[j] = varEditJudCd[i];
        varBack1Weight[j] = varEditWeight[i];
        j++;
    }

    j = 0;
    //対象行より後退避
    /** 2007.07.03 張 総合コメントが10個以上の場合発生している不具合対応 **/
    //for ( i = index; i < editcnt; i++ ) {
    for ( i = eval(index); i < eval(editcnt); i++ ) {
        varBack2CmtSeq.length ++;
        varBack2CmtCd.length ++;
        varBack2Cmtstc.length ++;
        varBack2ClassCd.length ++;
        varBack2JudCd.length ++;
        varBack2Weight.length ++;

        varBack2CmtSeq[j] = varEditCmtSeq[i];
        varBack2CmtCd[j] = varEditCmtCd[i];
        varBack2Cmtstc[j] = varEditCmtstc[i];
        varBack2ClassCd[j] = varEditClassCd[i];
        varBack2JudCd[j] = varEditJudCd[i];
        varBack2Weight[j] = varEditWeight[i];
        j++;
    }

    // オブジェクトの初期化
    while ( optList.length > 0 ) {
        optList.options[0] = null;
    }

    varEditCmtSeq = new Array();
    varEditCmtCd = new Array();
    varEditCmtstc = new Array();
    varEditClassCd = new Array();
    varEditJudCd = new Array();
    varEditWeight = new Array();

    varEditCmtSeq.length = 0;
    varEditCmtCd.length = 0;
    varEditCmtstc.length = 0;
    varEditClassCd.length = 0;
    varEditJudCd.length = 0;
    varEditWeight.length = 0;

    j = 0;
    for ( i = 0; i < varBack1CmtSeq.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varBack1Cmtstc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varBack1CmtCd[i];
        varEditCmtstc[j] = varBack1Cmtstc[i];
        varEditClassCd[j] = varBack1ClassCd[i];
        varEditJudCd[j] = varBack1JudCd[i];
        varEditWeight[j] = varBack1Weight[i];
        j++;

    }

    for ( i = 0; i < varBack2CmtSeq.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varBack2Cmtstc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varBack2CmtCd[i];
        varEditCmtstc[j] = varBack2Cmtstc[i];
        varEditClassCd[j] = varBack2ClassCd[i];
        varEditJudCd[j] = varBack2JudCd[i];
        varEditWeight[j] = varBack2Weight[i];
        j++;
    }

    document.resultList.editTtlCnt.value = (editcnt-0) - 1;
    
}

//総合コメントの初期状態を編集エリアにセット
function editCmtSet() {

    var i;

    varEditCmtSeq = new Array();
    varEditCmtCd = new Array();
    varEditCmtstc = new Array();
    varEditClassCd = new Array();
    varEditJudCd = new Array();
    varEditWeight = new Array();

    varEditCmtSeq.length = 0;
    varEditCmtCd.length = 0;
    varEditCmtstc.length = 0;
    varEditClassCd.length = 0;
    varEditJudCd.length = 0;
    varEditWeight.length = 0;

    for ( i = 0; i < document.resultList.orgCmtCnt.value; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        if ( document.resultList.orgCmtCnt.value == 1 ){
            varEditCmtSeq[i] = document.resultList.orgCmtSeq.value;
            varEditCmtCd[i] = document.resultList.orgTtlJudCmtCd.value;
            varEditCmtstc[i] = document.resultList.orgTtlJudCmtstc.value;
            varEditClassCd[i] = document.resultList.orgTtlJudClassCd.value;
            varEditJudCd[i] = document.resultList.orgTtlJudCd.value;
            varEditWeight[i] = document.resultList.orgTtlWeight.value;
        } else {
            varEditCmtSeq[i] = document.resultList.orgCmtSeq[i].value;
            varEditCmtCd[i] = document.resultList.orgTtlJudCmtCd[i].value;
            varEditCmtstc[i] = document.resultList.orgTtlJudCmtstc[i].value;
            varEditClassCd[i] = document.resultList.orgTtlJudClassCd[i].value;
            varEditJudCd[i] = document.resultList.orgTtlJudCd[i].value;
            varEditWeight[i] = document.resultList.orgTtlWeight[i].value;
        }
    }

    editcnt = document.resultList.orgCmtCnt.value;
    orgSetFlg = 1;

}

function saveJud() {

    if ( orgSetFlg == 1 ){
        document.resultList.cmtmode.value = "save";
    }

    //hidden データに格納
    document.resultList.editCmtSeq.value = varEditCmtSeq;
    document.resultList.editTtlCmtCd.value = varEditCmtCd;
    document.resultList.editJudCmtstc.value = varEditCmtstc;
    document.resultList.editJudCmtClassCd.value = varEditClassCd;
    document.resultList.editTtlJudCd.value = varEditJudCd;
    document.resultList.editTtlWeight.value = varEditWeight;

    document.resultList.action.value = "save";
    document.resultList.submit();

}

function windowClose() {

    // 総合コメントガイドを閉じる
    if ( winJudComment != null ) {
        if ( !winJudComment.closed ) {
            winJudComment.close();
        }
    }

    winJudComment = null;

    // 検査結果ウインドウを閉じる
    if ( winMenResult != null ) {
        if ( !winMenResult.closed ) {
            winMenResult.close();
        }
    }

    winMenResult = null;

}
//総合判定参照画面呼び出し
function calltotalJudView() {
    var url;    // URL文字列

    url = '/WebHains/contents/interview/totalJudView.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="resultList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

    <INPUT TYPE="hidden" NAME="action"  VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="cmtmode" VALUE="<%= strCmtMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpcd"   VALUE="<%= strGrpCd %>">
    <INPUT TYPE="hidden" NAME="csgrp"   VALUE="<%= strSelCsGrp %>">

<%
    '判定テーブルを退避
    For i = 0 To lngJudListCnt-1
%>
        <INPUT TYPE="hidden" NAME="tblJudcd"    VALUE="<%= strArrJudCd(i) %>">
        <INPUT TYPE="hidden" NAME="tblWeight"   VALUE="<%= strArrWeight(i) %>">
<%
    Next
%>
<%
    'メッセージの編集
    If strAct <> "" Then

        Select Case strAct

            '保存完了時は「保存完了」の通知
            Case "saveend"
                Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

            'さもなくばエラーメッセージを編集
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD ROWSPAN="2" WIDTH="150">分類</TD>
                        <TD COLSPAN="3" WIDTH="182">判定結果</TD>
                        <TD ROWSPAN="2" WIDTH="150">分類</TD>
                        <TD COLSPAN="3" WIDTH="182">判定結果</TD>
                    </TR>
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD WIDTH="60">今回</TD>
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
                                <TD ALIGN="center" ><B>***</B></TD>
<%
                            Else
%>
                                <TD><%= EditDropDownListFromArray2("judcd" & vntJudClassCd(i), strArrJudCd, strArrJudCd, vntEditJudCd(i), NON_SELECTED_ADD, "javascript:JudCheck(" & vntJudClassCd(i) & ", document.resultList.judcd" & vntJudClassCd(i) & "," & lngJudClassCount & ")") %></TD>
<%
                            End If
%>
                            <INPUT TYPE="hidden" NAME="editJudclass">
                            <INPUT TYPE="hidden" NAME="editJudcd">
                            <INPUT TYPE="hidden" NAME="editJudCmtCd" VALUE="<%= vntJudCmtCd(i) %>">
<%
                        Else
                            '依頼無し
                            If vntRsvNo(i) = "" Then
%>
                                <TD ALIGN="center" WIDTH="60"><B>***</B></TD>
<%
                            Else
                                '修正された？
                                '## 更新フラグで見る 2003.12.26
                                'If Trim(vntUpdUser(i)) <> Trim(AUTOJUD_USER) And _
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
                    <INPUT TYPE="hidden" NAME="orgCount" VALUE="<%= lngCount %>">
<%
                    '初期表示時の判定データ退避
                    For i = 0 To lngCount - 1
%>
                    <INPUT TYPE="hidden" NAME="orgSeq" VALUE="<%= vntSeq(i) %>">
                    <INPUT TYPE="hidden" NAME="orgJudClass" VALUE="<%= vntJudClassCd(i) %>">
                    <INPUT TYPE="hidden" NAME="orgJudCd" VALUE="<%= vntJudCd(i) %>">
<%
                    Next

%>
                            <TR BGCOLOR="#eeeeee" HEIGHT="18">
<%'#### 2008.07.01 張 「新しい日本人のGFR推算式」適用の為、修正 Start ####%>
                                <!--TD WIDTH="119" bgcolor="#cccccc">eGFR</TD-->
<%
'                    For i = 0 To 2
'                        If i <= (lngEGFRCount - 1) Then
%>
                                <!--TD ALIGN="right" WIDTH="50"><B><%'= vntEGFR(i) %></B></TD-->
<%
'                        Else
%>
                                <!--TD ALIGN="center" WIDTH="60"><FONT COLOR="999999"><B>***</B></FONT></TD-->
<%
'                        End If
'                    Next
%>
                                <TD WIDTH="119" bgcolor="#cccccc">eGFR(MDRD式)</TD>
<%
                    For i = 0 To 2
                        If i <= (lngMDRDCount - 1) Then
%>
                                <TD ALIGN="right" WIDTH="50"><B><%= vntMDRD(i) %></B></TD>
<%
                        Else
%>
                                <TD ALIGN="center" WIDTH="60"><FONT COLOR="999999"><B>***</B></FONT></TD>
<%
                        End If
                    Next
%>

                                <TD WIDTH="119" bgcolor="#cccccc">GFR(日本人推算式)</TD>
<%
                    For i = 0 To 2
                        If i <= (lngNewGFRCount - 1) Then
%>
                                <TD ALIGN="right" WIDTH="50"><B><%= vntNewGFR(i) %></B></TD>
<%
                        Else
%>
                                <TD ALIGN="center" WIDTH="60"><FONT COLOR="999999"><B>***</B></FONT></TD>
<%
                        End If
                    Next
%>

<%'#### 2008.07.01 張 「新しい日本人のGFR推算式」適用の為、修正 End   ####%>

                            </TR>
                
                </TABLE>
            </TD>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD>
                <TD VALIGN="top">
                <TABLE>
                    <TR>
                        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                            <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:saveJud()"><IMAGE SRC="/webHains/images/save.gif" ALT="入力内容を保存します" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
                        <%  end if  %>
                    </TR>
                    <TR>
                        <TD ALIGN="right" BGCOLOR="white"><A HREF="javascript:calltotalJudView()">参照専用画面へ</A></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE WIDTH="366" BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR>
            <TD>総合コメント</TD>
            <TD VALIGN="top"></TD>
        </TR>
        <TR>
            <INPUT TYPE="hidden" NAME="editTtlCnt" VALUE="<%= lngEditCmtCnt %>">
            <INPUT TYPE="hidden" NAME="orgCmtCnt" VALUE="<%= lngTtlCmtCnt %>">
            <INPUT TYPE="hidden" NAME="editCmtSeq">
            <INPUT TYPE="hidden" NAME="editTtlCmtCd" >
            <INPUT TYPE="hidden" NAME="editJudCmtstc">
            <INPUT TYPE="hidden" NAME="editJudCmtClassCd">
            <INPUT TYPE="hidden" NAME="editTtlJudCd" >
            <INPUT TYPE="hidden" NAME="editTtlWeight" >
            <TD>
            <SELECT STYLE="width:600px" NAME="selectLine" SIZE="20">

<%
            For i = 0 To lngTtlCmtCnt - 1
%>
<!-- SEQは必ずしも連番ではない 2004.01.13
            <OPTION VALUE="<%= vntCmtSeq(i) %>"><%= vntTtlJudCmtstc(i) %></OPTION>
-->
            <OPTION VALUE="<%= i + 1 %>"><%= vntTtlJudCmtstc(i) %></OPTION>
<%
            Next
%>
            </SELECT></TD>
<%
            For i = 0 To lngTtlCmtCnt - 1
%>
            <INPUT TYPE="hidden" NAME="orgCmtSeq" VALUE="<%= vntCmtSeq(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlJudCmtCd" VALUE="<%= vntTtlJudCmtCd(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlJudCmtstc" VALUE="<%= vntTtlJudCmtstc(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlJudClassCd" VALUE="<%= vntTtlJudClassCd(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlJudCd" VALUE="<%= vntTtlJudCd(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlWeight" VALUE="<%= vntTtlWeight(i) %>">
<%
            Next

%>
            <TD VALIGN="top">
                <TABLE WIDTH="64" BORDER="1" CELLSPACING="2" CELLPADDING="0">
                    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:showJudCommentWindow(document.resultList.selectLine.value,0,'add')">追加</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:showJudCommentWindow(document.resultList.selectLine.value,0,'insert')">挿入</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:showJudCommentWindow(document.resultList.selectLine.value,0,'edit')">修正</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:deleteJudComment(document.resultList.selectLine.value, 1)">削除</A></TD>
                        </TR>
                    <%  end if  %>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
    if ( orgSetFlg != 1 ) {
        editCmtSet();
    }

//-->
</SCRIPT>
</BODY>
</HTML>
