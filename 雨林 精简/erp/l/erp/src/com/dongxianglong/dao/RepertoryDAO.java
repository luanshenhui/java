package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Repertory;


/**
 * 
 * @author ������
 *
 * 2015-2-2����05:15:04
 * ������ݷ��ʱ�׼
 */
public interface RepertoryDAO {
	
	/**
	 * 
	 * @param repertory
	 * ��
	 */
	public abstract void add(Repertory repertory);
	
    /**
     * 
     * @return
     * ������
     */
	public abstract List<Repertory> getAll();

}
