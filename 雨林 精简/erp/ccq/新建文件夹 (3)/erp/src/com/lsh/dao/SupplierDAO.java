package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Supplier;


public interface SupplierDAO {
	
	/**
	 * ���ӹ�Ӧ��
	 * @param product
	 */
	public abstract void add(Supplier supplier);
	/**
	 * �޸Ĺ�Ӧ��
	 * @param product
	 */
	public abstract void update(Supplier supplier);
	
	/**
	 * ɾ����Ӧ��
	 * @param product
	 */
	public abstract void delete(Supplier supplier);
	
	/**
	 * ����id��Ӧ��
	 * @param id
	 * @return
	 */
	public abstract Supplier getByID(long id);
	
	/**
	 *��ѯ����Ӧ��
	 * @return
	 */
	public abstract List<Supplier> getAll();

}
