/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Sell;

/**
 * @author 冯学明
 *
 * 2015-2-2下午5:11:06
 *Sell的实现类
 *
 *
 */
public class SellDAOImpl extends BaseDAO implements SellDAO {
	private  static final String NAMESPACE="com.f.domain.Sell.";
	/* (non-Javadoc)
	 * @see com.f.DAO.SellDAOl#add(com.f.domain.Sell)
	 */
	public void add(Sell sell) {
		session.insert(NAMESPACE+"add",sell);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.SellDAOl#update(com.f.domain.Sell)
	 */
	public void update(Sell sell) {
		

	}

	/* (non-Javadoc)
	 * @see com.f.DAO.SellDAOl#delete(long)
	 */
	public void delete(long id) {
	
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.SellDAOl#getByID(long)
	 */
	public Sell getByID(long id) {
		Sell sell=session.selectOne(NAMESPACE+"getByID",id);
		return sell;
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.SellDAOl#getAll()
	 */
	public List<Sell> getAll() {
		List<Sell> sell=session.selectList(NAMESPACE+"getAll");
		return sell;
	}
	public static void main(String[] args) {
		
			
		SellDAO dao=new SellDAOImpl();
				
		List<Sell> sell=dao.getAll();
		for(Sell s:sell){
			System.out.print(s);
			System.out.print(s.getPerson());
			System.out.println(s.getProduct());
		}	
	}

}
