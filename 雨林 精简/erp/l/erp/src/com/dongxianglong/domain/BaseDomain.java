/**
 * 
 */
package com.dongxianglong.domain;

import com.dongxianglong.util.IDUtil;

/**
 * @author ������
 *
 * 2015-2-2����10:25:13
 * 
 * ��������ģ�͵ĸ��ࡣ
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
