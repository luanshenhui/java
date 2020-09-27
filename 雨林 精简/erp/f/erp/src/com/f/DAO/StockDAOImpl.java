/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Stock;

/**
 * @author 冯学明
 *
 * 2015-2-2下午5:06:25
 * Stcok的实现类
 *
 */
public class StockDAOImpl extends BaseDAO implements StockDAO {
	private  static final String NAMESPACE="com.f.domain.Stock.";
	/* (non-Javadoc)
	 * @see com.f.DAO.StockDAO#add(com.f.domain.Stock)
	 */
	public void add(Stock stock) {
		session.insert(NAMESPACE+"add",stock);
		session.commit();
	}
	/* (non-Javadoc)
	 * @see com.f.DAO.StockDAO#update(com.f.domain.Stock)
	 */
	public void update(Stock stock) {
		session.update(NAMESPACE+"update",stock);
		
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.StockDAO#delete(long)
	 */
	public void delete(long id) {
		session.update(NAMESPACE+"delete",id);
		
		session.commit();

	}

	/* (non-Javadoc)
	 * @see com.f.DAO.StockDAO#getByID(long)
	 */
	public Stock getByID(long id) {
		Stock stock =session.selectOne(NAMESPACE+"getByID",id);
		return stock;
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.StockDAO#getAll()
	 */
	public List<Stock> getAll() {
		List<Stock> list=session.selectList(NAMESPACE+"getAll");
		return list;
	}
	public static void main(String[] args) {
		
	}
}
