<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   来院確認  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const RAIIN_OPTMAX = 3					'オプション情報の１行あたりの表示最大数
Const BASEINFO_GRPCD = "X039"			'基本情報　検査項目グループコード
Const IMGFILE_PATH = "../../images/"	'イメージファイルのPATH名

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診クラス
Dim objFree				'汎用情報アクセス用
Dim objPubNote			'ノートクラス
Dim objInterView		'面接情報アクセス用
Dim objPerResult		'個人検査結果情報アクセス用

'### 2014.04.08 団体名称ハイライト表示有無をチェックの為追加　Start ###
Dim objOrganization     '団体情報アクセス用
'### 2014.04.08 団体名称ハイライト表示有無をチェックの為追加　End   ###

'パラメータ
Dim lngRsvNo			'予約番号
Dim strReceiptFlg		'受付フラグ(受付入力画面からの起動=1)

'来院情報用変数
Dim vntCancelFlg		'キャンセルフラグ
Dim vntCslDate			'受診日
Dim vntPerId			'個人ID
Dim vntCsCd				'コースコード
Dim vntOrgCd1			'受診時団体コード1
Dim vntOrgCd2			'受診時団体コード2
Dim vntRsvGrpCd			'予約群コード
Dim vntRsvDate			'予約日
Dim vntAge				'受診時年齢
Dim vntCtrPtCd			'契約パターンコード
Dim vntIsrSign			'保険証記号
Dim vntIsrNo			'保険証番号
Dim vntReportAddrDiv	'成績書宛先
Dim vntReportOurEng		'成績書英文出力
Dim vntCollectTicket	'利用券回収
Dim vntIssueCslTicket	'診察券発行
Dim vntBillPrint		'請求書出力
Dim vntVolunteer		'ボランティア
Dim vntVolunteerName	'ボランティア名
Dim vntDayID			'当日ID
Dim vntComeDate			'来院日時
Dim vntComeUser			'来院処理者
Dim vntOcrNo			'OCR番号
Dim vntLockerKey		'ロッカーキー
Dim vntBirth			'生年月日
Dim vntGender			'性別
Dim vntLastName			'姓
Dim vntFirstName		'名
Dim vntLastKName		'カナ姓
Dim vntFirstKName		'カナ名
Dim vntRomeName			'ローマ字名
Dim vntNationCd			'国籍コード
Dim vntNationName		'国籍名
Dim vntCompPerId		'同伴者個人ID
Dim vntCompPerName		'同伴者個人名
Dim vntCsName			'コース名
Dim vntCsSName			'コース略称
Dim vntOrgKName			'団体カナ名称
Dim vntOrgName			'団体漢字名称
Dim vntOrgSName			'団体略称
Dim vntTicket			'利用券
Dim vntInsBring			'保険証当日持参
Dim vntRsvGrpName		'予約群名称
Dim vntRsvGrpStrTime	'予約群開始時間
Dim vntRsvGrpEndTime	'予約群終了時間

'受診オプション管理情報
Dim vntOptCd			'オプションコード
Dim vntOptBranchNo		'オプション枝番
Dim vntOptSName			'オプション略称
Dim vntSetColor			'セットカラー
Dim lngOptCnt			'受診オプション管理情報の取得件数
Dim strArrOptInfo		'オプション情報（３件ずつ折り返すため）
DIm lngOptRow			'オプション情報の表示行数

