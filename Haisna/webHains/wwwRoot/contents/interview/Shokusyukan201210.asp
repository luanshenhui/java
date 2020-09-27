<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      栄養指導～食習慣問診  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_SHOKUSYUKAN = "X0221"       '食習慣問診グループコード

Const CONST_COLOR_M2 = "#fda9b8"    '失点-2
Const CONST_COLOR_M1 = "#fed5dd"    '失点-1
Const CONST_COLOR_M0 = "#eeeeee"    '失点0

Const DISPMODE_FOODADVICE = 6       '表示分類：新・食習慣
Const JUDCLASSCD_FOODADVICE = 57    '判定分類コード：新・食習慣


'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objInterView        '面接情報アクセス用
Dim objConsult          '予約情報取得用
Dim objJudgement        '判定用

'パラメータ
Dim strAction           '処理状態
Dim strWinMode          'ウィンドウモード
Dim strGrpNo            'グループNo
Dim lngRsvNo            '予約番号（今回分）
Dim strCsCd             'コースコード

'受診情報用変数
Dim strCslDate          '受診日
Dim strDayId            '当日ID


'検査結果情報
Dim vntPerId            '予約番号
Dim vntCslDate          '検査項目コード
Dim vntHisNo            '履歴No.
Dim vntRsvNo            '予約番号
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntResultType       '結果タイプ
Dim vntItemType         '項目タイプ
Dim vntItemName         '検査項目名称
Dim vntResult           '検査結果
Dim vntUnit             '単位
Dim vntItemQName        '問診文章
Dim vntGrpSeq           '表示順番
Dim vntRslFlg           '検査結果存在フラグ
Dim vntHealthPoint      'ヘルスポイント

Dim lngWay              '食べ方点数
Dim lngDiet             '食習慣点数
Dim lngContents         '食事内容点数

Dim lngRslCnt           '検査結果数

Dim strColor            '失点別色

Dim strURL              'ジャンプ先のURL
Dim lngIndex            'インデックス
Dim i, j                'インデックス
Dim Ret                 '復帰値


'食習慣コメント
Dim vntFoodCmtSeq       '表示順
Dim vntFoodCmtCd        '判定コメントコード
Dim vntFoodCmtStc       '判定コメント文章
Dim vntFoodClassCd      '判定分類コード
Dim lngFoodCmtCnt       '行数

'栄養再計算用
Dim vntCalcFlg()        '計算対象フラグ
Dim vntArrDayId()       '当日ＩＤ（複数指定の場合の計算処理への引数）
Dim strArrMessage       'エラーメッセージ

Dim strUpdUser          '更新者
Dim strIPAddress        'IPアドレス


'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterView    = Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strAction   = Request("act")
strWinMode  = Request("winmode")
strGrpNo    = Request("grpno")
lngRsvNo    = Request("rsvno")
strCsCd     = Request("cscd")

