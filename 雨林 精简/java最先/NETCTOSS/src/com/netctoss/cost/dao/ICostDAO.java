package com.netctoss.cost.dao;

import java.util.List;

import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;

/**
 * 资费模块DAO
 * 
 * @author soft01
 *
 */
public interface ICostDAO {
	public List<Cost> findAll() throws DAOException;
	public int getTotalPage(int pageSize) throws DAOException;
	public List<Cost> findByPages(int pages,int pageSize) throws DAOException;
	public void deleteById(int id) throws DAOException;
	public Cost findById(int id) throws DAOException;
	public Cost findByName(String name) throws DAOException;
	public void modify(Cost cost) throws DAOException;
	public void save(Cost cost)throws DAOException;
	public Cost vaildModiName(int id,String name)throws DAOException;
	public List<Cost> findByPagesAsc(int pages,int pageSize,String colName)throws DAOException;
	public List<Cost> findByPagesDesc(int pages,int pageSize,String colName)throws DAOException;
}