'ノート情報
Dim vntSeq				'seq
Dim vntPubNoteDivCd		'受診情報ノート分類コード
Dim vntPubNoteDivName	'受診情報ノート分類名称
Dim vntDefaultDispKbn	'表示対象区分初期値
Dim vntOnlyDispKbn		'表示対象区分しばり
Dim vntDispKbn			'表示対象区分
Dim vntUpdDate			'登録日時
Dim vntUpdUser			'登録者
Dim vntUserName			'登録者名
Dim vntBoldFlg			'太字区分
Dim vntPubNote			'ノート
Dim vntDispColor		'表示色
Dim lngPubNoteCount		'コメント数
'ノート情報(団体)
Dim vntOrgSeq				'seq
Dim vntOrgPubNoteDivCd		'受診情報ノート分類コード
Dim vntOrgPubNoteDivName	'受診情報ノート分類名称
Dim vntOrgDefaultDispKbn	'表示対象区分初期値
Dim vntOrgOnlyDispKbn		'表示対象区分しばり
Dim vntOrgDispKbn			'表示対象区分
Dim vntOrgUpdDate			'登録日時
Dim vntOrgUpdUser			'登録者
Dim vntOrgUserName			'登録者名
Dim vntOrgBoldFlg			'太字区分
Dim vntOrgPubNote			'ノート
Dim vntOrgDispColor			'表示色
Dim lngOrgPubNoteCount		'コメント数
'ノート情報(契約)
Dim vntCtrSeq				'seq
Dim vntCtrPubNoteDivCd		'受診情報ノート分類コード
Dim vntCtrPubNoteDivName	'受診情報ノート分類名称
Dim vntCtrDefaultDispKbn	'表示対象区分初期値
Dim vntCtrOnlyDispKbn		'表示対象区分しばり
Dim vntCtrDispKbn			'表示対象区分
Dim vntCtrUpdDate			'登録日時
Dim vntCtrUpdUser			'登録者
Dim vntCtrUserName			'登録者名
Dim vntCtrBoldFlg			'太字区分
Dim vntCtrPubNote			'ノート
Dim vntCtrDispColor			'表示色
Dim lngCtrPubNoteCount		'コメント数

'お連れ様情報
Dim strArrCslDate       '受診日の配列
Dim strArrSeq           'お連れ様Seqの配列
Dim strArrRsvNo         '予約番号の配列
Dim strArrSameGrp1      '面接同時受診１の配列
Dim strArrSameGrp2      '面接同時受診２の配列
Dim strArrSameGrp3      '面接同時受診３の配列
Dim strArrPerId         '個人IDの配列
Dim strArrCsName        'コース名の配列
Dim strArrOrgSName      '団体名称の配列
Dim strArrLastName      '姓の配列
Dim strArrFirstName     '名の配列
Dim strArrLastKName     'カナ姓の配列
Dim strArrFirstKName    'カナ名の配列
Dim strArrName          '氏名の配列
Dim strArrKName         'カナ氏名の配列
Dim strArrRsvGrpName    '予約群名称の配列
Dim lngFriendsCnt       'お連れ様情報の取得件数

'受診歴情報
Dim vntHisCslDate       '受診日
Dim vntHisCsCd          'コースコード
Dim vntHisCsName        'コース名
Dim vntHisCsSName       'コース略称
Dim lngHisCount         '表示歴数

'個人検査項目情報用変数
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntItemName         '検査項目名
Dim vntResult           '検査結果
Dim vntResultType       '結果タイプ
Dim vntItemType         '項目タイプ
Dim vntStcItemCd        '文章参照用項目コード
Dim vntStcCd            '文章コード
Dim vntShortStc         '文章略称
Dim vntIspDate          '検査日
Dim vntImageFileName    'イメージファイル名
Dim lngPerRslCount      '個人検査項目情報数

Dim strUpdUser          '更新者

Dim strEraBirth         '生年月日(和暦)
Dim strRealAge          '実年齢

Dim Ret                 '関数戻り値
Dim lngCount            '取得件数
Dim strHtml             'HTML文字列
Dim i, j                'カウンタ

'### 2014.04.08 団体名称ハイライト表示有無をチェックの為追加　Start ###
Dim strHighLight    ' 団体名称ハイライト表示区分
'### 2014.04.08 団体名称ハイライト表示有無をチェックの為追加　End   ###

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objPerResult    = Server.CreateObject("HainsPerResult.PerResult")
'### 2014.04.08 団体名称ハイライト表示有無をチェックの為追加　Start ###
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
'### 2014.04.08 団体名称ハイライト表示有無をチェックの為追加　End   ###


