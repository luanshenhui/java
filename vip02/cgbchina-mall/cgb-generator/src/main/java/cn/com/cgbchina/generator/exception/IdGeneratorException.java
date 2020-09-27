package cn.com.cgbchina.generator.exception;

/**
 * Created by 11140721050130 on 2016/5/3.
 */
public class IdGeneratorException extends RuntimeException {

	public IdGeneratorException() {
		super();
	}

	public IdGeneratorException(String message, Throwable cause) {
		super(message, cause);
	}

	public IdGeneratorException(String message) {
		super(message);
	}

	public IdGeneratorException(Throwable cause) {
		super(cause);
	}
}
