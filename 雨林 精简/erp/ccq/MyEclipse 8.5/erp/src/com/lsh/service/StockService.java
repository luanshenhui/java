package com.lsh.service;

import java.util.List;

import com.lsh.domain.Stock;

public interface StockService {
	/**
	 * ����һ��
	 * @param stock
	 * @return
	 */
	public abstract boolean add(Stock stock);
	
	/**
	 * �޸�һ������
	 * @param stock
	 * @return
	 */
	public abstract boolean update(Stock stock);
	
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
	public abstract Stock getByID(long id);
	
	/**
	 * �������н���
	 * @return
	 */
	public abstract List<Stock> getAll();

}
