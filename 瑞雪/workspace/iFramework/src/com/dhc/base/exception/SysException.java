package com.dhc.base.exception;

/** 
*/

public class SysException extends BaseException {

	/**
	 * @param mesg
	 */
	public SysException(String mesg) {
		super(mesg);
	}

	public SysException(Exception e) {
		this(e.getMessage());
	}
}
