var focusController = {

	// 要素集合から指定要素を検索し、そのインデックスを返す
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

	// 結果入力項目カーソル移動（詳細表示用・縦移動）
	portraitFocusMoveForDetail: function(target)
	{
		var fields = ['result', 'rslCmtCd1', 'rslCmtCd2'];

		// 現要素のname属性値を検索
		var fieldIndex = fields.indexOf(target.name);
		if ( fieldIndex < 0 ) {
			return;
		}

		// 検索したname属性値を持つ全要素を検索
		var elements = document.querySelectorAll('[name="' + fields[fieldIndex] + '"]');
		if ( elements.length <= 0 ) {
			return;
		}

		// 検索結果から現要素を検索
		var position = this.getPosition(elements, target);
		if ( position < 0 ) {
			return;
		}

		var nextElement;

		while ( true ) {

			// 1つ次の要素へ
			position++;

			// 最終要素まで到達していない場合
			if ( position < elements.length ) {

				// hidden要素の場合は再検索
				if ( elements[position].type == 'hidden' ) {
					continue;
				}

				// hidden要素でなければ確定
				nextElement = elements[position];
				break;

			}

			// 最終要素まで到達した場合
			while ( true ) {
			
				// 次のname属性値で検索へ
				fieldIndex++;

				// 最終の属性値であれば先頭の値を使用
				if ( fieldIndex >= fields.length ) {
					fieldIndex = 0;
				}

				// 属性値による検索
				var nextElements = document.querySelectorAll('[name="' + fields[fieldIndex] + '"]');

				// 存在しない場合は更に次の属性値で再検索
				if ( nextElements.length <= 0 ) {
					continue;
				}

				// 要素を先頭から検索し、最初に現れるhidden要素以外の要素を得る
				for ( var i = 0; i < nextElements.length; i++ ) {
					if ( nextElements[i].type != 'hidden' ) {
						nextElement = nextElements[i];
						break;
					}
				}

				// 要素が得られない場合は更に次の属性値で再検索
				if ( !nextElement ) {
					continue;
				}

				break;

			}
			
			break;

		}

		return nextElement;
	},

	// 結果入力項目カーソル移動（詳細表示用・横移動）
	landscapeFocusMoveForDetail: function(target)
	{
		// 検査結果、結果コメント要素のセレクタ検索
		var elements = document.querySelectorAll('[name="result"], [name="rslCmtCd1"], [name="rslCmtCd2"]');
		if ( elements.length <= 0 ) {
			return;
		}

		// 検索結果から現要素を検索
		var position = this.getPosition(elements, target);
		if ( position < 0 ) {
			return;
		}

		// 次要素の検索
		while ( true ) {

			// 1つ後の要素へ
			position++;

			// 最終要素に到達した場合は先頭に戻る
			if ( position >= elements.length ) {
				position = 0;
			}

			// hidden要素の場合は再検索
			if ( elements[position].type == 'hidden' ) {
				continue;
			}

			break;

		}

		return elements[position];
	},

	// 結果入力項目カーソル移動（略式表示用・縦移動）
	portraitFocusMoveForSimple: function(target)
	{
		// 検査結果要素のセレクタ検索
		var elements = document.querySelectorAll('[name="result"]');
		if ( elements.length <= 0 ) {
			return;
		}

		// 検索結果から現要素を検索
		var position = this.getPosition(elements, target);
		if ( position < 0 ) {
			return;
		}

		while ( true ) {

			// 1行当たりの検査項目数分移動することで縦移動させる
			position += 3;

			// 最終要素に到達した場合
			if ( position >= elements.length ) {

				// 次列の先頭へ移動
				position = position % 3 + 1;

				// 最終列に到達した場合は先頭列に移動
				if ( position >= 3 ) {
					position = 0;
				}

			}

			if ( !elements[position] ) {
				return;
			}

			// hidden要素の場合は再検索
			if ( elements[position].type == 'hidden' ) {
				continue;
			}

			break;
		}

		return elements[position];
	},

	// 結果入力項目カーソル移動（略式表示用・横移動）
	landscapeFocusMoveForSimple: function(target)
	{
		// 検査結果要素のセレクタ検索
		var elements = document.querySelectorAll('[name="result"]');
		if ( elements.length <= 0 ) {
			return;
		}

		// 検索結果から現要素を検索
		var position = this.getPosition(elements, target);
		if ( position < 0 ) {
			return;
		}

		// 次要素の検索
		while ( true ) {

			// 1つ後の要素へ
			position++;

			// 最終要素に到達した場合は先頭に戻る
			if ( position >= elements.length ) {
				position = 0;
			}

			// hidden要素の場合は再検索
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
	// Enterキー押下以外は何もしない
	if ( event.which != 13 ) {
		return;
	}

	var method;

	// 表示、移動モードごとに呼び出すメソッドを指定
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

	// メソッドを呼び、得られた要素へフォーカスを移動
	var element = focusController[method](event.target);
	if ( element ) {
		element.focus();
	}
};
