package DAO;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import util.Factory;

public class EmpDAOImplTest {

	@Test
	public void testFindByPage() {
			EmpDAOImpl dao = (EmpDAOImpl) Factory.getInstance("EmpDAO");
			try {
			  List list = 	dao.findByPage(2, 2);
			  System.out.println(list);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}

}
