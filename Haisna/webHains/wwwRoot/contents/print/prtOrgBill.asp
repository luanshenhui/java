<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	請求書（団体） (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode			'印刷モード
Dim vntMessage		'通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon		'共通クラス
Dim objOrganization	'団体情報アクセス用
Dim objOrgBsd		'事業部情報アクセス用
Dim objOrgRoom		'室部情報アクセス用
Dim objOrgPost		'所属情報アクセス用
Dim objPerson		'個人情報アクセス用

'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim UID
Dim strSCslYear, strSCslMonth, strSCslDay	'開始年月日
Dim strECslYear, strECslMonth, strECslDay	'終了年月日
Dim strOrgCd1, strOrgCd2			'請求先団体コード
Dim strBillNo					'請求書番号
Dim strObject					'出力対象
Dim strDelFlg					'取消伝票
Dim strSort						'出力順
Dim strBillNote					'請求書案内文
'<!--  2004/06/22 ADD STR ORB)R.ARAKI  区分項目追加  -->
Dim strKbn					'区分
'<!--  2004/06/22 ADD END ORB)R.ARAKI  -->

'■■■■■■■■■■
'作業用変数
Dim strOrgName		'団体名
Dim strSCslDate		'開始日
Dim strECslDate		'終了日


'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'共通引数値の取得
strMode = Request("mode")

'帳票出力処理制御
vntMessage = PrintControl(strMode)

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
'■■■■■■■■■■ 画面項目にあわせて編集
    '括弧内の文字列はHTML部で記述した項目の名称となります

'◆ 開始年月日
    If IsEmpty(Request("strCslYear")) Then
        strSCslYear   = Year(Now())				'開始年
        strSCslMonth  = Month(Now())			'開始月
        strSCslDay    = Day(Now())				'開始日
    Else
        strSCslYear   = Request("strCslYear")	'開始年
        strSCslMonth  = Request("strCslMonth")	'開始月
        strSCslDay    = Request("strCslDay")	'開始日
    End If
    strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'◆ 終了年月日
    If IsEmpty(Request("endCslYear")) Then
        strECslYear   = Year(Now())				'終了年
        strECslMonth  = Month(Now())			'開始月
        strECslDay    = Day(Now())				'開始日
    Else
        strECslYear   = Request("endCslYear")	'終了年
        strECslMonth  = Request("endCslMonth")	'開始月
        strECslDay    = Request("endCslDay")	'開始日
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay

'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
    If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
       Right("00" & Trim(CStr(strSCslMonth)), 2) & _
       Right("00" & Trim(CStr(strSCslDay)), 2) _
     > Right("0000" & Trim(CStr(strECslYear)), 4) & _
       Right("00" & Trim(CStr(strECslMonth)), 2) & _
       Right("00" & Trim(CStr(strECslDay)), 2) Then
        strSCslYear   = strECslYear
        strSCslMonth  = strECslMonth
        strSCslDay    = strECslDay
        strSCslDate   = strECslDate
        strECslYear   = Request("strCslYear")	'開始年
        strECslMonth  = Request("strCslMonth")	'開始月
        strECslDay    = Request("strCslDay")	'開始日
        strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
    End If

'◆ 団体
    strOrgCd1     = Request("orgCd1")		'団体コード１
    strOrgCd2     = Request("orgCd2")		'団体コード２
    If strOrgCd1 <> "" And strOrgCd2 <> "" Then
'		objOrganization.SelectOrg strOrgCd1, strOrgCd2, , strOrgName
    End If

'◆ 請求書番号
    strBillNo	= Request("BillNo")		'請求書番号

'◆ 出力対象
    strObject	= Request("Object")		'出力対象

'◆ 取消伝票
    strDelflg	= Request("Delflg")		'取消伝票

'◆ 案内文
    strBillNote = Request("billNote")		'取消伝票

'<!--  2004/06/22 ADD STR ORB)R.ARAKI  区分項目追加  -->
'◆ 区分
    strKbn = Request("Kbn")				'区分
'<!--  2004/06/22 ADD END ORB)R.ARAKI  -->

'■■■■■■■■■■
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

    Dim vntArrMessage	'エラーメッセージの集合
    Dim aryChkString
    
    aryChkString = Array("1","2","3","4","5","6","7","8","9","0")

    'ここにチェック処理を記述
    With objCommon

        If strMode <> "" Then
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "開始日付が正しくありません。"
            End If

            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "終了日付が正しくありません。"
            End If
        End If

'		If (Len(Trim(strBillNo)) <> 14) And (Trim(strBillNo) <> "") Then
'			.AppendArray vntArrMessage, "正しい請求書番号を入力してください。(14桁）"
'		End If

    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票ドキュメントファイル作成処理
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

    Dim objPrintCls	'団体一覧出力用COMコンポーネント
    Dim Ret			'関数戻り値

    Dim strURL

    If Not IsArray(CheckValue()) Then

		Dim referer	'URLとパラメータに分割したリファラ
		Dim ary		'URLを"/"で分割した配列
		
		'リファラをURLとパラメータに分割
		referer = Split(Request.ServerVariables("HTTP_REFERER"), "?")
		
		'URLを"/"で分割
		ary = Split(referer(0), "/")
		
		'リファラのファイル名から出力するログを決定
		Select Case ary(Ubound(ary))
			Case "dmdBurdenModify.asp"
				'情報漏えい対策用ログ書き出し
				Call putPrivacyInfoLog("PH047", "団体請求書基本情報画面 請求書の印刷を行った")
			Case Else
				'情報漏えい対策用ログ書き出し
				Call putPrivacyInfoLog("PH036", "請求書の印刷を行った")
		End Select

        'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        Set objPrintCls = Server.CreateObject("HainsprtOrgBill.prtOrgBill")

        'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'<!--  2004/06/22 UPD STR ORB)R.ARAKI  区分項目追加  -->
