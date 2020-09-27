/**
 * 
 */
package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Repertory;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-2ÏÂÎç05:30:37
 */
public class RepertoryDAOImpl extends BaseDAO implements RepertoryDAO {
private static final String NAMESPACE="com.lsh.domain.Repertory";
	/* (non-Javadoc)
	 * @see com.lsh.dao.RepertoryDAO#add(com.lsh.domain.Repertory)
	 */
	public void add(Repertory repertory) {
		// TODO Auto-generated method stub
		session.insert(NAMESPACE+".add",repertory);
		session.commit();

	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.RepertoryDAO#delete(com.lsh.domain.Repertory)
	 */
	public void delete(long id) {
		// TODO Auto-generated method stub
		session.delete(NAMESPACE+".delete",id);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.RepertoryDAO#getAll()
	 */
	public List<Repertory> getAll() {
		// TODO Auto-generated method
		List<Repertory>list=session.selectList(NAMESPACE+".all");
		return list;
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.RepertoryDAO#getByID(long)
	 */
	public Repertory getByID(long id) {
		// TODO Auto-generated method stub
		Repertory repertory=session.selectOne(NAMESPACE+".getID",id);
		return repertory;
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.RepertoryDAO#update(com.lsh.domain.Repertory)
	 */
	public void update(Repertory repertory) {
		// TODO Auto-generated method stub
		session.update(NAMESPACE+".update",repertory);
		session.commit();

	}
public static void main(String[] args) {
	RepertoryDAO dao=new RepertoryDAOImpl();
	List<Repertory>list=dao.getAll();
	for(Repertory r:list){
		System.out.println(r);
		System.out.println(r.getProduct());
		System.out.println();
	}
	Repertory repertory=dao.getByID(1);
	
}
}
