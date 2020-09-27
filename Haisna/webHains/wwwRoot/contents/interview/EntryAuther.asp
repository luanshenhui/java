<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       担当者登録 (Ver0.0.1)
'       AUTHER  : Keiko Fujii@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MENDOC_ITEMCD = "30950"       '面接医　検査項目コード
Const MENDOC_SUFFIX = "00"          '面接医　サフィックス
Const JUDDOC_ITEMCD = "30910"       '判定医　検査項目コード
Const JUDDOC_SUFFIX = "00"          '判定医　サフィックス
Const KANDOC_ITEMCD = "30960"       '看護師　検査項目コード
Const KANDOC_SUFFIX = "00"          '看護師　サフィックス
Const EIDOC_ITEMCD  = "30970"       '栄養士　検査項目コード
Const EIDOC_SUFFIX  = "00"          '栄養士　サフィックス
'### 2004.02.20 Mod by Ishihara@FSIT コードが誤っている
Const SHINDOC_ITEMCD = "39230"      '診察医　検査項目コード
Const SHINDOC_SUFFIX = "00"         '診察医　サフィックス
Const NAIDOC_ITEMCD = "23320"       '内視鏡医　検査項目コード
Const NAIDOC_SUFFIX = "00"          '内視鏡医　サフィックス
'Const SHINDOC_ITEMCD = "30980"      '診察医　検査項目コード
'Const SHINDOC_SUFFIX = "00"        '診察医　サフィックス
''### 2003.12.22 add start
'Const NAIDOC_ITEMCD = "30990"      '内視鏡医　検査項目コード
'Const NAIDOC_SUFFIX = "00"         '内視鏡医　サフィックス
''### 2003.12.22 add end
'### 2004.02.20 Mod End

Const JUDDOC_ITEMTYPE = 0           '判定医　項目タイプ

'データベースアクセス用オブジェクト
Dim objSentence         '文章情報アクセス用
Dim objResult           '検査結果情報アクセス用
Dim objHainsUser        'ユーザ情報アクセス用

Dim strHTML             'HTML 格納領域

'パラメータ
Dim strAct              '処理状態

Dim strRsvNo            '予約番号

'UpdateResult_tk パラメータ
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntResult           '検査結果
Dim vntRslCmtCd1        '結果コメント１
Dim vntRslCmtCd2        '結果コメント２
Dim strIPAddress        'IPアドレス

Dim strArrJudDocIndex()     'インデックス
Dim strArrJudDocItemCd()    '検査項目コード
Dim strArrJudDocSuffix()    'サフィックス
Dim strArrSentenceCd()      '文章コード
Dim strArrJudDocName()      '判定医名称
Dim lngFlgChk               '判定医フラグチェック件数

Dim strMenFlg           '面接医フラグ
Dim strHanFlg           '判定医フラグ
Dim strKanFlg           '看護師フラグ
Dim strEiFlg            '栄養士フラグ
Dim strShinFlg          '診察医フラグ
'### 2003.12.22 add start
Dim strNaiFlg           '内視鏡医フラグ
Dim strSentenceCd       'ユーザ対応文章コード
'### 2003.12.22 add end

Dim lngDocIndex         'インデックス
Dim strShortStc         '略文章


Dim strUserId           'ユーザＩＤ
Dim strUserName         'ユーザ名

Dim RetSentence         '文章検索復帰値
Dim strMessage          '結果登録復帰値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objSentence = Server.CreateObject("HainsSentence.Sentence")
Set objResult = Server.CreateObject("HainsResult.Result")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")

'パラメータ値の取得
strAct       = Request("action")
strRsvNo     = Request("rsvno")
lngDocIndex  = Request("judDocIndex")

strUserId        = Session.Contents("userId")

lngDocIndex = IIf( lngDocIndex="", 0, lngDocIndex )

strIPAddress      = Request.ServerVariables("REMOTE_ADDR")


'判定医名称の配列作成
Call CreateJudDocInfo()

Do

    '確定
    If strAct = "save" Then
        
        vntItemCd = Array()
        Redim Preserve vntItemCd(0)
        vntItemCd(0) = strArrJudDocItemCd(lngDocIndex)

        vntSuffix  = Array()
        Redim Preserve vntSuffix(0)
        vntSuffix(0) = strArrJudDocSuffix(lngDocIndex)

        vntResult  = Array()
        Redim Preserve vntResult(0)
        vntResult(0) = strArrSentenceCd(lngDocIndex)

        vntRslCmtCd1  = Array()
        Redim Preserve vntRslCmtCd1(0)
        vntRslCmtCd2  = Array()
        Redim Preserve vntRslCmtCd2(0)
'## 2003.11.16 Mod By T.Takagi@FSIT
'       strMessage = objResult.UpdateRsl_tk( _
'                           strUserId, _
'                           strIPAddress, _
'                           strRsvNo, _
'                           vntItemCd, _
'                           vntSuffix, _
'                           vntResult, _
'                           vntRslCmtCd1, _
'                           vntRslCmtCd2 _
'                         ) 
'           Err.Raise 1000, , strRsvNo & " " & strIPAddress & " " & strUserId & " " & vntItemCd(0) & " " & vntSuffix(0) & " " & vntResult(0)
        objResult.UpdateResult strRsvNo, strIPAddress, strUserId, vntItemCd, vntSuffix, vntResult, vntRslCmtCd1, vntRslCmtCd2, strMessage
