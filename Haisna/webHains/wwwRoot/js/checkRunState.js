// ��������IE11�Ή��ɂ�����ȉ����ɑ΂���Ώ��Ƃ��č쐬���ꂽ
// �i�u���E�U�̖߂���N���b�N���ꂽ�ꍇ�Ahidden�����̂܂܂Ŗ��̂��N���A����Ă��܂��j
// ����āA����v���r���[����u���E�U�̖߂�ŉ�ʂɖ߂��Ă����ꍇ�A������ʂ�Reload����

// �����X�e�[�^�X��run�ɕύX
function setRunState() {
//	alert(document.entryForm.runstate.value);
	document.entryForm.runstate.value = 'run';
}

// �����X�e�[�^�X���`�F�b�N���Arun�̏ꍇ�������g��reload����
function checkRunState() {
//	alert(document.entryForm.runstate.value);
	if (document.entryForm.runstate.value == 'run') {
		location.reload(true);
	}
}