'引数値の取得
lngRsvNo            = Request("rsvno")
strReceiptFlg       = Request("receiptflg")

strUpdUser          = Session("USERID")

Do
    '来院情報検索
    Ret = objConsult.SelectWelComeInfo(lngRsvNo, _
                                        vntCancelFlg,       _
                                        vntCslDate,         _
                                        vntPerId,           _
                                        vntCsCd,            _
                                        vntOrgCd1,          _
                                        vntOrgCd2,          _
                                        vntRsvGrpCd,        _
                                        vntRsvDate,         _
                                        vntAge,             _
                                        vntCtrPtCd,         _
                                        vntIsrSign,         _
                                        vntIsrNo,           _
                                        vntReportAddrDiv,   _
                                        vntReportOurEng,    _
                                        vntCollectTicket,   _
                                        vntIssueCslTicket,  _
                                        vntBillPrint,       _
                                        vntVolunteer,       _
                                        vntVolunteerName,   _
                                        vntDayID,           _
                                        vntComeDate,        _
                                        vntComeUser,        _
                                        vntOcrNo,           _
                                        vntLockerKey,       _
                                        vntBirth,           _
                                        vntGender,          _
                                        vntLastName,        _
                                        vntFirstName,       _
                                        vntLastKName,       _
                                        vntFirstKName,      _
                                        vntRomeName,        _
                                        vntNationCd,        _
                                        vntNationName,      _
                                        vntCompPerId,       _
                                        vntCompPerName,     _
                                        vntCsName,          _
                                        vntCsSName,         _
                                        vntOrgKName,        _
                                        vntOrgName,         _
                                        vntOrgSName,        _
                                        vntTicket,          _
                                        vntInsBring,        _
                                        vntRsvGrpName,      _
                                        vntRsvGrpStrTime,   _
                                        vntRsvGrpEndTime    _
                                    )
    If Ret = False Then
        Err.Raise 1000, , "来院情報が存在しません。（予約番号= " & lngRsvNo & " )"
    End If

    '受診オプション管理情報検索
    lngOptCnt = objConsult.SelectConsult_O(	lngRsvNo,		_
                                            vntOptCd,		_
                                            vntOptBranchNo,	_
                                            , ,				_
                                            vntOptSName,	_
                                            vntSetColor,	_
                                            3 _
                                            )
    If lngOptCnt < 0 Then
        Err.Raise 1000, , "受診オプション管理情報が取得できません。（予約番号= " & lngRsvNo & " )"
    End If

    'オプション情報の表示行数
    lngOptRow = IIf(lngOptCnt=0,0,INT((lngOptCnt - 1) / RAIIN_OPTMAX))
    strArrOptInfo = Array()
    Redim strArrOptInfo(lngOptRow)

    For i=0 To lngOptRow
        strArrOptinfo(i) = ""
        For j=0 To RAIIN_OPTMAX - 1 
            If j > 0 Then
                strArrOptInfo(i) = strArrOptInfo(i) & "<TD NOWRAP>　</TD>" & vbLf
            End If
            If ( i * RAIIN_OPTMAX + j ) < lngOptCnt Then
                strArrOptInfo(i) = strArrOptInfo(i) & "<TD NOWRAP><FONT COLOR=""" & vntSetColor(i * RAIIN_OPTMAX + j) & """>■</FONT>" & vntOptSName(i * RAIIN_OPTMAX + j) & "</TD>" & vbLf
            Else
                strArrOptInfo(i) = strArrOptInfo(i) & "<TD NOWRAP>　</TD>" & vbLf
            End If
        Next
    Next

    'お連れ様情報を取得（お連れ様がいない場合も自分自身の情報は返ってくるので注意）
    lngFriendsCnt = objConsult.SelectFriends(	vntCslDate, _
                                                lngRsvNo, _
                                                strArrCslDate,    _
                                                strArrSeq,        _
                                                strArrRsvNo,      _
                                                strArrSameGrp1,   _
                                                strArrSameGrp2,   _
                                                strArrSameGrp3,   _
                                                strArrPerId,      _
                                                , _
                                                strArrCsName,     _
                                                , , , _
                                                strArrOrgSName,   _
                                                strArrLastName,   _
                                                strArrFirstName,  _
                                                strArrLastKName,  _
                                                strArrFirstKName, _
                                                , _
                                                strArrRsvGrpName  _
                                                )
    If lngFriendsCnt < 0 Then
        Err.Raise 1000, , "お連れ様情報が存在しません。（受診日= " & vntCslDate & " 予約番号= " & lngRsvNo & " )"
    End If


    '生年月日(西暦＋和暦)の編集
    strEraBirth = objCommon.FormatString(CDate(vntBirth), "ge（yyyy）.m.d")

    '実年齢の計算
    If vntBirth <> "" Then
        Set objFree = Server.CreateObject("HainsFree.Free")
        strRealAge = objFree.CalcAge(vntBirth)
        Set objFree = Nothing
    Else
        strRealAge = ""
    End If

    '小数点以下の切り捨て
    If IsNumeric(strRealAge) Then
        strRealAge = CStr(Int(strRealAge))
    End If


    'ノート情報の取得
    lngPubNoteCount = objPubNote.SelectPubNote(	0, 0, _
                                                "", "", _
                                                lngRsvNo, _
                                                "", "", "", "",  _
                                                0, "", 0, _
                                                strUpdUser, _
                                                vntSeq, _
                                                vntPubNoteDivCd, _
                                                vntPubNoteDivName, _
                                                vntDefaultDispKbn, _
                                                vntOnlyDispKbn, _
                                                vntDispKbn, _
                                                vntUpdDate, _
                                                vntUpdUser, _
                                                vntUserName, _
                                                vntBoldFlg, _
                                                vntPubNote, _
                                                vntDispColor _
                                                )
    If lngPubNoteCount < 0 Then
        Err.Raise 1000, , "ノート情報が存在しません。"
    End If

    'ノート情報の取得(団体)
    lngOrgPubNoteCount = objPubNote.SelectPubNote(	3, 0, _
                                                "", "", _
                                                lngRsvNo, _
                                                "", "", "", "",  _
                                                0, "", 0, _
                                                strUpdUser, _
                                                vntOrgSeq, _
                                                vntOrgPubNoteDivCd, _
                                                vntOrgPubNoteDivName, _
                                                vntOrgDefaultDispKbn, _
                                                vntOrgOnlyDispKbn, _
                                                vntOrgDispKbn, _
                                                vntOrgUpdDate, _
                                                vntOrgUpdUser, _
                                                vntOrgUserName, _
                                                vntOrgBoldFlg, _
                                                vntOrgPubNote, _
                                                vntOrgDispColor _
                                                )
    If lngOrgPubNoteCount < 0 Then
        Err.Raise 1000, , "ノート情報が存在しません。"
    End If

    'ノート情報の取得(契約)
    lngCtrPubNoteCount = objPubNote.SelectPubNote(	4, 0, _
                                                "", "", _
                                                lngRsvNo, _
                                                "", "", "", "",  _
                                                0, "", 0, _
                                                strUpdUser, _
                                                vntCtrSeq, _
                                                vntCtrPubNoteDivCd, _
                                                vntCtrPubNoteDivName, _
                                                vntCtrDefaultDispKbn, _
                                                vntCtrOnlyDispKbn, _
                                                vntCtrDispKbn, _
                                                vntCtrUpdDate, _
                                                vntCtrUpdUser, _
                                                vntCtrUserName, _
                                                vntCtrBoldFlg, _
                                                vntCtrPubNote, _
                                                vntCtrDispColor _
                                                )
    If lngCtrPubNoteCount < 0 Then
        Err.Raise 1000, , "ノート情報が存在しません。"
    End If

    '指定された予約番号の受診歴一覧を取得する
    lngHisCount = objInterView.SelectConsultHistory( lngRsvNo, _
                                                    False, _
                                                    0, _
                                                    "", _
                                                    2, _
                                                    0, _
                                                    , _
                                                    , _
                                                    vntHisCslDate, _
                                                    vntHisCsCd, _
                                                    vntHisCsName, _
                                                    vntHisCsSName _
                                                    )
    If lngHisCount < 1 Then
        Err.Raise 1000, , "受診歴が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If


    '個人検査結果情報取得
    lngPerRslCount = objPerResult.SelectPerResultGrpList( vntPerId, _
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
        Err.Raise 1000, , "個人検査結果情報が存在しません。（個人ID= " & vntPerId & " )"
    End If


    '### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
    objOrganization.SelectOrg_Lukes vntOrgCd1, vntOrgCd2,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,strHighLight
    '### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###


    'オブジェクトのインスタンス削除
    Set objConsult = Nothing
    Set objPubNote = Nothing
    Set objInterView = Nothing
    Set objPerResult = Nothing

    Set objOrganization = Nothing

    Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>来院確認画面</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winWelComeInfo;

// ウィンドウを開く
function Guide_openWindow(guideNo) {

    var opened = false;	// 画面が開かれているか
    var url;

    // 未受付のときはウィンドウを表示しない
    if ( '<%= vntDayID %>' == '' ) {
        alert( '未受付のときは設定できません' );
        return;
    }

    // すでにガイドが開かれているかチェック
    if ( winWelComeInfo ) {
        if ( !winWelComeInfo.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/raiin/EditWelComeInfo.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';
    url = url + '&mode=' + guideNo;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winWelComeInfo.focus();
        winWelComeInfo.location.replace( url );
    } else {
// ## 2004.10.15 Mod By T.Takagi@FSIT 誘導キャンセル機能実装
//		winWelComeInfo = window.open( url, '', 'width=450,height=180,status=no,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
        winWelComeInfo = window.open( url, '', 'width=450,height=220,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
// ## 2004.10.15 Mod End
    }

}

// ウィンドウを閉じる
function windowClose() {

    // 来院情報設定画面を閉じる
    if ( winWelComeInfo != null ) {
        if ( !winWelComeInfo.closed ) {
            winWelComeInfo.close();
        }
    }

    winWelComeInfo = null;
}

// キー押下時の処理
function Key_Press(){

    // Spaceキー
    if ( event.keyCode == 32 ) {

        // ロッカーキー設定ウィンドウを開く
        Guide_openWindow(4);

        event.keyCode = 0;
    }

    return;
}

// ロッカーキーを設定したとき
function setLockerKey() {

    // 受付入力画面からの起動時はウィンドウを閉じる
    if( document.entryForm.receiptflg.value == '1' ) {
        if( opener != null) {
            opener.nextReceipt();
        }
    }
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>

<BODY BGCOLOR="#ffffff" ONUNLOAD="javascript:windowClose()" ONKEYPRESS="JavaScript:Key_Press()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <!-- 引数値 -->
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="receiptflg" VALUE="<%= strReceiptFlg %>">

    <!-- タイトルの表示 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">来院確認</FONT></B></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
        </TR>
        <TR VALIGN="middle">
            <TD NOWRAP><A HREF="javascript:Guide_openWindow(1)"><IMG SRC="../../images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
            <TD NOWRAP>当日ＩＤ</TD>
            <TD NOWRAP>：</TD>
            <TD NOWRAP><FONT SIZE="7" COLOR="#ff6600"><B><%= IIf(vntDayID="", "未受付", objCommon.FormatString(vntDayID, "0000")) %></B></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
        </TR>
        <TR VALIGN="middle">
            <TD NOWRAP>受診日</TD>
            <TD NOWRAP>：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntCslDate %></B></FONT></TD>
            <TD NOWRAP WIDTH="10"></TD>
            <TD NOWRAP>予約番号</TD>
            <TD NOWRAP>：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
            <TD NOWRAP WIDTH="10"></TD>
            <TD NOWRAP>予約群</TD>
            <TD NOWRAP>：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntRsvGrpName %></B></FONT></TD>
            <TD NOWRAP WIDTH="10"></TD>
            <TD NOWRAP>来院情報</TD>
            <TD NOWRAP>：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= IIf(vntComeDate="", "未来院", "来院済み") %></B></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="600">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="100%" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR VALIGN="middle">
            <TD NOWRAP><%= vntPerId %></TD>
            <TD WIDTH="10"></TD>
            <TD NOWRAP>
                <A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= vntPerId %>" TARGET="_blank">
                    <B><%= vntLastName & "　" & vntFirstName %></B>
                </A>
                <FONT COLOR="#999999"> (</FONT><FONT SIZE="-1" COLOR="#999999"><%= vntLastKName & "　" & vntFirstKName %></FONT><FONT COLOR="#999999">)</FONT>
                <FONT COLOR="#999999">　　<%= vntRomeName %></FONT>
            </TD>
            <TD WIDTH="100%"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR VALIGN="middle">
<%
    strHtml = ""
    Select Case vntIssueCslTicket
'### 2004/01/22 Updated by Ishihara@FSIT コード設定が全然違う
'	Case "1"
'		strHtml = "既存"
'	Case "2"
'		strHtml = "再発行"
'	Case "3"
'		strHtml = "新規"
    Case "1"
        strHtml = "新規"
    Case "2"
        strHtml = "既存"
    Case "3"
        strHtml = "再発行"
'### 2004/01/22 Updated End
    End Select
%>
            <TD COLSPAN="2" NOWRAP>診察券：<FONT COLOR="green"><B><%= strHtml %></B></FONT></TD>
            <TD NOWRAP><%= strEraBirth %>生　<%= strRealAge %>歳（<%= Int(vntAge) %>歳）　<%= IIf(vntGender = "1", "男性", "女性") %></TD>
        </TR>
        <TR HEIGHT="15">
            <TD COLSPAN="4" NOWRAP ALIGN="right">
                <TABLE WIDTH="80" BORDER="2" CELLSPACING="2" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP><A HREF="javascript:Guide_openWindow(4)">ロッカーキーを入力</A></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">受診コース</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><B><FONT COLOR="#ff6600"><%= vntCsName %></FONT></B></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">オプション</TD>
            <TD NOWRAP></TD>
            <%= strArrOptInfo(0) %>
        </TR>
<%
    For i=1 To lngOptRow
%>
        <TR>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <%= strArrOptInfo(i) %>
        </TR>
<%
    Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP bgcolor="#eeeeee">団体名</TD>
            <TD NOWRAP></TD>

<%      If strHighLight = "1" Then  %>
            <TD NOWRAP>
                <FONT style='font-weight:bold; background-color:#00FFFF;'><B><%= vntOrgName %></B></FONT>
                <FONT style='font-weight:bold; background-color:#00FFFF; color:#999999'>（<%= vntOrgKName %>）</FONT>
            </TD>
<%      Else                        %>
            <TD NOWRAP><%= vntOrgName %><FONT COLOR="#999999">（<%= vntOrgKName %>）</FONT></TD>
<%      End If                      %>

        </TR>
        </TR></TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">利用券有無</TD>
            <TD NOWRAP>　</TD>
            <TD NOWRAP><%= IIf(vntTicket="1", "あり", "なし") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">保険証有無</TD>
            <TD NOWRAP>　</TD>
            <TD NOWRAP><%= IIf(vntInsBring="1", "あり", "なし") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">本人/家族</TD>
            <TD NOWRAP></TD>
<%
    strHtml = ""
    Select Case vntBillPrint
    Case "1"
        strHtml = "本人"
    Case "2"
        strHtml = "家族"
    End Select
%>
            <TD NOWRAP><%= strHtml %></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">回収済み</TD>
            <TD NOWRAP>　</TD>
            <TD NOWRAP><%= IIf(vntCollectTicket="", "未回収", "済み") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">保険証記号</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntIsrSign %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">成績表宛先</TD>
            <TD NOWRAP></TD>
<%
    strHtml = ""
    Select Case vntReportAddrDiv
    Case "1"
        strHtml = "住所（自宅）"
    Case "2"
        strHtml = "住所（会社）"
    Case "3"
        strHtml = "住所（その他）"
    End Select
%>
            <TD NOWRAP><%= strHtml %></TD>
        </TR>
        <TR>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">保険証番号</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntIsrNo %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">成績表英文出力</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP WIDTH="92"><%= IIf(vntReportOurEng="1", "あり", "なし") %></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR BGCOLOR="#eeeeee">
            <TD WIDTH="450">団体コメント</TD>
            <TD WIDTH="150">オペレータ名</TD>
        </TR>
<%
    For i=0 To lngOrgPubNoteCount-1
%>
        <TR VALIGN="top" BGCOLOR="#ffffff">
            <TD NOWRAP>
                <%= IIf(vntOrgBoldFlg(i)=1, "<B>", "") %>
                <SPAN <%= IIf(vntOrgDispColor(i)="","","STYLE=""color: #" & vntOrgDispColor(i) & ";""") %>> <%= vntOrgPubNote(i) %></SPAN>
                <%= IIf(vntOrgBoldFlg(i)=1, "</B>", "") %>
            </TD>
            <TD NOWRAP><%= vntOrgUserName(i) %></TD>
        </TR>
