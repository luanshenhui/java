package dao;

import entity.Emp;

public interface EmpDAO {
	public abstract void save(Emp emp) throws Exception;
}
