/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.sms.model;

import java.util.List;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/6/14.
 */
public class SmallSeg {
	private final Seg seg;

	private SmallSeg() {
		this.seg = new Seg();
		try {
			seg.useDefaultDict();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	static class SingletonHolder {
		static SmallSeg instance = new SmallSeg();
	}

	public static SmallSeg instance() {
		return SingletonHolder.instance;
	}

	public List<String> cut(String text) {
		return seg.cut(text);
	}
}
