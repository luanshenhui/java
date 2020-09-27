package dao.jdbc;

import java.util.List;

import org.junit.Test;

import util.Factory;
import dao.EmployeeDAO;
import entity.Employee;

public class EmployeeDAOImplTest {

	@Test
	public void testFindAll() throws Exception {
		EmployeeDAO  dao = 
			(EmployeeDAO) Factory.getInstance(
					"EmployeeDAO");
		List<Employee> employees = dao.findAll();
		System.out.println(employees);
	}
	
	@Test
	public void testDelete() throws Exception {
		EmployeeDAO  dao = 
			(EmployeeDAO) Factory.getInstance(
					"EmployeeDAO");
		dao.delete(1);
	}
	
	@Test
	public void testSave() throws Exception {
		EmployeeDAO  dao = 
			(EmployeeDAO) Factory.getInstance(
					"EmployeeDAO");
		Employee e = new Employee();
		e.setName("emptest");
		e.setSalary(20000);
		e.setAge(22);
		dao.save(e);
	}
	
	@Test
	public void testFindById() throws Exception {
		EmployeeDAO  dao = 
			(EmployeeDAO) Factory.getInstance(
					"EmployeeDAO");
		Employee e = dao.findById(4);
		System.out.println(e);
	}
	
	@Test
	public void testModify() throws Exception {
		EmployeeDAO  dao = 
			(EmployeeDAO) Factory.getInstance(
					"EmployeeDAO");
		Employee e = dao.findById(4);
		e.setSalary(e.getSalary() + 10000);
		e.setAge(e.getAge() + 20);
		dao.modify(e);
	}

}
