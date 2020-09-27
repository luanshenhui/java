/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.domain.Repertory;

/**
 * @author 栾慎辉
 *
 * 2015-2-5下午03:51:21
 */
public interface RepertoryService {
	/**
	 * 增加最后一个库存
	 * @param repertory
	 * @return
	 */
	public abstract boolean add(Repertory repertory);
	
	/**
	 * 修改一个库存
	 * @param repertory
	 * @return
	 */
	public abstract boolean update(Repertory repertory);

	/**
	 * 删除一个库存
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	
	/**
	 * 查找一个库存
	 * @param id
	 * @return
	 */
	public abstract Repertory getByID(long id);
	
	/**
	 * 查找所有库存
	 * @return
	 */
	public abstract List<Repertory> getAll();

}
