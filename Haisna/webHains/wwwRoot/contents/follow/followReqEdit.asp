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
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/follow_print.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const PRT_DIV       = 1         '様式分類：依頼状

'### 2016.01.23 張 子宮頸部細胞診ベセスダ分類とＨＰＶ結果取得の為追加 STR ###
Const ITEM_BETHESDA     = "27050"   'ベセスダ分類
Const ITEM_HPV          = "59510"   'ＨＰＶ
'### 2016.01.23 張 子宮頸部細胞診ベセスダ分類とＨＰＶ結果取得の為追加 END ###

'### 2016.11.10 張 乳房検査結果取得の為追加 STR ###
Const ITEM_MMG_CATE     = "27770"   '乳房Ｘ線カテゴリー
Const ITEM_BECHO_CATE   = "28700"   '乳房超音波カテゴリー
Const ITEM_BECHO_OBS    = "28820"   '乳房超音波所見
Const ITEM_BREAST_PAL   = "27520"   '乳房触診
'### 2016.11.10 張 乳房検査結果取得の為追加 END ###

Dim strMode             '印刷モード
Dim strAction           '処理状態(保存ボタン押下時:"save")
Dim strMessage          '通知メッセージ
Dim vntMessage          '通知メッセージ

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objFollow           'フォローアップアクセス用
Dim objConsult          '受診クラス
Dim objFree             '汎用マスターアクセス用
Dim objHainsUser        'ユーザーアクセス用
'パラメータ
Dim lngRsvNo            '予約番号
Dim lngJudClassCd       '判定分類コード
Dim strJudClassName     '検診分類名
Dim strJudCd            '判定コード
Dim strRslJudCd         '最終判定コード

Dim strSecEquipName     '病医院名
Dim strSecEquipCourse   '診療科名
Dim strSecDoctor        '担当医師
Dim strSecEquipAddr     '住所
Dim strSecEquipTel      '電話番号

'受診情報用変数
Dim Ret                 '復帰値
Dim strCslDate          '受診日
Dim strPerId            '個人ID
Dim strAge              '受診年齢
Dim strRealAge          '実年齢
Dim strDayId            '当日ID
Dim strLastName         '姓
Dim strFirstName        '名
Dim strLastKName        'カナ姓
Dim strFirstKName       'カナ名
Dim strBirth            '生年月日
Dim strGender           '性別

Dim strName             '氏名
Dim strKname            'カナ氏名
Dim strUserId           'ユーザID
Dim strUserName         'ユーザ名

'依頼内容
Dim strFolItem          '診断・依頼項目
Dim strFolNote          '所見

'Dim strArrMessage       'エラーメッセージ
Dim vntArrMessage       'エラーメッセージ
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon     = Server.CreateObject("HainsCommon.Common")
Set objFollow     = Server.CreateObject("HainsFollow.Follow")
Set objConsult    = Server.CreateObject("HainsConsult.Consult")
Set objHainsUser  = Server.CreateObject("HainsHainsUser.HainsUser")

'パラメータ値の取得
strMode           = Request("mode")
strAction         = Request("act")

lngRsvNo          = Request("rsvno")
lngJudClassCd     = Request("judClassCd")
strJudClassName   = Request("judClassName")
strJudCd          = Request("judCd")
strRslJudCd       = Request("rslJudCd")

strSecEquipName   = Request("secEquipName")
strSecEquipCourse = Request("secEquipCourse")
strSecDoctor      = Request("secDoctor")
strSecEquipAddr   = Request("secEquipAddr")
strSecEquipTel    = Request("secEquipTel")

strUserId         = Session("USERID")

strFolItem        = Request("folItem")
strFolNote        = Request("folNote")

strCslDate        = Request("cslDate")
strPerId          = Request("perId")
strAge            = Request("age")
strRealAge        = Request("realAge")
strDayId          = Request("dayId")
strName           = Request("name")
strKname          = Request("kName")
strBirth          = Request("birth")
strGender         = Request("gender")

