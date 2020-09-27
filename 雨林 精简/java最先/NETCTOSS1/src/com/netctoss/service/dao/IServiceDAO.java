package com.netctoss.service.dao;

import java.util.List;

import com.netctoss.account.entity.Account;
import com.netctoss.exception.DAOException;
import com.netctoss.service.entity.QueryCodi;
import com.netctoss.service.entity.Service;
import com.netctoss.service.entity.ServiceUpdate;
import com.netctoss.service.vo.ServiceVO;

public interface IServiceDAO {
	/**
	 * 
	 * @param q查询条件
	 * @param page页数
	 * @param pageSize页容量
	 * @return
	 * @throws DAOException
	 */
	public List<ServiceVO> findByCodition(QueryCodi q, int page, int pageSize)
			throws DAOException;

	public int getTotalPage(QueryCodi q, int pageSize) throws DAOException;

	public void SetStart(int id) throws DAOException;

	public void SetPause(int id) throws DAOException;

	public void SetDelete(int id) throws DAOException;

	public Account findAccountByServiceId(int serviceId) throws DAOException;

	public void save(Service s) throws DAOException;

	public ServiceVO findById(int id) throws DAOException;

	public void saveServiceBak(ServiceUpdate sud) throws DAOException;

	public ServiceUpdate findServiceUpdateByServiceId(int ServiceId) throws DAOException;

	public void updateServiceUpdate(ServiceUpdate sud) throws DAOException;
}
