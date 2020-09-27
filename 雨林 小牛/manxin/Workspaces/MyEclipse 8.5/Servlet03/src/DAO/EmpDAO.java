package DAO;

import java.util.List;

import entity.Emp;

public interface EmpDAO{
	List<Emp> findAll() throws Exception;
	void save(Emp emp) throws Exception;
	List<Emp> findById(int id) throws Exception;
	void update(Emp emp) throws Exception;
	void delete(int id) throws Exception;
	List<Emp> findByPage(int page, int pageSize) throws Exception;
	Emp findLogin(String name, String pwd)throws Exception;
	void regist(Emp emp) throws Exception;
	Emp findLoginId(int id) throws Exception;
	public int getTotalPages(int pageSize) throws Exception;
	Emp findName(String name) throws Exception;
}
