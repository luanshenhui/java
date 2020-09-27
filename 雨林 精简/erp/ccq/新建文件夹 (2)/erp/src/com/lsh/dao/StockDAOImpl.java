/**
 * 
 */
package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Stock;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-2ÏÂÎç05:33:44
 */
public class StockDAOImpl extends BaseDAO implements StockDAO {
private static final String NAMESPACE="com.lsh.domain.Stock";
	/* (non-Javadoc)
	 * @see com.lsh.dao.StockDAO#add(com.lsh.domain.Stock)
	 */
	public void add(Stock stock) {
		// TODO Auto-generated method stub
		session.insert(NAMESPACE+".add",stock);
		session.commit();

	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.StockDAO#delete(com.lsh.domain.Stock)
	 */
	public void delete(long id) {
		// TODO Auto-generated method stub
		session.delete(NAMESPACE+"delete",id);
		session.commit();

	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.StockDAO#getAll()
	 */
	public List<Stock> getAll() {
		// TODO Auto-generated method stub
		List<Stock>list=session.selectList(NAMESPACE+".all");
		return list;
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.StockDAO#getByID(long)
	 */
	public Stock getByID(long id) {
		// TODO Auto-generated method stub
		Stock stock=session.selectOne(NAMESPACE+".getID",id);
		
		return stock;
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.StockDAO#update(com.lsh.domain.Stock)
	 */
	public void update(Stock stock) {
		// TODO Auto-generated method stub
		session.update(NAMESPACE+".update",stock);
		session.commit();

	}
public static void main(String[] args) {
	StockDAO dao=new StockDAOImpl();
	List<Stock>list=dao.getAll();
	for(Stock s:list){
//		System.out.println(s);
//		System.out.println(s.getPerson());
		System.out.println(s+s.getProduct().getInfo()+s.getProduct().getName()+s.getPerson());
	}
}
}