<%
    Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR BGCOLOR="#eeeeee">
            <TD WIDTH="450">契約コメント</TD>
            <TD WIDTH="150">オペレータ名</TD>
        </TR>
<%
    For i=0 To lngCtrPubNoteCount-1
%>
        <TR VALIGN="top" BGCOLOR="#ffffff">
            <TD NOWRAP>
                <%= IIf(vntCtrBoldFlg(i)=1, "<B>", "") %>
                <SPAN <%= IIf(vntCtrDispColor(i)="","","STYLE=""color: #" & vntCtrDispColor(i) & ";""") %>> <%= vntCtrPubNote(i) %></SPAN>
                <%= IIf(vntCtrBoldFlg(i)=1, "</B>", "") %>
            </TD>
            <TD NOWRAP><%= vntCtrUserName(i) %></TD>
        </TR>
<%
    Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR BGCOLOR="#eeeeee">
            <TD WIDTH="450">個人コメント</TD>
            <TD WIDTH="150">オペレータ名</TD>
        </TR>
<%
    For i=0 To lngPubNoteCount-1
%>
        <TR VALIGN="top" BGCOLOR="#ffffff">
            <TD NOWRAP>
                <%= IIf(vntBoldFlg(i)=1, "<B>", "") %>
                <SPAN <%= IIf(vntDispColor(i)="","","STYLE=""color: #" & vntDispColor(i) & ";""") %>> <%= vntPubNote(i) %></SPAN>
                <%= IIf(vntBoldFlg(i)=1, "</B>", "") %>
            </TD>
            <TD NOWRAP><%= vntUserName(i) %></TD>
        </TR>
