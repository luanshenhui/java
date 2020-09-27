<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web団体予約情報登録(検査セット) (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.11
'担当者  ：T.Takagi@RD
'修正内容：web予約受診オプションの取得方法変更

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD START #### %>
<!-- #include virtual = "/webHains/includes/convertWebOption.inc" -->
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD END   #### %>
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const SETCLASS_STOMAC_NOTHING   = "035" 'セット分類(１日ドック(胃せず))
Const SETCLASS_STOMAC_XRAY      = "001" 'セット分類(１日ドック(胃Ｘ線))
Const SETCLASS_STOMAC_CAMERA    = "002" 'セット分類(１日ドック(胃内視鏡))

Const SETCLASS_BREAST_NOTHING   = "009" 'セット分類(オプション乳房検査なし)

Const SETCLASS_BREAST_XRAY      = "010" 'セット分類(乳房Ｘ線)

Const SETCLASS_BREAST_ECHO      = "011" 'セット分類(乳房超音波)

Const SETCLASS_BREAST_XRAY_ECHO = "012" 'セット分類(乳房Ｘ線・乳房超音波)

'データベースアクセス用オブジェクト
Dim objContract             '契約情報アクセス用
Dim objSchedule             'スケジュール情報アクセス用

'引数値(共通)
Dim strPerId                '個人ＩＤ
Dim lngGender               '性別
Dim dtmBirth                '生年月日
Dim strOrgCd1               '団体コード１
Dim strOrgCd2               '団体コード２
Dim strCsCd                 'コースコード
Dim dtmCslDate              '受診日
Dim strCslDivCd             '受診区分コード
Dim lngOptionStomac         '胃検査(0:胃なし、1:胃X線、2:胃内視鏡)
Dim lngOptionBreast         '乳房検査(0:乳房なし、1:乳房X線、2:乳房超音波、3:乳房X線＋乳房超音波)
Dim blnShowAll              '全セット表示フラグ
Dim blnReadOnly             '読み込み専用
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
Dim strCslOptions			'受診オプション
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'引数値(本画面から表示ボタンを押下された場合のみ渡される)
Dim strCtrPtCd              '契約パターンコード
Dim strOptCd                'オプションコード
Dim strOptBranchNo          'オプション枝番

'契約情報
Dim strNewCtrPtCd           '契約パターンコード
Dim strAgeCalc              '年齢起算日
Dim strRefOrgCd1            '参照先団体コード１
Dim strRefOrgCd2            '参照先団体コード２
Dim strCsName               'コース名

'オプション検査情報
Dim strArrOptCd             'オプションコード
Dim strArrOptBranchNo       'オプション枝番
Dim strOptName              'オプション名
Dim strSetColor             'セットカラー
Dim strSetClassCd           'セット分類コード
Dim strConsult              '受診要否
Dim strBranchCount          'オプション枝番数
Dim strAddCondition         '追加条件
Dim strHideRsv              '予約画面非表示
Dim strPrice                '総金額
Dim strPerPrice             '個人負担金額
Dim lngCount                'オプション検査数

'非表示オプション情報
Dim strHideElementName()    'エレメント名
Dim strHideOptCd()          'オプションコード
Dim strHideOptBranchNo()    'オプション枝番
Dim strHideConsult()        '受診要否
Dim lngHideCount            'オプション数

'契約情報
Dim strArrCsCd              'コースコード
Dim strArrCsName            'コース名
Dim strArrCtrPtCd           '契約パターンコード
Dim lngCtrCount             '契約情報数

'受診区分情報
Dim strArrCslDivCd          '受診区分コード
Dim strArrCslDivName        '受診区分名
Dim lngCslDivCount          '受診区分数

Dim strAge                  '受診時年齢
Dim strRealAge              '実年齢

Dim strChecked              'チェックボックスのチェック状態

Dim strPrevOptCd            '直前レコードのオプションコード
Dim lngOptGrpSeq            'オプショングループのSEQ値
Dim strElementType          'オプション選択用のエレメント種別
Dim strElementName          'オプション選択用のエレメント名

Dim blnExist                '存在フラグ
Dim strMessage              'メッセージ
Dim strURL                  'ジャンプ先のURL
Dim i                       'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract = Server.CreateObject("HainsContract.Contract")

'response.write Request("birth")
'response.write Request("cslDate")
'response.end

'引数値の取得
strPerId        = Request("perId")
lngGender       = CLng("0" & Request("gender"))
dtmBirth        = CDate(Request("birth"))
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strCsCd         = Request("csCd")
dtmCslDate      = CDate(Request("cslDate"))
strCslDivCd     = Request("cslDivCd")
lngOptionStomac = CLng("0" & Request("stomac"))
lngOptionBreast = CLng("0" & Request("breast"))
blnShowAll      = (Request("showAll") <> "")
blnReadOnly     = (Request("readOnly") <> "")
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
strCslOptions   = Request("csloptions")
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

strCtrPtCd      = Request("ctrPtCd")
strOptCd        = ConvIStringToArray(Request("optCd"))
strOptBranchNo  = ConvIStringToArray(Request("optBNo"))

Do

    strMessage = "基本情報を入力して下さい。"

    '受診日時点での実年齢計算
    strRealAge = CalcAge(dtmBirth, dtmCslDate, "")

    '小数点以下の除去
    If InStr(strRealAge, ".") > 0 Then
        strRealAge = Left(strRealAge, InStr(strRealAge, ".") - 1)
    End If

    '指定団体における受診日時点で有効なすべてのコースを契約管理情報を元に読み込む
    lngCtrCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, "", dtmCslDate, dtmCslDate, , strArrCsCd, , strArrCsName, , , , strArrCtrPtCd)
    If lngCtrCount <= 0 Then
        Exit Do
    End If

    '受診日時点で有効なすべてのコースに指定されたコースが存在するかを検索し、その契約パターンコードを取得
    For i = 0 To lngCtrCount - 1
        If strArrCsCd(i) = strCsCd Then
            strNewCtrPtCd = strArrCtrPtCd(i)
            Exit For
        End If
    Next

    '指定条件を満たす契約情報が存在しない場合、年齢計算も不能、かつオプション検査の取得も不能なため、処理を終了する
    If strNewCtrPtCd = "" Then
        strMessage = "この団体のドック契約情報は存在しません。"
        Exit Do
    End If

    '指定団体における受診日時点で有効な受診区分を契約管理情報を元に読み込む
    lngCslDivCount = objContract.SelectAllCslDiv(strOrgCd1, strOrgCd2, strCsCd, dtmCslDate, dtmCslDate, strArrCslDivCd, strArrCslDivName)
    If lngCslDivCount <= 0 Then
        Exit Do
    End If

    '年齢計算に際し、まず契約情報を読み込んで年齢起算日を取得する(参照先の団体は後でアンカー用に使用する)
    objContract.SelectCtrMng strOrgCd1, strOrgCd2, strNewCtrPtCd, , , , , , , , strRefOrgCd1, strRefOrgCd2, strAgeCalc

    '年齢計算
    strAge = CalcAge(dtmBirth, dtmCslDate, strAgeCalc)

    '選択すべき受診区分が存在するかを検索
    For i = 0 To lngCslDivCount - 1
        If strArrCslDivCd(i) = strCslDivCd Then
            blnExist = True
            Exit For
        End If
    Next

    '選択すべき受診区分が存在しなければオプション検査の取得は不能と判断し、処理を終了する
    If Not blnExist Then
        Exit Do
    End If

    '指定契約パターンの全オプション検査とそのデフォルト受診状態を取得
    lngCount = objContract.SelectCtrPtOptFromConsult( _
                   dtmCslDate,        _
                   strCslDivCd,       _
                   strNewCtrPtCd,     _
                   strPerId,          _
                   lngGender,         _
                   dtmBirth, ,        _
                   True,              _
                   False,             _
                   strArrOptCd,       _
                   strArrOptBranchNo, _
                   strOptName, ,      _
                   strSetColor,       _
                   strSetClassCd,     _
                   strConsult, , ,    _
                   strBranchCount,    _
                   strAddCondition, , _
                   strHideRsv, , ,    _
                   strPrice,          _
                   strPerPrice,       _
                   1                  _
               )

    'オプションが引数として渡されていない場合、または渡されているが契約パターンが一致しない場合(後者は事実上発生しない)
    If strCtrPtCd = "" Or strCtrPtCd <> strNewCtrPtCd Then

        'デフォルト受診状態を設定
        Call SetDefaultConsults

        Exit Do
    End If

    'オプションが渡され、かつ契約パターンも一致する場合は受診状態の継承を行う
    SetConsultPreviousStatus strOptCd, strOptBranchNo

    Exit Do
