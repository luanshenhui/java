package dao;

import org.junit.Test;

import util.Factory;

import entity.Emp;

public class EmpDAOImplTest {

	@Test
	public void testSave() {
		Emp emp =new Emp();
		emp.setName("a");
		emp.setSalary(1.1);
		emp.setAge(18);
		EmpDAO dao =(EmpDAOImpl)Factory.getInstance("EmpDAO");
		try {
			dao.save(emp);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
