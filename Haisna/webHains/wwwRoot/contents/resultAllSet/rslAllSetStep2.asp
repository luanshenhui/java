<%
'-----------------------------------------------------------------------------
'		���ʈꊇ����(�ꊇ���ʒl����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<%
'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'�E��
Const CLASS_ERROR     = "CLASS=""rslErr"""				'�G���[�\���̃N���X�w��

Dim objCourse			'�R�[�X�A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objGrp				'�O���[�v�A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strAction			'�������[�h

Dim lngItemCount		'�������ڐ�

Dim strArrItemCd()		'�ҏW�p�������ڃR�[�h
Dim strArrSuffix()		'�ҏW�p�T�t�B�b�N�X
Dim strArrItemName()	'�ҏW�p�������ږ���
Dim strArrResultType()	'�ҏW�p���ʃ^�C�v
Dim strArrItemType()	'�ҏW�p���ڃ^�C�v
Dim strArrResult()		'�ҏW�p��������
Dim strArrResultErr()	'�ҏW�p�������ʃG���[
Dim strArrShortStc()	'�ҏW�p���͗���
Dim lngArrPos()			'���ʔz��ʒu
Dim lngArraySize		'�z��T�C�Y

Dim strOldItemCd		'�ۑ��p�������ڃR�[�h
Dim strOldSuffix		'�ۑ��p�T�t�B�b�N�X
Dim strOldItemType		'�ۑ��p���ڃ^�C�v

Dim strElementName		'�G�������g��

Dim strAlignMent		'�\���ʒu
Dim strClass			'�X�^�C���V�[�g��CLASS�w��

Dim strCsName			'�R�[�X��
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objGrp = Server.CreateObject("HainsGrp.Grp")

'�����l�̎擾
strAction = Request("act")

'�ǂݍ��ݏ����̐���
Do

	'�u���ցv�u�ۑ��v�{�^���������ɂ����֔��ł����ꍇ�͉��炩�̃G���[���������Ă���ꍇ�Ȃ̂ŏ����𔲂���
	If strAction = "next" Or strAction = "save" Then
		Exit Do
	End If

	'�f�t�H���g�W�J��
	If strAction = "develop" Then

		'���ʏ����l��ݒ肷��
		lngItemCount = objGrp.SelectGrp_I_ItemDefResultList(mstrGrpCd, _
															mstrCslDate, _
															mstrItemCd, _
															mstrSuffix, _
															mstrItemName, _
															mstrResultType, _
															mstrItemType, _
															mstrResult, _
															mstrStcItemCd, _
															mstrShortStc)

		'���ʁE���͗��̂���ь��ʃ`�F�b�N�p�̔z��쐬
		If lngItemCount > 0 Then
			mstrResultErr = Array()
			ReDim Preserve mstrResultErr(lngItemCount - 1)
		End If

		Exit Do
	End If

	'�������ړǂݍ���
	lngItemCount = objGrp.SelectGrp_I_ItemList(mstrGrpCd, mstrItemCd, mstrSuffix, mstrItemName, mstrResultType, mstrItemType, mstrStcItemCd)
	If lngItemCount <= 0 Then
		mstrArrMessage("���̌����O���[�v�ɑ����錟�����ڂ͑��݂��܂���B")
		Exit Do
	End If

	'���ʁE���͗��̂���ь��ʃ`�F�b�N�p�̔z��쐬
	If lngItemCount > 0 Then
		mstrResult    = Array()
		mstrShortStc  = Array()
		mstrResultErr = Array()
		ReDim Preserve mstrResult(lngItemCount - 1)
		ReDim Preserve mstrShortStc(lngItemCount - 1)
		ReDim Preserve mstrResultErr(lngItemCount - 1)
	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ꊇ���ʒl����</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc" -->
<!-- #include virtual = "/webHains/includes/tseGuide.inc" -->
<!--
var lngSelectedIndex1;	// �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var lngSelectedIndex2;	// �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var lngSelectedIndex3;	// �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

// ���̓K�C�h�Ăяo��
function callStcGuide( index1, index2, index3 ) {

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���̓R�[�h�E�����͂̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex1 = index1;
	lngSelectedIndex2 = index2;
	lngSelectedIndex3 = index3;

	// �K�C�h��ʂ̘A����Ɍ������ڃR�[�h��ݒ肷��
	if ( document.step2.stcItemCd.length != null ) {
		stcGuide_ItemCd = document.step2.stcItemCd[ index1 ].value;
	} else {
		stcGuide_ItemCd = document.step2.stcItemCd.value;
	}

	// �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
	if ( document.step2.itemType.length != null ) {
		stcGuide_ItemType = document.step2.itemType[ index1 ].value;
	} else {
		stcGuide_ItemType = document.step2.itemType.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	stcGuide_CalledFunction = setStcInfo;

	// ���̓K�C�h�\��
	showGuideStc();
}

// ���̓R�[�h�E�����͂̃Z�b�g
function setStcInfo() {

	var stcNameElement;	// �����͂�ҏW����G�������g�̖���
	var stcName;		// �����͂�ҏW����G�������g���g

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( document.step2.result.length != null ) {
		document.step2.result[lngSelectedIndex1].value = stcGuide_StcCd;
	} else {
		document.step2.result.value = stcGuide_StcCd;
	}
	if ( document.step2.shortStc.length != null ) {
		document.step2.shortStc[lngSelectedIndex1].value = stcGuide_ShortStc;
	} else {
		document.step2.shortStc.value = stcGuide_ShortStc;
	}

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		stcNameElement = 'stcName_' + lngSelectedIndex2 + lngSelectedIndex3;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(stcNameElement).innerHTML = stcGuide_ShortStc;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(stcNameElement).innerHTML = stcGuide_ShortStc;
		}

		break;
	}

	return false;
}

// �萫�K�C�h�Ăяo��
function callTseGuide( index1 ) {

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(�������ʂ̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex1 = index1;

	// �K�C�h��ʂ̘A����Ɍ��ʃ^�C�v��ݒ肷��
	if ( document.step2.itemType.length != null ) {
		tseGuide_ResultType = document.step2.resultType[ index1 ].value;
	} else {
		tseGuide_ResultType = document.step2.resultType.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	tseGuide_CalledFunction = setTseInfo;

	// ���̓K�C�h�\��
	showGuideTse();
}

// �������ʂ̃Z�b�g
function setTseInfo() {

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( document.step2.result.length != null ) {
		document.step2.result[lngSelectedIndex1].value = tseGuide_Result;
	} else {
		document.step2.result.value = tseGuide_Result;
	}

	return false;
}

// �f�t�H���g�W�J����
function goDevelopment() {

	document.step2.act.value   = 'develop';
	document.step2.grpCd.value = '<%= mstrGrpCd %>';
	document.step2.submit();

}

// �X�e�b�v�P�ɖ߂�
function goStep1() {

	var myForm = document.step2;	// ����ʂ̃t�H�[���G�������g

	// ���݂̕ێ����e���̂܂܂ɁA�X�e�b�v�ԍ��݂̂�ύX����submit
	myForm.step.value = '1';
	myForm.submit();

}

// submit����
function submitForm( act ) {

	// �ۑ����̂݊m�F��ʂ�\��
	if ( act == 'save' ) {
		if ( !confirm('���̓��e�Ō������ʂ̈ꊇ�o�^���s���܂��B��낵���ł����H') ) {
			return;
		}
	}

	document.step2.act.value = act;

	// �f�t�H���g�W�J���̓O���[�v�R�[�h���w�肷��
	if ( act == 'develop' ) {
		document.step2.grpCd.value = '<%= mstrGrpCd %>';
	}

	document.step2.submit();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsltab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step2" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
	'�������g�̃X�e�b�v�ԍ���ێ����A����p��ASP�Ŏg�p����
%>
	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<INPUT TYPE="hidden" NAME="act"  VALUE="">

	<!-- Step1����̈����p����� -->

	<INPUT TYPE="hidden" NAME="year"   VALUE="<%= mlngYear   %>">
	<INPUT TYPE="hidden" NAME="month"  VALUE="<%= mlngMonth  %>">
	<INPUT TYPE="hidden" NAME="day"    VALUE="<%= mlngDay    %>">
	<INPUT TYPE="hidden" NAME="csCd"   VALUE="<%= mstrCsCd   %>">
	<INPUT TYPE="hidden" NAME="dayIdF" VALUE="<%= mstrDayIdF %>">
	<INPUT TYPE="hidden" NAME="dayIdT" VALUE="<%= mstrDayIdT %>">

	<BLOCKQUOTE>

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">Step2�F�ꊇ���ēo�^���錋�ʒl����͂��Ă��������B</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If Not IsEmpty(strArrMessage) Then

		'�G���[���b�Z�[�W�ҏW
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><FONT COLOR="#ff6600"><B><%= mlngYear & "/" & Right("00" & mlngMonth, 2) & "/" & Right("00" & mlngDay, 2) %></B></FONT></TD>
			<TD NOWRAP>&nbsp;&nbsp;�R�[�X</TD>
			<TD>�F</TD>
<%
			'�R�[�X���̓ǂݍ���
			If mstrCsCd <> "" Then
				Set objCourse = Server.CreateObject("HainsCourse.Course")
				If objCourse.SelectCourse(mstrCsCd, strCsName) = False Then
					Err.Raise 1000, , "�R�[�X��񂪑��݂��܂���B"
				End If
				Set objCourse = Nothing
			Else
				strCsName = "�S�ẴR�[�X"
			End If
%>
			<TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
			<TD NOWRAP>&nbsp;&nbsp;�����h�c</TD>
			<TD>�F</TD>
			<TD><FONT COLOR="#ff6600"><B><%= IIf(mstrDayIdF <> "" Or mstrDayIdT <> "", mstrDayIdF & IIf(mstrDayIdT <> "", "�`", "") & mstrDayIdT, "���ׂ�") %></B></FONT></TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD>���͌��ʃO���[�v�F</TD>
			<TD><%= EditGrpIList_GrpDiv("grpCd", mstrGrpCd, "", "", ADD_NONE) %></TD>
			<TD>��</TD>
			<TD><A HREF="javascript:submitForm('')"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="���͗p�������ڃZ�b�g��ύX���ĕ\��"></A></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="650">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="allResultClear" VALUE="1"<%= IIf(mstrAllResultClear = "1", " CHECKED", "") %>>���̃O���[�v�̌������ʂ�S�ăN���A����</TD>
			<TD ALIGN="RIGHT">
				<A HREF="JavaScript:submitForm('develop')"><IMG SRC="/webHains/images/default.gif" WIDTH="110" HEIGHT="24" ALT="�f�t�H���g�l��W�J���܂��B"></A>
			</TD>
		</TR>
	</TABLE>
	<BR>
<%
	'�z���\���p�ɍĕҏW
	For mlngIndex1 = 0 To UBound(mstrItemCd)

		'�ŏ��̏���
		If strOldItemCd = "" Then

			'�ҏW�p�z��쐬
			ReDim strArrItemCd(1, lngArraySize)
			ReDim strArrSuffix(1, lngArraySize)
			ReDim strArrItemName(lngArraySize)
			ReDim strArrResultType(1, lngArraySize)
			ReDim strArrItemType(1, lngArraySize)
			ReDim strArrResult(1, lngArraySize)
			ReDim strArrResultErr(1, lngArraySize)
			ReDim strArrShortStc(1, lngArraySize)
			ReDim lngArrPos(1, lngArraySize)
			lngArraySize = lngArraySize + 1

			'�������ڕۑ�
			strOldItemCd   = mstrItemCd(mlngIndex1)
			strOldItemType = mstrItemType(mlngIndex1)

			'���ʂ̏ꍇ
			If CStr(mstrItemType(mlngIndex1)) = CStr(ITEMTYPE_BUI) Then

				strArrItemCd(0, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
				strArrSuffix(0, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
				strArrResultType(0, lngArraySize - 1) = mstrResultType(mlngIndex1)
				strArrItemType(0, lngArraySize - 1)   = mstrItemType(mlngIndex1)
				strArrResult(0, lngArraySize - 1)     = mstrResult(mlngIndex1)
				strArrResultErr(0, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
				strArrShortStc(0, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
				lngArrPos(0, lngArraySize -1)         = mlngIndex1

			'���ʈȊO�̏ꍇ
			Else

				strArrItemCd(1, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
				strArrSuffix(1, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
				strArrResultType(1, lngArraySize - 1) = mstrResultType(mlngIndex1)
				strArrItemType(1, lngArraySize - 1)   = mstrItemType(mlngIndex1)
				strArrResult(1, lngArraySize - 1)     = mstrResult(mlngIndex1)
				strArrResultErr(1, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
				strArrShortStc(1, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
				lngArrPos(1, lngArraySize -1)         = mlngIndex1

			End If

			strArrItemName(lngArraySize - 1) = mstrItemName(mlngIndex1)

		Else

			'�O���ڂƍ��ڃR�[�h����v���A�O���ڃ^�C�v���h���ʁh�ō����ڃ^�C�v���h�����h�̏ꍇ
			If strOldItemCd = mstrItemCd(mlngIndex1) And CStr(strOldItemType) = CStr(ITEMTYPE_BUI) And CStr(mstrItemType(mlngIndex1)) = CStr(ITEMTYPE_SHOKEN) Then

				strArrItemCd(1, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
				strArrSuffix(1, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
				strArrResultType(1, lngArraySize - 1) = mstrResultType(mlngIndex1)
				strArrItemType(1, lngArraySize - 1)   = mstrItemType(mlngIndex1)
				strArrResult(1, lngArraySize - 1)     = mstrResult(mlngIndex1)
				strArrResultErr(1, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
				strArrShortStc(1, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
				lngArrPos(1, lngArraySize -1)         = mlngIndex1
				strArrItemName(lngArraySize - 1)      = mstrItemName(mlngIndex1)

			Else

				'�ҏW�p�z��쐬
				ReDim Preserve strArrItemCd(1, lngArraySize)
				ReDim Preserve strArrSuffix(1, lngArraySize)
				ReDim Preserve strArrItemName(lngArraySize)
				ReDim Preserve strArrResultType(1, lngArraySize)
				ReDim Preserve strArrItemType(1, lngArraySize)
				ReDim Preserve strArrResult(1, lngArraySize)
				ReDim Preserve strArrResultErr(1, lngArraySize)
				ReDim Preserve strArrShortStc(1, lngArraySize)
				ReDim Preserve lngArrPos(1, lngArraySize)
				lngArraySize = lngArraySize + 1

				'���ʂ̏ꍇ
				If CStr(mstrItemType(mlngIndex1)) = CStr(ITEMTYPE_BUI) Then
					strArrItemCd(0, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
					strArrSuffix(0, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
					strArrResultType(0, lngArraySize - 1) = mstrResultType(mlngIndex1)
					strArrItemType(0, lngArraySize - 1)   = mstrItemType(mlngIndex1)
					strArrResult(0, lngArraySize - 1)     = mstrResult(mlngIndex1)
					strArrResultErr(0, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
					strArrShortStc(0, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
					lngArrPos(0, lngArraySize -1)         = mlngIndex1

				'���ʈȊO�̏ꍇ
				Else
					strArrItemCd(1, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
					strArrSuffix(1, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
					strArrResultType(1, lngArraySize - 1) = mstrResultType(mlngIndex1)
					strArrItemType(1, lngArraySize - 1)   = mstrItemType(mlngIndex1)
					strArrResult(1, lngArraySize - 1)     = mstrResult(mlngIndex1)
					strArrResultErr(1, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
					strArrShortStc(1, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
					lngArrPos(1, lngArraySize -1)         = mlngIndex1

				End If

				strArrItemName(lngArraySize - 1) = mstrItemName(mlngIndex1)

			End If

			'�������ڕۑ�
			strOldItemCd   = mstrItemCd(mlngIndex1)
			strOldItemType = mstrItemType(mlngIndex1)

		End If

	Next

	For mlngIndex1 = 0 To UBound(mstrItemCd)
%>
		<INPUT TYPE="hidden" NAME="itemCd"     VALUE="<%= mstrItemCd(mlngIndex1)     %>">
		<INPUT TYPE="hidden" NAME="suffix"     VALUE="<%= mstrSuffix(mlngIndex1)     %>">
		<INPUT TYPE="hidden" NAME="itemName"   VALUE="<%= mstrItemName(mlngIndex1)   %>">
		<INPUT TYPE="hidden" NAME="resultType" VALUE="<%= mstrResultType(mlngIndex1) %>">
		<INPUT TYPE="hidden" NAME="itemType"   VALUE="<%= mstrItemType(mlngIndex1)   %>">
		<INPUT TYPE="hidden" NAME="resultErr"  VALUE="<%= mstrResultErr(mlngIndex1)  %>">
		<INPUT TYPE="hidden" NAME="stcItemCd"  VALUE="<%= mstrStcItemCd(mlngIndex1)  %>">
		<INPUT TYPE="hidden" NAME="shortStc"   VALUE="<%= mstrShortStc(mlngIndex1)   %>">
<%
	Next
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="110" BGCOLOR="#eeeeee" ALIGN="right"><B>�������ږ�</B></TD>
			<TD WIDTH="100" COLSPAN="2"><B>����</B></TD>
			<TD WIDTH="100" COLSPAN="2"><B>����</B></TD>
			<TD><B>���ʕ���</B></TD>
			<TD><B>��������</B></TD>
		</TR>
<%
		For mlngIndex1 = 0 To lngArraySize - 1
%>
			<TR>
				<TD WIDTH="110" NOWRAP ALIGN="right"><%= strArrItemName(mlngIndex1) %></TD>
<%
				'�K�C�h�{�^���̕ҏW
				If strArrItemCd(0, mlngIndex1) <> "" Then

					'���ʌ��ʃK�C�h�{�^���̕ҏW
					Select Case strArrResultType(0, mlngIndex1)

						Case CStr(RESULTTYPE_SENTENCE)
%>
							<TD><A HREF="JavaScript:callStcGuide('<%= lngArrPos(0, mlngIndex1) %>','0','<%= mlngIndex1 %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ʃK�C�h�\��"></A></TD>
<%
						Case CStr(RESULTTYPE_TEISEI1), CStr(RESULTTYPE_TEISEI2)
%>
							<TD><A HREF="JavaScript:callTseGuide('<%= lngArrPos(0, mlngIndex1) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�萫�K�C�h�\��"></A></TD>
<%
						Case Else
%>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="21"></TD>
<%
					End Select

				Else
%>
					<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="21"></TD>
<%
				End If

				'���ʂ̕ҏW
				If strArrItemCd(0, mlngIndex1) <> "" Then

					If strArrResultType(0, mlngIndex1) = CStr(RESULTTYPE_CALC) Then
%>
						<TD><INPUT TYPE="hidden" NAME="result" VALUE="<%= strArrResult(0, mlngIndex1) %>"></TD>
<%
					Else

						'�X�^�C���V�[�g�̐ݒ�
						strAlignment = IIf(CLng(strArrResultType(0, mlngIndex1)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
						strClass     = IIf(strArrResultErr(0, mlngIndex1) <> "", CLASS_ERROR, "")
%>
						<TD><INPUT TYPE="text" NAME="result" SIZE="10" MAXLENGTH="8" VALUE="<%= strArrResult(0, mlngIndex1) %>" <%= strAlignment %> <%= strClass %>></TD>
<%
					End If

				Else
%>
					<TD></TD>
<%
				End If

				'�������ʃK�C�h�{�^���̕ҏW
				Select Case strArrResultType(1, mlngIndex1)

					Case CStr(RESULTTYPE_SENTENCE)
%>
						<TD><A HREF="JavaScript:callStcGuide('<%= lngArrPos(1, mlngIndex1) %>','1','<%= CStr(mlngIndex1) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ʃK�C�h�\��"></A></TD>
<%
					Case CStr(RESULTTYPE_TEISEI1), CStr(RESULTTYPE_TEISEI2)
%>
						<TD><A HREF="JavaScript:callTseGuide('<%= lngArrPos(1, mlngIndex1) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�萫�K�C�h�\��"></A></TD>
<%
					Case Else
%>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="21"></TD>
<%
				End Select

				'�������ʂ̕ҏW
				If strArrItemCd(1, mlngIndex1) <> "" Then

					If CStr(strArrResultType(1, mlngIndex1)) = CStr(RESULTTYPE_CALC) Then
%>
						<TD><INPUT TYPE="hidden" NAME="result" VALUE="<%= strArrResult(1, mlngIndex1) %>"></TD>
<%
					Else

						'�X�^�C���V�[�g�̐ݒ�
						strAlignment = IIf(CLng(strArrResultType(1, mlngIndex1)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
						strClass     = IIf(strArrResultErr(1, mlngIndex1) <> "", CLASS_ERROR, "")
%>
						<TD><INPUT TYPE="text" NAME="result" SIZE="10" MAXLENGTH="8" VALUE="<%= strArrResult(1, mlngIndex1) %>" <%= strAlignment %> <%= strClass %>></TD>
<%
					End If

				Else
%>
					<TD></TD>
<%
				End If

				strElementName = "stcName_0" & mlngIndex1
%>
				<TD WIDTH="181" NOWRAP><SPAN ID="<%= strElementName %>" STYLE="position:relative"><%= strArrShortStc(0, mlngIndex1) %></SPAN></TD>
<%
				strElementName = "stcName_1" & mlngIndex1
%>
				<TD WIDTH="181" NOWRAP><SPAN ID="<%= strElementName %>" STYLE="position:relative"><%= strArrShortStc(1, mlngIndex1) %></SPAN></TD>
			</TR>
<%
		Next
%>
	</TABLE>

	<BR>

	<A HREF="javascript:goStep1()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	    <A HREF="javascript:submitForm('save')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
    <%  end if  %>
	<BR><BR>
	
	<A HREF="javascript:submitForm('next')"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