'		Ret = objPrintCls.PrintOut(Server.HTMLEncode(Session("USERID")), strSCslDate, strECslDate, strOrgCd1, strOrgCd2, strBillNo, strObject, strDelflg, strBillNote)
        Ret = objPrintCls.PrintOut(Server.HTMLEncode(Session("USERID")), strSCslDate, strECslDate, strOrgCd1, strOrgCd2, strBillNo, strObject, strDelflg, strBillNote, strKbn)
'<!--  2004/06/22 ADD END ORB)R.ARAKI  -->
        print=Ret


    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- ◆ ↓<Title>の修正を忘れないように ◆ -->
<TITLE>請求書（団体）</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setBillNote() {

    var wk_billNote;
    
    with ( document.entryForm ) {

        if ( billNoteDiv.value == 1 ) {
            wk_billNote = ''
            wk_billNote = wk_billNote + '拝啓　貴社ますますご清祥のこととお喜び申し上げます。\n';
            wk_billNote = wk_billNote + 'いつも当院人間ドックをご利用いただきありがとうございます。\n';
            wk_billNote = wk_billNote + 'さて、先月にお受けいただいた人間ドックの請求書をお送り申し上げます。\n';
            wk_billNote = wk_billNote + 'ご確認の上、指定口座までご入金下さいますようお願い申し上げます。\n';
            wk_billNote = wk_billNote + '今後とも、より一層のご厚情を賜りますようお願い申し上げます。\n';
            wk_billNote = wk_billNote + '　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　敬具';
            billNote.value = wk_billNote;

        }

        if ( billNoteDiv.value == 2 ) {
//### 2015.12.01 張 案内文２に固定文章デフォルト表示 START ###################################################################
//            billNote.value = '';
            wk_billNote = ''
            wk_billNote = wk_billNote + '拝啓　貴社ますますご清祥のこととお喜び申し上げます。\n';
            wk_billNote = wk_billNote + 'いつも当院人間ドックをご利用いただきありがとうございます。\n';
            wk_billNote = wk_billNote + 'さて、先月にお受けいただいた人間ドックの請求書をお送り申し上げます。\n';
            wk_billNote = wk_billNote + 'ご確認の上、指定口座までご入金下さいますようお願い申し上げます。\n';
            wk_billNote = wk_billNote + '勝手ながら、支払期日はご受診月の翌月末までとさせていただきます。\n';
            wk_billNote = wk_billNote + '今後とも、より一層のご厚情を賜りますようお願い申し上げます。\n';
            wk_billNote = wk_billNote + '　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　敬具';
            billNote.value = wk_billNote;
//### 2015.12.01 張 案内文２に固定文章デフォルト表示 END   ###################################################################
        }

    }

}
// エレメントの参照設定
function setElement() {

    with ( document.entryForm ) {

        // 団体・所属情報エレメントの参照設定（入力項目に団体・所属が無い場合は不要）
        orgPostGuide_getElement( orgCd1, orgCd2, 'orgName' );

    
    }

}
//-->
</SCRIPT>
<script TYPE="text/javascript" src="/webHains/js/checkRunState.js?v=1.2"></script>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement();setBillNote();checkRunState();">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" onsubmit="setRunState();">
    <INPUT TYPE="hidden" NAME="runstate" VALUE="">
    <BLOCKQUOTE>