Do
    If strAction <> "save" Then
        '### フォローアップ情報取得
        objFollow.SelectFollow_Info lngRsvNo,         lngJudClassCd, _
                                    strJudClassName,  strJudCd, _
                                    strRslJudCd, , , , , , strSecEquipName, _
                                    strSecEquipCourse, strSecDoctor, _
                                    strSecEquipAddr, strSecEquipTel

        '受診情報検索
        Ret = objConsult.SelectConsult(lngRsvNo, _
                                        , _
                                        strCslDate,    _
                                        strPerId,      _
                                        , , , , , , , _
                                        strAge, _
                                        , , , , , , , , , , , , _
                                        strDayId,   _
                                        , , 0, , , , , , , , , , , , , , , _
                                        strLastName,   _
                                        strFirstName,  _
                                        strLastKName,  _
                                        strFirstKName, _
                                        strBirth,      _
                                        strGender _
                                       )

        '受診情報が存在しない場合はエラーとする
        If Ret = False Then
            Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
        End If

        '実年齢の計算
        If strBirth <> "" Then
            Set objFree = Server.CreateObject("HainsFree.Free")
            strRealAge = objFree.CalcAge(strBirth, strCslDate)
            Set objFree = Nothing
        Else
            strRealAge = ""
        End If

        '小数点以下の切り捨て
        If IsNumeric(strRealAge) Then
            strRealAge = CStr(Int(strRealAge))
        End If

        If strLastName <> "" and strFirstName <> "" Then
            strName = strLastName & "　" & strFirstName
        End If

        If strLastKName <> "" and strFirstKName <> "" Then
            strKname = strLastKName & "　" & strFirstKName
        End If

    Else
        '入力チェック
        'strArrMessage = CheckValue()
        vntArrMessage = CheckValue()

        'If Not IsEmpty(strArrMessage) Then
        If Not IsEmpty(vntArrMessage) Then
            Exit Do
        End If

    End If

    'ユーザ名取得
    objHainsUser.SelectHainsUser strUserId, strUserName

    Exit Do
Loop


'### 2016.01.23 張 子宮頸部細胞診の場合、子宮頸部細胞診ベセスダ分類とＨＰＶ結果をデフォルトで表示（記載）STR ###
If lngJudClassCd = 31 and Trim(strFolNote) = "" Then

    strFolNote = ""
    strFolNote = strFolNote & "■ 子宮頸部細胞診 ベセスダ分類　：　" & objFollow.GetResult(lngRsvNo, ITEM_BETHESDA) & vbLf
    strFolNote = strFolNote & "■ ＨＰＶ　：　" & objFollow.GetResult(lngRsvNo, ITEM_HPV) & vbLf

'### 2016.11.10 張 乳房の場合結果をデフォルトで表示（記載）STR ###
ElseIf lngJudClassCd = 24 and Trim(strFolNote) = "" Then

    strFolNote = ""
    strFolNote = strFolNote & "■ 乳房Ｘ線　：　" & objFollow.GetResult(lngRsvNo, ITEM_MMG_CATE) & vbLf
    strFolNote = strFolNote & "■ 乳房超音波：　" & objFollow.GetResult(lngRsvNo, ITEM_BECHO_CATE) & objFollow.GetResult(lngRsvNo, ITEM_BECHO_OBS) & vbLf
    '### 2017.12.12 張 乳房触診検査廃止に伴って乳房触診項目削除 STR ##########################################
    'strFolNote = strFolNote & "■ 乳房触診　：　" & objFollow.GetResult(lngRsvNo, ITEM_BREAST_PAL) & vbLf
    '### 2017.12.12 張 乳房触診検査廃止に伴って乳房触診項目削除 END ##########################################

    '### デフォルト診療科設定 ###
    If Trim(strSecEquipCourse) = "" Then
        strSecEquipCourse = "乳腺外科"
    End If
