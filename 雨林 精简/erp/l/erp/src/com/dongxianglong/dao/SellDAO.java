package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Sell;


/**
 * 
 * @author ������
 *
 * 2015-2-2����05:09:58
 * 
 * ���۵����ݷ��ʱ�׼
 */
public interface SellDAO {
	
	/**
	 * 
	 * @param sell
	 * ��
	 */
	public abstract void add(Sell sell);
	
	
	/**
	 * 
	 * @return
	 * ������
	 */
	public abstract List<Sell> getAll();
	

}