<!--- タイトル -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN>請求書（団体）</B></TD>
        </TR>
    </TABLE>
    <BR>

<%
'エラーメッセージ表示
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<BR>
<!--- 日付 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="90" NOWRAP>請求日</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                        <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
                        <TD>日</TD>
                        <TD>～</TD>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                        <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
                        <TD>日</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <!-- 請求書先 -->
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>請求先</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
                        <TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
                        <TD NOWRAP><SPAN ID="orgName"></SPAN>
                            <INPUT TYPE="hidden" NAME="orgCd1" VALUE="<% = strOrgCd1 %>">
                            <INPUT TYPE="hidden" NAME="orgCd2" VALUE="<% = strOrgCd2 %>">
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <!-- 請求書番号 -->
        <TR>
            <TD><font color="black">□</font></TD>
            <TD WIDTH="90" NOWRAP>請求書番号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="BillNo" MAXLENGTH="14" SIZE="20" VALUE="<%= strBillNo %>"></TD>
        </TR>
        <!--請求対象-->
        <TR>
            <TD><font color="black">□</font></TD>
            <TD WIDTH="90" NOWRAP>請求対象</TD>
            <TD>：</TD>
            <TD>
                <select name="Object" size="1">
                    <option selected value="1">全て出力</option>
                    <option value="2">未印刷のみ</option>
                    <option value="3">印刷済のみ</option>
                </select>
            </TD>
        </TR>
        <!--取消伝票-->
        <TR>
            <TD><font color="black">□</font></TD>
            <TD WIDTH="90" NOWRAP>取消伝票</TD>
            <TD>：</TD>
            <TD>
                <select name="Delflg" size="1">
                    <option selected value="2">出力しない</option>
                    <option value="1">出力する</option>
                </select>
            </TD>
        </TR>
        <!--コメント-->
        <TR>
            <TD ROWSPAN="2" VALIGN="TOP"><font color="black">□</font></TD>
            <TD ROWSPAN="2" VALIGN="TOP" WIDTH="90" NOWRAP>案内文</TD>
            <TD ROWSPAN="2" VALIGN="TOP">：</TD>
            <TD>
                <select name="billNoteDiv" size="1" ONCHANGE="javascript:setBillNote()">
                    <option selected value="1">案内文１</option>
                    <option value="2">案内文２</option>
                </select>
            </TD>
        </TR>
        <TR>
            <TD COLSPAN="15">
                <TEXTAREA NAME="billNote" ROWS="10" COLS="80" WRAP="SOFT"></TEXTAREA>
            </TD>
        </TR>
        
<!--  2004/06/22 ADD STR ORB)R.ARAKI  -->
        <!--- 区分 -->
        
        <TR>
            <TD><font color="black">□</font></TD>
            <TD WIDTH="90" NOWRAP>区分</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="Radio" NAME="Kbn" VALUE="0" <%= "CHECKED" %> >１次</TD>
                        <TD><INPUT TYPE="Radio" NAME="Kbn" VALUE="1" >２次</TD>
                        <TD><INPUT TYPE="Radio" NAME="Kbn" VALUE="2" >全て</TD>
                    </TR>
                </TABLE>
            </TD>			
        </TR>
<!--  2004/06/22 ADD END ORB)R.ARAKI  -->
        
        
    </TABLE>
<BR>
<!--- 印刷モード -->
<%
    '印刷モードの初期設定
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<!--  2003/02/27  START  START  E.Yamamoto  -->
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/02/27  START  END    E.Yamamoto  -->
<!--  2003/02/27  DEL  START  E.Yamamoto  -->
<!--
            <TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
            <TD NOWRAP>プレビュー</TD>

            <TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
            <TD NOWRAP>直接出力</TD>
        </TR>
--><!--  2003/02/27  DEL  END    E.Yamamoto  -->
                </TABLE>

    <BR><BR>

<!--- 印刷ボタン -->
    <!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
    <%  End if  %>

    </BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>