package com.f.domain;

import com.f.utl.IDUtl;

/**
 * 
 * 
 * @author ��ѧ��
 *
 * 2015-2-2����10:15:29
 */

public abstract class BaseDomain {
	private long id;
	public BaseDomain(){
		id=IDUtl.getID();
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	
}
