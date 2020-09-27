package com.market.service;

import java.util.List;

import com.market.dao.EmployeeDAO;
import com.market.util.PageBean;
import com.market.vo.Employee;

public class EmployeeServiceImpl implements EmployeeService {
	private EmployeeDAO employeeDAO;

	public void save(Employee employee) {
		employeeDAO.save(employee);
	}

	public void update(Employee employee) {
		employeeDAO.update(employee);
	}

	public Employee getEmployee(Employee employee) {
		return employeeDAO.getEmployee(employee);
	}

	public Employee getEmployee(Long id) {
		return employeeDAO.getEmployee(id);
	}

	public void delete(Employee employee) {
		employeeDAO.delete(employee);
	}

	public List<Employee> findPageInfoEmployee(Employee employee,
			PageBean pageBean) {
		return employeeDAO.findPageInfoEmployee(employee, pageBean);
	}

	public Integer getCount(Employee employee) {
		return employeeDAO.getCount(employee);
	}

	public void setEmployeeDAO(EmployeeDAO employeeDAO) {
		this.employeeDAO = employeeDAO;
	}
}
