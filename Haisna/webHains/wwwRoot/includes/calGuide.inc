<%
'-----------------------------------------------------------------------------
'		日付ガイド Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var calGuide_Year;				// 年
var calGuide_Month;				// 月
var calGuide_Day;				// 日
var calGuide_CalledFunction;	// 日付選択時に呼び出される関数オブジェクト

var winGuideCalendar;			// ウィンドウハンドル

// 日付ガイド画面を表示
function calGuide_showGuideCalendar( year, month, day, calledFunc ) {

	var opened = false;											// 画面が開かれているか
	var url    = '/webHains/contents/guide/gdeCalendar.asp';	// 日付ガイド画面のURL

	// ガイド画面との連絡域を使用して処理制御を行う
	calGuide_Year           = document.getElementById( year  ) || document.getElementsByName( year  )[0];
	calGuide_Month          = document.getElementById( month ) || document.getElementsByName( month )[0];
	calGuide_Day            = document.getElementById( day   ) || document.getElementsByName( day   )[0];
	calGuide_CalledFunction = calledFunc;

	// すでにガイドが開かれているかチェック
	if ( winGuideCalendar ) {
		if ( !winGuideCalendar.closed ) {
			opened = true;
		}
	}

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideCalendar.focus();
		winGuideCalendar.location.replace( url );
	} else {
		winGuideCalendar = window.open( url, '', 'width=390,height=210,status=no,directories=no,menubar=no,resizable=no,toolbar=no' );
	}

}

// 日付編集用関数
function calGuide_setDate( year, month, day ) {

	// 年の編集
	if ( calGuide_Year ) {
		calGuide_Year.value = year;
	}

	// 月の編集
	if ( calGuide_Month ) {
		calGuide_Month.value = month;
	}

	// 日の編集
	if ( calGuide_Day ) {
		calGuide_Day.value = day;
	}

	// 関数呼び出し
	if ( calGuide_CalledFunction ) {
		calGuide_CalledFunction();
	}

}

// 日付のクリア
function calGuide_clearDate( year, month, day ) {

	var calYear           = document.getElementById( year  ) || document.getElementsByName( year  )[0];
	var calMonth          = document.getElementById( month ) || document.getElementsByName( month )[0];
	var calDay            = document.getElementById( day   ) || document.getElementsByName( day   )[0];
	
	// 年のクリア
	if ( calYear ) {
		calYear.value = '';
	}

	// 月のクリア
	if ( calMonth ) {
		calMonth.value = '';
	}

	// 日のクリア
	if ( calDay ) {
		calDay.value = '';
	}

}

// ガイドを閉じる
function calGuide_closeGuideCalendar() {

	if ( winGuideCalendar ) {
		if ( !winGuideCalendar.closed ) {
			winGuideCalendar.close();
		}
	}

	winGuideCalendar = null;
}
//-->
</SCRIPT>
