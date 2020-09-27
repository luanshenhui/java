<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       セット外請求追加表示 (Ver0.0.1)
'       AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------

Dim objCommon               '共通クラス
Dim objPerbill              '受診情報アクセス用

Dim strDmdDate              '請求日
Dim lngBillSeq              '請求書Ｓｅｑ
Dim lngBranchNo             '請求書枝番

Dim Ret                     '関数戻り値

'個人請求書情報用変数
Dim vntDmdDate              '請求日
Dim vntBillSeq              '請求書Ｓｅｑ
Dim vntBranchNo             '請求書枝番
Dim vntDelflg               '取消伝票フラグ
Dim vntUpdDate              '更新日時
Dim vntUpdUser              'ユーザＩＤ
Dim vntUserName             'ユーザ漢字氏名
Dim vntBillcoment           '請求書コメント
Dim vntPaymentDate          '入金日
Dim vntPaymentSeq           '入金Ｓｅｑ
Dim vntPrice                '金額
Dim vntEditPrice            '調整金額
Dim vntTaxPrice             '税額
Dim vntEditTax              '調整税額
Dim vntLineTotal            '小計（金額、調整金額、税額、調整税額）

Dim lngCount                '取得件数
Dim lngBillCount            '未入金明細書件数
Dim lngRsvNo                '予約番号

Dim strDivCd                'セット外請求明細コード
Dim strDivName              'セット外請求明細名称
Dim strLineName             '明細名称
Dim lngPrice                '金額
Dim lngEditPrice            '調整金額
Dim lngTaxPrice             '税額
Dim lngEditTax              '調整税額

Dim strMode                 '処理モード
Dim strAction               '動作モード(保存:"save"、保存完了:"saved")
Dim i                       'インデックス
Dim strHTML
Dim strArrMessage           'エラーメッセージ

strArrMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得
lngRsvNo       = Request("rsvno")
lngBillCount   = Request("billcount")

strDmdDate     = Request("dmddate")
lngBillSeq     = Request("billseq")
lngBranchNo    = Request("branchno")

strAction      = Request("act")
strMode        = Request("mode")

strDivCd       = Request("divcd")
strDivName     = Request("divname")
strLineName    = Request("linename")
lngPrice       = Request("price")
lngEditPrice   = Request("editprice")
lngTaxPrice    = Request("taxprice")
lngEditTax     = Request("edittax")


'パラメタのデフォルト値設定
    lngPrice     = IIf(lngPrice = "", 0, lngPrice )
    lngEditPrice = IIf(lngEditPrice = "", 0, lngEditPrice )
    lngTaxPrice  = IIf(lngTaxPrice = "", 0, lngTaxPrice )
    lngEditTax   = IIf(lngEditTax = "", 0, lngEditTax )

Do

    '確定ボタン押下時
    If strAction = "check" Then

        '入力チェック
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        If (lngBillCount = 0) OR (lngBillCount = 1) Then
            'そのまま保存処理へ
            strAction = "save"

            If lngBillCount = 0 Then
                strDmdDate = ""
                lngBillSeq = 0
                lngBranchNo = 0
            End If

        Else
            '請求書情報選択画面へ
            strAction = "openwin"
            Response.Redirect "otherIncomeSub.asp?rsvno="&lngRsvNo&"&linename="&strLineName&"&price="&lngPrice&"&editprice="&lngEditPrice&"&taxprice="&lngTaxPrice&"&edittax="&lngEditTax&"&divcd="&strDivCd
            Response.end
        End If

    End If


    '保存処理実行
    If strAction = "save" Then
