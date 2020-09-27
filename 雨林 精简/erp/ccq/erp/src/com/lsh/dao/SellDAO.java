package com.lsh.dao;

import java.util.List;


import com.lsh.domain.Sell;

public interface SellDAO {
	
	/**
	 * ��������
	 * @param product
	 */
	public abstract void add(Sell sell);
	/**
	 * �޸�����
	 * @param product
	 */
	public abstract void update(Sell sell);
	
	/**
	 * ɾ������
	 * @param product
	 */
	public abstract void delete(long id);
	
	/**
	 * ����id������
	 * @param id
	 * @return
	 */
	public abstract Sell getByID(long id);
	
	/**
	 *��ѯ��������
	 * @return
	 */
	public abstract List<Sell> getAll();

}
