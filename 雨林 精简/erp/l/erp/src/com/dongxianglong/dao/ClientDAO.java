package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Client;

/**
 * 
 * @author 董祥龙
 *
 * 2015-2-2下午05:29:55
 * 客户访问数据标准
 */
public interface ClientDAO {
	
	/**
	 * 
	 * @param client
	 * 增
	 */
	public abstract void add(Client client);
	
	/**
	 * 
	 * @param id
	 * 删
	 */
	public abstract void delete(long id);
	
	/**
	 * 
	 * @param client
	 * 改
	 */
	public abstract void update(Client client);
	
	/**
	 * 
	 * @param id
	 * @return
	 * 查单个
	 */
	public abstract Client getByID(long id);
	
	/**
	 * 
	 * @return
	 * 查所有
	 */
	public abstract List<Client> getAll();
	
	

}
