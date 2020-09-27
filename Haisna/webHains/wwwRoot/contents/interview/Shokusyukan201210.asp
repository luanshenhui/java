<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      �h�{�w���`�H�K����f  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_SHOKUSYUKAN = "X0221"       '�H�K����f�O���[�v�R�[�h

Const CONST_COLOR_M2 = "#fda9b8"    '���_-2
Const CONST_COLOR_M1 = "#fed5dd"    '���_-1
Const CONST_COLOR_M0 = "#eeeeee"    '���_0

Const DISPMODE_FOODADVICE = 6       '�\�����ށF�V�E�H�K��
Const JUDCLASSCD_FOODADVICE = 57    '���蕪�ރR�[�h�F�V�E�H�K��


'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objInterView        '�ʐڏ��A�N�Z�X�p
Dim objConsult          '�\����擾�p
Dim objJudgement        '����p

'�p�����[�^
Dim strAction           '�������
Dim strWinMode          '�E�B���h�E���[�h
Dim strGrpNo            '�O���[�vNo
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strCsCd             '�R�[�X�R�[�h

'��f���p�ϐ�
Dim strCslDate          '��f��
Dim strDayId            '����ID


'�������ʏ��
Dim vntPerId            '�\��ԍ�
Dim vntCslDate          '�������ڃR�[�h
Dim vntHisNo            '����No.
Dim vntRsvNo            '�\��ԍ�
Dim vntItemCd           '�������ڃR�[�h
Dim vntSuffix           '�T�t�B�b�N�X
Dim vntResultType       '���ʃ^�C�v
Dim vntItemType         '���ڃ^�C�v
Dim vntItemName         '�������ږ���
Dim vntResult           '��������
Dim vntUnit             '�P��
Dim vntItemQName        '��f����
Dim vntGrpSeq           '�\������
Dim vntRslFlg           '�������ʑ��݃t���O
Dim vntHealthPoint      '�w���X�|�C���g

Dim lngWay              '�H�ו��_��
Dim lngDiet             '�H�K���_��
Dim lngContents         '�H�����e�_��

Dim lngRslCnt           '�������ʐ�

Dim strColor            '���_�ʐF

Dim strURL              '�W�����v���URL
Dim lngIndex            '�C���f�b�N�X
Dim i, j                '�C���f�b�N�X
Dim Ret                 '���A�l


'�H�K���R�����g
Dim vntFoodCmtSeq       '�\����
Dim vntFoodCmtCd        '����R�����g�R�[�h
Dim vntFoodCmtStc       '����R�����g����
Dim vntFoodClassCd      '���蕪�ރR�[�h
Dim lngFoodCmtCnt       '�s��

'�h�{�Čv�Z�p
Dim vntCalcFlg()        '�v�Z�Ώۃt���O
Dim vntArrDayId()       '�����h�c�i�����w��̏ꍇ�̌v�Z�����ւ̈����j
Dim strArrMessage       '�G���[���b�Z�[�W

Dim strUpdUser          '�X�V��
Dim strIPAddress        'IP�A�h���X


'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterView    = Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strAction   = Request("act")
strWinMode  = Request("winmode")
strGrpNo    = Request("grpno")
lngRsvNo    = Request("rsvno")
strCsCd     = Request("cscd")

Do

    '��f��񌟍�
    Set objConsult = Server.CreateObject("HainsConsult.Consult")
    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , _
                                    strCslDate, _
                                    , , , , , , , , , , , , , , , , , , , , , _
                                    strDayId _
                                    )
    '��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
    If Ret = False Then
        Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
    End If

    '�h�{�Čv�Z
    If strAction = "calc" Then
        '�X�V�҂̐ݒ�
        strUpdUser = Session("USERID")
        'IP�A�h���X�̎擾
        strIPAddress = Request.ServerVariables("REMOTE_ADDR")

        Redim Preserve vntCalcFlg(7)
        vntCalcFlg(0) = 0
        vntCalcFlg(1) = 0
        vntCalcFlg(2) = 0
        vntCalcFlg(3) = 0
        vntCalcFlg(4) = 0
        vntCalcFlg(5) = 0
        vntCalcFlg(6) = 0
        vntCalcFlg(7) = 1   '�H�K���v�Z�̂݋N��

        Redim Preserve vntArrDayId(0)

        '���胁�C���Ăяo��
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
            objCommon.AppendArray strArrMessage, "�������肪�ُ�I�����܂����B�i�ڍׂ́H�j"
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
        Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
    End If

    '�H�K���v�Z���ʂ̃Z�b�g
    For i=0 To lngRslCnt-1
        Select Case (vntItemCd(i) & "-" & vntSuffix(i))
        Case "61610-01" '�H�ו��_��
            lngWay = vntResult(i)
        Case "61610-02" '�H�K���_��
            lngDiet = vntResult(i)
        Case "61610-03" '�H�����e�_��
            lngContents = vntResult(i)
        End Select
    Next


    '�H�K���R�����g�擾
    lngFoodCmtCnt = 0
    lngFoodCmtCnt = objInterview.SelectTotalJudCmt(lngRsvNo, DISPMODE_FOODADVICE, 1, 1, strCsCd , 0, vntFoodCmtSeq, vntFoodCmtCd, vntFoodCmtstc, vntFoodClassCd)

    '�I�u�W�F�N�g�̃C���X�^���X�폜
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
<TITLE>�h�{�w���`�H�K����f</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//OCR���͌��ʊm�F��ʌĂяo��
function callOcrNyuryoku() {

    var url;                            // URL������

    url = '/WebHains/contents/Monshin/ocrNyuryoku.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';
    url = url + '&anchor=5';

    location.href(url);

}

var winMenFoodComment;      // �E�B���h�E�n���h��

//�H�K���A��f�R�����g���͉�ʌĂяo��
function callMenFoodComment() {

    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩

    var i;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
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

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winMenFoodComment.focus();
        winMenFoodComment.location.replace( url );
    } else {
        winMenFoodComment = window.open( url, '', 'width=750,height=370,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=no');
    }

}

