package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Roleaction;

/**
 * 
 * @author ������
 *
 * 2015-2-2����05:35:17
 * ��ɫ�������ݱ�׼
 */
public interface RoleactionDAO {
	
	/**
	 * 
	 * @param roleaction
	 * ��
	 */
	public abstract void add(Roleaction roleaction);
	
	/**
	 * 
	 * @param id
	 * ɾ
	 */
	public abstract void delete(long id);
	
	/**
	 * 
	 * @param roleaction
	 * ��
	 */
	public abstract void update(Roleaction roleaction);
	
	/**
	 * 
	 * @param id
	 * @return
	 * �鵥��
	 */
	public abstract Roleaction getByID(long id);
	
	/**
	 * 
	 * @return
	 * ������
	 */
	public abstract List<Roleaction> getAll();
	

}
