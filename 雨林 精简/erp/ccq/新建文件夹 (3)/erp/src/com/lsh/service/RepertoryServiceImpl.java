/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.dao.RepertoryDAO;
import com.lsh.dao.RepertoryDAOImpl;
import com.lsh.domain.Repertory;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-5ÏÂÎç03:56:49
 */
public class RepertoryServiceImpl implements RepertoryService {
private RepertoryDAO dao=new RepertoryDAOImpl();
	/* (non-Javadoc)
	 * @see com.lsh.service.RepertoryService#add(com.lsh.domain.Repertory)
	 */
	public boolean add(Repertory repertory) {
		// TODO Auto-generated method stub
		dao.add(repertory);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.RepertoryService#delete(long)
	 */
	public boolean delete(long id) {
		// TODO Auto-generated method stub
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.RepertoryService#getAll()
	 */
	public List<Repertory> getAll() {
		// TODO Auto-generated method stub
		return dao.getAll();
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.RepertoryService#getByID(long)
	 */
	public Repertory getByID(long id) {
		// TODO Auto-generated method stub
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.RepertoryService#update(com.lsh.domain.Repertory)
	 */
	public boolean update(Repertory repertory) {
		// TODO Auto-generated method stub
		dao.update(repertory);
		return true;
	}

}
