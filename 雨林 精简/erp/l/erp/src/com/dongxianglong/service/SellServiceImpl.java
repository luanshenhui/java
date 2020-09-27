/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.dao.SellDAO;
import com.dongxianglong.dao.SellDAOImpl;
import com.dongxianglong.domain.Sell;

/**
 * @author ������
 *
 * 2015-2-5����03:25:25
 */
public class SellServiceImpl implements SellService {
     private SellDAO dao=new SellDAOImpl();
	/* (non-Javadoc)
	 * @see com.dongxianglong.service.SellService#add(com.dongxianglong.domain.Sell)
	 */
	public boolean add(Sell sell) {
		dao.add(sell);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.SellService#getAll()
	 */
	public List<Sell> getAll() {
		
		return dao.getAll();
	}

}