Do

    '受診情報検索
    Set objConsult = Server.CreateObject("HainsConsult.Consult")
    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , _
                                    strCslDate, _
                                    , , , , , , , , , , , , , , , , , , , , , _
                                    strDayId _
                                    )
    '受診情報が存在しない場合はエラーとする
    If Ret = False Then
        Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
    End If

    '栄養再計算
    If strAction = "calc" Then
        '更新者の設定
        strUpdUser = Session("USERID")
        'IPアドレスの取得
        strIPAddress = Request.ServerVariables("REMOTE_ADDR")

        Redim Preserve vntCalcFlg(7)
        vntCalcFlg(0) = 0
        vntCalcFlg(1) = 0
        vntCalcFlg(2) = 0
        vntCalcFlg(3) = 0
        vntCalcFlg(4) = 0
        vntCalcFlg(5) = 0
        vntCalcFlg(6) = 0
        vntCalcFlg(7) = 1   '食習慣計算のみ起動

        Redim Preserve vntArrDayId(0)

        '判定メイン呼び出し
        Set objJudgement = Server.CreateObject("HainsJudgement.JudgementControl")
        Ret = objJudgement.JudgeAutomaticallyMain (strUpdUser, _
                                                strIPAddress, _
                                                strCslDate, _
                                                 vntCalcFlg, _
                                                1, _
                                                strDayId, _
                                                strDayId, _
                                                vntArrDayId, _
                                                "", _
                                                "", _
                                                0, _
                                                0)

        If Ret = True Then
            strAction = "calcend"
        Else
            objCommon.AppendArray strArrMessage, "自動判定が異常終了しました。（詳細は？）"
        End If
    End If


    lngRslCnt = objInterView.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        GRPCD_SHOKUSYUKAN, _
                        1, _
                        strCsCd, _
                        0, _
                        0, _
                        1, _
                        vntPerId, _
                        vntCslDate, _
                        vntHisNo, _
                        vntRsvNo, _
                        vntItemCd, _
                        vntSuffix, _
                        vntResultType, _
                        vntItemType, _
                        vntItemName, _
                        vntResult, _
                        , , , , , , _
                        vntUnit, _
                        , , , , , _
                        vntItemQName, _
                        vntGrpSeq, _
                        vntRslFlg, _
                        , , , , _
                        vntHealthPoint _
                        )

    If lngRslCnt < 0 Then
        Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If

    '食習慣計算結果のセット
    For i=0 To lngRslCnt-1
        Select Case (vntItemCd(i) & "-" & vntSuffix(i))
        Case "61610-01" '食べ方点数
            lngWay = vntResult(i)
        Case "61610-02" '食習慣点数
            lngDiet = vntResult(i)
        Case "61610-03" '食事内容点数
            lngContents = vntResult(i)
        End Select
    Next


    '食習慣コメント取得
    lngFoodCmtCnt = 0
    lngFoodCmtCnt = objInterview.SelectTotalJudCmt(lngRsvNo, DISPMODE_FOODADVICE, 1, 1, strCsCd , 0, vntFoodCmtSeq, vntFoodCmtCd, vntFoodCmtstc, vntFoodClassCd)

    'オブジェクトのインスタンス削除
    Set objInterview = Nothing
    Set objConsult = Nothing
    Set objJudgement = Nothing


    Exit Do
    
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>栄養指導～食習慣問診</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//OCR入力結果確認画面呼び出し
function callOcrNyuryoku() {

    var url;                            // URL文字列

    url = '/WebHains/contents/Monshin/ocrNyuryoku.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';
    url = url + '&anchor=5';

    location.href(url);

}

var winMenFoodComment;      // ウィンドウハンドル

