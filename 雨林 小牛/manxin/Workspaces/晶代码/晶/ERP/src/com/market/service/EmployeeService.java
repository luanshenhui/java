package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Employee;

public interface EmployeeService {
	public void save(Employee employee);

	public void update(Employee employee);

	public void delete(Employee employee);

	public Employee getEmployee(Employee employee);

	public Employee getEmployee(Long id);

	public List<Employee> findPageInfoEmployee(Employee employee,
			PageBean pageBean);

	public Integer getCount(Employee employee);
}