'### 2016.11.10 張 乳房の場合結果をデフォルトで表示（記載）END ###

End If
'### 2016.01.23 張 子宮頸部細胞診の場合、子宮頸部細胞診ベセスダ分類とＨＰＶ結果をデフォルトで表示（記載）END ###


'帳票出力処理制御
vntMessage = PrintControl(strMode, lngRsvNo, lngJudClassCd, PRT_DIV)

'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim vntArrMessage  'エラーメッセージの集合
        
        With objCommon

        '備考(改行文字も1字として含む旨を通達)
        strMessage = .CheckWideValue("診断・依頼項目", strFolItem, 120, CHECK_NECESSARY)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '備考(改行文字も1字として含む旨を通達)
        strMessage = .CheckWideValue("所見", strFolNote, 400)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '病医院名
        strMessage = .CheckWideValue("病医院名", strSecEquipName, 50)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '診療科
        strMessage = .CheckWideValue("診療科", strSecEquipCourse, 50, CHECK_NECESSARY)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '担当医師
        strMessage = .CheckWideValue("担当医師", strSecDoctor, 40)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If
        
        '住所
        strMessage = .CheckLength("住所", strSecEquipAddr, 120)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '電話番号
        strMessage = .CheckLength("電話番号", strSecEquipTel, 15)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 依頼状ドキュメントファイル作成処理
'
' 引数　　 :
'
' 戻り値　 : 印刷ログ情報のシーケンス値
'
' 備考　　 : 帳票ドキュメントファイル作成メソッドを呼び出す。メソッド内では次の処理が行われる。
' 　　　　   ?@印刷ログ情報の作成
' 　　　　   ?A帳票ドキュメントファイルの作成
' 　　　　   ?B処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
    Function Print()

