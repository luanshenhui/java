/**
 * 
 */
package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Sell;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-2ÏÂÎç05:32:46
 */
public class SellDAOImpl extends BaseDAO implements SellDAO {
	private static final String NAMESPACE="com.lsh.domain.Sell";
	/* (non-Javadoc)
	 * @see com.lsh.dao.SellDAO#add(com.lsh.domain.Sell)
	 */
	public void add(Sell sell) {
		// TODO Auto-generated method stub
		session.insert(NAMESPACE+".add",sell);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.SellDAO#delete(com.lsh.domain.Sell)
	 */
	public void delete(long id) {
		// TODO Auto-generated method stub
		session.delete(NAMESPACE+".delete",id);
		session.commit();

	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.SellDAO#getAll()
	 */
	public List<Sell> getAll() {
		// TODO Auto-generated method stub
		List<Sell>list=session.selectList(NAMESPACE+".all");
		
		return list;
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.SellDAO#getByID(long)
	 */
	public Sell getByID(long id) {
		// TODO Auto-generated method stub
		Sell sell=session.selectOne(NAMESPACE+".getID",id);
		return sell;
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.SellDAO#update(com.lsh.domain.Sell)
	 */
	public void update(Sell sell) {
		// TODO Auto-generated method stub
		session.update(NAMESPACE+".update",sell);
		session.commit();
	}
public static void main(String[] args) {
	SellDAO dao=new SellDAOImpl();
	List<Sell>list=dao.getAll();
	for(Sell s:list){
		System.out.println(s.getPerson()+s.getPerson().getUsername());
		System.out.println(s);
		System.out.println();
	}
}
}
