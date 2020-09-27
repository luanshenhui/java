/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.domain.Sell;

/**
 * @author ������
 *
 * 2015-2-5����03:43:19
 */
public interface SellService {
	/**
	 * ����һ������
	 * @param sell
	 * @return
	 */
	public abstract boolean add(Sell sell);
	
	/**
	 * �޸�һ������
	 * @param sell
	 * @return
	 */
	public abstract boolean update(Sell sell);
	
	/**
	 * ɾ��һ������
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	
	/**
	 * ����һ������
	 * @param id
	 * @return
	 */
	public abstract Sell getByID(long id);
	
	/**
	 * ������������
	 * @return
	 */
	public abstract List<Sell> getAll();

}
