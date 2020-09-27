<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �t�H���[(�˗���) (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon               '���ʃN���X
Dim objFollow               '�t�H���[�A�b�v�A�N�Z�X�p
Dim objReqHistory           '�˗��󗚗��A�N�Z�X�p
Dim objPerson               
Dim objReqSendCheck         '�˗���쐬�N���X


Dim strMessage              '�G���[���b�Z�[�W
Dim strMode                 '�������[�h
Dim strAct                  '�������
Dim strStartCslDate         '����������f�N�����i�J�n�j
Dim strStartYear            '����������f�N�i�J�n�j
Dim strStartMonth           '����������f���i�J�n�j
Dim strStartDay             '����������f���i�J�n�j
Dim strEndCslDate           '����������f�N�����i�I���j
Dim strEndYear              '����������f�N�i�I���j
Dim strEndMonth             '����������f���i�I���j
Dim strEndDay               '����������f���i�I���j
Dim strPerId
Dim strPerName
Dim strLastName             '����������
Dim strFirstName            '����������
Dim strSendFlg
Dim strItemCd               '����������������
Dim lngItemCount            '�t�H���[�Ώی������ڐ�

Dim vntCslDate              '��f��
Dim vntDayId                '����ID
Dim vntPerId                '�lID
Dim vntPerKname             '�J�i����
Dim vntPerName              '����
Dim vntAge                  '�N��
Dim vntGender               '����
Dim vntBirth                '���N����
Dim vntRsvNo                '�\��ԍ�
Dim vntJudClassCd           '���蕪�ރR�[�h
Dim vntJudClassName         '���蕪�ޖ�
Dim vntFileName
Dim vntHanSu
Dim vntAddDate              '�o�^���i�˗��������j
Dim vntAddUser              '�o�^��
Dim vntReqSendDate          '������
Dim vntReqSendUser          '�����m�F��
Dim vntItemCd               '�t�H���[�Ώی������ڃR�[�h
Dim vntItemName             '�t�H���[�Ώی������ږ���
Dim vntClrFlg           	'�����N���A�t���O
Dim vntDelRsvNo				'�����N���A�\��ԍ�
Dim vntDelJudClassCd		'�����N���A���蕪�ރR�[�h
Dim vntDelSeq               '�����N���A�˗���Ő�

Dim strReqSendStat          '�˗��󔭑��X�e�[�^�X("":���ׂāA"0":�������A"1":�����ς�)
Dim lngStartPos             '�\���J�n�ʒu
Dim lngPageMaxLine          '�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()     '�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName() '�P�y�[�W�\���l�`�w�s���̔z��
Dim strArrMessage           '�G���[���b�Z�[�W
Dim lngAllCount             '������
Dim lngAllRsvCount          '�����\��Ȃ�����
Dim strBeforeRsvNo          '�O�s�̗\��ԍ�

Dim strWebCslDate           '��f��
Dim strWebDayId             '����ID
Dim strWebPerId             '�lID
Dim strWebPerName           '�J�i�����E����
Dim strWebGender            '����
Dim strWebAge               '�N��
Dim strWebBirth             '���N����
Dim strWebRsvNo             '�\��ԍ�
Dim strWebJudClassName      '���蕪�ޖ�
Dim strWebSendUser          '�˗��󔭑��m�F��
Dim strWebSendDate
Dim strWebHanSu             '�˗���Ő�

Dim i                       '�J�E���^
Dim j                      
Dim strURL                  '�W�����v���URL

'-------------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")
Set objReqHistory   = Server.CreateObject("HainsRequestCard.RequestCard")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strMode             = Request("mode")
strAct              = Request("action")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear          = Request("endYear")
strEndMonth         = Request("endMonth")
strEndDay           = Request("endDay")
strItemCd           = Request("itemCd")
strPerId            = Request("perId")
strSendFlg          = Request("reqSendStat")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

vntRsvNo            = ConvIStringToArray(Request("rsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("judClassCd"))
vntHanSu            = ConvIStringToArray(Request("seq"))
vntClrFlg           = ConvIStringToArray(Request("checkClrVal"))

'vntRsvNo            = ConvIStringToArray(Request("arrRsvNo"))
'vntJudClassCd       = ConvIStringToArray(Request("arrJudClassCd"))

'�f�t�H���g�̓V�X�e���N������K�p����
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
    strStartYear    = CStr(Year(Now))
    strStartMonth   = CStr(Month(Now))
    strStartDay     = CStr(Day(Now))
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos )
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine)


Call CreatePageMaxLineInfo()
'�I�u�W�F�N�g�̃C���X�^���X�쐬


Do

    '�t�H���[�Ώی������ځi���蕪�ށj���擾
    lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName)

	'�ۑ��{�^���N���b�N
	If strAct = "save" Then
		vntDelRsvNo         = Array()
        vntDelJudClassCd    = Array()
		vntDelSeq           = Array()

		For i = 0 To UBound(vntClrFlg)
			'�`�F�b�N���ꂽ�ꍇ�ɁA�������s
			If vntClrFlg(i) = "1" Then
				ReDim Preserve vntDelRsvNo(j)
                ReDim Preserve vntDelJudClassCd(j)
				ReDim Preserve vntDelSeq(j)

				vntDelRsvNo(j)      = vntRsvNo(i)
                vntDelJudClassCd(j) = vntJudClassCd(i)
				vntDelSeq(j)        = vntHanSu(i)
				j = j + 1
			End If
		Next

		if j > 0 Then
			'�������N���A
			If objReqHistory.ClearSendDate(vntDelRsvNo,vntDelJudClassCd, vntDelSeq) Then
				strAct = "saveend"
			Else
				strArrMessage = Array("�������N���A�����Ɏ��s���܂����B")
			End If
		Else
			'�I�u�W�F�N�g�̃C���X�^���X�쐬
			objCommon.AppendArray strArrMessage, "�N���A����˗��󂪈���I������Ă��܂���"
			strMessage = strArrMessage
		End If
	End If


    '�����{�^���N���b�N
    If strAct <> "" Then

        '��f��(��)�̓��t�`�F�b�N
        If strStartYear <> "" Or strStartMonth <> "" Or strStartDay <> "" Then
            If Not IsDate(strStartYear & "/" & strStartMonth & "/" & strStartDay) Then
                strArrMessage = Array("��f���̎w��Ɍ�肪����܂��B")
                Exit Do
            End If
        End If

        '��f��(��)�̓��t�`�F�b�N
        If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then
            If Not IsDate(strEndYear & "/" & strEndMonth & "/" & strEndDay) Then
                strArrMessage = Array("��f���̎w��Ɍ�肪����܂��B")
                Exit Do
            End If
            strEndCslDate   = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
        Else
            strEndCslDate = strStartCslDate
        End If

        '�����J�n�I����f���̕ҏW
        strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)


        lngAllCount =objReqHistory.SelectReqPrtSendList( strStartCslDate, strEndCslDate, _
                                                    strItemCd, strPerId, _
                                                    strSendFlg, 1, _
                                                    lngStartPos,lngPageMaxLine, _
                                                    vntCslDate, vntDayId, _
                                                    vntPerId, _
                                                    vntPerName, vntPerKName, _
                                                    vntGender, vntAge, _
                                                    vntBirth, vntRsvNo, _
                                                    vntJudClassCd, vntJudClassName, _
                                                    vntFileName, vntHanSu, _
                                                    vntAddDate, vntAddUser, _
                                                    vntReqSendDate, vntReqSendUser _
                                                    )
        '�lID�̎w�肪����ꍇ�A���̎擾
        If strPerId <> "" Then
            ObjPerson.SelectPerson_lukes strPerId, strLastName, strFirstName 
            strPerName = strLastName & "�@" & strFirstName
        Else
            strPerName = ""
        End If 

    End If
    Exit Do
