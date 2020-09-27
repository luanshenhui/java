/**
 * 
 */
package com.lsh.domain;

import com.lsh.util.IDUtil;

/**
 * @author 栾慎辉
 *
 * 2015-2-2上午10:28:56
 * 所以领域模型父类
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