Loop
'-------------------------------------------------------------------------------
'
' 機能　　 : 年齢計算
'
' 引数　　 : (In)     dtmParaBirth    生年月日
' 　　　　   (In)     dtmParaCslDate  受診年月日
' 　　　　   (In)     strParaAgeCalc  年齢起算日
'
' 戻り値　 : 年齢
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CalcAge(dtmParaBirth, dtmParaCslDate, strParaAgeCalc)

    Dim objFree     '汎用情報アクセス用

    'オブジェクトのインスタンス作成
    Set objFree = Server.CreateObject("HainsFree.Free")

    '年齢の計算
    CalcAge = objFree.CalcAge(dtmParaBirth, dtmParaCslDate, strParaAgeCalc)

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : デフォルト受診状態設定
'
' 引数　　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SetDefaultConsults()

    Dim strArrSetClassCd    'セット分類コード

'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
	Dim i					'インデックス

	'受診オプションのカンマ区切り文字列が指定されている場合はその内容をもとにデフォルト受診状態を設定。さもなくば旧来の設定ロジックを採用。
	If strCslOptions <> "" Then

		'受診オプションのカンマ区切り文字列をセット分類の配列に変換
		strArrSetClassCd = ConvertToSetClass(strCslOptions)

		'配列要素が存在する場合はそのすべてのセット分類を検索し、デフォルト受診状態を設定
		If Not IsEmpty(strArrSetClassCd) Then
			For i = 0 To UBound(strArrSetClassCd)
				SetConsults strArrSetClassCd(i)
			Next
		End If

	Else
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

    '胃検査のデフォルト受診状態設定
    strArrSetClassCd = Array(SETCLASS_STOMAC_NOTHING, SETCLASS_STOMAC_XRAY, SETCLASS_STOMAC_CAMERA)
    SetConsults strArrSetClassCd(lngOptionStomac)

    '乳房検査のデフォルト受診状態設定
    strArrSetClassCd = Array(SETCLASS_BREAST_NOTHING, SETCLASS_BREAST_XRAY, SETCLASS_BREAST_ECHO, SETCLASS_BREAST_XRAY_ECHO)
    SetConsults strArrSetClassCd(lngOptionBreast)

