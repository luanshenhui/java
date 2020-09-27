/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Repertory;
import com.sun.org.apache.regexp.internal.recompile;

/**
 * @author ��ѧ��
 *
 * 2015-2-2����5:15:31
 *RepertoryDAOʵ����
 */
public class RepertoryDAOImpl extends BaseDAO implements RepertoryDAO {
	private static final String NANMSPACE="com.f.domain.Repertory.";
	/* (non-Javadoc)
	 * @see com.f.DAO.RepertoryDAO#add(com.f.domain.Repertory)
	 */
	public void add(Repertory repertory) {
		session.insert(NANMSPACE+"add", repertory);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.RepertoryDAO#update(com.f.domain.Repertory)
	 */
	public void update(Repertory repertory) {
		// TODO �޸���Ϣ
		
		session.update(NANMSPACE+"update",repertory);
		System.out.println("i");
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.RepertoryDAO#delete(long)
	 */
	public void delete(long id) {
		
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.RepertoryDAO#getByID(long)
	 */
	public Repertory getByID(long id) {
		Repertory repertory =session.selectOne(NANMSPACE+"getByID", id);
		return repertory;
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.RepertoryDAO#getAll()
	 */
	public List<Repertory> getAll() {
		List<Repertory> list=session.selectList(NANMSPACE+"getAll");
		return list;
	}
	public static void main(String[] args) {
		Repertory repertory=new RepertoryDAOImpl().getByID(2489);
		
		repertory.setStorge(55);
		
		new RepertoryDAOImpl().update(repertory);
	}
	
}
