package cn.com.cgbchina.common.utils;

import java.util.List;

/**
 * Created by 11140721050130 on 2016/5/16.
 */
public class NumberValidator {

	public static boolean gt0(Long num) {
		return (num != null) && (num.longValue() > 0L);
	}

	public static boolean gt0(List<Long> nums) {
		if ((nums == null) || (nums.size() < 0)) {
			return false;
		}
		for (Long num : nums) {
			if (!gt0(num))
				return false;
		}
		return true;
	}

	public static boolean gt0(Integer num) {
		return (num != null) && (num.intValue() > 0);
	}
}
