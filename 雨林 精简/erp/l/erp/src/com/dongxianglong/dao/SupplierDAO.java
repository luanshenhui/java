package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Supplier;

/**
 * 
 * @author ������
 *
 * 2015-2-2����05:22:48
 * ��Ӧ�̷��ʱ�׼
 */
public interface SupplierDAO {
	
	
	/**
	 * 
	 * @param supplier
	 * ��
	 */
	public abstract void add(Supplier supplier);
	
	/**
	 * 
	 * @param id
	 * ɾ
	 */
	public abstract void delete(long id);
	
	/**
	 * 
	 * @param supplier
	 * ��
	 */
	public abstract void update(Supplier supplier);
	
	/**
	 * @param id
	 * @return
	 * �鵥��
	 */
	public abstract  Supplier getByID(long id);
	
	/**
	 * 
	 * @return
	 * ������
	 */
	public abstract   List<Supplier> getAll();

}
