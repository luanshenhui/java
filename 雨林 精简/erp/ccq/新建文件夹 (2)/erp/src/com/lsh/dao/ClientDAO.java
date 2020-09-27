package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Client;



public interface ClientDAO {
	
	/**
	 * ���ӿͻ�
	 * @param product
	 */
	public abstract void add(Client client);
	/**
	 * �޸Ŀͻ�
	 * @param product
	 */
	public abstract void update(Client client);
	
	/**
	 * ɾ���ͻ�
	 * @param product
	 */
	public abstract void delete(Client client);
	
	/**
	 * ����id��ͻ�
	 * @param id
	 * @return
	 */
	public abstract Client getByID(long id);
	
	/**
	 *��ѯ���пͻ�
	 * @return
	 */
	public abstract List<Client> getAll();

}
