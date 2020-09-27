/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.domain.Repertory;

/**
 * @author ������
 *
 * 2015-2-5����03:51:21
 */
public interface RepertoryService {
	/**
	 * �������һ�����
	 * @param repertory
	 * @return
	 */
	public abstract boolean add(Repertory repertory);
	
	/**
	 * �޸�һ�����
	 * @param repertory
	 * @return
	 */
	public abstract boolean update(Repertory repertory);

	/**
	 * ɾ��һ�����
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	
	/**
	 * ����һ�����
	 * @param id
	 * @return
	 */
	public abstract Repertory getByID(long id);
	
	/**
	 * �������п��
	 * @return
	 */
	public abstract List<Repertory> getAll();

}
