/**
 * 
 */
package com.f.service;

import java.util.List;



import com.f.DAO.StockDAO;
import com.f.DAO.StockDAOImpl;
import com.f.domain.Stock;

/**
 * @author ��ѧ��
 *
 * 2015-2-5����3:29:13
 */
public class StockServiceImpl implements StockService{
	private  StockDAO dao=new StockDAOImpl();
	public boolean add(Stock stock) {
		dao.add(stock);
		return true;
	}

	

}