<%
    Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">ボランティア</TD>
            <TD NOWRAP></TD>
<%
    Select Case vntVolunteer
    Case "0"
        strHtml = "利用なし"
    Case "1"
        strHtml = "通訳要"
    Case "2"
        strHtml = "介護要"
    Case "3"
        strHtml = "通訳＆介護要"
    Case "4"
        strHtml = "車椅子要"
    Case Else
        strHtml = ""
    End Select
%>
            <TD NOWRAP><%= strHtml %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">来院処理担当</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntComeUser %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee" WIDTH="88">ＯＣＲ番号</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntOcrNo %></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">ボランティア名</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntVolunteerName %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">来院日時</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntComeDate %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee" WIDTH="88">ロッカーキー</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntLockerKey %></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">国籍</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntNationName %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">案内書番号</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= lngRsvNo %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR BGCOLOR="#eeeeee">
            <TD WIDTH="60"><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
            <TD NOWRAP>個人ＩＤ</TD>
            <TD WIDTH="170">氏名</TD>
            <TD NOWRAP>予約番号</TD>
            <TD WIDTH="150">受診団体</TD>
            <TD WIDTH="100">受診コース</TD>
            <TD WIDTH="100">予約群</TD>
        </TR>
<%
    strHtml = ""
    'i=0は自分自身なので除く
    For i = 1 To lngFriendsCnt - 1
        strHtml = strHtml & "<TR>"
        If strArrPerId(i) = vntCompPerId Then
            strHtml = strHtml & "<TD NOWRAP>同伴者</TD>"
        Else
            strHtml = strHtml & "<TD NOWRAP>お連れ様</TD>"
        End If
        strHtml = strHtml & "<TD NOWRAP>" & strArrPerId(i) & "</TD>"
        strHtml = strHtml & "<TD NOWRAP>" & strArrLastName(i) & "　" & strArrFirstName(i) & "（<SPAN STYLE=""font-size:9px;""><B>" & strArrLastKName(i) & "　" & strArrFirstKName(i) & "</B></SPAN>）</TD>"
        strHtml = strHtml & "<TD NOWRAP><A HREF=""../Reserve/rsvMain.asp?rsvNo=" & strArrRsvNo(i) & """ TARGET=""_blank"">" & strArrRsvNo(i) & "</A></TD>"
        strHtml = strHtml & "<TD NOWRAP>" & strArrOrgSName(i) & "</TD>"
        strHtml = strHtml & "<TD NOWRAP>" & strArrCsName(i) & "</TD>"
        strHtml = strHtml & "<TD NOWRAP>" & strArrRsvGrpName(i) & "</TD>"
        strHtml = strHtml & "</TR>"
    Next
    Response.Write strHtml
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP>前回受診日</TD>
            <TD NOWRAP>：</TD>
<%
    If lngHisCount = 2 Then
%>
            <TD NOWRAP><%= vntHisCslDate(1) %>　　<%= vntHisCsName(1) %></TD>
<%
    Else
%>
            <TD NOWRAP>　</TD>
<%
    End If
%>
        </TR>
        <TR>
            <TD NOWRAP>身体情報</TD>
            <TD NOWRAP>：</TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
<%
    For i=0 To lngPerRslCount-1
        If vntImageFileName(i) <> "" Then
%>
                        <TD BGCOLOR="#eeeeee"><IMG SRC="<%= IMGFILE_PATH & vntImageFileName(i) %>" ALT="<%= vntItemName(i) %>" HEIGHT="22" WIDTH="22" BORDER="0"></TD>
<%
        End If
    Next
%>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE WIDTH="180" BORDER="1" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD NOWRAP><A HREF="javascript:Guide_openWindow(2)">来院情報修正</A></TD>
            <TD NOWRAP><A HREF="javascript:Guide_openWindow(3)">OCR番号修正</A></TD>
            <TD NOWRAP><A HREF="/webHains/contents/result/rslMain2.asp?rsvno=<%= lngRsvNo %>&code=X064&NoReceipt=1" TARGET="_blank">希望医師入力</A></TD>
        </TR>
    </TABLE>
</FORM>
</BODY>
</HTML>
