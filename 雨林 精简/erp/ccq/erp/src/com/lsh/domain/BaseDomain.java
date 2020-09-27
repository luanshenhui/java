/**
 * 
 */
package com.lsh.domain;

import com.lsh.util.IDUtil;

/**
 * @author ������
 *
 * 2015-2-2����10:28:56
 * ��������ģ�͸���
 */
public abstract class BaseDomain {
	
	private long id;

	public BaseDomain() {
		//id=IDUtil.getId();
		id=IDUtil.getSequenceID();
	}

//	public BaseDomain(long id) {
//		super();
//		this.id = id;
//	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

}
