package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Supplier;

/**
 * 
 * @author 董祥龙
 *
 * 2015-2-2下午05:22:48
 * 供应商访问标准
 */
public interface SupplierDAO {
	
	
	/**
	 * 
	 * @param supplier
	 * 增
	 */
	public abstract void add(Supplier supplier);
	
	/**
	 * 
	 * @param id
	 * 删
	 */
	public abstract void delete(long id);
	
	/**
	 * 
	 * @param supplier
	 * 改
	 */
	public abstract void update(Supplier supplier);
	
	/**
	 * @param id
	 * @return
	 * 查单个
	 */
	public abstract  Supplier getByID(long id);
	
	/**
	 * 
	 * @return
	 * 查所有
	 */
	public abstract   List<Supplier> getAll();

}