Loop



'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �P�y�[�W�\���l�`�w�s�̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()
    Redim Preserve lngArrPageMaxLine(4)
    Redim Preserve strArrPageMaxLineName(4)

    lngArrPageMaxLine(0) = 10:strArrPageMaxLineName(0) = "10�s����"
    lngArrPageMaxLine(1) = 20:strArrPageMaxLineName(1) = "20�s����"
    lngArrPageMaxLine(2) = 50:strArrPageMaxLineName(2) = "50�s����"
    lngArrPageMaxLine(3) = 100:strArrPageMaxLineName(3) = "100�s����"
    lngArrPageMaxLine(4) = 999:strArrPageMaxLineName(4) = "���ׂ�"

End Sub

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�˗��󔭑��i���Ɖ�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->
    var winGuideFollow;     //�t�H���[�A�b�v��ʃn���h��
    var winMenResult;       // �h�b�N���ʎQ�ƃE�B���h�E�n���h��
    var winRslFol;          // �t�H���[���ʓo�^�E�B���h�E�n���h��
    var winReqCheck;

    // �G�������g�Q�Ɨp�ϐ�
    var calCheck_Year;				// �N
    var calCheck_Month;				// ��
    var calCheck_Day;				// ��
    var calCheck_CalledFunction;	// ���t�I�����ɌĂяo�����֐��I�u�W�F�N�g
    var winGuideCalendar;			// �E�B���h�E�n���h��

    // ���[�U�[�K�C�h�Ăяo��
    function callGuideUsr() {

        usrGuide_CalledFunction = SetUpdUser;

        // ���[�U�[�K�C�h�\��
        showGuideUsr();

    }

    // ���[�U�[�Z�b�g
    function SetUpdUser() {

        document.entryForm.upduser.value = usrGuide_UserCd;
        document.entryForm.updusername.value = usrGuide_UserName;
        document.getElementById('username').innerHTML = usrGuide_UserName;
    }


    // ���[�U�[�w��N���A
    function clearUpdUser() {
        document.entryForm.upduser.value = '';
        document.entryForm.updusername.value = '';
        document.getElementById('username').innerHTML = '';

    }

    // ���t�K�C�h�Ăяo��
    function callCalGuide(year, month, day) {
        // ���t�K�C�h�\��
        calGuide_showGuideCalendar( year, month, day);
    }

    function submitForm(act) {
        with ( document.entryForm) {
            if (act == "search" ) {
                startPos.value = 1 ;
            }
            action.value = act;
            submit();
        }
        return false;
    }

