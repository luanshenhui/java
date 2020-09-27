package com.dhc.base.exception;

import org.springframework.core.NestedRuntimeException;

public class BaseDataAccessException extends NestedRuntimeException {
	/**
	* 
	*/
	private static final long serialVersionUID = 1L;

	public BaseDataAccessException(String arg0) {
		super(arg0);
	}

	public BaseDataAccessException(Exception e) {
		this(e.getMessage());
	}
}
