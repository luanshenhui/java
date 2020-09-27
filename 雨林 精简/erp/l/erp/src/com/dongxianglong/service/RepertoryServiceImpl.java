/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.dao.RepertoryDAO;
import com.dongxianglong.dao.RepertoryDAOImpl;
import com.dongxianglong.domain.Repertory;

/**
 * @author ¶­ÏéÁú
 *
 * 2015-2-5ÏÂÎç03:29:28
 */
public class RepertoryServiceImpl implements RepertoryService {
    private RepertoryDAO dao=new RepertoryDAOImpl();
	/* (non-Javadoc)
	 * @see com.dongxianglong.service.RepertoryService#add(com.dongxianglong.domain.Repertory)
	 */
	public boolean add(Repertory repertory) {
		dao.add(repertory);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.RepertoryService#getAll()
	 */
	public List<Repertory> getAll() {
		
		return dao.getAll();
	}

}
