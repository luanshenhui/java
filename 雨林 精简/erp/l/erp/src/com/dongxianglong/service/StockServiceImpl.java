/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.dao.StockDAO;
import com.dongxianglong.dao.StockDAOImpl;
import com.dongxianglong.domain.Stock;

/**
 * @author ¶­ÏéÁú
 *
 * 2015-2-5ÏÂÎç03:21:55
 */
public class StockServiceImpl implements StockService {

	private StockDAO dao=new StockDAOImpl();
	/* (non-Javadoc)
	 * @see com.dongxianglong.service.StockService#add(com.dongxianglong.domain.Stock)
	 */
	public boolean add(Stock stock) {
		dao.add(stock);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.StockService#getAll()
	 */
	public List<Stock> getAll() {
		
		return dao.getAll();
	}

}
