package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Client;



public interface ClientDAO {
	
	/**
	 * 增加客户
	 * @param product
	 */
	public abstract void add(Client client);
	/**
	 * 修改客户
	 * @param product
	 */
	public abstract void update(Client client);
	
	/**
	 * 删除客户
	 * @param product
	 */
	public abstract void delete(Client client);
	
	/**
	 * 根据id查客户
	 * @param id
	 * @return
	 */
	public abstract Client getByID(long id);
	
	/**
	 *查询所有客户
	 * @return
	 */
	public abstract List<Client> getAll();

}