// �H�K���A��f�R�����g���͉�ʂ����
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


//�H�K�����_�Čv�Z��ʌĂяo��
function callMenDietKeisan() {

    // �m�F���b�Z�[�W
    if( !confirm('�H�K���_���v�Z�����܂��B��낵���ł����H') ) return;

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
// �L�����o�X�̏����������Ɏ����I�ɌĂ΂��֐�
function xcanvas()
{
    // �O���t�`��
    draw();
}

// �O���t�`��
function draw()
{
    var PI = 3.14159265358979;  // �~����

    var defaultlinewidth = 1;   // ���̑����̃f�t�H���g�l

    var config = {
        outertriangle: {
            //center: {x: 200, y: 200}, // ���S��XY���W
            //distance: 150,            // ���S����̋���
            center: {x: 150, y: 150},   // ���S��XY���W
            distance: 120,              // ���S����̋���
            outlinecolor: '#1F477A',    // ���F
            outlinewidth: 3             // ���̑���
        },
        resulttriangle: {
            resultlinecolor: '#FF0000', // ���F
            resultlinewidth: 3          // ���̑���
        },
        howdoyoueat: {
            caption: {value: '�H�ו�', x: 8,   y: -20},     // �L���v�V�����y�ђ��_����̑��΍��W
            vertex:  {value: 0,        x: -4,  y: -20},     // ���_�l�y�ђ��_����̑��΍��W
            center:  {value: -8,       x: -20, y: -22}      // �����l�y�ђ��_����̑��΍��W
        },
        eatinghabits: {
            caption: {value: '�H�K��', x: -30, y: 6},       // �L���v�V�����y�ђ��_����̑��΍��W
            vertex:  {value: 0,        x: -13, y: -8},      // ���_�l�y�ђ��_����̑��΍��W
            center:  {value: -11,      x: -19, y: 5}        // �����l�y�ђ��_����̑��΍��W
        },
        favoritefoods: {
            caption: {value: '�H�����e', x: -20, y: 6},     // �L���v�V�����y�ђ��_����̑��΍��W
            vertex:  {value: 0,          x: 4,   y: -8},    // ���_�l�y�ђ��_����̑��΍��W
            center:  {value: -16,        x: 11,  y: -8}     // �����l�y�ђ��_����̑��΍��W
        },
        font: "14px '�l�r �o�S�V�b�N'",                     // �t�H���g
        distance_of_minvalue: 10                            // �O�p�`��������e�v���b�g���ڂ̍ŏ��l�ʒu�܂ł̋���
    };

    // �R���e�L�X�g�̎擾
    var canvas = document.getElementById('cv');
    var ctx = canvas.getContext('2d');

    // �L�����o�X�̏�����
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // �H�ו��i��̒��_�j�̍��W�v�Z
    var vertex1_x = config.outertriangle.center.x;
    var vertex1_y = config.outertriangle.center.y - config.outertriangle.distance;

    // �H�K���i�����̒��_�j�̍��W�v�Z
    var vertex2_x = config.outertriangle.center.x - Math.round(config.outertriangle.distance * Math.cos(PI / 6));
    var vertex2_y = config.outertriangle.center.y + Math.round(config.outertriangle.distance * Math.sin(PI / 6));

    // �H�����e�i�E���̒��_�j�̍��W�v�Z
    var vertex3_x = config.outertriangle.center.x + Math.round(config.outertriangle.distance * Math.cos(PI / 6));
    var vertex3_y = vertex2_y;

    // ���O�p�`�̕`��
    ctx.beginPath();
    ctx.strokeStyle = config.outertriangle.outlinecolor;
    ctx.lineWidth = config.outertriangle.outlinewidth;
    ctx.moveTo(vertex1_x, vertex1_y);
    ctx.lineTo(vertex2_x, vertex2_y);
    ctx.lineTo(vertex3_x, vertex3_y);
    ctx.closePath();
    ctx.stroke();

    ctx.lineWidth = defaultlinewidth;

    // ���S���璸�_�ւ̒����`��
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

    // ���_�̃L���v�V�����l��`��
    ctx.fillText(config.howdoyoueat.caption.value,   vertex1_x + config.howdoyoueat.caption.x,   vertex1_y + config.howdoyoueat.caption.y);
    ctx.fillText(config.eatinghabits.caption.value,  vertex2_x + config.eatinghabits.caption.x,  vertex2_y + config.eatinghabits.caption.y);
    ctx.fillText(config.favoritefoods.caption.value, vertex3_x + config.favoritefoods.caption.x, vertex3_y + config.favoritefoods.caption.y);

    // ���_�̐��l��`��
    //ctx.fillText(config.howdoyoueat.vertex.value.toString(),   vertex1_x + config.howdoyoueat.vertex.x,   vertex1_y + config.howdoyoueat.vertex.y);
    //ctx.fillText(config.eatinghabits.vertex.value.toString(),  vertex2_x + config.eatinghabits.vertex.x,  vertex2_y + config.eatinghabits.vertex.y);
    //ctx.fillText(config.favoritefoods.vertex.value.toString(), vertex3_x + config.favoritefoods.vertex.x, vertex3_y + config.favoritefoods.vertex.y);

    // ���ʂ̎擾
    var way = document.getElementsByName('way')[0].value;
    var diet = document.getElementsByName('diet')[0].value;
    var contents = document.getElementsByName('contents')[0].value;

    while ( true ) {

        if ( ( way == '' ) || ( diet == '' ) || ( contents == '' ) || isNaN(way) || isNaN(diet) || isNaN(contents) ) {
            break;
        }

        var result;
        var rate;

        // �H�ו��������ʂ̑��΍��W�ϊ�
        
        // ���l�ϊ�
        result = parseInt(way, 10);

        // �ő�A�ŏ��𒴂��Ȃ����߂̕␳
        if ( result > config.howdoyoueat.vertex.value ) {
            result = config.howdoyoueat.vertex.value;
        } else if ( result < config.howdoyoueat.center.value ) {
            result = config.howdoyoueat.center.value;
        }

        // X���W��������X���W
        var result1_x = config.outertriangle.center.x;

        // �O�p�`��������ŏ��l�ʒu�܂ł̋��������炵���l���ŏ��l��Y���W�Ƃ���
        var result1_y = config.outertriangle.center.y - config.distance_of_minvalue;

        //�l���ŏ��l�łȂ��ꍇ��Y���W��ϊ�
        if ( result > config.howdoyoueat.center.value ) {
            rate = (result - config.howdoyoueat.center.value) / (config.howdoyoueat.vertex.value - config.howdoyoueat.center.value);
            result1_y = result1_y + Math.round((vertex1_y - result1_y) * rate);
        }

        // �H�K���������ʂ̑��΍��W�ϊ�

        // ���l�ϊ�
        result = parseInt(diet, 10);

        // �ő�A�ŏ��𒴂��Ȃ����߂̕␳
        if ( result > config.eatinghabits.vertex.value ) {
            result = config.eatinghabits.vertex.value;
        } else if ( result < config.eatinghabits.center.value ) {
            result = config.eatinghabits.center.value;
        }

        // �O�p�`��������ŏ��l�ʒu�܂ł̋��������炵���l���ŏ��l�̍��W�Ƃ���
        var result2_x = config.outertriangle.center.x - Math.round(config.distance_of_minvalue * Math.cos(PI / 6));
        var result2_y = config.outertriangle.center.y + Math.round(config.distance_of_minvalue * Math.sin(PI / 6));

        // �l���ŏ��l�łȂ��ꍇ�͍��W��ϊ�
        if ( result > config.eatinghabits.center.value ) {
            rate = (result - config.eatinghabits.center.value) / (config.eatinghabits.vertex.value - config.eatinghabits.center.value);
            result2_x = result2_x + Math.round((vertex2_x - result2_x) * rate);
            result2_y = result2_y + Math.round((vertex2_y - result2_y) * rate);
        }

        // �H�����e�������ʂ̑��΍��W�ϊ�

        // ���l�ϊ�
        result = parseInt(contents, 10);

        // �ő�A�ŏ��𒴂��Ȃ����߂̕␳
        if ( result > config.favoritefoods.vertex.value ) {
            result = config.favoritefoods.vertex.value;
        } else if ( result < config.favoritefoods.center.value ) {
            result = config.favoritefoods.center.value;
        }

        // �O�p�`��������ŏ��l�ʒu�܂ł̋��������炵���l���ŏ��l�̍��W�Ƃ���
        var result3_x = config.outertriangle.center.x + Math.round(config.distance_of_minvalue * Math.cos(PI / 6));
        var result3_y = config.outertriangle.center.y + Math.round(config.distance_of_minvalue * Math.sin(PI / 6));

        // �l���ŏ��l�łȂ��ꍇ�͍��W��ϊ�
        if ( result > config.favoritefoods.center.value ) {
            rate = (result - config.favoritefoods.center.value) / (config.favoritefoods.vertex.value - config.favoritefoods.center.value);
            result3_x = result3_x + Math.round((vertex3_x - result3_x) * rate);
            result3_y = result3_y + Math.round((vertex3_y - result3_y) * rate);
        }

        // �O�p�`�̕`��
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

    // ���S���̍ŏ��l�e�L�X�g�`��
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
    '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
    If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post"  STYLE="margin: 0px;">
    <!-- �����l -->
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAction %>">

    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="RslCnt"  VALUE="<%= lngRslCnt %>">

    <INPUT TYPE="hidden" NAME="way"     VALUE="<%= lngWay %>">
    <INPUT TYPE="hidden" NAME="diet"    VALUE="<%= lngDiet %>">
    <INPUT TYPE="hidden" NAME="contents" VALUE="<%= lngContents %>">

    <!-- �^�C�g���̕\�� -->
    <TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�H�K����f</FONT></B></TD>
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
                <A HREF="<%= strURL %>" TARGET="_blank">OCR���͌��ʊm�F</A>
            </TD>
            <TD NOWRAP WIDTH="50%" ALIGN="RIGHT">
                <A HREF="JavaScript:callMenDietKeisan()">�H�K���_���Čv�Z</A>&nbsp;&nbsp;&nbsp;&nbsp;
                <A HREF="JavaScript:callMenFoodComment()">�H�K����f�R�����g����</A>
            </TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD VALIGN="TOP">
                <!-- �H�K����f�̕\�� -->
                <TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
                    <TR>
                        <TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20"><B>�P�D�H�ו��ɂ���</B></TD>
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
                        <TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20"><B>�Q�D�H�K���ɂ���</B></TD>
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
                        <TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20"><B>�R�D�H�����e�ɂ���</B></TD>
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
                        <TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20"><B>�S�D���̑��̎���</B></TD>
                    </TR>
            <%
                    lngIndex = 20
            %>
                    <TR>
                        <TD NOWRAP>�h�{���k���K�v�Ǝv����ꍇ�A���ē����������肵�Ă��悢�ł���</TD>
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
                                <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15" WIDTH="350"><B><FONT COLOR="#333333">�H�K���R�����g</FONT></B></TD>
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
                                <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15" WIDTH="350"><B><FONT COLOR="#333333">�H�K���o�����X</FONT></B></TD>
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
                        <TD><FONT COLOR="#FF0000"><B>��</B></FONT>�����Ȃ��̐H�K���o�����X�ł�</TD>
                    </TR>
                    <TR>
                        <TD WIDTH="10">&nbsp;</TD>
                        <TD><FONT COLOR="#1F477A"><B>��</B></FONT>�����z�̌`�ł�</TD>
                    </TR>
                </TABLE>

            </TD>
        </TR>
    </TABLE>


</FORM>
<!--[if !(lte IE 8)]><!-->
<script type="text/javascript">
<!--
// �O���t�`��
draw();
-->
</script>
<!--<![endif]-->
</BODY>
</HTML>
