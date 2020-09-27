package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Roleaction;

/**
 * 
 * @author 董祥龙
 *
 * 2015-2-2下午05:35:17
 * 角色访问数据标准
 */
public interface RoleactionDAO {
	
	/**
	 * 
	 * @param roleaction
	 * 增
	 */
	public abstract void add(Roleaction roleaction);
	
	/**
	 * 
	 * @param id
	 * 删
	 */
	public abstract void delete(long id);
	
	/**
	 * 
	 * @param roleaction
	 * 改
	 */
	public abstract void update(Roleaction roleaction);
	
	/**
	 * 
	 * @param id
	 * @return
	 * 查单个
	 */
	public abstract Roleaction getByID(long id);
	
	/**
	 * 
	 * @return
	 * 查所有
	 */
	public abstract List<Roleaction> getAll();
	

}
