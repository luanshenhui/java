package DAO;

import java.util.List;

import entity.Emp;

public interface EmpDao {
	void save(Emp emp) throws Exception;
	List<Emp> findEmp() throws Exception;
	List<Emp> findEmpById(int id) throws Exception;
	void update(Emp emp) throws Exception;
	void delete(Emp emp) throws Exception;
	List<Emp> findEmpPage(int page) throws Exception;
}
