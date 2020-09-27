/**
 * 
 */
package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Stock;

/**
 * @author ¶­ÏéÁú
 *
 * 2015-2-2ÏÂÎç05:43:19
 */
public class StockDAOImpl extends BaseDAO implements StockDAO {
      
	private static final String NAMESPACE="com.dongxianglong.domain.Stock.";
	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.StockDAO#add(com.dongxianglong.domain.Stock)
	 */
	public void add(Stock stock) {
		session.insert(NAMESPACE+"add",stock);
		session.commit();
	}

	
	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.StockDAO#getAll()
	 */
	public List<Stock> getAll() {
		List<Stock>list=session.selectList(NAMESPACE+"all");
		return list;
	}

	
	public static void main(String[] args)
	{
//		StockDAO dao=new StockDAOImpl();
//		List<Stock>list=dao.getAll();
//		for(Stock s:list)
//		{
//		System.out.println(s+s.getPerson().getUsername()+s.getProduct().getName());
//		}
		
	}

}
