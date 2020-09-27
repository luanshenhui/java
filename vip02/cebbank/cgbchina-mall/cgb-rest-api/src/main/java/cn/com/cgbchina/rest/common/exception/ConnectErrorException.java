package cn.com.cgbchina.rest.common.exception;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class ConnectErrorException extends RuntimeException {
	public ConnectErrorException() {
	}

	public ConnectErrorException(String message) {
		super(message);
	}

	public ConnectErrorException(String message, Throwable cause, boolean enableSuppression,
			boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

	public ConnectErrorException(String message, Throwable cause) {
		super(message, cause);
	}

	public ConnectErrorException(Throwable cause) {
		super(cause);
	}

}
