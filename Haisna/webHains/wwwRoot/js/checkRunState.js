// 当処理はIE11対応における以下問題に対する対処として作成された
// （ブラウザの戻るをクリックされた場合、hiddenがそのままで名称がクリアされてしまう）
// よって、印刷プレビューからブラウザの戻るで画面に戻ってきた場合、初期画面をReloadする

// 処理ステータスをrunに変更
function setRunState() {
//	alert(document.entryForm.runstate.value);
	document.entryForm.runstate.value = 'run';
}

// 処理ステータスをチェックし、runの場合自分自身をreloadする
function checkRunState() {
//	alert(document.entryForm.runstate.value);
	if (document.entryForm.runstate.value == 'run') {
		location.reload(true);
	}
}
