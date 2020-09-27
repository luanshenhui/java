/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.DAO.RepertoryDAO;
import com.f.DAO.RepertoryDAOImpl;
import com.f.domain.Repertory;


/**
 * @author ·ëÑ§Ã÷
 *
 * 2015-2-5ÏÂÎç3:33:06
 */
public class RepertoryServiceImpl implements RepertoryService {
	private  RepertoryDAO dao=new RepertoryDAOImpl();
	/* (non-Javadoc)
	 * @see com.f.service.RepertoryService#add(com.f.service.RepertoryService)
	 */
	public boolean add(Repertory repertory) {
		dao.add(repertory);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.RepertoryService#update(com.f.service.RepertoryService)
	 */
	public boolean update(Repertory repertory) {
		dao.update(repertory);
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.RepertoryService#delete(long)
	 */
	public boolean delete(long id) {
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.RepertoryService#getByID(long)
	 */
	public Repertory getByID(long id) {
		
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.f.service.RepertoryService#getAll()
	 */
	public List<Repertory> getAll() {
	
		return dao.getAll();
	}

}
