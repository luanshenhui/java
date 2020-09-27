package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Repertory;



public interface RepertoryDAO {
	
	/**
	 * 增加库存
	 * @param product
	 */
	public abstract void add(Repertory repertory);
	/**
	 * 修改库存
	 * @param product
	 */
	public abstract void update(Repertory repertory);
	
	/**
	 * 删除库存
	 * @param product
	 */
	public abstract void delete(long id);
	
	/**
	 * 根据id查库存
	 * @param id
	 * @return
	 */
	public abstract Repertory  getByID(long id);
	
	/**
	 *查询所有库存
	 * @return
	 */
	public abstract List<Repertory> getAll();

}
