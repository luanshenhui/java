/**
 * 
 */
package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Repertory;

/**
 * @author ¶­ÏéÁú
 *
 * 2015-2-2ÏÂÎç05:41:08
 */
public class RepertoryDAOImpl extends BaseDAO implements RepertoryDAO {
	private static final String NAMESPACE="com.dongxianglong.domain.Repertory.";

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.RepertoryDAO#add(com.dongxianglong.domain.Repertory)
	 */
	public void add(Repertory repertory) {
		session.insert(NAMESPACE+"add",repertory);
		session.commit();
	}


	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.RepertoryDAO#getAll()
	 */
	public List<Repertory> getAll() {
		List<Repertory>list=session.selectList(NAMESPACE+"all");
		return list;
	}

	public static void main(String[] args)
	{     
		RepertoryDAO dao=new RepertoryDAOImpl();
		List<Repertory>list=dao.getAll();
		for(Repertory r:list)
		{
			System.out.println(r);
		}
	}

}
