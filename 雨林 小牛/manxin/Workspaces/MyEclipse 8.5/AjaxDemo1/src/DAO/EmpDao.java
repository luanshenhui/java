package DAO;

import java.util.List;

import entity.Emp;

public interface EmpDao {
	List<Emp> findAll() throws Exception;
	
	List<Emp> findById(int id) throws Exception;
	

	Emp findLogin(String name, String pwd)throws Exception;
	void regist(Emp emp) throws Exception;
	Emp findLoginId(int id) throws Exception;

	Emp findName(String name) throws Exception;
}
