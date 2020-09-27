package cn.com.cgbchina.common.utils;

import com.google.common.base.Strings;
import com.google.common.collect.ImmutableSet;

import java.util.Set;
import java.util.regex.Pattern;

/**
 * Created by 11140721050130 on 2016/5/16.
 */
public class NameValidator {

	private static final Pattern pattern = Pattern.compile("([a-z]|[A-Z]|[0-9]|[\\u4e00-\\u9fa5]|_)+");
	private static final Set reservedUserNames = ImmutableSet.builder().add("admin").add("管理员").add("系统管理员")
			.add("system").add("administrator").add("cgb").add("广发银行").add("root").build();

	public static boolean validate(String name) {
		return (Strings.isNullOrEmpty(name)) || (pattern.matcher(name).matches());
	}

	public static boolean isAllowedUserName(String name) {
		return !reservedUserNames.contains(name.toLowerCase());
	}
}
