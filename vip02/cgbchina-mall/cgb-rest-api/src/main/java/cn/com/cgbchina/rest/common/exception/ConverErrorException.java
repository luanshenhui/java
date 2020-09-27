package cn.com.cgbchina.rest.common.exception;

/**
 * Comment: Created by 11150321050126 on 2016/4/24.
 */
public class ConverErrorException extends RuntimeException {
	public ConverErrorException() {
	}

	public ConverErrorException(String message) {
		super(message);
	}

	public ConverErrorException(String message, Throwable cause) {
		super(message, cause);
	}

	public ConverErrorException(Throwable cause) {
		super(cause);
	}

}
