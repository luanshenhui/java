/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Repertory;

/**
 * @author ������
 *
 * 2015-2-5����03:27:23
 */
public interface RepertoryService {
	
	/**
	 * ����
	 * @param repertory
	 * @return
	 */
	public abstract boolean add(Repertory repertory);
	
	/**
	 * �鿴����
	 * @return
	 */
	public abstract List<Repertory> getAll();
	

}