'Err.Raise 1000, , "mode = " & strMode

        '個人請求書管理個人情報作成？
        If strMode = "person" Then

            '呼び元画面の関数呼び出して自身を閉じる
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'#### 2008.07.03 張 セット外請求明細コードを文字列として扱う為（0010などのコード対応）に修正 Start ####
'           strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) { opener.setOtherDiv( "
'           strHTML = strHTML &	strDivCd & ", '" & strLineName & "', '" & strDivName & "'," & lngPrice & "," & lngEditPrice & "," & lngTaxPrice & "," & lngEditTax
'           strHTML = strHTML & " ); } close();"">"
'           strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) { opener.setOtherDiv( '"
            strHTML = strHTML & strDivCd & "', '" & strLineName & "', '" & strDivName & "'," & lngPrice & "," & lngEditPrice & "," & lngTaxPrice & "," & lngEditTax
            strHTML = strHTML & " ); } close();"">"
            strHTML = strHTML & "</BODY>"
'#### 2008.07.03 張 セット外請求明細コードを文字列として扱う為（0010などのコード対応）に修正 End   ####
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End
            Exit Do

        Else

            ''' 個人請求明細情報登録用にパラメータ追加 2003.12.18 
            '受診確定金額情報、個人請求明細情報の登録
            Ret = objPerbill.InsertPerBill_c(strDmdDate, _
                                            lngBillSeq, _
                                            lngBranchNo, _
                                            lngPrice, _
                                            lngEditPrice, _
                                            lngTaxPrice, _
                                            lngEditTax, _
                                            IIf( strDivName = strLineName, "", strLineName), _
                                            lngRsvNo, _
                                            strDivCd, _
                                            , strLineName )

            '保存に失敗した場合
            If Ret <> True Then
                strArrMessage = Array("セット外請求明細の追加に失敗しました。")
                Err.Raise 1000, , "セット外請求明細が追加できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
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

    End If


    Exit Do
Loop


'-------------------------------------------------------------------------------
'
' 機能　　 : 請求書コメントの妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon       '共通クラス
    Dim vntArrMessage   'エラーメッセージの集合

    '共通クラスのインスタンス作成
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '各値チェック処理
    With objCommon
        '請求書コメントチェック
        If strDivCd = "" Then 
            .AppendArray vntArrMessage, "セット外請求明細名【？】を選択して下さい。"
        End If
        .AppendArray vntArrMessage, .CheckWideValue("請求詳細名", strLineName, 40)
''' マイナスの値も入力可能　2003.12.17
        .AppendArray vntArrMessage, objPerBill.CheckNumeric("請求金額", lngPrice, 7)
        .AppendArray vntArrMessage, objPerBill.CheckNumeric("調整金額", lngEditPrice, 7)
        .AppendArray vntArrMessage, objPerBill.CheckNumeric("消費税", lngTaxPrice, 7)
        .AppendArray vntArrMessage, objPerBill.CheckNumeric("調整税額", lngEditTax, 7)
'       .AppendArray vntArrMessage, .CheckNumeric("請求金額", lngPrice, 7)
'       .AppendArray vntArrMessage, .CheckNumeric("調整金額", lngEditPrice, 7)
'       .AppendArray vntArrMessage, .CheckNumeric("消費税", lngTaxPrice, 7)
'       .AppendArray vntArrMessage, .CheckNumeric("調整税額", lngEditTax, 7)
    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>セット外請求明細登録・修正</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

var winGuideOther;          // ウィンドウハンドル
var Other_divCd;            // セット外請求書明細コード
var Other_divName;          // セット外請求書明細名
var Other_lineName;         // 請求書明細名
var Other_Price;            // 標準単価
var Other_TaxPrice;         // 標準税額

