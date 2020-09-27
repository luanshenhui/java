/**
 * 
 */
package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Sell;

/**
 * @author ¶­ÏéÁú
 * 
 *         2015-2-2ÏÂÎç05:42:42
 */
public class SellDAOImpl extends BaseDAO implements SellDAO {
	private static final String NAMESPACE="com.dongxianglong.domain.Sell.";
	        /*
			 * (non-Javadoc)
			 * 
			 * @see
			 * com.dongxianglong.dao.SellDAO#add(com.dongxianglong.domain.Sell)
			 */
	public void add(Sell sell) {
		session.insert(NAMESPACE+"add",sell);
		session.commit();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dongxianglong.dao.SellDAO#getAll()
	 */
	public List<Sell> getAll() {
		List<Sell>list=session.selectList(NAMESPACE+"all");
		return list;
	}
	
	public static void main(String[] args)
	{
//		SellDAO dao=new SellDAOImpl();
//		List<Sell>list=dao.getAll();
//		for(Sell s:list)
//		{
//			System.out.println(s);
//		}
	}

}
