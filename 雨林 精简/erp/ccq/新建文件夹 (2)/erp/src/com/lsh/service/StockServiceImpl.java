/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.dao.StockDAO;
import com.lsh.dao.StockDAOImpl;
import com.lsh.domain.Stock;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-5ÏÂÎç03:39:33
 */
public class StockServiceImpl implements StockService {
private StockDAO dao=new StockDAOImpl();
	/* (non-Javadoc)
	 * @see com.lsh.service.StockService#add(com.lsh.domain.Stock)
	 */
	public boolean add(Stock stock) {
		// TODO Auto-generated method stub
		dao.add(stock);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.StockService#delete(long)
	 */
	public boolean delete(long id) {
		// TODO Auto-generated method stub
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.StockService#getAll()
	 */
	public List<Stock> getAll() {
		// TODO Auto-generated method stub
		return dao.getAll();
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.StockService#getByID(long)
	 */
	public Stock getByID(long id) {
		// TODO Auto-generated method stub
		
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.StockService#update(com.lsh.domain.Stock)
	 */
	public boolean update(Stock stock) {
		// TODO Auto-generated method stub
		dao.update(stock);
		return true;
	}

}
