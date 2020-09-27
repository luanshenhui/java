<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ��f���� (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const MONLIFE_GRPCD = "X030"		'��f�i�����K���j�O���[�v�R�[�h
Const MONSELF_GRPCD = "X025"		'��f�i���o�Ǐ�Q�j�O���[�v�R�[�h
Const SELF_ITEMCD   = "877001"		'���o�Ǐ� �������ڃR�[�h

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objHainsUser		'���[�U�[���A�N�Z�X�p
Dim objInterview		'�ʐڏ��A�N�Z�X�p
Dim objSentence			'���͏��A�N�Z�X�p
Dim objResult			'�������ʏ��A�N�Z�X�p

Dim strWinMode			'�E�C���h�E�\�����[�h�i1:�ʃE�C���h�E�A0:���E�C���h�E�j
Dim lngRsvNo			'�\��ԍ��i���񕪁j

Dim	vntLifeSeq			'�����K���@����ԍ�
Dim	vntLifeRsvNo		'�����K���@�\��ԍ�
Dim	vntLifeSuffix		'�����K���@�T�t�B�b�N�X
Dim	vntLifeItemType		'�����K���@���ڃR�[�h
Dim	vntLifeItemName		'�����K���@���ږ�
Dim vntLifeItemCd		'�����K���@�������ڃR�[�h
Dim vntLifeResult		'�����K���@�񓚓��e
Dim vntLifeQuestionRank	'�����K���@��f�\�������N
Dim	vntLifeItemQName	'�����K���@��f����
Dim	vntUnit				'�����K���@�P��

Dim	lngLifeCnt			'�����K���@����

Dim	vntSelfSeq			'���o�Ǐ�@����ԍ�
Dim	vntSelfRsvNo		'���o�Ǐ�@�\��ԍ�
Dim	vntSelfSuffix		'���o�Ǐ�@�T�t�B�b�N�X
Dim	vntSelfItemType		'���o�Ǐ�@���ڃR�[�h
Dim	vntSelfItemName		'���o�Ǐ�@���ږ�
Dim vntSelfItemCd		'���o�Ǐ�@�������ڃR�[�h
Dim vntSelfResult		'���o�Ǐ�@�񓚓��e
Dim vntSelfStcCd		'���o�Ǐ�@���̓R�[�h
Dim vntSelfQuestionRank	'���o�Ǐ�@��f�\�������N
Dim	vntSelfItemQName	'���o�Ǐ�@��f����

Dim	lngSelfCnt			'���o�Ǐ�@����
Dim	lngSelfCntEx		'���o�Ǐ�@������

Dim strResult1			'�񓚓��e
Dim strResult2			'�񓚓��e
Dim strResult3			'�񓚓��e
Dim strResult4			'�񓚓��e
Dim vntResult5			'�ŋߋC�ɂȂ邱��
Dim lngQuestionRank		'��f�\�������N

Dim vntSelfCondition		'���o�Ǐ�
Dim vntSelfConditionCd		'���o�Ǐ󕶏̓R�[�h
Dim vntSelfCondItemCd		'���o�Ǐ� �������ڃR�[�h
Dim vntSelfCondSuffix		'���o�Ǐ� �T�t�B�b�N�X
Dim vntSelfNumValue			'���o�Ǐ����
Dim vntSelfNumItemCd		'���o�Ǐ� �������ڃR�[�h
Dim vntSelfNumSuffix		'���o�Ǐ� �T�t�B�b�N�X
Dim vntSelfDayUnit			'���o�Ǐ�P��
Dim vntSelfDayUnitCd		'���o�Ǐ�P�ʕ��̓R�[�h
Dim vntSelfUnitItemCd		'���o�Ǐ� �������ڃR�[�h
Dim vntSelfUnitSuffix		'���o�Ǐ� �T�t�B�b�N�X
Dim vntSelfCslStat			'���o�Ǐ��f��
Dim vntSelfCslStatCd		'���o�Ǐ��f�󋵕��̓R�[�h
Dim vntSelfCslStatItemCd	'���o�Ǐ� �������ڃR�[�h
Dim vntSelfCslStatSuffix	'���o�Ǐ� �T�t�B�b�N�X

Dim i					'���[�v�J�E���^
Dim j					'���[�v�J�E���^
Dim lngWkCnt			'���[�N�p�̃J�E���g

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objSentence     = Server.CreateObject("HainsSentence.Sentence")
Set objResult       = Server.CreateObject("HainsResult.Result")

'�����l�̎擾
lngRsvNo         = Request("rsvno")
strWinMode       = Request("winmode")

Do

	'��f���ʁi�����K���j����
''## 2006.05.10 Mod by ��  *****************************
''�O���\�����[�h�ݒ�
	
'	lngLifeCnt = objInterview.SelectHistoryRslList( _
'					    lngRsvNo, _
'    					1, _
'    					MONLIFE_GRPCD, _
'    					0, _
'    					"", _
'    					2, _
'    					, , _
'						, , _
'    					vntLifeSeq, _
'    					vntLifeRsvNo, _
'    					vntLifeItemCd, _
'    					vntLifeSuffix, _
'    					 , _
'    					vntLifeItemType, _
'    					vntLifeItemName, _
'    					vntLifeResult, _
'						 , , , , , , _
'						vntUnit, _
'						 , , , _
'                        vntLifeQuestionRank, , _
'						vntLifeItemQName _
'						)


	lngLifeCnt = objInterview.SelectHistoryRslList( _
					    lngRsvNo, _
    					1, _
    					MONLIFE_GRPCD, _
    					2, _
    					"CSC01", _
    					2, _
    					, , _
						, , _
    					vntLifeSeq, _
    					vntLifeRsvNo, _
    					vntLifeItemCd, _
    					vntLifeSuffix, _
    					 , _
    					vntLifeItemType, _
    					vntLifeItemName, _
    					vntLifeResult, _
						 , , , , , , _
						vntUnit, _
						 , , , _
                        vntLifeQuestionRank, , _
						vntLifeItemQName _
						)


	'��f���ʁi���o�Ǐ�j����
'	lngSelfCnt = objInterview.SelectHistoryRslList( _
'					    lngRsvNo, _
'    					1, _
'    					MONSELF_GRPCD, _
'    					0, _
'    					"", _
'    					1, _
'    					, , _
'						, , _
'    					vntSelfSeq, _
'    					vntSelfRsvNo, _
'    					vntSelfItemCd, _
'    					vntSelfSuffix, _
'    					 , _
'    					vntSelfItemType, _
'    					vntSelfItemName, _
'    					vntSelfResult, _
'						vntSelfStcCd, _
'						 , , , , , , , , , _
'                        vntSelfQuestionRank _
'						)

	lngSelfCnt = objInterview.SelectHistoryRslList( _
					    lngRsvNo, _
    					1, _
    					MONSELF_GRPCD, _
    					2, _
    					"CSC01", _
    					1, _
    					, , _
						, , _
    					vntSelfSeq, _
    					vntSelfRsvNo, _
    					vntSelfItemCd, _
    					vntSelfSuffix, _
    					 , _
    					vntSelfItemType, _
    					vntSelfItemName, _
    					vntSelfResult, _
						vntSelfStcCd, _
						 , , , , , , , , , _
                        vntSelfQuestionRank _
						)

''## 2006.05.10 End ��  *****************************


	Exit Do
Loop

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��f����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winJikakushoujyou;				// �E�B���h�E�n���h��
//���o�Ǐ�E�C���h�E�Ăяo��
function showJikakushoujyou() {

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩


	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winJikakushoujyou != null ) {
		if ( !winJikakushoujyou.closed ) {
			opened = true;
		}
	}
	url = '/WebHains/contents/interview/jikakushoujyou.asp?rsvno=' + <%= lngRsvNo %>;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winJikakushoujyou.focus();
		winJikakushoujyou.location.replace( url );
	} else {
		winJikakushoujyou = window.open( url, '', 'width=900,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

function windowClose() {

	// ���o�Ǐ�E�C���h�E�����
	if ( winJikakushoujyou != null ) {
		if ( !winJikakushoujyou.closed ) {
			winJikakushoujyou.close();
		}
	}

	winJikakushoujyou = null;

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="813" class="mensetsu-tb">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<th NOWRAP WIDTH="193">������e</th>
			<th COLSPAN="4" NOWRAP>�񓚓��e</th>
		</TR>
<%
		For i = 0 To lngLifeCnt - 1
%>
			<TR BGCOLOR="#ffffff">
				<TD NOWRAP WIDTH="226"><%= vntLifeItemQName(i) %></TD>
<%
				lngQuestionRank = CLng(IIf( IsNumeric(vntLifeQuestionRank(i))=True, vntLifeQuestionRank(i), 0 ))
				strResult1 = "&nbsp;"
				strResult2 = "&nbsp;"
				strResult3 = "&nbsp;"
				strResult4 = "&nbsp;"
				Select Case lngQuestionRank
					Case 1
						strResult1 = vntLifeResult(i) & vntUnit(i)
					Case 2
						strResult2 = vntLifeResult(i) & vntUnit(i)
					Case 3
						strResult3 = vntLifeResult(i) & vntUnit(i)
					Case Else
						strResult4 = vntLifeResult(i) & vntUnit(i)
				End Select
%>
				<TD ALIGN="left" NOWRAP BGCOLOR="#90f0aa" WIDTH="140"><%= strResult1 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffffcc" WIDTH="140"><%= strResult2 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffdead" WIDTH="140"><%= strResult3 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="100%"><%= strResult4 %></TD>
			</TR>
<%
		Next
%>
<%
		'���o�Ǐ�
		vntResult5 = Array()	
		strResult1 = "&nbsp;"
		strResult2 = "&nbsp;"
		strResult3 = "&nbsp;"
		lngWkCnt = 0
		'�\���p�G���A�ɃZ�b�g
		For i = 0 To lngSelfCnt-1
			If vntSelfResult(i) <> "" Then
				Select Case vntSelfSuffix(i)
			    	Case "01"
			    		Redim Preserve vntResult5(lngWkCnt)
			    		vntResult5(lngWkCnt) = vntSelfResult(i)
			    	Case "02"
			    		vntResult5(lngWkCnt) = vntResult5(lngWkCnt) & vntSelfResult(i)
			    	Case "03"
			    		vntResult5(lngWkCnt) = vntResult5(lngWkCnt) & vntSelfResult(i)
			    	Case "04"
			    		vntResult5(lngWkCnt) = vntResult5(lngWkCnt) & vntSelfResult(i)
			    		lngWkCnt = lngWkCnt + 1
			    End Select
			End If
		Next

		For i = 0 To lngWkCnt - 1
%>
			<TR BGCOLOR="#ffffff">
				<TD NOWRAP WIDTH="226">�ŋߋC�ɂȂ邱��</TD>
<!-- ## 2004.02.18 �F�w�肪�������� -->
<!--
				<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="137"><%= strResult1 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffffcc" WIDTH="147"><%= strResult2 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#90f0aa" WIDTH="140"><%= strResult3 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffdead" WIDTH="100%"><%= vntResult5(i) %></TD>
-->
				<TD ALIGN="left" NOWRAP BGCOLOR="#90f0aa" WIDTH="137"><%= strResult1 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffffcc" WIDTH="147"><%= strResult2 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffdead" WIDTH="140"><%= strResult3 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="100%"><%= vntResult5(i) %></TD>

			</TR>
<%
		Next
%>
	</TABLE>
	<BR>
	<BR>
	<A HREF="javascript:showJikakushoujyou()"><FONT SIZE="+1">���o�Ǐ�</FONT></A>
	<BR><BR>
<%
	If lngSelfCnt > 0 Then
%>
<%
		vntSelfCondition = Array()		
		vntSelfConditionCd = Array()	
		vntSelfCondItemCd = Array()	
		vntSelfCondSuffix = Array()	
		vntSelfNumValue = Array()		
		vntSelfNumItemCd = Array()		
		vntSelfNumSuffix = Array()		
		vntSelfDayUnit = Array()	
		vntSelfDayUnitCd = Array()	
		vntSelfUnitItemCd = Array()	
		vntSelfUnitSuffix = Array()	
		vntSelfCslStat = Array()	
		vntSelfCslStatCd = Array()	
		vntSelfCslStatItemCd = Array()	
		vntSelfCslStatSuffix = Array()	
		lngSelfCntEx = 0
		'�\���p�G���A�ɃZ�b�g
		For i = 0 To lngSelfCnt-1
			lngWkCnt = Int( i / 4 )
			Select Case vntSelfSuffix(i)
				Case "01"
					Redim Preserve vntSelfCondition(lngWkCnt)
					Redim Preserve vntSelfConditionCd(lngWkCnt)
					Redim Preserve vntSelfCondItemCd(lngWkCnt)
					Redim Preserve vntSelfCondSuffix(lngWkCnt)
					vntSelfCondition(lngWkCnt) = vntSelfResult(i)
					vntSelfConditionCd(lngWkCnt) = vntSelfStcCd(i)
					vntSelfCondItemCd(lngWkCnt) = vntSelfItemCd(i)
					vntSelfCondSuffix(lngWkCnt) = vntSelfSuffix(i)
				Case "02"
					Redim Preserve vntSelfNumValue(lngWkCnt)
					Redim Preserve vntSelfNumItemCd(lngWkCnt)
					Redim Preserve vntSelfNumSuffix(lngWkCnt)
					vntSelfNumValue(lngWkCnt) = vntSelfResult(i)
					vntSelfNumItemCd(lngWkCnt) = vntSelfItemCd(i)
					vntSelfNumSuffix(lngWkCnt) = vntSelfSuffix(i)
				Case "03"
					Redim Preserve vntSelfDayUnit(lngWkCnt)
					Redim Preserve vntSelfDayUnitCd(lngWkCnt)
					Redim Preserve vntSelfUnitItemCd(lngWkCnt)
					Redim Preserve vntSelfUnitSuffix(lngWkCnt)
					vntSelfDayUnit(lngWkCnt) = vntSelfResult(i)
					vntSelfDayUnitCd(lngWkCnt) = vntSelfStcCd(i)
					vntSelfUnitItemCd(lngWkCnt) = vntSelfItemCd(i)
					vntSelfUnitSuffix(lngWkCnt) = vntSelfSuffix(i)
				Case "04"
					Redim Preserve vntSelfCslStat(lngWkCnt)
					Redim Preserve vntSelfCslStatCd(lngWkCnt)
					Redim Preserve vntSelfCslStatItemCd(lngWkCnt)
					Redim Preserve vntSelfCslStatSuffix(lngWkCnt)
					vntSelfCslStat(lngWkCnt) = vntSelfResult(i)
					vntSelfCslStatCd(lngWkCnt) = vntSelfStcCd(i)
					vntSelfCslStatItemCd(lngWkCnt) = vntSelfItemCd(i)
					vntSelfCslStatSuffix(lngWkCnt) = vntSelfSuffix(i)
			End Select
		Next
%>
		<TABLE BORDER="1" CELLSPACING="0" CELLPADDING="0" WIDTH="300">
<%
		For i = 0 To UBound( vntSelfConditionCd )
			If vntSelfConditionCd(i) <> "" Then
%>
				<TR>
			    	<TD ALIGN="left" NOWRAP ><%= vntSelfCondition(i) %></TD>
			    	<TD ALIGN="left" NOWRAP ><%= vntSelfNumValue(i) %></TD>
			    	<TD ALIGN="left" NOWRAP ><%= vntSelfDayUnit(i) %></TD>
			    	<TD ALIGN="left" NOWRAP ><%= vntSelfCslStat(i) %></TD>
			    </TR>
<%
			End If
		Next
%>
		</TABLE>
<%
	End If
%>
	<BR>
</FORM>
</BODY>
</HTML>