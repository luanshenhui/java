/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: CN
 */
jQuery.extend(jQuery.validator.messages, {
        required: "必須項目",
		remote: "この項目を修正してください",
		email: "正しいフォームでメールアドレスを入力してください",
		url: "正しいアドレスを入力してください",
		date: "正しい日付を入力してください",
		dateISO: "正しい日付を入力してください (ISO).",
		number: "正しい数字を入力してください",
		digits: "整数のみ入力できます",
		creditcard: "正しいクレジットカード番号を入力してください",
		equalTo: "再度同じ内容を入力してください",
		accept: "正しい拡張子の文字列を入力してください",
		maxlength: jQuery.validator.format("長さが {0}以内の文字列を入力してください"),
		minlength: jQuery.validator.format("長さが {0}以内の文字列を入力してください"),
		rangelength: jQuery.validator.format("長さが {0}と{1} 間の文字列を入力してください "),
		range: jQuery.validator.format(" {0} と{1}間の値を入力してください"),
		max: jQuery.validator.format("最大が{0}の値を入力してください"),
		min: jQuery.validator.format("最小が{0}の値を入力してください"),
		specialCharCheck: "テキスト欄に以下の記号' | ^ \"\ < > ? % $ { } [ ] = # : & \\ を含んではいけません、入力を確認してください",
		byteRangeLength: jQuery.validator.format("長さが {0}と{1} 間の文字列を入力してください "),
		accountValidate: jQuery.validator.format("数字もしくはアンダーバーのみ入力することができます")
});
