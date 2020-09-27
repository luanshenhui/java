package cn.com.cgbchina.rest.common.exception;

/**
 * Comment: Created by 11150321050126 on 2016/4/21.
 */
public class ContentException extends RuntimeException {
	public ContentException() {
		super("内容错误,请检查报文和装载的对象内容");
	}

	public ContentException(String message) {
		super(message);
	}
}
