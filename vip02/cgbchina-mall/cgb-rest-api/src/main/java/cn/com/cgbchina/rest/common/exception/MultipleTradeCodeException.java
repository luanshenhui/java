package cn.com.cgbchina.rest.common.exception;

/**
 * Comment: Created by 11150321050126 on 2016/4/22.
 */
public class MultipleTradeCodeException extends Exception {
	public MultipleTradeCodeException() {
		super("交易码重复");
	}

	public MultipleTradeCodeException(String message) {
		super(message);
	}
}
