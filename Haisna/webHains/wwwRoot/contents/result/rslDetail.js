var focusController = {

	// �v�f�W������w��v�f���������A���̃C���f�b�N�X��Ԃ�
	getPosition: function(elements, target)
	{
		var ret = -1;
		for ( var i = 0; i < elements.length; i++ ) {
			if ( elements[i] == target ) {
				ret = i;
				break;
			}
		}

		return ret;
	},

	// ���ʓ��͍��ڃJ�[�\���ړ��i�ڍו\���p�E�c�ړ��j
	portraitFocusMoveForDetail: function(target)
	{
		var fields = ['result', 'rslCmtCd1', 'rslCmtCd2'];

		// ���v�f��name�����l������
		var fieldIndex = fields.indexOf(target.name);
		if ( fieldIndex < 0 ) {
			return;
		}

		// ��������name�����l�����S�v�f������
		var elements = document.querySelectorAll('[name="' + fields[fieldIndex] + '"]');
		if ( elements.length <= 0 ) {
			return;
		}

		// �������ʂ��猻�v�f������
		var position = this.getPosition(elements, target);
		if ( position < 0 ) {
			return;
		}

		var nextElement;

		while ( true ) {

			// 1���̗v�f��
			position++;

			// �ŏI�v�f�܂œ��B���Ă��Ȃ��ꍇ
			if ( position < elements.length ) {

				// hidden�v�f�̏ꍇ�͍Č���
				if ( elements[position].type == 'hidden' ) {
					continue;
				}

				// hidden�v�f�łȂ���Ίm��
				nextElement = elements[position];
				break;

			}

			// �ŏI�v�f�܂œ��B�����ꍇ
			while ( true ) {
			
				// ����name�����l�Ō�����
				fieldIndex++;

				// �ŏI�̑����l�ł���ΐ擪�̒l���g�p
				if ( fieldIndex >= fields.length ) {
					fieldIndex = 0;
				}

				// �����l�ɂ�錟��
				var nextElements = document.querySelectorAll('[name="' + fields[fieldIndex] + '"]');

				// ���݂��Ȃ��ꍇ�͍X�Ɏ��̑����l�ōČ���
				if ( nextElements.length <= 0 ) {
					continue;
				}

				// �v�f��擪���猟�����A�ŏ��Ɍ����hidden�v�f�ȊO�̗v�f�𓾂�
				for ( var i = 0; i < nextElements.length; i++ ) {
					if ( nextElements[i].type != 'hidden' ) {
						nextElement = nextElements[i];
						break;
					}
				}

				// �v�f�������Ȃ��ꍇ�͍X�Ɏ��̑����l�ōČ���
				if ( !nextElement ) {
					continue;
				}

				break;

			}
			
			break;

		}

		return nextElement;
	},

	// ���ʓ��͍��ڃJ�[�\���ړ��i�ڍו\���p�E���ړ��j
	landscapeFocusMoveForDetail: function(target)
	{
		// �������ʁA���ʃR�����g�v�f�̃Z���N�^����
		var elements = document.querySelectorAll('[name="result"], [name="rslCmtCd1"], [name="rslCmtCd2"]');
		if ( elements.length <= 0 ) {
			return;
		}

		// �������ʂ��猻�v�f������
		var position = this.getPosition(elements, target);
		if ( position < 0 ) {
			return;
		}

		// ���v�f�̌���
		while ( true ) {

			// 1��̗v�f��
			position++;

			// �ŏI�v�f�ɓ��B�����ꍇ�͐擪�ɖ߂�
			if ( position >= elements.length ) {
				position = 0;
			}

			// hidden�v�f�̏ꍇ�͍Č���
			if ( elements[position].type == 'hidden' ) {
				continue;
			}

			break;

		}

		return elements[position];
	},

	// ���ʓ��͍��ڃJ�[�\���ړ��i�����\���p�E�c�ړ��j
	portraitFocusMoveForSimple: function(target)
	{
		// �������ʗv�f�̃Z���N�^����
		var elements = document.querySelectorAll('[name="result"]');
		if ( elements.length <= 0 ) {
			return;
		}

		// �������ʂ��猻�v�f������
		var position = this.getPosition(elements, target);
		if ( position < 0 ) {
			return;
		}

		while ( true ) {

			// 1�s������̌������ڐ����ړ����邱�Ƃŏc�ړ�������
			position += 3;

			// �ŏI�v�f�ɓ��B�����ꍇ
			if ( position >= elements.length ) {

				// ����̐擪�ֈړ�
				position = position % 3 + 1;

				// �ŏI��ɓ��B�����ꍇ�͐擪��Ɉړ�
				if ( position >= 3 ) {
					position = 0;
				}

			}

			if ( !elements[position] ) {
				return;
			}

			// hidden�v�f�̏ꍇ�͍Č���
			if ( elements[position].type == 'hidden' ) {
				continue;
			}

			break;
		}

		return elements[position];
	},

	// ���ʓ��͍��ڃJ�[�\���ړ��i�����\���p�E���ړ��j
	landscapeFocusMoveForSimple: function(target)
	{
		// �������ʗv�f�̃Z���N�^����
		var elements = document.querySelectorAll('[name="result"]');
		if ( elements.length <= 0 ) {
			return;
		}

		// �������ʂ��猻�v�f������
		var position = this.getPosition(elements, target);
		if ( position < 0 ) {
			return;
		}

		// ���v�f�̌���
		while ( true ) {

			// 1��̗v�f��
			position++;

			// �ŏI�v�f�ɓ��B�����ꍇ�͐擪�ɖ߂�
			if ( position >= elements.length ) {
				position = 0;
			}

			// hidden�v�f�̏ꍇ�͍Č���
			if ( elements[position].type == 'hidden' ) {
				continue;
			}

			break;

		}

		return elements[position];
	}
};

document.onkeypress = function(event)
{
	// Enter�L�[�����ȊO�͉������Ȃ�
	if ( event.which != 13 ) {
		return;
	}

	var method;

	// �\���A�ړ����[�h���ƂɌĂяo�����\�b�h���w��
	switch ( document.resultList.orientation.value ) {
		case document.resultList.portrait.value:
			method = ( document.resultList.dispMode.value == 'detail' ) ? 'landscapeFocusMoveForDetail' : 'portraitFocusMoveForSimple';
			break;
		case document.resultList.landscape.value:
			method = ( document.resultList.dispMode.value == 'detail' ) ? 'portraitFocusMoveForDetail' : 'landscapeFocusMoveForSimple';
			break;
	}

	if ( !method ) {
		return;
	}

	// ���\�b�h���ĂсA����ꂽ�v�f�փt�H�[�J�X���ړ�
	var element = focusController[method](event.target);
	if ( element ) {
		element.focus();
	}
};
