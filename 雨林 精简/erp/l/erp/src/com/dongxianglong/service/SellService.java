/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Sell;

/**
 * @author ������
 *
 * 2015-2-5����03:23:32
 */
public interface SellService {

	/**
	 * ����
	 * @param sell
	 * @return
	 */
	public abstract boolean add(Sell sell);
	/**
	 * �鿴����
	 * @return
	 */
	public abstract List<Sell> getAll();
	
	
	
}
