<!--
// 日付チェック
function isDate( year, month, day ) {

	for ( var ret = false; ; ) {

		// 年月日のいずれかが未指定ならばエラー
		if ( year == '' || month == '' || day == '' ) {
			break;
		}

		// 数値以外ならばエラー
		if ( isNaN(year) || isNaN(month) || isNaN(day) ) {
			break;
		}

		var lastDay = Array(31,29,31,30,31,30,31,31,30,31,30,31);
		var wkYear  = parseInt(year,  10);
		var wkMonth = parseInt(month, 10);
		var wkDay   = parseInt(day,   10);

		// 月チェック
		if ( wkMonth < 1 || wkMonth > 12 ) {
			break;
		}

		// 日チェック
		if ( wkDay < 1 || wkDay > lastDay[wkMonth - 1] ) {
			break;
		}

		// 2/29の場合は閏年チェック
		if ( !( wkMonth == 2 && wkDay == 29 ) ) {
			ret = true;
			break;
		}

		if ( ( wkYear % 4 ) == 0 && ( wkYear % 100 ) != 0 ) {
			ret = true;
			break;
		}

		if ( ( wkYear % 400 ) == 0 ) {
			ret = true;
			break;
		}

		ret = false;
		break;
	}

	return ret;
}

// 指定年月日をyyyy/mm/ddの形式に変換
function formatDate(year, month, day) {

	var buffer = '';

	for ( ; ; ) {

		// 日付チェック
		if ( !isDate(year, month, day) ) {
			break;
		}

		// 年を編集
		buffer = year + '/';

		// 月を連結
		if ( month.length == 1 ) {
			buffer = buffer + '0';
		}
		buffer = buffer + month + '/';

		// 日を連結
		if ( day.length == 1 ) {
			buffer = buffer + '0';
		}
		buffer = buffer + day;

		break;
	}

	return buffer;
}
//-->
