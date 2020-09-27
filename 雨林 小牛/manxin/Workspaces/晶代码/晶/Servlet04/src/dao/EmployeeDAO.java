package dao;

import java.util.List;

import entity.Employee;

public interface EmployeeDAO {
	public List<Employee> findAll() throws Exception;
	public void delete(int id) throws Exception;
	public void save(Employee e) throws Exception;
	public Employee findById(int id) throws Exception;
	public void modify(Employee e) throws Exception;
}
