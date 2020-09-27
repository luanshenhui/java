/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.DAO.SellDAO;
import com.f.DAO.SellDAOImpl;
import com.f.domain.Sell;


/**
 * @author ·ëÑ§Ã÷
 *
 * 2015-2-5ÏÂÎç3:25:06
 */
public class SellServiceImpl implements SellService {
	private  SellDAO dao=new SellDAOImpl();
	/* (non-Javadoc)
	 * @see com.f.service.SellService#add(com.f.service.SellService)
	 */
	public boolean add(Sell sell) {
		dao.add(sell);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.SellService#update(com.f.service.SellService)
	 */
	public boolean update(Sell sell) {
		dao.update(sell);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.SellService#delete(long)
	 */
	public boolean delete(long id) {
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.SellService#getByID(long)
	 */
	public Sell getByID(long id) {
		
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.f.service.SellService#getAll()
	 */
	public List<Sell> getAll() {
		
		return dao.getAll();
	}

}
