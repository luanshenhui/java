<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �ꗗ���ʓ��� (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditGrpList.inc" -->
<!-- #include virtual = "/webHains/includes/EditNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditRslDailyList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const STDFLG_H = "H"		'�ُ�i��j
Const STDFLG_U = "U"		'�y�x�ُ�i��j
Const STDFLG_D = "D"		'�y�x�ُ�i���j
Const STDFLG_L = "L"		'�ُ�i���j
Const STDFLG_T1 = "*"		'�萫�l�ُ�
Const STDFLG_T2 = "@"		'�萫�l�y�x�ُ�

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon				'���ʃN���X
Dim objResult				'�������ʃA�N�Z�X�pCOM�I�u�W�F�N�g
Dim objConsult				'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objGrp					'�O���[�v�A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objWorkStation			'�ʉߏ��A�N�Z�X�p

Dim strAction				'�������(���փ{�^��������:"next")
Dim lngYear					'��f���i�N�j
Dim lngMonth				'��f���i���j
Dim lngDay					'��f���i���j
Dim strGrpCd				'�����O���[�v�R�[�h
Dim strSortKey				'�\����
Dim strDayIdF				'�\���J�n�����h�c
Dim strGetCount				'�\������
Dim lngStartPos				'�\���J�n�ʒu

'��f���
Dim strRsvNo				'�\��ԍ�
Dim strPerId				'�l�h�c
Dim strDayId				'�����h�c
Dim strLastName				'��
Dim strFirstName			'��

'�O���[�v���������ڏ��
Dim strGrpItemCd			'�������ڃR�[�h
Dim strGrpSuffix			'�T�t�B�b�N�X
Dim strGrpItemName			'�������ږ���

'�������ʏ��
Dim strRslRsvNo				'�������ڂ��Ɨ\��ԍ�
Dim strRslLastName			'�������ڂ��Ɛ�
Dim strRslFirstName			'�������ڂ��Ɩ�
Dim strConsultFlg			'��f���ڃt���O
Dim strItemCd				'�������ڃR�[�h
Dim strSuffix				'�T�t�B�b�N�X
Dim strItemName				'�������ږ���
Dim strResult				'��������
Dim strResultType			'���ʃ^�C�v
Dim strResultErr			'���ʓ��̓G���[
Dim strStdFlg				'��l�t���O
Dim strInitRsl				'�����ǂݍ��ݏ�Ԃ̌���

'���ۂɍX�V���鍀�ڏ����i�[������������
Dim strUpdRsvNo				'�\��ԍ�
Dim strUpdItemCd			'�������ڃR�[�h
Dim strUpdSuffix			'�T�t�B�b�N�X
Dim strUpdResult			'��������
Dim lngUpdCount				'�X�V���ڐ�

Dim strCslDate				'��f��
Dim lngDayId				'�����h�c
Dim strArrMessage			'�G���[���b�Z�[�W

Dim lngAllCount				'�����𖞂����S���R�[�h����
Dim lngCount				'���R�[�h����
Dim lngItemCount			'�������ڐ�
Dim lngRslCount				'�������ʐ�
Dim lngUpdItemCount			'�X�V���ڐ�

Dim lngWorkGetCount			'�擾����

Dim i						'�C���f�b�N�X
Dim blnFindFlg				'�����t���O

'�[���Ǘ����
Dim strIPAddress			'IPAddress
Dim strWkstnName			'�[����
Dim strWkstnGrpCd			'�O���[�v�R�[�h
Dim strWkstnGrpName			'�O���[�v��

'�\���F
Dim strH_Color				'��l�t���O�F�i�g�j
Dim strU_Color				'��l�t���O�F�i�t�j
Dim strD_Color				'��l�t���O�F�i�c�j
Dim strL_Color				'��l�t���O�F�i�k�j
Dim strT1_Color				'��l�t���O�F�i���j
Dim strT2_Color				'��l�t���O�F�i���j

Dim strUpdUser			'�X�V��

Dim lngChkIndex()		'�������ڃR�[�h
Dim strChkItemCd()		'�������ڃR�[�h
Dim strChkSuffix()		'�T�t�B�b�N�X
Dim strChkResult()		'��������
Dim strChkShortStc		'���͗���
Dim strChkResultErr()	'�������ʃG���[
Dim lngChkCount			'�`�F�b�N���ڐ�

Dim strPrevRsvNo		'���O���R�[�h�̗\��ԍ�
Dim strPrevRslName		'���O���R�[�h�̎���
Dim strArrMessage2		'���b�Z�[�W
Dim lngMsgCount			'���b�Z�[�W��
Dim j					'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'IP�A�h���X�̎擾
strIPAddress = Request.ServerVariables("REMOTE_ADDR")

'�����l�̎擾
strAction		= Request("act")
lngYear			= Request("year")
lngMonth		= Request("month")
lngDay			= Request("day")
strGrpCd		= Request("grpCd")
strSortKey		= Request("sortKey")
strDayIdF		= Request("dayIdF")
strGetCount		= Request("getCount")
lngStartPos 	= CLng("0" & Request("startPos"))

'�����J�n�ʒu���w�莞�͐擪���猟������
If lngStartPos = 0 Then
	lngStartPos = 1
End If

'��f�������w��̏ꍇ�́A�V�X�e�������f�t�H���g�Z�b�g
If lngYear = "" And lngMonth = "" And lngDay = "" Then
	lngYear  = CLng(Year(Now))
	lngMonth = CLng(Month(Now))
	lngDay   = CLng(Day(Now))
Else
	lngYear  = CLng("0" & lngYear)
	lngMonth = CLng("0" & lngMonth)
	lngDay   = CLng("0" & lngDay)
End If

'�R�[�h���n����Ă��Ȃ��ꍇ
If strGrpCd = "" Then

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objWorkStation = Server.CreateObject("HainsWorkStation.WorkStation")

	'�K��̃O���[�v�R�[�h�擾
	If objWorkStation.SelectWorkstation(strIPAddress, strWkstnName, strWkstnGrpCd, strWkstnGrpName) = True Then
		strGrpCd = strWkstnGrpCd
	End If

	Set objWorkStation = Nothing

End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'��l�t���O�F�擾
objCommon.SelectStdFlgColor "H_COLOR", strH_Color
objCommon.SelectStdFlgColor "U_COLOR", strU_Color
objCommon.SelectStdFlgColor "D_COLOR", strD_Color
objCommon.SelectStdFlgColor "L_COLOR", strL_Color
objCommon.SelectStdFlgColor "*_COLOR", strT1_Color
objCommon.SelectStdFlgColor "@_COLOR", strT2_Color

'��f���
strRsvNo     = ConvIStringToArray(Request("rsvNo"))
strPerId     = ConvIStringToArray(Request("perId"))
strDayId     = ConvIStringToArray(Request("dayId"))
strLastName  = ConvIStringToArray(Request("lastName"))
strFirstName = ConvIStringToArray(Request("firstName"))

'�O���[�v���������ڏ��
strGrpItemCd   = ConvIStringToArray(Request("grpItemCd"))
strGrpSuffix   = ConvIStringToArray(Request("grpSuffix"))
strGrpItemName = ConvIStringToArray(Request("grpItemName"))

'�������ʏ��
strRslRsvNo     = ConvIStringToArray(Request("rslRsvNo"))
strRslLastName  = ConvIStringToArray(Request("rslLastName"))
strRslFirstName = ConvIStringToArray(Request("rslFirstName"))
strConsultFlg   = ConvIStringToArray(Request("consultFlg"))
strItemCd       = ConvIStringToArray(Request("itemCd"))
strSuffix       = ConvIStringToArray(Request("suffix"))
strItemName     = ConvIStringToArray(Request("itemName"))
strResult       = ConvIStringToArray(Request("result"))
strResultType   = ConvIStringToArray(Request("resultType"))
strResultErr    = ConvIStringToArray(Request("resultErr"))
strStdFlg       = ConvIStringToArray(Request("stdFlg"))
strInitRsl      = ConvIStringToArray(Request("initRsl"))

'�������
lngCount     = CLng("0" & Request("count"))
lngItemCount = CLng("0" & Request("itemCount"))
lngRslCount  = CLng("0" & Request("rslCount"))
lngUpdItemCount = CLng("0" & Request("updItemCount"))

Do
	If strAction = "save" Then

		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objResult  = Server.CreateObject("HainsResult.Result")

		strCslDate = CDate(lngYear & "/" & lngMonth & "/" & lngDay)

		'���ʓ��̓`�F�b�N
		For i = 0 To UBound(strRslRsvNo)

			'���O���R�[�h�Ɨ\��ԍ����ς�������_�Ń`�F�b�N���s��
			If strPrevRsvNo <> "" And strRslRsvNo(i) <> strPrevRsvNo Then

				'���ʓ��̓`�F�b�N
				strArrMessage2 = objResult.CheckResult(strCslDate, strChkItemCd, strChkSuffix, strChkResult, strChkShortStc, strChkResultErr)

				'�`�F�b�N���ʂ�߂�
				For j = 0 To lngChkCount - 1
					strResult(lngChkIndex(j))    = strChkResult(j)
					strResultErr(lngChkIndex(j)) = strChkResultErr(j)
				Next

				'�G���[�����݂���ꍇ
				If Not IsEmpty(strArrMessage2) Then

					If IsEmpty(strArrMessage) Then
						strArrMessage = Array()
					End If

					'�G���[���b�Z�[�W��ǉ�
					For j = 0 To UBound(strArrMessage2)
						ReDim Preserve strArrMessage(lngMsgCount)
						strArrMessage(lngMsgCount) = strPrevRslName & "�@" & strArrMessage2(j)
						lngMsgCount = lngMsgCount + 1
					Next

				End If

				'�`�F�b�N�����N���A
				Erase lngChkIndex
				Erase strChkItemCd
				Erase strChkSuffix
				Erase strChkResult
				Erase strChkResultErr
				lngChkCount = 0

			End If

			'�`�F�b�N�����X�^�b�N
			ReDim Preserve lngChkIndex(lngChkCount)
			ReDim Preserve strChkItemCd(lngChkCount)
			ReDim Preserve strChkSuffix(lngChkCount)
			ReDim Preserve strChkResult(lngChkCount)
			ReDim Preserve strChkResultErr(lngChkCount)
			lngChkIndex(lngChkCount)     = i
			strChkItemCd(lngChkCount)    = strItemCd(i)
			strChkSuffix(lngChkCount)    = strSuffix(i)
			strChkResult(lngChkCount)    = strResult(i)
			strChkResultErr(lngChkCount) = strResultErr(i)
			lngChkCount = lngChkCount + 1

			'�����R�[�h�̗\��ԍ��A������ޔ�
			strPrevRsvNo   = strRslRsvNo(i)
			strPrevRslName = Trim(strRslLastName(i) & "�@" & strRslFirstName(i))

		Next

		'�X�^�b�N�c�蕪�̌��ʃ`�F�b�N

		'���ʓ��̓`�F�b�N
		strArrMessage2 = objResult.CheckResult(strCslDate, strChkItemCd, strChkSuffix, strChkResult, strChkShortStc, strChkResultErr)

		'�`�F�b�N���ʂ�߂�
		For j = 0 To lngChkCount - 1
			strResult(lngChkIndex(j))    = strChkResult(j)
			strResultErr(lngChkIndex(j)) = strChkResultErr(j)
		Next

		'�G���[�����݂���ꍇ
		If Not IsEmpty(strArrMessage2) Then

			If IsEmpty(strArrMessage) Then
				strArrMessage = Array()
			End If

			'�G���[���b�Z�[�W��ǉ�
			For j = 0 To UBound(strArrMessage2)
				ReDim Preserve strArrMessage(lngMsgCount)
				strArrMessage(lngMsgCount) = strPrevRslName & "�@" & strArrMessage2(j)
				lngMsgCount = lngMsgCount + 1
			Next

		End If

		'�`�F�b�N�G���[���͏����𔲂���
		If Not IsEmpty(strArrMessage) Then

			'�ۑ��G���[�������͑��J�E���g�����Z�b�g�i�y�[�W���O�p�̃{�^�����\������Ȃ��Ȃ��Ă��܂��j
			lngAllCount = Request("allCountUseSave")
			lngStartPos = Request("startPosUseSave")

			Exit Do
		End If

		lngUpdCount  = 0
		strUpdRsvNo  = Array()
		strUpdItemCd = Array()
		strUpdSuffix = Array()
		strUpdResult = Array()

		'���ۂɍX�V���s�����ڂ݂̂𒊏o(���ʖ����͂Ń`�F�b�N�Ȃ��̍��ڈȊO���X�V�Ώ�)
		For i = 0 To UBound(strRslRsvNo)

			'���ʂ������\�����̒l����X�V����Ă�����f�[�^�X�V
			If strConsultFlg(i) = CStr(CONSULT_ITEM_T) And strResult(i) <> strInitRsl(i) Then
				ReDim Preserve strUpdRsvNo(lngUpdCount)
				ReDim Preserve strUpdItemCd(lngUpdCount)
				ReDim Preserve strUpdSuffix(lngUpdCount)
				ReDim Preserve strUpdResult(lngUpdCount)
				strUpdRsvNo(lngUpdCount)  = strRslRsvNo(i)
				strUpdItemCd(lngUpdCount) = strItemCd(i)
				strUpdSuffix(lngUpdCount) = strSuffix(i)
				strUpdResult(lngUpdCount) = strResult(i)
				lngUpdCount = lngUpdCount + 1
			End If

		Next

		'�������ʍX�V
		If lngUpdCount > 0 Then

			strArrMessage = objResult.UpdateResultList(strUpdUser, strIPAddress, strUpdRsvNo, strUpdItemCd, strUpdSuffix, strUpdResult)

			If Not IsEmpty(strArrMessage) Then

				'�ۑ��G���[�������͑��J�E���g�����Z�b�g�i�y�[�W���O�p�̃{�^�����\������Ȃ��Ȃ��Ă��܂��j
				lngAllCount = Request("allCountUseSave")
				lngStartPos = Request("startPosUseSave")

				Exit Do
			End If

		End If

		'�I�u�W�F�N�g�̃C���X�^���X�폜
		Set objResult = Nothing

		'�ۑ�����
		strAction = "saveend"

	End If

	'�����J�E���^�N���A
	lngCount = 0
	lngItemCount = 0
	lngRslCount = 0

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objResult  = Server.CreateObject("HainsResult.Result")

	'�������̓`�F�b�N
	strArrMessage = objResult.CheckRslListSetConditionValue(lngYear, lngMonth, lngDay, strCslDate, strDayIdF)

	'�`�F�b�N�G���[���͏����𔲂���
	If Not IsEmpty(strArrMessage) Then
		Exit Do
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objResult  = Nothing

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objResult  = Server.CreateObject("HainsResult.Result")
	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	Set objGrp     = Server.CreateObject("HainsGrp.Grp")

	lngDayId = CLng("0" & strDayIdF)

	'�擾�������w�莞�̓f�t�H���g�l���擾
	strGetCount = IIf(strGetCount = "", EditRslPageMaxLine(), strGetCount)

	'�擾�����̐ݒ�
	If IsNumeric(strGetCount) Then
		lngWorkGetCount = CLng(strGetCount)
	End If

	'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'	lngAllCount = objConsult.SelectConsultList(strCslDate,         _
'											   0,                  _
'											   "",                 _
'											   lngDayId, ,         _
'											   strGrpCd,           _
'											   lngStartPos,        _
'											   lngWorkGetCount,    _
'											   strSortKey, , , , , _
'											   strRsvNo,           _
'											   strDayId, , ,       _
'											   strPerId,           _
'											   strLastName,        _
'											   strFirstName)
	lngAllCount = objConsult.SelectConsultList(strCslDate,         _
											   0,                  _
											   "",                 _
											   lngDayId, ,         _
											   strGrpCd,           _
											   lngStartPos,        _
											   lngWorkGetCount,    _
											   strSortKey, , , , , _
											   strRsvNo,           _
											   strDayId, , ,       _
											   strPerId,           _
											   strLastName,        _
											   strFirstName, , , , , , , , , , , , , , , , , _
											   True)
'## 2004.01.09 Mod End

	'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
	If lngAllCount = 0 Then
		strArrMessage = Array("�����ɍ��v�����f���͑��݂��܂���B")
		Exit Do
	End If

	If Not IsEmpty(strRsvNo) Then
		lngCount = UBound(strRsvNo) + 1
	End If

	'�O���[�v���������ڂ��擾
	lngItemCount = objGrp.SelectGrp_I_ItemList(strGrpCd, strGrpItemCd, strGrpSuffix, strGrpItemName)

	'�������ʂ��擾
	lngRslCount = objResult.SelectRslListSet(strRsvNo, _
											 strLastName, _
											 strFirstName, _
											 strGrpCd, _
											 lngUpdItemCount, _
											 strRslRsvNo, _
											 strRslLastName, _
											 strRslFirstName, _
											 strConsultFlg, _
											 strItemCd, _
											 strSuffix, _
											 strItemName, _
											 strResult, _
											 strResultType, _
											 strStdFlg)

	'�ǂݍ��񂾒���̌��ʁA���ʃR�����g��������Ԃ̔z��Ƃ��ĕێ�
	strInitRsl = strResult

	'���̓`�F�b�N�p�̔z����g��
	If lngRslCount > 0 Then
		ReDim strResultErr(lngRslCount - 1)
	End If

	Exit Do
Loop

'-----------------------------------------------------------------------------
' �ꗗ�������ʂ̕ҏW
'-----------------------------------------------------------------------------
Sub EditRslList()

	Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'�E��
	Const CLASS_ERROR     = "CLASS=""rslErr"""				'�G���[�\���̃N���X�w��

	Dim strDispStdFlgColor	'�ҏW�p��l�\���F
	Dim strAlignMent		'�\���ʒu

	Dim strClass			'�X�^�C���V�[�g��CLASS�w��
	Dim strClassStdFlg		'��l�X�^�C���V�[�g��CLASS�w��

	Dim i					'�C���f�b�N�X
	Dim j					'�C���f�b�N�X
	Dim k					'�C���f�b�N�X

%>
	<INPUT TYPE="hidden" NAME="count"         VALUE="<%= lngCount %>">
	<INPUT TYPE="hidden" NAME="itemCount"     VALUE="<%= lngItemCount %>">
	<INPUT TYPE="hidden" NAME="rslCount"      VALUE="<%= lngRslCount %>">
	<INPUT TYPE="hidden" NAME="updItemCount"  VALUE="<%= lngUpdItemCount %>">
<%
	If lngCount = 0 Or lngItemCount = 0 Or lngRslCount = 0 Then
		Exit Sub
	End If

	If lngUpdItemCount = 0 Then
		Call EditMessage("���̌����O���[�v�Ɏ�f�����������ڂ͑��݂��܂���B", MESSAGETYPE_NORMAL)
		Exit Sub
	End If
%>
	�u<FONT COLOR="#ff6600"><B><%= lngYear %>�N<%= lngMonth %>��<%= lngDay %>��</B></FONT>�v�̗��@�ςݎ�f�҈ꗗ��\�����Ă��܂��B�ΏێҐ���<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>�l�ł��B<BR><BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" class="mensetsu-tb">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP>�����h�c</TD>
			<TD NOWRAP>�l�h�c</TD>
			<TD NOWRAP>����</TD>
<%
			For i = 0 To lngItemCount - 1
%>
				<TD>
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="70" HEIGHT="1"><BR>
					<INPUT TYPE="hidden" NAME="grpItemCd"   VALUE="<%= strGrpItemCd(i) %>">
					<INPUT TYPE="hidden" NAME="grpSuffix"   VALUE="<%= strGrpSuffix(i) %>">
					<INPUT TYPE="hidden" NAME="grpItemName" VALUE="<%= strGrpItemName(i) %>">
					<%= strGrpItemName(i) %>
				</TD>
<%
			Next
%>
		</TR>
<%
		For i = 0 To lngCount - 1
%>
			<TR>
				<TD NOWRAP><%= Right("0000" & strDayId(i), 4) %></TD>
				<TD NOWRAP><%= strPerId(i) %></TD>
				<TD NOWRAP>
					<%= strLastName(i) & "�@" & strFirstName(i) %>
					<INPUT TYPE="hidden" NAME="rsvNo"     VALUE="<%= strRsvNo(i) %>">
					<INPUT TYPE="hidden" NAME="perId"     VALUE="<%= strPerId(i) %>">
					<INPUT TYPE="hidden" NAME="dayId"     VALUE="<%= strDayId(i) %>">
					<INPUT TYPE="hidden" NAME="lastName"  VALUE="<%= strLastName(i) %>">
					<INPUT TYPE="hidden" NAME="firstName" VALUE="<%= strFirstName(i) %>">
				</TD>
<%
				For j = 0 To lngItemCount - 1

					blnFindFlg = False
					For k = 0 To lngRslCount - 1

						If strRsvNo(i) = strRslRsvNo(k) And strGrpItemCd(j) = strItemCd(k) And strGrpSuffix(j) = strSuffix(k) Then
%>
							<TD>
								<INPUT TYPE="hidden" NAME="rslRsvNo"     VALUE="<%= strRslRsvNo(k)     %>">
								<INPUT TYPE="hidden" NAME="rslLastName"  VALUE="<%= strRslLastName(k)  %>">
								<INPUT TYPE="hidden" NAME="rslFirstName" VALUE="<%= strRslFirstName(k) %>">
								<INPUT TYPE="hidden" NAME="consultFlg"   VALUE="<%= strConsultFlg(k)   %>">
								<INPUT TYPE="hidden" NAME="itemCd"       VALUE="<%= strItemCd(k)       %>">
								<INPUT TYPE="hidden" NAME="suffix"       VALUE="<%= strSuffix(k)       %>">
								<INPUT TYPE="hidden" NAME="itemName"     VALUE="<%= strItemName(k)     %>">
								<INPUT TYPE="hidden" NAME="resultType"   VALUE="<%= strResultType(k)   %>">
								<INPUT TYPE="hidden" NAME="resultErr"    VALUE="<%= strResultErr(k)    %>">
								<INPUT TYPE="hidden" NAME="stdFlg"       VALUE="<%= strStdFlg(k)       %>">
								<INPUT TYPE="hidden" NAME="initRsl"      VALUE="<%= strInitRsl(k)      %>">
<%
								'��l�t���O�ɂ��F��ݒ肷��
								Select Case strStdFlg(k)
									Case STDFLG_H
										strDispStdFlgColor = strH_Color
									Case STDFLG_U
										strDispStdFlgColor = strU_Color
									Case STDFLG_D
										strDispStdFlgColor = strD_Color
									Case STDFLG_L
										strDispStdFlgColor = strL_Color
									Case STDFLG_T1
										strDispStdFlgColor = strT1_Color
									Case STDFLG_T2
										strDispStdFlgColor = strT2_Color
									Case Else
										strDispStdFlgColor = ""
								End Select

								If strResultErr(k) <> "" Then
									strClass       = CLASS_ERROR
									strClassStdFlg = ""
								Else
									strClass       = ""
									strClassStdFlg = IIf(strDispStdFlgColor <> "", "STYLE=""color:" & strDispStdFlgColor & """", "")
								End If

								'�v�Z���ڂłȂ��A����f���Ă���ꍇ
								If CLng(strResultType(k)) <> RESULTTYPE_CALC And CLng(strConsultFlg(k)) = CONSULT_ITEM_T Then

									'�X�^�C���V�[�g�̐ݒ�
									strAlignment = IIf(CLng(strResultType(k)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
									<INPUT TYPE="text" NAME="result" SIZE="<%= TextLength(8) %>" MAXLENGTH="8" VALUE="<%= strResult(k) %>" <%= strAlignment %> <%= strClass %> <%= strClassStdFlg %>>
<%
								Else
%>
									<INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(k) %>"><SPAN <%= strClassStdFlg %>><%= strResult(k) %></SPAN>
<%
								End If
%>
							</TD>
<%
							blnFindFlg = True
							Exit For
						End If

					Next

					If Not blnFindFlg Then
%>
						<TD>&nbsp;</TD>
<%
					End If

				Next
%>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End Sub

'-----------------------------------------------------------------------------
' �y�[�W���O�i�r�Q�[�^�[�̕ҏW
'-----------------------------------------------------------------------------
Sub EditNavi()

	Dim strBasedURL			'URL�̋��ʕ�

	Dim lngTotalPage		'���y�[�W��
	Dim lngStartPage		'�J�n�y�[�W�ԍ�
	Dim lngCurrentPage		'���݃y�[�W�ԍ�
	Dim lngPage				'�y�[�W�J�E���^
	Dim lngCurrentStartPos	'URL�ɕҏW���錟���J�n�ʒu
	Dim lngGetCount			'�\������

	If Not IsNumeric(strGetCount) Then
		Exit Sub
	Else
		lngGetCount = CLng(strGetCount)
	End If

'response.write "lngAllCount=" & lngAllCount & "<BR>"
'response.write "lngGetCount=" & lngGetCount & "<BR>"

	'�����������\�������ȉ��̏ꍇ�A�y�[�W���O�i�r�Q�[�^�͕\�����Ȃ�
	If lngAllCount <= lngGetCount Then
		Exit Sub
	End If

	'���y�[�W���E���݃y�[�W�ԍ������߂�
	lngTotalPage   = Int(lngAllCount / lngGetCount) + IIf(lngAllCount Mod lngGetCount > 0, 1, 0)
	lngCurrentPage = (lngStartPos - 1) / lngGetCount + 1
	lngCurrentStartPos = (lngCurrentPage - 1) * lngGetCount + 1
	strBasedURL = "rslListSet.asp?year=" & lngYear & "&month=" & lngMonth & "&day=" & lngDay & "&grpCd=" & strGrpCd & "&sortKey=" & strSortKey & "&dayIdF=" & strDayIdF & "&getCount=" & strGetCount & "&startPos="

'response.write "lngCurrentPage=" & lngCurrentPage & "<BR>"
'response.write "lngCurrentStartPos=" & lngCurrentStartPos & "<BR>"

	If lngCurrentPage > 1 Then
%>
		<TD>
			<A HREF="<%= strBasedURL & (lngCurrentStartPos - lngGetCount) %>"><IMG SRC="/webHains/images/prevper.gif" WIDTH="77" HEIGHT="24" ALT="�O�̎�f�҂�\��"></A>
		</TD>
<%
	End If
	If lngCurrentPage < lngTotalPage Then
%>
		<TD>
			<A HREF="<%= strBasedURL & (lngCurrentStartPos + lngGetCount) %>"><IMG SRC="/webHains/images/nextper.gif" WIDTH="77" HEIGHT="24" ALT="���̎�f�҂�\��"></A>
		</TD>
<%
	End If

End Sub

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���[�N�V�[�g�`���̌��ʓ���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
function goNextPage() {

	document.rslListSet.submit();
	
	return false;
}

// �ۑ�����
function saveData() {

	// ������ύX�O�̏�Ԃɖ߂�
	document.rslListSet.year.value = '<%= lngYear %>';
	document.rslListSet.month.value = '<%= lngMonth %>';
	document.rslListSet.day.value = '<%= lngDay %>';
	document.rslListSet.grpCd.value = '<%= strGrpCd %>';
	document.rslListSet.sortkey.value = '<%= strSortKey %>';
	document.rslListSet.dayIdF.value = '<%= strDayIdF %>';
	document.rslListSet.getCount.value = '<%= strGetCount %>';

	document.rslListSet.act.value = 'save';
	document.rslListSet.submit();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/mensetsutable.css">
<STYLE TYPE="text/css">
	td.rsltab  { background-color:#FFFFFF }
	input[name="result"] { width:100% }
	table.mensetsu-tb { margin: 10px 0; border-top: 1px solid #ccc;}
	div.maindiv { margin: 10px 10px 0 10px; }
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="rslListSet" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<div class="maindiv">
<INPUT TYPE="hidden" NAME="act" VALUE="select">
<INPUT TYPE="hidden" NAME="allCountUseSave" VALUE="<%= lngAllCount %>">
<INPUT TYPE="hidden" NAME="startPosUseSave" VALUE="<%= lngStartPos %>">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">���[�N�V�[�g�`���̌��ʓ���</FONT></B></TD>
	</TR>
</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		'�ۑ��������́u�ۑ������v�̒ʒm
		If strAction = "saveend" Then
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
		<TR>
			<TD>��f���F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("month", 1, 12, lngMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("day", 1, 31, lngDay, False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
		<TR>
			<TD><%= EditGrpIList_GrpDiv("grpCd", strGrpCd, "", "", "") %></TD>
			<TD>�̌��ʂ�</TD>
			<TD><%= EditSortKeyList("sortkey", strSortKey) %></TD>
			<TD>�ԍ�</TD>
			<TD><INPUT TYPE="text" NAME="dayIdF" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" VALUE="<%= strDayIdF %>"></TD>
			<TD>����</TD>
			<TD><%= EditRslPageMaxLineList("getCount", strGetCount) %></TD>
			<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="javascript:goNextPage();return false;"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></A></TD>
		</TR>
	</TABLE>

	<BR>
<%
	Call EditRslList
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="180">
		<TR>
<%
			Call EditNavi()

			If lngUpdItemCount > 0 Then
%>
				<TD>
				<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
	           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  	
					<A HREF="javascript:saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
				<%  else    %>
					 &nbsp;
				<%  end if  %>
				<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
				</TD>
<%
			End If
%>
		</TR>
	</TABLE>
</div>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