'## 2003.11.16 Mod End

        If Not IsEmpty(strMessage) Then
            Err.Raise 1000, , strMessage(0) & " " & vntResult(0)
            Err.Raise 1000, , "担当者の登録ができませんでした。"
            Exit Do
        Else
            'エラーがなければ呼び元画面をリロードして自身を閉じる
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End
            Exit Do
        End If
    
    End If

    Exit Do

Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 判定医名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateJudDocInfo()

    'ユーザ情報読み込み
    If strUserId <> "" Then
        '### 内視鏡医フラグ(strNaiFlg) 追加 2003.12.22 
        objHainsUser.SelectHainsUser strUserId, strUserName, _
                                      , , , , , , , , , , _
                                      , , , , , , , _
                                     strMenFlg, strHanFlg, strKanFlg, _
                                     strEiFlg, strShinFlg, , , , strNaiFlg, strSentenceCd
    End If


    lngFlgChk = 0

    '面接医対象？
    If strMenFlg = 1 Then

        '面接医として文章テーブルに登録されているかチェック
        '文章参照コードで検索するモード追加　2004.01.02
        RetSentence = objSentence.SelectSentence( MENDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, MENDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = MENDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = MENDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "面接医"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '判定医対象？
    If strHanFlg = 1 Then
        '判定医として文章テーブルに登録されているかチェック
        '文章参照コードで検索するモード追加　2004.01.02
        RetSentence = objSentence.SelectSentence( JUDDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, JUDDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = JUDDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = JUDDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "判定医"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '看護師対象？
    If strKanFlg = 1 Then
        '看護師として文章テーブルに登録されているかチェック
        '文章参照コードで検索するモード追加　2004.01.02
        RetSentence = objSentence.SelectSentence( KANDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, KANDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = KANDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = KANDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "看護師"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '栄養士対象？
    If strEiFlg = 1 Then
        '栄養士として文章テーブルに登録されているかチェック
        '文章参照コードで検索するモード追加　2004.01.02
        RetSentence = objSentence.SelectSentence( EIDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, EIDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = EIDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = EIDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "栄養士"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '診察医対象？
    If strShinFlg = 1 Then
        '診察医として文章テーブルに登録されているかチェック
        '文章参照コードで検索するモード追加　2004.01.02
        RetSentence = objSentence.SelectSentence( SHINDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, SHINDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = SHINDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = SHINDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "診察医"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '#### 2003.12.22 add start 
    '内視鏡医対象？
    If strNaiFlg = 1 Then
        '内視鏡医として文章テーブルに登録されているかチェック
        '文章参照コードで検索するモード追加　2004.01.02
        RetSentence = objSentence.SelectSentence( NAIDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, NAIDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = NAIDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = NAIDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "内視鏡医"
            lngFlgChk = lngFlgChk + 1
        End If
    End If
    '#### 2003.12.22 add end 

End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>担当者登録</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    function saveAuther(){


/** 2006/03/08 張 担当者分類チェック有無の確認の為追加 Start **/
/**               チェックされていないとエラーメッセージ表示 **/
        var objRadio = document.entryForm;
        var j = 0;

        for(i=0 ; i < objRadio.elements.length ; i++)
        {
            if(objRadio.elements[i].type == "radio" || objRadio.elements[i].type == "RADIO" )
            {
                if(objRadio.elements[i].checked == true) {
                    j = j + 1;
                }
            }
        }
        if(j == 0){
            alert("該当する【　担当者区分　】を選択してください。");
            return;
        }
/** 2006/03/08 張 担当者分類チェック有無の確認の為追加 End   **/
        
        document.entryForm.action.value = "save";
        document.entryForm.submit();

/** 2006/03/08 張 担当者分類がコンボリストボックス対応の場合、再度確認メッセージ表示の為、追加 Start **/
        /**
        var doctorKind;
        with(document.entryForm){
            doctorKind = judDocIndex.options[judDocIndex.selectedIndex].text;
            if(confirm("<%= strUserName %>さんを　【　"+doctorKind+"　】　として登録します。\n保存しますか？")){
                document.entryForm.action.value = "save";
                document.entryForm.submit();
            }else{
                return;
            }
        }
        **/
/** 2006/03/08 張 担当者分類がコンボリストボックス対応の場合、再度確認メッセージ表示の為、追加 End   **/

    }

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= strRsvNo %>">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">担当者登録</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    現在の担当者は、<%= strUserName %>さんです。<BR>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
<%
            If lngFlgChk = 0 Then
%>
                <TD><%= strUserName %>さんに対応する判定医ＩＤが登録されていません。管理者に連絡してください。</TD>
<% 
            Else
%>
                <!--TD><%= strUserName %>さんを<%= EditDropDownListFromArray("judDocIndex", strArrJudDocIndex, strArrJudDocName, lngDocIndex, NON_SELECTED_DEL) %>として登録します。　よろしいですか？</TD-->

                <TD nowrap><%= strUserName %>さんを&nbsp;&nbsp;</TD>
                <TD bgcolor="#cccccc" width="100" nowrap><%= EditRadioFromArray("judDocIndex", strArrJudDocIndex, strArrJudDocName, lngDocIndex, NON_SELECTED_ADD) %></TD>
                <TD nowrap>&nbsp;&nbsp;として登録します。　よろしいですか？</TD>
<%
            End If
%>
        </TR>
    </TABLE>
    <BR>
    <TABLE WIDTH="169" BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR>
<%
            If lngFlgChk > 0 Then
%>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD>
                    <A HREF="javascript:saveAuther()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存" border="0"></A>
                </TD>
            <%  end if  %>
<%
            End If
%>
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル" border="0"></A></TD>
        </TR>
    </TABLE>
    <BR>
</FORM>
</BODY>
</HTML>