function checkClrAct( index ) {

	with ( document.entryForm ) {
		if ( checkClr.length == null ) {
			checkClr.value = (checkClr.checked ? '1' : '0');
			checkClrVal.value = (checkClr.checked ? '1' : '0');
		} else {
			checkClr[index].value = (checkClr[index].checked ? '1' : '0');
			checkClrVal[index].value = (checkClr[index].checked ? '1' : '0');
		}
	}
}

function setReqSendDateClr() {
	if( !confirm('�I�����ꂽ�˗��󔭑������N���A���܂��B��낵���ł����H' ) ) return;

	with ( document.entryForm ) {
		action.value = 'save';
		submit();
	}
	return false;
}


//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	td.flwtab { background-color:#ffffff }
</style>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
    <INPUT TYPE="hidden" NAME="action"      VALUE="">
    <INPUT TYPE="hidden" NAME="startPos"    VALUE="<%= lngStartPos %>">

<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�˗��󔭑��i���Ɖ�</FONT></B></TD>
    </TR>
</TABLE>

<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="60">��f��</TD>
        <TD WIDTH="10">�F</TD>
        <TD>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
                    <TD>&nbsp;�N&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
                    <TD>&nbsp;���`&nbsp;</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" BORDER="0" ALT="���t�K�C�h��\��"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" BORDER="0" ALT="�ݒ���t���N���A"></A></TD>
                    <TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
                    <TD>&nbsp;�N&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
                    <TD>&nbsp;��</TD>
                    <TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>

                    <TD align="right">
                        <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                            <TR>
                                <TD WIDTH="100"><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %></TD>
                                <TD align="right">
                                    <A HREF="javascript:submitForm('search')"><IMG SRC="../../images/b_search.gif" ALT="���̏����Ō���" HEIGHT="24" WIDTH="77" BORDER="0"></A>
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>

                </TR>
            </TABLE>
        </TD>

    </TR>
</TABLE>


<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="60">��������</TD>
        <TD WIDTH="10">�F</TD>
        <TD><%= EditDropDownListFromArray("itemCd", vntItemCd, vntItemName, strItemCd, NON_SELECTED_ADD) %></TD>

        <TD WIDTH="60" NOWRAP>�����敪 </TD>
        <TD WIDTH="10">�F</TD>
        <TD WIDTH="110">
            <SELECT NAME="reqSendStat">
                <OPTION VALUE=""  <%= IIf(strSendFlg = "",  "SELECTED", "") %>>
                <OPTION VALUE="0" <%= IIf(strSendFlg = "0", "SELECTED", "") %>>������
                <OPTION VALUE="1" <%= IIf(strSendFlg = "1", "SELECTED", "") %>>�����ς�
            </SELECT>
        </TD>
        <TD WIDTH="400"></TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD NOWRAP WIDTH="60">�lID</TD>
        <TD NOWRAP WIDTH="10">�F</TD>
        <TD NOWRAP WIDTH="*" ALIGN="LEFT">
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryForm.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD><A HREF="javascript:perGuide_clearPerInfo(document.entryForm.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD WIDTH="5"></TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
                        <INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
                        <SPAN ID="perName"><%= strPerName %></SPAN>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>


<%
    Do
    '���b�Z�[�W�̕ҏW
        If strAct <> "" Then

            Select Case strAct
                '�ۑ��������́u�ۑ������v�̒ʒm
                Case "saveend"
                    Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)
                '�����Ȃ��΃G���[���b�Z�[�W��ҏW
                Case Else
                    Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
            End Select

%>
            <BR>
            <TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
                <TR>
                    <TD>
                        <SPAN STYLE="font-size:9pt;">
                        �u<FONT COLOR="#ff6600"><B><%= strStartYear %>�N<%= strStartMonth %>��<%= strStartDay %>��<%  If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then %>�`<%= strEndYear %>�N<%= strEndMonth %>��<%= strEndDay %>��<% End IF%></B></FONT>�v�̃t�H���[�A�b�v�Ώێ҈ꗗ��\�����Ă��܂��B<BR>
                                �i��������&nbsp;�F&nbsp;<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>&nbsp;���j
                        </SPAN>
                    </TD>

                <%
                    If lngAllCount > 0 Then
                %>
                    <TD><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="1"></TD>
                    <TD><A HREF="javascript:setReqSendDateClr()"><IMG SRC="../../images/save.gif" ALT="�����m�F�������N���A���܂�" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
                <%
                    End If
                %>
                <TD WIDTH="300"> </TD>
                </TR>
            </TABLE>

            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP >��f��</TD>
                    <TD ALIGN="center" NOWRAP >�����h�c</TD>
                    <TD ALIGN="center" NOWRAP >�l�h�c</TD>
                    <TD ALIGN="center" NOWRAP  WIDTH="70">��f�Җ�</TD>
                    <TD ALIGN="center" NOWRAP >����</TD>
                    <TD ALIGN="center" NOWRAP >�N��</TD>
                    <TD ALIGN="center" NOWRAP >���N����</TD>
                    <TD ALIGN="center" NOWRAP  WIDTH="110">��������<BR>�i���蕪�ށj</TD>
                    <TD ALIGN="center" NOWRAP >�˗���Ő�</TD>
                    <TD ALIGN="center" NOWRAP  >�����m�F��</TD>
                    <TD ALIGN="center" NOWRAP  >�����m�F��</TD>
                    <TD ALIGN="center" NOWRAP >�����N���A</TD>
                </TR>
                
<%
        End If

        If lngAllCount > 0 Then
            strBeforeRsvNo = ""

            vntClrFlg = Array()
			Redim Preserve vntClrFlg(lngAllCount)

            For i = 0 To UBound(vntRsvNo)
                strWebCslDate       = ""
                strWebDayId         = ""
                strWebPerId         = ""
                strWebPerName       = ""
                strWebGender        = ""
                strWebAge           = ""
                strWebBirth         = ""
                strWebHanSu         = vntHanSu(i)
                strWebJudClassName  = vntJudClassName(i)
                strWebRsvNo         = ""
                strWebSendUser      = vntReqSendUser(i)
                strWebSendDate      = vntReqSendDate(i)

                If strBeforeRsvNo <> vntRsvNo(i) Then
                    strWebCslDate   = vntCslDate(i)
                    strWebDayId     = objCommon.FormatString(vntDayId(i), "0000")
                    strWebPerId     = vntPerId(i)
                    strWebPerName   = "<SPAN STYLE=""font-size:9px;"">" & vntPerKname(i) & "</SPAN><BR>" & vntPerName(i)
                    strWebGender    = vntGender(i)
                    strWebAge       = vntAge(i) & "��"
                    strWebBirth     = vntBirth(i)
                    strWebRsvNo     = vntRsvNo(i)
                    strWebSendUser  = vntReqSendUser(i)
                    strWebHanSu     = vntHanSu(i)
                    
                End If
%>
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'" onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebDayId %></TD>
                    <TD NOWRAP><%= strWebPerId %></TD>
                    <TD NOWRAP><%= strWebPerName %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebGender %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebAge %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebBirth %></TD>
<%
                    strBeforeRsvNo = vntRsvno(i)
%>
                    <TD NOWRAP ALIGN="center">
                        <%= strWebJudClassName   %>
                        <INPUT TYPE="hidden"    NAME="rsvNo"         VALUE="<%=vntRsvNo(i)%>">
                        <INPUT TYPE="hidden"    NAME="judClassCd"    VALUE="<%=vntJudClassCd(i)%>">
                        <INPUT TYPE="hidden"    NAME="seq"           VALUE="<%=vntHanSu(i)%>">
                    </TD>
                    <TD NOWRAP ALIGN="center"> <%= strWebHanSu %></TD>
                    <TD NOWRAP ALIGN="center"  WIDTH="140"> <% If vntReqSendDate(i) = "" Then %>-<% End If %> <%= strWebSendDate %></TD>
                    <TD NOWRAP ALIGN="center"  WIDTH="70"> <% If vntReqSendUser(i) = "" Then %>-<% End If %> <%= strWebSendUser %></TD>
                    <TD NOWRAP>
                        <INPUT TYPE="hidden" NAME="checkClrVal" VALUE="<%= vntClrFlg(i) %>">
                    <%
                        If strWebSendDate <> "" Then
                    %>
                            <INPUT TYPE="checkbox" NAME="checkClr" VALUE="1" <%= IIf(vntClrflg(i) <> "", " CHECKED", "") %>  ONCLICK="javascript:checkClrAct(<%= i %>)" border="0">�N���A
                    <%
                        Else
                    %>
                             <INPUT TYPE="checkbox" NAME="checkClr" VALUE="0" BORDER="0" STYLE="visibility:hidden">
                    <%
                        End If
                    %>
                    </TD>
                </TR>
<%
                    strBeforeRsvNo = vntRsvno(i)
            Next
        End If
%>

        </TABLE>

<%
        If lngAllCount > 0 Then
            '�S���������̓y�[�W���O�i�r�Q�[�^�s�v
                If lngPageMaxLine <= 0 Then
            Else
                'URL�̕ҏW
                strURL = Request.ServerVariables("SCRIPT_NAME")
                strURL = strURL & "?mode="        & strMode
                strURL = strURL & "&action="      & "search"
                strURL = strURL & "&startYear="   & strStartYear
                strURL = strURL & "&startMonth="  & strStartMonth
                strURL = strURL & "&startDay="    & strStartDay
                strURL = strURL & "&endYear="     & strEndYear
                strURL = strURL & "&endMonth="    & strEndMonth
                strURL = strURL & "&endDay="      & strEndDay
                strURL = strURL & "&itemCd="      & strItemCd
                strURL = strURL & "&perId="       & strPerId
                strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
                '�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
                <%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
            End If
%>
            <BR>
<%
        End If
        Exit Do
    Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