function showOtherIncomeWindow( divCd, divName, price, taxPrice, lineName ) {

    var objForm = document.entryForm;   // 自画面のフォームエレメント

    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか

    // ガイドとの連結用変数にエレメントを設定
    Other_divCd     = divCd;
    Other_divName   = divName;
    Other_lineName  = lineName;
    Other_Price     = price;
    Other_TaxPrice  = taxPrice;

    // すでにガイドが開かれているかチェック
    if ( winGuideOther != null ) {
        if ( !winGuideOther.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/perbill/gdeOtherIncome.asp'

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winGuideOther.focus();
        winGuideOther.location.replace( url );
    } else {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//		winGuideOther = window.open( url, '', 'width=640,height=370,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        winGuideOther = window.open( url, '', 'width=400,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
    }
}

// セット外請求明細情報編集用関数
function setDivInfo( divCd, divName, price, taxPrice ) {

    // セット外請求明細コードの編集
    if ( Other_divCd ) {
        Other_divCd.value = divCd;
    }

    // セット外請求明細名の編集
    if ( Other_divName ) {
        Other_divName.value = divName;
        Other_lineName.value = divName;
    }

    if ( document.getElementById( 'dspdivname' ) ) {
        document.getElementById( 'dspdivname' ).innerHTML = divName;
    }

    // 標準金額の編集
    if ( Other_Price ) {
        Other_Price.value = price;
    }

    // 標準税額の編集
    if ( Other_TaxPrice ) {
        Other_TaxPrice.value = taxPrice;
    }

}

// ガイドを閉じる
function closeGuideOther() {

    if ( winGuideOther != null ) {
        if ( !winGuideOther.closed ) {
            winGuideOther.close();
        }
    }

    winGuideOther = null;

}

function checkData() {

    // モードを指定してsubmit
    document.entryForm.act.value = 'check';
    document.entryForm.submit();

}

function windowClose() {

    //ガイドを閉じる
    closeGuideOther();
}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>セット外請求明細登録・修正</B></TD>
        </TR>
    </TABLE>
    <!-- 引数情報 -->
    <INPUT TYPE="hidden" NAME="act" VALUE="">
    <INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

    <INPUT TYPE="hidden" NAME="divcd" VALUE="<%= strDivCd %>">
    <INPUT TYPE="hidden" NAME="divname" VALUE="<%= strDivName %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="billcount" VALUE="<%= lngBillCount %>">
    <INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
    <INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
    <INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">
<%
'メッセージの編集
    'メッセージの編集
    If strAction <> "" Then

        Select Case strAction

            '保存完了時は「保存完了」の通知
            Case "saveend"
                Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

            '削除完了時は「削除完了」の通知
            Case "deleteend"
                Call EditMessage("削除が完了しました。", MESSAGETYPE_NORMAL)

            'さもなくばエラーメッセージを編集
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD NOWRAP >請求先</TD>
            <TD>：</TD>
            <TD NOWRAP >個人受診</TD>
        </TR>
        <TR>
            <TD NOWRAP >セット外請求明細名</TD>
            <TD>：</TD>
            <TD>
                <TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP ><A HREF="javascript:showOtherIncomeWindow(document.entryForm.divcd, document.entryForm.divname, document.entryForm.price, document.entryForm.taxprice, document.entryForm.linename )" ><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="セット外請求明細一覧表示"></A></TD>
                        <TD NOWRAP ><SPAN ID="dspdivname"><%= strDivName %></SPAN></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP >請求明細名</TD>
            <TD>：</TD>
            <TD>
                <TABLE WIDTH="120" BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP ><INPUT TYPE="text" NAME="linename" VALUE="<%= strLineName %>" SIZE="40" MAXLENGTH="20"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP >請求金額</TD>
            <TD>：</TD>
            <TD NOWRAP ><INPUT TYPE="text" NAME="price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="7"></TD>
        </TR>
        <TR>
            <TD NOWRAP >調整金額</TD>
            <TD>：</TD>
            <TD NOWRAP ><INPUT TYPE="text" NAME="editprice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="7"></TD>
        </TR>
        <TR>
            <TD NOWRAP >消費税</TD>
            <TD>：</TD>
            <TD NOWRAP ><INPUT TYPE="text" NAME="taxprice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="7"></TD>
        </TR>
        <TR>
            <TD NOWRAP >調整税額</TD>
            <TD>：</TD>
            <TD NOWRAP ><INPUT TYPE="text" NAME="edittax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="7"></TD>
        </TR>
    </TABLE>
    <BR>
    <A HREF="javascript:checkData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で確定"></A>
    <A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
</FORM>
</BODY>
</HTML>
