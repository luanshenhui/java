/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.dao.SellDAO;
import com.lsh.dao.SellDAOImpl;
import com.lsh.domain.Sell;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-5ÏÂÎç03:47:36
 */
public class SellServiceImpl implements SellService {
private SellDAO dao=new SellDAOImpl();
	/* (non-Javadoc)
	 * @see com.lsh.service.SellService#add(com.lsh.domain.Sell)
	 */
	public boolean add(Sell sell) {
		// TODO Auto-generated method stub
		dao.add(sell);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.SellService#delete(long)
	 */
	public boolean delete(long id) {
		// TODO Auto-generated method stub
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.SellService#getAll()
	 */
	public List<Sell> getAll() {
		// TODO Auto-generated method stub
		return dao.getAll();
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.SellService#getByID(long)
	 */
	public Sell getByID(long id) {
		// TODO Auto-generated method stub
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.SellService#update(com.lsh.domain.Sell)
	 */
	public boolean update(Sell sell) {
		// TODO Auto-generated method stub
		dao.update(sell);
		return true;
	}

}
