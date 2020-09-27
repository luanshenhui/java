package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Repertory;



public interface RepertoryDAO {
	
	/**
	 * ���ӿ��
	 * @param product
	 */
	public abstract void add(Repertory repertory);
	/**
	 * �޸Ŀ��
	 * @param product
	 */
	public abstract void update(Repertory repertory);
	
	/**
	 * ɾ�����
	 * @param product
	 */
	public abstract void delete(long id);
	
	/**
	 * ����id����
	 * @param id
	 * @return
	 */
	public abstract Repertory  getByID(long id);
	
	/**
	 *��ѯ���п��
	 * @return
	 */
	public abstract List<Repertory> getAll();

}
