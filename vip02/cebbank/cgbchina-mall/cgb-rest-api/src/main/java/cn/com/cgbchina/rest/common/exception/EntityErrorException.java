package cn.com.cgbchina.rest.common.exception;

/**
 * Comment: Created by 11150321050126 on 2016/4/27.
 */
public class EntityErrorException extends Exception {
	public EntityErrorException() {
		super("实体定义异常");
	}

	public EntityErrorException(String message) {
		super(message);
	}
}