'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
	End If
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

    '受診フラグが立っていない任意受診のセットに対し、先頭セットを受診状態にする
    Call SetConsultTopSet

    '複数の枝番セットに受診フラグが立つ任意受診のセットに対して、枝番が若い方を優先する
    Call SetConsultMinimumOpt

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 任意受診オプションのデフォルト受診状態設定１
'
' 引数　　 : (In)     strParaSetClassCd  受診対象となるセット分類コード
'
' 備考　　 : 指定セット分類に受診フラグを立てる
'
'-------------------------------------------------------------------------------
Sub SetConsults(strParaSetClassCd)

    Dim i   'インデックス

    '指定セット分類の任意受診検査セットに受診フラグを立てる
    For i = 0 To lngCount - 1
        If strAddCondition(i) = "1" And strSetClassCd(i) = strParaSetClassCd Then
            strConsult(i) = "1"
        End If
    Next

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 任意受診オプションのデフォルト受診状態設定２
'
' 引数　　 :
'
' 備考　　 : 受診フラグが立っていない任意受診のセットに対し、先頭セットを受診状態にする
'
'-------------------------------------------------------------------------------
Sub SetConsultTopSet()

    Dim blnConsult  '受診チェックの要否
    Dim i, j        'インデックス

    i = 0
    Do Until i >= lngCount

        Do

            '自動追加オプションはスキップ
            If strAddCondition(i) = "0" Then
                i = i + 1
                Exit Do
            End If

            '枝番数が１のものは(チェックボックス制御となるので)スキップ
            If CLng("0" & strBranchCount(i)) <= 1 Then
                i = i + 1
                Exit Do
            End If

            '現在位置をキープ
            j = i

            strPrevOptCd = strArrOptCd(i)
            blnConsult = False

            '現在位置から同一オプションコードの受診状態を検索
            Do Until i >= lngCount

                '直前レコードとオプションコードが異なる場合は終了
                If strArrOptCd(i) <> strPrevOptCd Then
                    Exit Do
                End If

                'すでに受診状態のものがあればフラグ成立
                If strConsult(i) = "1" Then
                    blnConsult = True
                End If

                '現在のオプションコードを退避
                strPrevOptCd = strArrOptCd(i)
                i = i + 1
            Loop

            '結果、受診状態のものがなければ先にキープしておいた先頭のオプションを受診状態にする
            If Not blnConsult Then
                strConsult(j) = "1"
            End If

            Exit Do
        Loop

    Loop

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 任意受診オプションのデフォルト受診状態設定３
'
' 引数　　 :
'
' 備考　　 : 複数の枝番セットに受診フラグが立つ任意受診のセットに対して、枝番が若い方を優先する
'
'-------------------------------------------------------------------------------
Sub SetConsultMinimumOpt()

    Dim blnConsult  '受診チェックの要否
    Dim i, j        'インデックス

    i = 0
    Do Until i >= lngCount

        Do

            '自動追加オプションはスキップ
            If strAddCondition(i) = "0" Then
                i = i + 1
                Exit Do
            End If

            '枝番数が１のものは(チェックボックス制御となるので)スキップ
            If CLng("0" & strBranchCount(i)) <= 1 Then
                i = i + 1
                Exit Do
            End If

            strPrevOptCd = strArrOptCd(i)
            blnConsult = False

            '現在位置から同一オプションコードの受診状態を検索
            Do Until i >= lngCount

                '直前レコードとオプションコードが異なる場合は終了
                If strArrOptCd(i) <> strPrevOptCd Then
                    Exit Do
                End If

                'すでにフラグ成立時は以降の枝番オプションの受診状態をクリア
                If blnConsult Then
                    strConsult(i) = ""
                End If

                '受診状態のセットを最初に検索した場合にフラグ成立
                If strConsult(i) = "1" Then
                    blnConsult = True
                End If

                '現在のオプションコードを退避
                strPrevOptCd = strArrOptCd(i)
                i = i + 1
            Loop

            Exit Do
        Loop

    Loop

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 直前受診状態の設定
'
' 引数　　 : (In)     strParaDefOptCd        継承チェックすべきオプションコードの集合
' 　　　　   (In)     strParaDefOptBranchNo  継承チェックすべきオプション枝番の集合
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SetConsultPreviousStatus(strParaDefOptCd, strParaDefOptBranchNo)

    Dim i, j    'インデックス

    '全検査セットの検索
    For i = 0 To lngCount - 1

        Do

            'フラグの初期化
            strConsult(i) = ""

            '引数未指定時は未選択とする
            If IsEmpty(strParaDefOptCd) Or IsEmpty(strParaDefOptBranchNo) Then
                Exit Do
            End If

            '引数指定されたオプションに対してチェックをつける
            For j = 0 To UBound(strParaDefOptCd)
                If strParaDefOptCd(j) = strArrOptCd(i) And strParaDefOptBranchNo(j) = strArrOptBranchNo(i) Then
                    strConsult(i) = "1"
                    Exit Do
                End If
            Next

            Exit Do
        Loop

    Next

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>オプション検査</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 指定エレメントのチェック状態による行表示色設定
function selColor( selObj ) {

    var rowColor, topColor;     // 行全体の色、先頭列の色

    // 表示色を変更すべきノードを取得
    var changedNode = selObj.parentNode.parentNode;

    // 表示色の設定
    if ( selObj.checked ) {
        rowColor = '#eeeeee';
        topColor = '#ffc0cb';
    } else {
        rowColor = '#ffffff';
        topColor = '#ffffff';
    }

    // 表示色の変更
    changedNode.style.backgroundColor = rowColor;
    changedNode.getElementsByTagName('td')[0].style.backgroundColor = topColor;

}

