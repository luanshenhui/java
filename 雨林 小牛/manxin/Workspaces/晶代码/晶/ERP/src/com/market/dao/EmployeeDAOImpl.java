package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.Employee;

public class EmployeeDAOImpl extends HibernateGenericDao<Employee> implements
		EmployeeDAO {

	public void save(Employee employee) {
		super.save(employee);
	}

	public void update(Employee employee) {
		super.update(employee);
	}

	public void delete(Employee employee) {
		super.remove(employee);
	}

	public Employee getEmployee(Employee employee) {
		return get(employee.getId());
	}

	public Employee getEmployee(Long id) {
		return get(id);
	}

	public List<Employee> findPageInfoEmployee(Employee employee,
			PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM employee WHERE 1=1 ");
		sql = getStringBuffer(employee, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public Integer getCount(Employee employee) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM employee WHERE 1=1 ");
		sql = getStringBuffer(employee, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param employee
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/05/2011 create
	 */
	private StringBuffer getStringBuffer(Employee employee, StringBuffer buf,
			List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (StringUtils.isNotBlank(employee.getName())) {
			buf.append(" and name like ? ");
			args.add("%" + employee.getName().trim() + "%");
		}
		if (StringUtils.isNotBlank(employee.getEmployType())) {
			buf.append(" and employ_type = ? ");
			args.add(employee.getEmployType().trim());
		}
		return buf;
	}
}