'    Dim objCommon
    Dim objPrintCls '依頼状出力用COMコンポーネント
    Dim Ret         '関数戻り値
    Dim strURL

    If Not IsArray(CheckValue()) Then

        '情報漏えい対策用ログ書き出し
        Call putPrivacyInfoLog("PH042", "フォローアップ 依頼状の印刷を行った")

    Set objPrintCls    = Server.CreateObject("HainsRequestCard.RequestCard")

        Ret = objPrintCls.PrintOut(strUserId, strUserName, lngRsvNo, lngJudClassCd, strJudClassName, PRT_DIV, strSecEquipName, strSecEquipCourse, strSecDoctor, _
              strSecEquipAddr, strSecEquipTel, strCslDate, strPerId, strRealAge, strDayId, strName, strKname, strBirth, strGender, strFolItem, strFolNote)

        print = Ret

    End If

    End Function
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>依頼状作成</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

    function submitForm() {
        with ( document.requestForm ) {
            act.value = 'save';
            submit();
        }
    }

    function clear() {
        with(document.requestForm) {

            folItem.value = "";
            folNote.value = "";
        }
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">依頼状作成</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
    '## 受診者個人情報表示
    Call followupHeader(lngRsvNo)
%>
    <!--BR-->
<FORM NAME="requestForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

    <INPUT TYPE="hidden" NAME="act"             VALUE="">
    <INPUT TYPE="hidden" NAME="rsvno"           VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= lngJudClassCd %>">
    <INPUT TYPE="hidden" NAME="judClassName"    VALUE="<%= strJudClassName %>">
    <INPUT TYPE="hidden" NAME="judCd"           VALUE="<%= strJudCd %>">
    <INPUT TYPE="hidden" NAME="rslJudCd"        VALUE="<%= strRslJudCd %>">
    <INPUT TYPE="hidden" NAME="cslDate"         VALUE="<%= strCslDate %>">
    <INPUT TYPE="hidden" NAME="perId"           VALUE="<%= strPerId %>">
    <INPUT TYPE="hidden" NAME="dayId"           VALUE="<%= strDayId %>">
    <INPUT TYPE="hidden" NAME="name"            VALUE="<%= strName %>">
    <INPUT TYPE="hidden" NAME="kName"           VALUE="<%= strKname %>">
    <INPUT TYPE="hidden" NAME="gender"          VALUE="<%= strGender %>">
    <INPUT TYPE="hidden" NAME="realAge"         VALUE="<%= strRealAge %>">
    <INPUT TYPE="hidden" NAME="age"             VALUE="<%= strAge %>">
    <INPUT TYPE="hidden" NAME="birth"           VALUE="<%= strBirth %>">
<%
    If strAction <> "" Then
        'Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
        Call EditMessage(vntArrMessage, MESSAGETYPE_WARNING)
    End If
%>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR ALIGN="left">
            <TD width="*">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR align="center">
                        <TD BGCOLOR="#cccccc" width="120" HEIGHT="22">健診項目</TD>
                        <TD BGCOLOR="#eeeeee" width="120"><B><%= strJudClassName %></B></TD>
                        <TD width="20">&nbsp;</TD>
                        <TD BGCOLOR="#cccccc" width="120">判定</TD>
                        <TD BGCOLOR="#eeeeee" width="160"><%= strJudCd %>&nbsp;&nbsp;(&nbsp;最終判定&nbsp;：&nbsp;<%= strRslJudCd %>&nbsp;)</TD>
                    </TR>
                </TABLE>
            </TD>
            <TD width="300" align="right">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">

            <!--- 印刷モード -->
            <%
                '印刷モードの初期設定
                strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
            %>
                <INPUT TYPE="hidden" NAME="mode" VALUE="<%=strMode%>">

                    <TR align="right">
                        <%  If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then   %>

                        <TD ALIGN="right">&nbsp;<A HREF="javascript:submitForm();"><IMG SRC="/webHains/images/prtSave.gif" WIDTH="77" HEIGHT="24" ALT="依頼状作成"></A>
                        <A HREF="javascript:clear();"><IMG SRC="/webHains/images/clear.gif" WIDTH="77" HEIGHT="24" ALT="クリア"></A></TD>
                        <TD>&nbsp;</TD>
                        <% End If %>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">依頼内容</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;診断・依頼項目</TD>
                        <%'### 2016.11.09 張 乳房の場合判定分類名称のデフォルト表示を「乳房異常所見」に変更 STR ### %>
                        <!--TD><TEXTAREA NAME="folItem" style="ime-mode:active"  COLS="80" ROWS="2"><%= IIf(strFolItem = "",strJudClassName, strFolItem) %></TEXTAREA></TD-->
                        <TD><TEXTAREA NAME="folItem" style="ime-mode:active"  COLS="80" ROWS="2"><%= IIf(strFolItem = "",IIF(lngJudClassCd = 24, "乳房異常所見", strJudClassName), strFolItem) %></TEXTAREA></TD>
                        <%'### 2016.11.09 張 乳房の場合判定分類名称のデフォルト表示を「乳房異常所見」に変更 END ### %>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;所見</TD>
                        <TD>
                            <TEXTAREA NAME="folNote" style="ime-mode:active"  COLS="80" ROWS="12"><%= strFolNote %></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">医療機関</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;病医院名</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipName" SIZE="70" MAXLENGTH="50" VALUE="<%= strSecEquipName %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;診療科</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipCourse" SIZE="70" MAXLENGTH="50" VALUE="<%= strSecEquipCourse %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;担当医師</TD>
                        <TD><INPUT TYPE="text" NAME="secDoctor" SIZE="50" MAXLENGTH="40" VALUE="<%= strSecDoctor %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;住所</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipAddr" SIZE="100" MAXLENGTH="120" VALUE="<%= strSecEquipAddr %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;電話番号</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipTel" SIZE="50" MAXLENGTH="15" VALUE="<%= strSecEquipTel %>" STYLE="ime-mode:inactive;"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
