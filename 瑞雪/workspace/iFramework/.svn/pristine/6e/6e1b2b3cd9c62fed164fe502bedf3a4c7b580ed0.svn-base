package com.dhc.base.exception;

import org.springframework.core.NestedCheckedException;

/**
 * brief description 基本异常，系统定义的所有异常都需要继承这个基本类
 * 
 */
public class BaseException extends NestedCheckedException {

	public BaseException(String msg) {
		super(msg);
	}

	public BaseException(Exception e) {
		this(e.getMessage());
	}
}