// 指定エレメントに対応する行の選択表示
function setRow( selObj ) {

    var objRadio;   // ラジオボタンの集合
    var selFlg;     // 選択フラグ

    // エレメントタイプごとの処理分岐
    switch ( selObj.type ) {

        case 'checkbox':    // チェックボックス
            selColor( selObj );
            break;

        case 'radio':       // ラジオボタン

            // 同名の全エレメントに対する選択表示
            objRadio = document.optList.elements[ selObj.name ];
            for ( var i = 0; i < objRadio.length; i++ ) {
                selColor( objRadio[ i ] );
            }

    }

}

// 全行の選択表示
function setRows() {

    // 一覧が存在しなければ何もしない
    if ( !document.optList ) {
        return;
    }

    var objElements = document.optList.elements;
    for ( var i = 0; i < objElements.length; i++ ) {
        setRow( objElements[ i ] );
    }

}

// 一覧の再表示
function showOptList() {

    var arrOptCd       = new Array();	// オプションコード
    var arrOptBranchNo = new Array();	// オプション枝番

    // 現在の選択オプション値を取得
    top.convOptCd( document.optList, arrOptCd, arrOptBranchNo );

    // オプション検査画面の更新
    top.replaceOptionFrame( document.entryForm.ctrPtCd.value, arrOptCd, arrOptBranchNo );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setRows()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="464">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">検査セット</FONT></B></TD>
    </TR>
</TABLE>
<%
Do
    '契約情報の表示が行えない場合はメッセージを編集
    If Not blnExist Then
%>
        <BR><%= strMessage %>
<%
        Exit Do
    End If
%>
    <FORM NAME="entryForm" STYLE="margin: 0px" action="#">
        <INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strNewCtrPtCd %>">
        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0" WIDTH="464">
            <TR>
                <TD NOWRAP><FONT SIZE="-1">パターンNo.：<B><%= strNewCtrPtCd %></B></FONT></TD>
<%
                '契約参照用のURL編集
                strURL = "/webHains/contents/contract/ctrDetail.asp"
                strURL = strURL & "?orgCd1="  & strRefOrgCd1
                strURL = strURL & "&orgCd2="  & strRefOrgCd2
                strURL = strURL & "&csCd="    & strCsCd
                strURL = strURL & "&ctrPtCd=" & strNewCtrPtCd
%>
                <TD WIDTH="100%" NOWRAP><FONT SIZE="-1">&nbsp;&nbsp;<A HREF="<%= strURL %>" TARGET="_blank">この契約を参照</A></FONT></TD>
                <TD><INPUT TYPE="checkBox" NAME="showAll" VALUE="1"<%= IIf(blnShowAll, " CHECKED", "") %>></TD>
                <TD NOWRAP><FONT SIZE="-1">すべての検査を&nbsp;</FONT></TD>
                <TD><A HREF="javascript:showOptList()"><IMG SRC="/webhains/images/b_prev.gif" HEIGHT="28" WIDTH="53" ALT="検査セットを再表示します"></A></TD>
            </TR>
            <TR>
                <TD HEIGHT="5"></TD>
            </TR>
        </TABLE>
    </FORM>
<%
    'オプション検査が存在しない場合はメッセージ編集
    If lngCount = 0 Then
        Response.Write "この契約情報のオプション検査は存在しません。"
        Exit Do
    End If

    lngOptGrpSeq = 0
%>
    <FORM NAME="optList" STYLE="margin: 0px" action="#">
        <TABLE ID="optTable" BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="464">
            <TR>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="1" ALT=""></TD>
            </TR>
            <TR BGCOLOR="#eeeeee" ALIGN="center">
<%
                '契約パターン情報を読み、契約上のコース名を取得
                objContract.SelectCtrPt strNewCtrPtCd, , , , , strCsName
%>
                <TD ALIGN="left" COLSPAN="3">検査セット名（<%= strCsName %>）</TD>
                <TD NOWRAP>負担金額計</TD>
                <TD NOWRAP>個人負担分</TD>
                <TD></TD>
            </TR>
<%
            '読み込んだオプション検査情報の検索
            strPrevOptCd = ""
            For i = 0 To lngCount - 1

                '直前レコードとオプションコードが異なる場合
                If strArrOptCd(i) <> strPrevOptCd Then

                    'まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
                    strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

                    'オプション編集用のエレメント名を定義する
                    lngOptGrpSeq   = lngOptGrpSeq + 1
                    strElementName = "opt" & CStr(lngOptGrpSeq)

                End If

                '予約画面非表示オプション、かつすべての検査を表示しない場合
                If strHideRsv(i) <> "" And blnShowAll = False Then

                    '後で編集するためにここでスタックする
                    ReDim Preserve strHideElementName(lngHideCount)
                    ReDim Preserve strHideOptCd(lngHideCount)
                    ReDim Preserve strHideOptBranchNo(lngHideCount)
                    ReDim Preserve strHideConsult(lngHideCount)
                    strHideElementName(lngHideCount) = strElementName
                    strHideOptCd(lngHideCount) = strArrOptCd(i)
                    strHideOptBranchNo(lngHideCount) = strArrOptBranchNo(i)
                    strHideConsult(lngHideCount) = strConsult(i)
                    lngHideCount = lngHideCount + 1

                '表示対象オプションの場合
                Else

                    '直前レコードとオプションコードが異なる場合はセパレータを編集
                    If strPrevOptCd <> "" And strArrOptCd(i) <> strPrevOptCd Then
%>
                        <TR><TD HEIGHT="3"></TD></TR>
<%
                    End If

                    strChecked = IIf(strConsult(i) = "1", " CHECKED", "")
%>
                    <TR ALIGN="right">
                        <TD></TD>
                        <TD><INPUT TYPE="<%= strElementType %>" NAME="<%= strElementName %>" VALUE="<%= strArrOptCd(i) & "," & strArrOptBranchNo(i) %>"<%= strChecked %> ONCLICK="javascript:setRow(this)"></TD>
                        <TD ALIGN="left" WIDTH="100%"><FONT COLOR="<%= strSetColor(i) %>">■</FONT><%= strOptName(i) %></TD>
                        <TD><%= FormatCurrency(strPrice(i)) %></TD>
                        <TD><%= FormatCurrency(strPerPrice(i)) %></TD>
                        <TD NOWRAP>&nbsp;<%= strArrOptCd(i) & "-" & strArrOptBranchNo(i) %></TD>
                    </TR>
<%
                End If

                '現レコードのオプションコードを退避
                strPrevOptCd = strArrOptCd(i)

            Next
%>
        </TABLE>
<%
        'スタックされた情報をここでhiddenにて保持
        For i = 0 To lngHideCount - 1
%>
            <INPUT TYPE="hidden" NAME="<%= strHideElementName(i) %>" VALUE="<%= strHideOptCd(i) & "," & strHideOptBranchNo(i) & "," & strHideConsult(i) %>">
<%
        Next
%>
    </FORM>
<%
    Exit Do
Loop
%>
<SCRIPT TYPE="text/javascript">
<!--
<%
'受診区分セレクションボックスの編集
%>
var cslDivInfo = new Array();
<%
For i = 0 To lngCslDivCount - 1
%>
    cslDivInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrCslDivCd(i) %>', '<%= strArrCslDivName(i) %>' );
<%
Next
%>
top.editCslDiv(cslDivInfo, '<%= strCslDivCd %>');
<%
'年齢を計算し、基本情報に編集する
%>
top.editAge('<%= strAge %>', '<%= strRealAge %>');
<%
'読み込み専用時はすべての入力要素を使用不能にする
If blnReadOnly Then
%>
    top.disableElements( document.optList );
<%
End If
%>
//-->
</SCRIPT>
</BODY>
</HTML>
