package cn.com.cgbchina.image.exception;

public class ImageDeleteException extends Exception {
	private static final long serialVersionUID = 6295717443044894321L;

	public ImageDeleteException() {
	}

	public ImageDeleteException(String message) {
		super(message);
	}

	public ImageDeleteException(String message, Throwable cause) {
		super(message, cause);
	}

	public ImageDeleteException(Throwable cause) {
		super(cause);
	}
}
