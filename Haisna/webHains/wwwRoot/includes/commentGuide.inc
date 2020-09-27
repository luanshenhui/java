<%
'-----------------------------------------------------------------------------
'		コメントガイド Include File (Ver0.0.1)
'		AUTHER  : K.Fujii@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// ガイド画面との連絡域
var cmtGuide_varSelCmtCd = new Array();		//選択されたコメントコード
var cmtGuide_varSelCmtStc = new Array();	//選択されたコメント文章
var cmtGuide_varSelClassCd = new Array();	//選択された判定分類コード
var cmtGuide_CalledFunction;				//親画面の関数名

var cmtGuide_editcnt;						//親画面に表示されているコメントの数
var cmtGuide_varEditCmtCd;					//親画面に表示されているコメントコード（複数の場合配列）

var winAdviceComment;			// ウィンドウハンドル
// コメントガイド画面を表示
// ### 2004/11/12 Add by Gouda@FSIT 生活指導コメントの表示分類
//function cmtGuide_showAdviceComment( judclasscd, functionName ) {
function cmtGuide_showAdviceComment( judclasscd, functionName, recogLevel) {
// ### 2004/11/12 Add End

    var url;			// URL文字列
    var opened = false;	// 画面がすでに開かれているか

    var i;


    // ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
    cmtGuide_CalledFunction = functionName;

    // すでにガイドが開かれているかチェック
    if ( winAdviceComment != null ) {
        if ( !winAdviceComment.closed ) {
            opened = true;
        }
    }
//2008/03/18　特定検診階層化コメントの表示分類のため追加
    if ( judclasscd == 90 ) {
        url = '/WebHains/contents/guide/gdeStepComment.asp?judClassCd=' + judclasscd;
        url = url + '&selCmtCnt=' + cmtGuide_editcnt;
//2008/03/18　追加END
    } else {    
        url = '/WebHains/contents/guide/gdeAdviceComment.asp?judClassCd=' + judclasscd;
        url = url + '&selCmtCnt=' + cmtGuide_editcnt;
    }
    
    for( i = 0; i < cmtGuide_editcnt; i++ ){
        if ( i == 0 ){
            url = url + '&selCmtCd=' + cmtGuide_varEditCmtCd[i];
        } else {
            url = url + ',' + cmtGuide_varEditCmtCd[i];
        }
    }
// ### 2004/11/12 Add by Gouda@FSIT 生活指導コメントの表示分類
    if ( recogLevel != "" ) {
        url = url + '&recogLevel=' + recogLevel;
    }
// ### 2004/11/12 End

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winAdviceComment.focus();
        winAdviceComment.location.replace( url );
    } else {
        winAdviceComment = window.open( url, '', 'width=600,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}


// ガイドを閉じる
function cmtGuide_closeAdviceComment() {

    if ( winAdviceComment != null ) {
        if ( !winAdviceComment.closed ) {
            winAdviceComment.close();
        }
    }

    winAdviceComment = null;
}
//-->
</SCRIPT>
