package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Repertory;


/**
 * 
 * @author 董祥龙
 *
 * 2015-2-2下午05:15:04
 * 库存数据访问标准
 */
public interface RepertoryDAO {
	
	/**
	 * 
	 * @param repertory
	 * 增
	 */
	public abstract void add(Repertory repertory);
	
    /**
     * 
     * @return
     * 查所有
     */
	public abstract List<Repertory> getAll();

}
