<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �R�����g���ڍ�(Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objFree				'�ėp���A�N�Z�X�p
Dim objPubNote			'�R�����g���A�N�Z�X�p
Dim objHainsUser		'���[�U���A�N�Z�X�p
Dim objConsult			'��f���A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objOrg				'�c�̏��A�N�Z�X�p

Dim strMode				'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")

Dim strCmtMode			'�ΏۃR�����g�i�J���}��؂�j
Dim strArrCmtMode		'�ΏۃR�����g�i�z��j

Dim strPerID			'�l�h�c
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strCslDate			'��M��
Dim lngRsvNo			'�\��ԍ�
Dim strCtrPtCd			'�_��p�^�[���R�[�h�i��f�R�[�X�j
Dim strCsName			'��M�R�[�X��
Dim strBirth			'���N����
Dim strBirthYear		'���N����(�N)
Dim strBirthMonth		'���N����(��)
Dim strBirthDay			'���N����(��)
Dim strGender			'����
Dim strOrgName			'�c�̖���
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q


'��f���p�ϐ�
Dim strCsCd				'�R�[�X�R�[�h
Dim strAge				'�N��
Dim strGenderName		'���ʖ���
Dim strDayId			'����ID

Dim lngSelInfo			'1:��f���,2:�l,3:�c��,4:�_��
Dim lngCheckSelInfo		'1:��f���,2:�l,3:�c��,4:�_��i�`�F�b�N��j

Dim lngSeq         		'seq
Dim lngNewSeq      		'�V�K���̐V����seq
Dim strPubNoteDivCd		'��f���m�[�g���ރR�[�h
Dim strPubNoteDivName	'��f���m�[�g���ޖ�
Dim lngDispKbn     		'�\���Ώ�
Dim lngBoldFlg     		'�����敪
Dim strPubNote     		'�m�[�g
Dim strDispColor        '�\���F
Dim lngOnlyDispKbn     	'�\���Ώۂ��΂�

Dim strUpdDate			'�X�V���t
Dim strUpdUser        	'�X�V��
Dim strUserName			'���[�U��
Dim lngAuthNote      	'�Q�Ɠo�^����
Dim lngDefNoteDispKbn	'�m�[�g�����\�����

'�R�����g���擾�p
Dim vntSeq         		'seq
Dim vntPubNoteDivCd		'��f���m�[�g���ރR�[�h
Dim vntDispKbn     		'�\���Ώ�
Dim vntBoldFlg     		'�����敪
Dim vntPubNote     		'�m�[�g
Dim vntDispColor        '�\���F
Dim vntUpdDate			'�X�V���t
Dim vntUpdUser        	'�X�V��
Dim vntUserName			'���[�U��
Dim vntPubNoteDivName	'��f���m�[�g����
Dim vntDefaultDispKbn	'�\���敪�����l
Dim vntOnlyDispKbn		'�\���敪���΂�
'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
Dim vntDelFlg			'�폜�t���O
'### 2004/3/24 Added End

DIm lngNoteCnt			'����

Dim strArrPubNoteDivCd		'��f���m�[�g���ރR�[�h
Dim strArrPubNoteDivName	'��f���m�[�g���ޖ���
Dim strArrDefaultDispKbn	'�\���Ώۋ敪�����l
Dim strArrOnlyDispKbn		'�\���Ώۋ敪���΂�
Dim lngDivCnt				'��f���m�[�g���ތ���

Dim i				'�J�E���^

Dim strArrMessage	'�G���[���b�Z�[�W
Dim Ret				'�֐��߂�l

Dim strHTML				'�Ăяo�����g�s�l�k

Dim strWkSentence		'���̓��[�N�G���A
Dim lngWrtFlg			'�������݃`�F�b�N�t���O
Dim strWkSelInfo		'�ΏۃR�����g�ԍ����[�N
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFree         = Server.CreateObject("HainsFree.Free")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set objOrg          = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strMode           = Request("mode")
strAction         = Request("act")

strCmtMode        = Request("cmtMode")
strArrCmtMode     = split( strCmtMode, "," )
If UBound( strArrCmtMode ) <> 3 Then
	Err.Raise 1000, , "�p�����[�^�F�ΏۃR�����g���s���ł��iCmtMode= " & strCmtMode & " )"    
End If

lngSelInfo        = Request("selInfo")
lngCheckSelInfo   = Request("chkSelInfo")
lngRsvNo          = Request("rsvno")
lngAuthNote       = Request("authNote")

strPerId          = Request("perId")
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strCtrPtCd        = Request("ctrPtCd")
strUpdDate	      = Request("updDate")
strUpdUser        = Session.Contents("userId")

lngSeq          = Request("seq")
strPubNoteDivCd = Request("pubNoteDivCd")
lngDispKbn      = Request("chkDispKbn")
lngOnlyDispKbn  = Request("onlyDispKbn")
strUpdDate      = Request("updDate")
strUpdUser      = Session.Contents("userId")
lngBoldFlg      = Request("checkBoldFlg")
strPubNote      = Request("pubNote")
strDispColor    = Request("dispColor")

'### 2004/06/23 Added by Ishihara@FSIT �X�V���ɂ͍ēǍ������Ȃ����߁A�폜�t���O�̎����z��
vntDelflg = Array(0)
vntDelflg(0) = Request("delflg")
'### 2004/06/23 Added End

strArrDefaultDispKbn	= ConvIStringToArray(Request("arrDefaultDispKbn"))
strArrOnlyDispKbn		= ConvIStringToArray(Request("arrOnlyDispKbn"))

'�p�����^�̃f�t�H���g�l�ݒ�
lngRsvNo   = IIf(lngRsvNo = "", 0,  lngRsvNo )
lngSeq     = IIf(IsNumeric(lngSeq) = False, 0,  lngSeq )

If lngSelInfo ="" Then
	For i = 0 To 3
		'�ΏۃR�����g
		If strArrCmtMode(i) = 1 Then
			'�C�����ł��łɑΏۃR�����g�����܂��Ă���
			If lngSelInfo <> "" Then
				If lngSeq > 0 Then
					Err.Raise 1000, , "�p�����[�^�F�ΏۃR�����g���s���ł��iCmtMode= " & strCmtMode & " )"
				End If
			Else
				lngSelInfo = CStr(i + 1)
			End If
		End If
	Next
End If

lngCheckSelInfo   = IIf(lngCheckSelInfo = "", lngSelInfo,  lngCheckSelInfo )
lngCheckSelInfo   = IIf(lngCheckSelInfo = "", "1",  lngCheckSelInfo )

objHainsUser.SelectHainsUser strUpdUser, strUserName, _
							,,,,,,,,,,,,,,,,,,,,,,, _
							lngAuthNote, lngDefNoteDispKbn



If strMode = "" Then
	If lngSeq > 0 Then
		strMode = "update"
	Else
		strMode = "insert"
	End If
End If

Do

	lngDivCnt = objPubNote.SelectPubNoteDivList ( strUpdUser, strArrPubNoteDivCd, strArrPubNoteDivName,  strArrDefaultDispKbn, strArrOnlyDispKbn)

	'�\��ԍ�����H
	If lngRsvNo <> 0 Then
		
		'��f��񌟍�
		Ret = objConsult.SelectConsult(lngRsvNo, _    
									, _    
									strCslDate,    _    
									strPerId,      _    
									strCsCd,       _    
									strCsName,     _    
									strOrgCd1, strOrgCd2, _    
									strOrgName,     _    
									, , _    
									strAge,        _    
									, , , , , , , , , , , , _    
									strDayId,   _    
									, , 0, , , , , , , , , , , , , _
									strCtrPtCd, , _    
									strLastName,   _    
									strFirstName,  _    
									strLastKName,  _    
									strFirstKName, _    
									strBirth,      _    
									strGender )    
            
		'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���    
		If Ret = False Then    
			Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"    
		End If
	Else

		'�l�h�c����H
		If strPerId <> "" Then
			'�l�h�c�����擾����
			Ret = objPerson.SelectPerson_lukes(strPerId, _
							strLastName, _
							strFirstName, _
							strLastKName, _
							strFirstKName, _
							,  _
							strBirth, _
							strGender )
			'�l��񂪑��݂��Ȃ��ꍇ
			If Ret = False Then
				Err.Raise 1000, , "�l��񂪎擾�ł��܂���B�i�l�h�c�@= " & strPerId &" �j"
			End If

			strAge = objFree.CalcAge(strBirth)
		End If

		'�c�̃R�[�h����H
		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			'�c�̏����擾����
			Ret = objOrg.SelectOrg_lukes(strOrgCd1, strOrgCd2, _
							 , , _
							strOrgName )
			'�c�̏�񂪑��݂��Ȃ��ꍇ
			If Ret = False Then
				Err.Raise 1000, , "�c�̏�񂪎擾�ł��܂���B�i�c�̃R�[�h�@= " & strOrgCd1 & "-" & strOrgCd2 &  "�j"
			End If
		End If

		'�_��R�[�h����H�H�H



	End If




	'�폜�{�^��������
	If strAction = "delete" Then

		Ret = objPubNote.DeletePubNote( _
										lngSelInfo, _
										lngRsvNo , strPerId & "", _
										strOrgCd1 & "", strOrgCd2 & "", strCtrPtCd & "", _
										lngSeq )
		
		
		'�X�V�G���[���͏����𔲂���
		If Ret <> 0 Then
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ��ĕ\�����Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.parent.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If

	'�ۑ��{�^��������
	If strAction = "save" Then
'				Err.Raise 1000, , lngCheckSelInfo & " " & lngSelInfo &" �j"

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If


		'�o�^����
		Ret = objPubNote.EntryPubNote( _
										strMode, lngCheckSelInfo, _
										lngRsvNo , strPerId & "", _
										strOrgCd1 & "", strOrgCd2 & "", strCtrPtCd & "", _
										lngSeq, strPubNoteDivCd, _
                                  		lngDispKbn, strUpdUser, lngBoldFlg, _
                                  		strPubNote & "", strDispColor & "", _
										lngNewSeq )
		'�X�V�G���[���͏����𔲂���
		If Ret <> 0 Then
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ��ĕ\�����Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.parent.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If



	End If



	
	'���ޓ���ς��������̂Ƃ��͓ǂݒ������Ȃ�
	If strAction = "change" Then
		Exit Do
	End If

	'�X�V���[�h
	If strMode = "update" Then
		
		'�R�����g���擾
'### 2004/3/24 Updated by Ishihara@FSIT �폜�f�[�^�\���Ή�
'		lngNoteCnt = objPubNote.SelectPubNote ( _
'								    lngSelInfo, _
'                           	    	0, "", "", _
'                           	    	lngRsvNo, _
'                            	    strPerId & "", _
'                            	    strOrgCd1 & "", _
'                            	    strOrgCd2 & "", _
'                            	    strCtrPtCd & "", _
'                            	    lngSeq, _
'                            	    "", 0, _
'								    strUpdUser, _
'                            	    vntSeq, _
'                            	    vntPubNoteDivCd, _
'                            	    vntPubNoteDivName, _
'                            	    vntDefaultDispKbn, _
'                            	    vntOnlyDispKbn, _
'                            	    vntDispKbn, _
'                            	    vntUpdDate, _
'                            	    vntUpdUser, _
'                            	    vntUserName, _
'                            	    vntBoldFlg, _
'                            	    vntPubNote, _
'                            	    vntDispColor _
'								)
		lngNoteCnt = objPubNote.SelectPubNote ( _
								    lngSelInfo, _
                           	    	0, "", "", _
                           	    	lngRsvNo, _
                            	    strPerId & "", _
                            	    strOrgCd1 & "", _
                            	    strOrgCd2 & "", _
                            	    strCtrPtCd & "", _
                            	    lngSeq, _
                            	    "", 0, _
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
                            	    vntDispColor, _
									,,,,1, vntDelFlg)
'### 2004/3/24 Updated End

		If lngNoteCnt <= 0 Then
				Err.Raise 1000, , "�R�����g��񂪎擾�ł��܂���B�i�l�h�c�@= " & strPerId &" �j"
		End If
 		
		lngSeq         		= vntSeq(0)         	
        strPubNoteDivCd		= vntPubNoteDivCd(0)	
        strPubNoteDivName	= vntPubNoteDivName(0)	
        lngDispKbn     		= vntDispKbn(0)     	
        lngBoldFlg     	 	= vntBoldFlg(0)    
        strPubNote     	 	= vntPubNote(0)    
        strDispColor        = vntDispColor(0)  
        strUpdDate			= vntUpdDate(0)	
        strUpdUser          = vntUpdUser(0)    
        strUserName			= vntUserName(0)	
        lngOnlyDispKbn      = vntOnlyDispKbn(0) 	

	'�V�K
	Else
		lngDispKbn = IIf(lngDispKbn = "", lngDefNoteDispKbn,  lngDispKbn )
		lngDispKbn = IIf(lngDispKbn = "", lngAuthNote,  lngDispKbn )
		lngDispKbn = IIf(lngDispKbn = "", "3",  lngDispKbn )

		If strPubNoteDivCd <> "" Then
			objPubNote.SelectPubNoteDiv strPubNoteDivCd, strPubNoteDivName, , lngOnlyDispKbn
		End If
	End If


	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �R�����g���ނ̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function PubNoteDivList()


	If lngDivCnt = 0 Then
		strArrPubNoteDivCd = Array()
		Redim Preserve strArrPubNoteDivCd(0)
		strArrPubNoteDivName = Array()
		Redim Preserve strArrPubNoteDivName(0)
		strArrDefaultDispKbn = Array()
		Redim Preserve strArrDefaultDispKbn(0)
		strArrOnlyDispKbn = Array()
		Redim Preserve strArrOnlyDispKbn(0)
	End If

	PubNoteDivList = EditDropDownListFromArray2("pubNoteDivCd", strArrPubNoteDivCd, strArrPubNoteDivName, strPubNoteDivCd, NON_SELECTED_DEL, "javascript:chkPubNoteDiv()" )

	If strPubNoteDivCd = "" Then
		lngOnlyDispKbn = strArrOnlyDispKbn(0)
	End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���͂̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()
	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
	Dim strMessage		'�G���[���b�Z�[�W

	'�e�l�`�F�b�N����
	With objCommon
		'�R�����g

		strPubNote = .StrConvKanaWide( strPubNote )

		strMessage = .CheckWideValue("�R�����g", strPubNote, 400)

		'���s������1���Ƃ��Ċ܂ގ|��ʒB
		If strMessage <> "" Then
			.AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
		End If
	End With

	'�߂�l�̕ҏW
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
<TITLE>�R�����g���ڍ�</TITLE>
<!-- #include virtual = "/webHains/includes/colorGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
//�R�����g���ޑI��������
function chkPubNoteDiv() {

//	var i
<%
	'### 2004/06/24 Added by Ishihara@FSIT �폜�f�[�^�ɂ̓��W�b�N�s�v
	If vntDelFlg(0) <> "1" Then
%>
	with ( document.entryForm ) {
		for ( i = 0; i < arrPubNoteDivCd.length; i++ ){
			if ( arrPubNoteDivCd[i].value == pubNoteDivCd.value ){
				//�f�t�H���g�̕\���ΏۃZ�b�g
				dispKbn.value = arrDefaultDispKbn[i].value;
				// �f�t�H���g�̕\���Ώۂɑ΂��錠���������ꍇ
				if (( authNote.value == 1 && (dispKbn.value == 2)) ||
					( authNote.value == 2 && (dispKbn.value == 1))){
					//�����̂���\���Ώۂ�
					dispKbn.value = authNote.value;
				} 
				chkDispKbn.value = dispKbn.value;
				onlyDispKbn.value = arrOnlyDispKbn[i].value;
				break;
			}
		}
		act.value = "change"
		submit();
	}
<%
	Else
%>
	return null;
<%
	End If
%>

}

//�\���Ώۃ`�F�b�N
function checkDispKbnAct(index) {

	with ( document.entryForm ) {
		if (index == 0 ){
			dispKbn.value = (dispKbn[index].checked ? '3' : '');
		} else if (index == 1 ){
			dispKbn.value = (dispKbn[index].checked ? '1' : '');
		} else if (index == 2 ){
			dispKbn.value = (dispKbn[index].checked ? '2' : '');
		}
		chkDispKbn.value = dispKbn.value;

	}

}
//�ΏۃR�����g�`�F�b�N
function checkSelInfoAct(index) {

	with ( document.entryForm ) {
		if (index == 0 ){
			chkSelInfo.value = (selInfoBtn[index].checked ? '1' : '');
		} else if (index == 1 ){
			chkSelInfo.value = (selInfoBtn[index].checked ? '2' : '');
		} else if (index == 2 ){
			chkSelInfo.value = (selInfoBtn[index].checked ? '3' : '');
		} else if (index == 3 ){
			chkSelInfo.value = (selInfoBtn[index].checked ? '4' : '');
		}

	}

}

//�����敪�`�F�b�N
function checkBoldFlgAct() {

	with ( document.entryForm ) {
		checkBoldFlg.value = (checkBoldFlg.checked ? '1' : '');
	}

}

//�ۑ�����
function saveData(mode) {

	if ( document.entryForm.pubNote.value == '' ){
		alert( "�R�����g�����͂���Ă��܂���B");
	} else 	if ( document.entryForm.rsvno.value == 0 && document.entryForm.chkSelInfo.value == 1 ){
		alert( "�\��ԍ����Ȃ����ߎ�f���R�����g�Ƃ��Ă͓o�^�ł��܂���B");
	} else if ( document.entryForm.perId.value == '' && document.entryForm.chkSelInfo.value == 2 ){
		alert( "�l�h�c���Ȃ����ߌl�R�����g�Ƃ��Ă͓o�^�ł��܂���B");
	} else if (( document.entryForm.orgCd1.value == '' || document.entryForm.orgCd2.value == '' )
              && document.entryForm.chkSelInfo.value == 3 ){
		alert( "�c�̃R�[�h���Ȃ����ߒc�̃R�����g�Ƃ��Ă͓o�^�ł��܂���B");
	} else if ( document.entryForm.ctrPtCd.value == '' && document.entryForm.chkSelInfo.value == 4 ){
		alert( "�_��p�^�[���R�[�h���Ȃ����ߌ_��R�����g�Ƃ��Ă͓o�^�ł��܂���B");
	} else {
		document.entryForm.act.value = "save";
		document.entryForm.mode.value = mode;
		document.entryForm.submit();
	}

}

//�폜����
function deleteData() {

	if ( !confirm( "���̃R�����g���폜���Ă���낵���ł����B")){
		return;
	}
	document.entryForm.act.value = "delete";
	document.entryForm.submit();

}
// �e�E�C���h�E�֖߂�
function goBackPage() {

	// �J���[�E�C���h�E�����
	colorGuide_closeGuideColor();

	close();

	return false;
}

// �F�I���K�C�h��ʂ�\��
function showGuideColor( elemName, colorElemName ) {

	colorGuide_showGuideColor( document.entryForm.elements[elemName], colorElemName );

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 20px 0 0 25px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:colorGuide_closeGuideColor()">
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="act"    VALUE="<%= strAction %>">
<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="cmtMode" VALUE="<%= strCmtMode %>">
<INPUT TYPE="hidden" NAME="selInfo"   VALUE="<%= lngSelInfo %>">
<INPUT TYPE="hidden" NAME="authNote"   VALUE="<%= lngAuthNote %>">
<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="seq"   VALUE="<%= lngSeq %>">
<INPUT TYPE="hidden" NAME="perId"   VALUE="<%= strPerId %>">
<INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1 %>">
<INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2 %>">
<INPUT TYPE="hidden" NAME="ctrPtCd"   VALUE="<%= strCtrPtCd %>">
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�R�����g���ڍ�</B></TD>
	</TR>
</TABLE>
<BR>
<TABLE WIDTH="562" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD></TD>
<%
		'�����������ꍇ
		If lngAuthNote = 0  Then
%>
			<TD ALIGN="right"><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0">�@<IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></TD>
<%
		Else
			If strMode = "update" Then

				If vntDelFlg(0) = "1" Then
%>
					<TD><FONT COLOR="RED"><B>���̃f�[�^�͍폜���ꂽ�f�[�^�ł��B�C���ł��܂���B</B></FONT></TD>
<%
				Else
%>
				<TD ALIGN="right">
				<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
				<%  if Session("PAGEGRANT") = "3"  then   %>
					<A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>�@
				<%  elseif Session("PAGEGRANT") = "2"  then   %>
					<A HREF="javascript:saveData( '<%= strMode %>' )" ><IMG SRC="../../images/save.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>
				<%  elseif Session("PAGEGRANT") = "4"  then    %>
					<A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>�@
					<A HREF="javascript:saveData( '<%= strMode %>' )" ><IMG SRC="../../images/save.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>
				<%  else    %>
					&nbsp;
				<%  end if  %>
				<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
				</TD>
<%
				End If
			Else
%>
				<TD ALIGN="right">
				<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
				<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
					<IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0">�@<A HREF="javascript:saveData( '<%= strMode %>' )" ><IMG SRC="../../images/save.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>
				<%  else    %>
					&nbsp;
				<%  end if  %>
				<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
				</TD>
<%
			End If
		End If
%>
	</TR>
</TABLE>
<BR>
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		Select Case strAction

			'�ۑ��������́u�ۑ������v�̒ʒm
			Case "saveend"
				Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

			'�폜�������́u�폜�����v�̒ʒm
			Case "deleteend"
				Call EditMessage("�폜���������܂����B", MESSAGETYPE_NORMAL)

			'�����Ȃ��΃G���[���b�Z�[�W��ҏW
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

		End Select

	End If
%>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
	</TR>
<%
	'�\��ԍ�������Ƃ�
	If lngRsvNo <> 0 Then
%>
		<TR>
			<TD NOWRAP>��f���F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %> </B></FONT></TD>
			<TD NOWRAP>�@�R�[�X�F</TD>
		    <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		    <TD NOWRAP>�@�����h�c�F</TD>
		    <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strDayId %></B></FONT></TD>
		    <TD NOWRAP>�@�c�́F</TD>
		    <TD NOWRAP><%= strOrgName %></TD>
		</TR>
<%
	Else
%>
		<TR>
			<TD></TD>
			<TD></TD>
<%
		'�R�[�X������H
		If strCsName <> "" Then
%>
			<TD NOWRAP>�R�[�X�F</TD>
		    <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %>�@</B></FONT></TD>
<%
		End If
%>
			<TD></TD>
			<TD></TD>
<%
		'�c�̖�����H
		If strOrgName <> "" Then
%>
		    <TD NOWRAP>�c�́F</TD>
		    <TD NOWRAP><%= strOrgName %></TD>
<%
		End If
%>
		</TR>
<%
	End If
%>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD></TD>
		<TD></TD>
		<TD></TD>
	</TR>
	<TR>
<%
		'�l�h�c����H
		If strPerId <> "" THEN
%>
			<TD NOWRAP><%= strPerId %></TD>
			<TD NOWRAP>�@<B><%= strLastName %>�@<%= strFirstName %></B> �i<FONT SIZE="-1"><%= strLastKName %>�@<%= strFirstKName %></FONT>�j</TD>
			<TD NOWRAP>�@�@<%= objCommon.FormatString(CDate(strBirth), "ge�iyyyy�j.m.d") %>���@<%= Int(strAge) %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
<%
		Else
%>
			<TD></TD>
			<TD></TD>
			<TD></TD>
<%
		End If
%>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
	<TR>
		<TD NOWRAP>�R�����g���</TD>
		<TD>�F</TD>
<!--
		<TD COLSPAN="2"><SELECT NAME="csCd" ONCHANGE="JavaScript:changeCourse()">
-->
<%
		'�����������ꍇ
		If lngAuthNote = 0  Then
%>
			<TD><%= strPubNoteDivName %></TD>
<%
		Else
%>
			<TD><%= PubNoteDivList() %></TD>
<%
			For i = 0 To lngDivCnt - 1
%>
				<INPUT TYPE="hidden" NAME="arrPubNoteDivCd" VALUE="<%= strArrPubNoteDivCd(i) %>" >
				<INPUT TYPE="hidden" NAME="arrPubNoteDivName" VALUE="<%= strArrPubNoteDivName(i) %>" >
				<INPUT TYPE="hidden" NAME="arrDefaultDispKbn" VALUE="<%= strArrDefaultDispKbn(i) %>" >
				<INPUT TYPE="hidden" NAME="arrOnlyDispKbn" VALUE="<%= strArrOnlyDispKbn(i) %>" >
<%
			Next
		End If
%>
		<TD WIDTH="100%"></TD>
<%
%>
	</TR>
	<TR>
		<INPUT TYPE="hidden" NAME="chkDispKbn" VALUE="<%= lngDispKbn %>" >
		<INPUT TYPE="hidden" NAME="onlyDispKbn" VALUE="<%= lngOnlyDispKbn %>" >
		<TD NOWRAP>�\���Ώ�</TD>
		<TD>�F</TD>
		<TD COLSPAN="2">
<%
		'�\���Ώۋ敪���΂肠��H �܂��͌���������
		If lngOnlyDispKbn = "1" Or lngOnlyDispKbn = "2" Or lngAuthNote = 0  Then
%>
			<INPUT TYPE="hidden" NAME="dispKbn" VALUE="<%= lngDispKbn %>">
<%
		Else
%>
			<INPUT TYPE="radio" NAME="dispKbn" VALUE="<%= lngDispKbn %>" <%= IIf(lngDispKbn = "3", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(0)"  BORDER="0">���ʁ@
<%
		End If
%>
<%
		'�\���Ώۋ敪 �����̂݁H �܂��͌���������
		If lngOnlyDispKbn = "2" Or lngAuthNote = 0 Or lngAuthNote = 2  Then
%>
			<INPUT TYPE="hidden" NAME="dispKbn" VALUE="<%= lngDispKbn %>">
<%
		Else
%>
			<INPUT TYPE="radio" NAME="dispKbn" VALUE="<%= lngDispKbn %>" <%= IIf(lngDispKbn = "1", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(1)"  BORDER="0">��Ï��@
<%
		End If
%>
<%
		'�\���Ώۋ敪 ��Â̂݁H �܂��͌���������
		If lngOnlyDispKbn = "1"  Or lngAuthNote = 0 Or lngAuthNote = 1 Then
%>
			<INPUT TYPE="hidden" NAME="dispKbn" VALUE="<%= lngDispKbn %>">
<%
		Else
%>
			<INPUT TYPE="radio" NAME="dispKbn" VALUE="<%= lngDispKbn %>" <%= IIf(lngDispKbn = "2", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(2)"  BORDER="0">�������
<%
		End If
%>
		</TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<TR>
		<TD VALIGN="top" NOWRAP>�R�����g</TD>
		<TD VALIGN="top">�F</TD>
<!--
		<TD VALIGN="top"><A HREF="commentList.html" TARGET="_blank"><IMG SRC="../../images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
-->
		<TD WIDTH="467"><TEXTAREA NAME="pubNote" ROWS="4" COLS="63" STYLE="ime-mode:active;"><%= strPubNote %></TEXTAREA></TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<INPUT TYPE="hidden" NAME="chkSelInfo" VALUE="<%= lngCheckSelInfo %>" >
<%
	lngWrtFlg = 0
	For i = 0 To 3
		If strArrCmtMode(i) = 1 Then
			Select Case i
				Case 0
					strWkSentence = "����̌��f�ɂ��ăR�����g��o�^"
				Case 1
					strWkSentence = "���̎�f�҂ɑ΂��ăR�����g��o�^"
				Case 2
					strWkSentence = "���̒c�̂ɑ΂��ăR�����g��o�^"
				Case 3
					strWkSentence = "����̌_��ɑ΂��ăR�����g��o�^"
			End Select
	
			If lngWrtFlg = 0 Then
				lngWrtFlg = 1
%>
				<TR>
					<TD NOWRAP>�ΏۃR�����g</TD>
					<TD>�F</TD>
<%
			Else
%>
				<TR>
					<TD NOWRAP></TD>
					<TD></TD>
<%
			End If

			strWkSelInfo = Cstr(i+1)
%>
				<TD COLSPAN="2"><INPUT TYPE="radio" NAME="selInfoBtn" VALUE="<%= lngCheckSelInfo %>" <%= IIf(lngCheckSelInfo = strWkSelInfo, " CHECKED", "") %> ONCLICK="javascript:checkSelInfoAct(<%= i %>)" BORDER="0"><% = strWkSentence %></TD>
				<TD WIDTH="100%"></TD>
			</TR>
<%
		End If
	Next
%>
	<TR>
		<TD NOWRAP></TD>
		<TD></TD>
		<TD COLSPAN="2"></TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<TR>
		<TD NOWRAP>�\���F</TD>
		<TD>�F</TD>
		<TD COLSPAN="2">
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:showGuideColor('dispColor', 'elemDispColor')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�F�I���K�C�h�\��"></A></TD>
					<TD><INPUT TYPE="hidden" NAME="dispColor" VALUE="<%= strDispColor %>"><FONT SIZE="4" COLOR="#<%= strDispColor %>" ID="elemDispColor">��</FONT></TD>
					<TD>�@<INPUT TYPE="checkbox" NAME="checkBoldFlg" VALUE="1" <%= IIf(lngBoldFlg <> 0, " CHECKED", "") %>  ONCLICK="javascript:checkBoldFlgAct()" border="0"></FONT><FONT COLOR="black">���̃R�����g�͑����ŕ\������</FONT></TD>
				</TR>
			</TABLE>
		</TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<TR HEIGHT="4">
		<TD VALIGN="top" NOWRAP HEIGHT="4"></TD>
		<TD VALIGN="top" HEIGHT="4"></TD>
		<TD HEIGHT="4"></TD>
		<TD WIDTH="467" HEIGHT="4"></TD>
		<TD WIDTH="100%" HEIGHT="4"></TD>
	</TR>
	<TR>
		<TD NOWRAP>�X�V����</TD>
		<TD>�F</TD>
		<TD COLSPAN="2"><%= strUpdDate %></TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<TR>
		<TD NOWRAP>�X�V��</TD>
		<TD>�F</TD>
		<TD COLSPAN="2"><%= strUserName %></TD>
		<TD WIDTH="100%"></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD WIDTH="500"></TD>
		<TD>
			<A HREF="javascript:goBackPage()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
		</TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
