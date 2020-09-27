package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Supplier;


public interface SupplierDAO {
	
	/**
	 * 增加供应商
	 * @param product
	 */
	public abstract void add(Supplier supplier);
	/**
	 * 修改供应商
	 * @param product
	 */
	public abstract void update(Supplier supplier);
	
	/**
	 * 删除供应商
	 * @param product
	 */
	public abstract void delete(Supplier supplier);
	
	/**
	 * 根据id供应商
	 * @param id
	 * @return
	 */
	public abstract Supplier getByID(long id);
	
	/**
	 *查询所供应商
	 * @return
	 */
	public abstract List<Supplier> getAll();

}
