<%
'-----------------------------------------------------------------------------
'		所見選択 Include File (Ver0.0.1)
'		AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
%>
<!--
var winSentence;						// 所見選択ウィンドウハンドル
var winMemo;							// メモ入力ウィンドウハンドル

var SameLineno = new Array();			// 同じ検査項目の行番号
var SameStccd = new Array();			// 同じ検査項目の文章コード
var SameCount;							// 同じ検査項目数

//所見選択画面呼び出し
function callSentence(lineno) {
	var url;							// URL文字列
	var opened = false;					// 画面がすでに開かれているか
	var i								// インデックス

	// 同じ検査項目の検索
	SameCount = 0;
	if ( document.entryForm.itemcd.length != null ) {
		for( i=0; i<document.entryForm.itemcd.length; i++ ) {
			if( document.entryForm.hisno[i].value != '1' ) break;
			if( document.entryForm.updflg[i].value == '-1' ) continue;

			if( document.entryForm.rsvno1[lineno].value == document.entryForm.rsvno1[i].value &&
				document.entryForm.itemcd[lineno].value == document.entryForm.itemcd[i].value &&
				document.entryForm.itemtype[lineno].value == document.entryForm.itemtype[i].value ) {
				SameLineno.length ++ ;
				SameLineno[SameCount] = i;
				SameStccd[SameCount] = document.entryForm.stccd[i].value;
				SameCount++;
			}
		}
	}

	url = '/WebHains/contents/interview/Sentence.asp';
	url = url + '?lineno=' + lineno;
	if ( document.entryForm.itemcd.length != null ) {
		url = url + '&itemcd=' + document.entryForm.itemcd[lineno].value;
		url = url + '&suffix=' + document.entryForm.suffix[lineno].value;
		url = url + '&itemtype=' + document.entryForm.itemtype[lineno].value;
	} else {
		url = url + '&itemcd=' + document.entryForm.itemcd.value;
		url = url + '&suffix=' + document.entryForm.suffix.value;
		url = url + '&itemtype=' + document.entryForm.itemtype.value;
	}
	if ( document.getElementById( 'itemname' + lineno ) ) {
		url = url + '&itemname=' + document.getElementById( 'itemname' + lineno ).innerHTML;
	}
	if( SameCount > 0 ) {
		url = url + '&stccd=' + SameStccd[0]
		for( i=1; i<SameCount; i++ ) {
			url = url + ',' + SameStccd[i];
		}
	}

	// すでにガイドが開かれているかチェック
	if ( winSentence != null ) {
		if ( !winSentence.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winSentence.focus();
		winSentence.location.replace( url );
	} else {
		winSentence = window.open( url, '', 'width=500,height=600,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
	}

}

//メモ入力画面呼び出し
function callMemo(lineno) {
	var url;							// URL文字列
	var opened = false;					// 画面がすでに開かれているか
	var i								// インデックス

	url = '/WebHains/contents/interview/Memo.asp';
	url = url + '?lineno=' + lineno;
	if ( document.entryForm.itemcd.length != null ) {
		url = url + '&itemcd=' + document.entryForm.itemcd[lineno].value;
		url = url + '&suffix=' + document.entryForm.suffix[lineno].value;
		url = url + '&itemtype=' + document.entryForm.itemtype[lineno].value;
		url = url + '&result=' + document.entryForm.result[lineno].value;
	} else {
		url = url + '&itemcd=' + document.entryForm.itemcd.value;
		url = url + '&suffix=' + document.entryForm.suffix.value;
		url = url + '&itemtype=' + document.entryForm.itemtype.value;
		url = url + '&result=' + document.entryForm.result.value;
	}
	if ( document.getElementById( 'itemname' + lineno ) ) {
		url = url + '&itemname=' + document.getElementById( 'itemname' + lineno ).innerHTML;
	}

	// すでにガイドが開かれているかチェック
	if ( winMemo != null ) {
		if ( !winMemo.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winMemo.focus();
		winMemo.location.replace( url );
	} else {
		winMemo = window.open( url, '', 'width=500,height=300,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
	}

}

// サブ画面を閉じる
function closeWindow() {

	// 所見選択画面を閉じる
	if ( winSentence != null ) {
		if ( !winSentence.closed ) {
			winSentence.close();
		}
	}

	winSentence  = null;
}


// 所見情報のセット
function setSentenceInfo(lineno, stccd, sentence) {

	// 所見
	if ( document.entryForm.stccd.length != null ) {
		document.entryForm.stccd[lineno].value = stccd
	} else {
		document.entryForm.stccd.value = stccd
	}
	if ( document.getElementById( 'sentence' + lineno ) ) {
		document.getElementById( 'sentence' + lineno ).innerHTML = sentence;
	}
	// 更新フラグ
	if ( document.entryForm.updflg.length != null ) {
		document.entryForm.updflg[lineno].value = "1"
	} else {
		document.entryForm.updflg.value = "1"
	}
}

// 所見情報のクリア
function clearSentenceInfo(lineno) {

	// 所見
	if ( document.entryForm.stccd.length != null ) {
		document.entryForm.stccd[lineno].value = ""
	} else {
		document.entryForm.stccd.value = ""
	}
	if ( document.getElementById( 'sentence' + lineno ) ) {
		document.getElementById( 'sentence' + lineno ).innerHTML = '&nbsp;';
	}
	// 更新フラグ
	if ( document.entryForm.updflg.length != null ) {
		document.entryForm.updflg[lineno].value = "1"
	} else {
		document.entryForm.updflg.value = "1"
	}
}

// 所見情報の前詰め
function sortSentenceInfo() {
	var myForm = document.entryForm;
	var EmptyLine;
	var i, j;							// インデックス

	if ( myForm.itemcd == null ) rerurn;

	// 修正された検査項目の検索
	if ( myForm.itemcd.length != null ) {
		for( i=0; i<myForm.itemcd.length; i++ ) {
			if( myForm.hisno[i].value != '1' ) break;
			if( myForm.updflg[i].value == '-1' ) continue;
			if( myForm.stccd[i].value == '' ) continue;

			// 同じ検査項目で空白行を検索
			EmptyLine = -1;
			for( j=i-1; j>=0; j-- ) {
				if( myForm.rsvno1[i].value == myForm.rsvno1[j].value &&
					myForm.itemcd[i].value == myForm.itemcd[j].value &&
					myForm.itemtype[i].value == myForm.itemtype[j].value ) {
					if( myForm.updflg[j].value == '-1' ) continue;
					if( myForm.stccd[j].value == '' ) {
						EmptyLine = j;
					}
				}
			}
			// 空白行あり？
			if ( EmptyLine >= 0 ) {
				// 移動先
				myForm.stccd[EmptyLine].value = myForm.stccd[i].value;
				myForm.updflg[EmptyLine].value = "1";
				// 移動元
				myForm.stccd[i].value = '';
				myForm.updflg[i].value = '1';
			}
		}
	}
}
//-->
