package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Client;

/**
 * 
 * @author ������
 *
 * 2015-2-2����05:29:55
 * �ͻ��������ݱ�׼
 */
public interface ClientDAO {
	
	/**
	 * 
	 * @param client
	 * ��
	 */
	public abstract void add(Client client);
	
	/**
	 * 
	 * @param id
	 * ɾ
	 */
	public abstract void delete(long id);
	
	/**
	 * 
	 * @param client
	 * ��
	 */
	public abstract void update(Client client);
	
	/**
	 * 
	 * @param id
	 * @return
	 * �鵥��
	 */
	public abstract Client getByID(long id);
	
	/**
	 * 
	 * @return
	 * ������
	 */
	public abstract List<Client> getAll();
	
	

}
