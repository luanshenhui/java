package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Roleaction;


public interface RoleactionDAO {
	/**
	 * ���ӽ�ɫȨ��
	 * @param product
	 */
	public abstract void add(Roleaction roleaction);
	/**
	 * �޸Ľ�ɫȨ��
	 * @param product
	 */
	public abstract void update(Roleaction roleaction);
	
	/**
	 * ɾ����ɫȨ��
	 * @param product
	 */
	public abstract void delete(Roleaction roleaction);
	
	/**
	 * ����id���ɫȨ��
	 * @param id
	 * @return
	 */
	public abstract Roleaction getByID(long id);
	
	/**
	 *��ѯ���н�ɫȨ��
	 * @return
	 */
	public abstract List<Roleaction> getAll();

}
