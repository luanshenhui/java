package com.dhc.base.exception;

/**
 */
public class ServiceException extends BaseException {

	public ServiceException(String msg) {
		super(msg);
	}

	public ServiceException(Exception e) {
		this(e.getMessage());
	}
}
