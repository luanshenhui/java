package com.netctoss.account.dao;

import java.util.List;

import com.netctoss.account.entity.Account;
import com.netctoss.account.entity.QueryCodi;
import com.netctoss.exception.DAOException;

public interface IAccountDAO {
	public List<Account> findAll() throws DAOException;

	public List<Account> findByCondition(QueryCodi q, int page, int PageSize)
			throws DAOException;

	public int getTotalPage(QueryCodi q, int pageSize) throws DAOException;

	public Account findById(int id) throws DAOException;

	public void setStart(int id) throws DAOException;

	public void setPause(int id) throws DAOException;

	public void setDelete(int id) throws DAOException;

	public void saveAccount(Account a) throws DAOException;

	public Account findByIdcardNo(String idcardNo) throws DAOException;

	public void modifyAccount(Account a) throws DAOException;

	public Account findByIdAndPwd(int id, String password) throws DAOException;

	public void pauseServiceByAccountId(int id) throws DAOException;
	public void deleteServiceByAccountId(int id) throws DAOException;
}
