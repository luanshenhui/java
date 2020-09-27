/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Repertory;

/**
 * @author 董祥龙
 *
 * 2015-2-5下午03:27:23
 */
public interface RepertoryService {
	
	/**
	 * 增添
	 * @param repertory
	 * @return
	 */
	public abstract boolean add(Repertory repertory);
	
	/**
	 * 查看所有
	 * @return
	 */
	public abstract List<Repertory> getAll();
	

}
