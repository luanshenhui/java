/**
 * 
 */
package com.dongxianglong.domain;

import com.dongxianglong.util.IDUtil;

/**
 * @author 董祥龙
 *
 * 2015-2-2上午10:25:13
 * 
 * 所有领域模型的父类。
 */
public abstract class BaseDomain {
	
	private long id;
	
	public BaseDomain()
	{
		id=IDUtil.getsequenceID();
	}
public BaseDomain(long id) {
		this.id=id;
	}

	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	
	

}