//食習慣、問診コメント入力画面呼び出し
function callMenFoodComment() {

    var url;            // URL文字列
    var opened = false; // 画面がすでに開かれているか

    var i;

    // すでにガイドが開かれているかチェック
    if ( winMenFoodComment != null ) {
        if ( !winMenFoodComment.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/interview/MenFoodComment.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&grpno=' + '<%= strGrpNo %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winMenFoodComment.focus();
        winMenFoodComment.location.replace( url );
    } else {
        winMenFoodComment = window.open( url, '', 'width=750,height=370,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=no');
    }

}

// 食習慣、問診コメント入力画面を閉じる
function closeMenFoodComment() {

    if ( winMenFoodComment != null ) {
        if ( !winMenFoodComment.closed ) {
            winMenFoodComment.close();
        }
    }

    winMenFoodComment = null;
}

function refreshForm(){
        document.entryForm.submit();
}


//食習慣失点再計算画面呼び出し
function callMenDietKeisan() {

    // 確認メッセージ
    if( !confirm('食習慣点数計算をします。よろしいですか？') ) return;

    document.entryForm.act.value = "calc";
    document.entryForm.submit();
}

//-->
</SCRIPT>

<!--[if lte IE 8]>
<script type="text/javascript" src="uuCanvas.mini.js"></script>
<![endif]-->
<script type="text/javascript">
<!--
// キャンバスの準備完了時に自動的に呼ばれる関数
function xcanvas()
{
    // グラフ描画
    draw();
}

// グラフ描画
function draw()
{
    var PI = 3.14159265358979;  // 円周率

    var defaultlinewidth = 1;   // 線の太さのデフォルト値

    var config = {
        outertriangle: {
            //center: {x: 200, y: 200}, // 中心のXY座標
            //distance: 150,            // 中心からの距離
            center: {x: 150, y: 150},   // 中心のXY座標
            distance: 120,              // 中心からの距離
            outlinecolor: '#1F477A',    // 線色
            outlinewidth: 3             // 線の太さ
        },
        resulttriangle: {
            resultlinecolor: '#FF0000', // 線色
            resultlinewidth: 3          // 線の太さ
        },
        howdoyoueat: {
            caption: {value: '食べ方', x: 8,   y: -20},     // キャプション及び頂点からの相対座標
            vertex:  {value: 0,        x: -4,  y: -20},     // 頂点値及び頂点からの相対座標
            center:  {value: -8,       x: -20, y: -22}      // 中央値及び頂点からの相対座標
        },
        eatinghabits: {
            caption: {value: '食習慣', x: -30, y: 6},       // キャプション及び頂点からの相対座標
            vertex:  {value: 0,        x: -13, y: -8},      // 頂点値及び頂点からの相対座標
            center:  {value: -11,      x: -19, y: 5}        // 中央値及び頂点からの相対座標
        },
        favoritefoods: {
            caption: {value: '食事内容', x: -20, y: 6},     // キャプション及び頂点からの相対座標
            vertex:  {value: 0,          x: 4,   y: -8},    // 頂点値及び頂点からの相対座標
            center:  {value: -16,        x: 11,  y: -8}     // 中央値及び頂点からの相対座標
        },
        font: "14px 'ＭＳ Ｐゴシック'",                     // フォント
        distance_of_minvalue: 10                            // 三角形中央から各プロット項目の最小値位置までの距離
    };

    // コンテキストの取得
    var canvas = document.getElementById('cv');
    var ctx = canvas.getContext('2d');

    // キャンバスの初期化
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // 食べ方（上の頂点）の座標計算
    var vertex1_x = config.outertriangle.center.x;
    var vertex1_y = config.outertriangle.center.y - config.outertriangle.distance;

    // 食習慣（左下の頂点）の座標計算
    var vertex2_x = config.outertriangle.center.x - Math.round(config.outertriangle.distance * Math.cos(PI / 6));
    var vertex2_y = config.outertriangle.center.y + Math.round(config.outertriangle.distance * Math.sin(PI / 6));

    // 食事内容（右下の頂点）の座標計算
    var vertex3_x = config.outertriangle.center.x + Math.round(config.outertriangle.distance * Math.cos(PI / 6));
    var vertex3_y = vertex2_y;

    // 正三角形の描画
    ctx.beginPath();
    ctx.strokeStyle = config.outertriangle.outlinecolor;
    ctx.lineWidth = config.outertriangle.outlinewidth;
    ctx.moveTo(vertex1_x, vertex1_y);
    ctx.lineTo(vertex2_x, vertex2_y);
    ctx.lineTo(vertex3_x, vertex3_y);
    ctx.closePath();
    ctx.stroke();

    ctx.lineWidth = defaultlinewidth;

    // 中心から頂点への直線描画
    ctx.beginPath();
    ctx.moveTo(config.outertriangle.center.x, config.outertriangle.center.y);
    ctx.lineTo(vertex1_x, vertex1_y);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(config.outertriangle.center.x, config.outertriangle.center.y);
    ctx.lineTo(vertex2_x, vertex2_y);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(config.outertriangle.center.x, config.outertriangle.center.y);
    ctx.lineTo(vertex3_x, vertex3_y);
    ctx.stroke();

    ctx.font = config.font;
    ctx.textBaseline = 'top';

    // 頂点のキャプション値を描画
    ctx.fillText(config.howdoyoueat.caption.value,   vertex1_x + config.howdoyoueat.caption.x,   vertex1_y + config.howdoyoueat.caption.y);
    ctx.fillText(config.eatinghabits.caption.value,  vertex2_x + config.eatinghabits.caption.x,  vertex2_y + config.eatinghabits.caption.y);
    ctx.fillText(config.favoritefoods.caption.value, vertex3_x + config.favoritefoods.caption.x, vertex3_y + config.favoritefoods.caption.y);

    // 頂点の数値を描画
    //ctx.fillText(config.howdoyoueat.vertex.value.toString(),   vertex1_x + config.howdoyoueat.vertex.x,   vertex1_y + config.howdoyoueat.vertex.y);
    //ctx.fillText(config.eatinghabits.vertex.value.toString(),  vertex2_x + config.eatinghabits.vertex.x,  vertex2_y + config.eatinghabits.vertex.y);
    //ctx.fillText(config.favoritefoods.vertex.value.toString(), vertex3_x + config.favoritefoods.vertex.x, vertex3_y + config.favoritefoods.vertex.y);

    // 結果の取得
    var way = document.getElementsByName('way')[0].value;
    var diet = document.getElementsByName('diet')[0].value;
    var contents = document.getElementsByName('contents')[0].value;

    while ( true ) {

        if ( ( way == '' ) || ( diet == '' ) || ( contents == '' ) || isNaN(way) || isNaN(diet) || isNaN(contents) ) {
            break;
        }

        var result;
        var rate;

        // 食べ方検査結果の相対座標変換
        
        // 数値変換
        result = parseInt(way, 10);

        // 最大、最小を超えないための補正
        if ( result > config.howdoyoueat.vertex.value ) {
            result = config.howdoyoueat.vertex.value;
        } else if ( result < config.howdoyoueat.center.value ) {
            result = config.howdoyoueat.center.value;
        }

        // X座標＝中央のX座標
        var result1_x = config.outertriangle.center.x;

        // 三角形中央から最小値位置までの距離分ずらした値を最小値のY座標とする
        var result1_y = config.outertriangle.center.y - config.distance_of_minvalue;

        //値が最小値でない場合はY座標を変換
        if ( result > config.howdoyoueat.center.value ) {
            rate = (result - config.howdoyoueat.center.value) / (config.howdoyoueat.vertex.value - config.howdoyoueat.center.value);
            result1_y = result1_y + Math.round((vertex1_y - result1_y) * rate);
        }

        // 食習慣検査結果の相対座標変換

        // 数値変換
        result = parseInt(diet, 10);

        // 最大、最小を超えないための補正
        if ( result > config.eatinghabits.vertex.value ) {
            result = config.eatinghabits.vertex.value;
        } else if ( result < config.eatinghabits.center.value ) {
            result = config.eatinghabits.center.value;
        }

        // 三角形中央から最小値位置までの距離分ずらした値を最小値の座標とする
        var result2_x = config.outertriangle.center.x - Math.round(config.distance_of_minvalue * Math.cos(PI / 6));
        var result2_y = config.outertriangle.center.y + Math.round(config.distance_of_minvalue * Math.sin(PI / 6));

        // 値が最小値でない場合は座標を変換
        if ( result > config.eatinghabits.center.value ) {
            rate = (result - config.eatinghabits.center.value) / (config.eatinghabits.vertex.value - config.eatinghabits.center.value);
            result2_x = result2_x + Math.round((vertex2_x - result2_x) * rate);
            result2_y = result2_y + Math.round((vertex2_y - result2_y) * rate);
        }

        // 食事内容検査結果の相対座標変換

        // 数値変換
        result = parseInt(contents, 10);

        // 最大、最小を超えないための補正
        if ( result > config.favoritefoods.vertex.value ) {
            result = config.favoritefoods.vertex.value;
        } else if ( result < config.favoritefoods.center.value ) {
            result = config.favoritefoods.center.value;
        }

        // 三角形中央から最小値位置までの距離分ずらした値を最小値の座標とする
        var result3_x = config.outertriangle.center.x + Math.round(config.distance_of_minvalue * Math.cos(PI / 6));
        var result3_y = config.outertriangle.center.y + Math.round(config.distance_of_minvalue * Math.sin(PI / 6));

        // 値が最小値でない場合は座標を変換
        if ( result > config.favoritefoods.center.value ) {
            rate = (result - config.favoritefoods.center.value) / (config.favoritefoods.vertex.value - config.favoritefoods.center.value);
            result3_x = result3_x + Math.round((vertex3_x - result3_x) * rate);
            result3_y = result3_y + Math.round((vertex3_y - result3_y) * rate);
        }

        // 三角形の描画
        ctx.beginPath();
        ctx.strokeStyle = config.resulttriangle.resultlinecolor;
        ctx.lineWidth = config.resulttriangle.resultlinewidth;
        ctx.moveTo(result1_x, result1_y);
        ctx.lineTo(result2_x, result2_y);
        ctx.lineTo(result3_x, result3_y);
        ctx.closePath();
        ctx.stroke();

        ctx.lineWidth = defaultlinewidth;

        break;
    }

    // 中心部の最小値テキスト描画
    //ctx.fillText(config.howdoyoueat.center.value.toString(),   config.outertriangle.center.x + config.howdoyoueat.center.x,   config.outertriangle.center.y + config.howdoyoueat.center.y);
    //ctx.fillText(config.eatinghabits.center.value.toString(),  config.outertriangle.center.x + config.eatinghabits.center.x,  config.outertriangle.center.y + config.eatinghabits.center.y);
    //ctx.fillText(config.favoritefoods.center.value.toString(), config.outertriangle.center.x + config.favoritefoods.center.x, config.outertriangle.center.y + config.favoritefoods.center.y);
}
//-->
</script>
<style TYPE="text/css">
canvas {
    border:0px solid #333;
}
</style>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeMenFoodComment()">
<%
    '「別ウィンドウで表示」の場合、ヘッダー部分表示
    If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post"  STYLE="margin: 0px;">
    <!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAction %>">

    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="RslCnt"  VALUE="<%= lngRslCnt %>">

    <INPUT TYPE="hidden" NAME="way"     VALUE="<%= lngWay %>">
    <INPUT TYPE="hidden" NAME="diet"    VALUE="<%= lngDiet %>">
    <INPUT TYPE="hidden" NAME="contents" VALUE="<%= lngContents %>">

    <!-- タイトルの表示 -->
    <TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">食習慣問診</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="900">
        <TR>
            <TD HEIGHT="5" COLSPAN="2"></TD>
        </TR>
        <TR>
<%
            strURL = "/WebHains/contents/Monshin/ocrNyuryoku.asp"
            strURL = strURL & "?rsvno=" & lngRsvNo
            strURL = strURL & "&anchor=5"
%>
            <TD NOWRAP WIDTH="50%" ALIGN="LEFT">
                <A HREF="<%= strURL %>" TARGET="_blank">OCR入力結果確認</A>
            </TD>
            <TD NOWRAP WIDTH="50%" ALIGN="RIGHT">
                <A HREF="JavaScript:callMenDietKeisan()">食習慣点数再計算</A>&nbsp;&nbsp;&nbsp;&nbsp;
                <A HREF="JavaScript:callMenFoodComment()">食習慣問診コメント入力</A>
            </TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD VALIGN="TOP">
                <!-- 食習慣問診の表示 -->
                <TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
                    <TR>
                        <TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20"><B>１．食べ方について</B></TD>
                    </TR>
            <%
                    For lngIndex = 0 To 3
                        If vntHealthPoint(lngIndex) = "-2" Then
                            strColor = CONST_COLOR_M2
                        Elseif vntHealthPoint(lngIndex) = "-1"  then
                            strColor = CONST_COLOR_M1
                        Else
                            strColor = CONST_COLOR_M0
                        End If

            %>
                        <TR>
                            <TD NOWRAP><%= vntItemQName(lngIndex) %></TD>
                            <TD NOWRAP BGCOLOR="<%=strColor%>" WIDTH="143"><%= vntResult(lngIndex) %></TD>
                        </TR>
            <%
                    Next
            %>
                    <TR>
                        <TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20"><B>２．食習慣について</B></TD>
                    </TR>
            <%
                    For lngIndex = 4 To 10
                        If vntHealthPoint(lngIndex) = "-2" Then
                            strColor = CONST_COLOR_M2
                        Elseif vntHealthPoint(lngIndex) = "-1"  then
                            strColor = CONST_COLOR_M1
                        Else
                            strColor = CONST_COLOR_M0
                        End If
            %>
                        <TR>
                            <TD NOWRAP><%= vntItemQName(lngIndex) %></TD>
                            <TD NOWRAP BGCOLOR="<%= strColor %>" WIDTH="143"><%= vntResult(lngIndex) %></TD>
                        </TR>
            <%
                    Next
            %>
                    <TR>
                        <TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20"><B>３．食事内容について</B></TD>
                    </TR>
            <%
                    For lngIndex = 11 To 19
                        If vntHealthPoint(lngIndex) = "-2" Then
                            strColor = CONST_COLOR_M2
                        Elseif vntHealthPoint(lngIndex) = "-1"  then
                            strColor = CONST_COLOR_M1
                        Else
                            strColor = CONST_COLOR_M0
                        End If
            %>
                        <TR>
                            <TD NOWRAP><%= vntItemQName(lngIndex) %></TD>
                            <TD NOWRAP BGCOLOR="<%= strColor %>" WIDTH="143"><%= vntResult(lngIndex) %></TD>
                        </TR>
            <%
                    Next
            %>
                    <TR>
                        <TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20"><B>４．その他の質問</B></TD>
                    </TR>
            <%
                    lngIndex = 20
            %>
                    <TR>
                        <TD NOWRAP>栄養相談が必要と思われる場合、ご案内書をお送りしてもよいですか</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" WIDTH="143"><%= vntResult(lngIndex) %></TD>
                    </TR>
                </TABLE>
            </TD>

            <TD WIDTH="5">&nbsp;</TD>

            <TD VALIGN="TOP">
                <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="2" WIDTH="350">
                    <TR>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="350">
                                <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15" WIDTH="350"><B><FONT COLOR="#333333">食習慣コメント</FONT></B></TD>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>

                <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="2" WIDTH="350" HEIGHT="100">
                    <TR>
                        <TD VALIGN="TOP">
                            <TABLE>
            <%
                For i = 0 To lngFoodCmtCnt - 1
            %>
                                <TR><TD><%= vntFoodCmtStc(i) %></TD></TR>
            <%
                Next
            %>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>

                <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="2" WIDTH="350">
                    <TR>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="350">
                                <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15" WIDTH="350"><B><FONT COLOR="#333333">食習慣バランス</FONT></B></TD>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>

                <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="2" WIDTH="350" >

                    <TR><TD COLSPAN="2" ALIGN="center">
                        <canvas id="cv" width="310" height="250"></canvas>
                    </TD></TR>
                    <TR>
                        <TD WIDTH="10">&nbsp;</TD>
                        <TD><FONT COLOR="#FF0000"><B>△</B></FONT>があなたの食習慣バランスです</TD>
                    </TR>
                    <TR>
                        <TD WIDTH="10">&nbsp;</TD>
                        <TD><FONT COLOR="#1F477A"><B>△</B></FONT>が理想の形です</TD>
                    </TR>
                </TABLE>

            </TD>
        </TR>
    </TABLE>


</FORM>
<!--[if !(lte IE 8)]><!-->
<script type="text/javascript">
<!--
// グラフ描画
draw();
-->
</script>
<!--<![endif]-->
</BODY>
</HTML>
