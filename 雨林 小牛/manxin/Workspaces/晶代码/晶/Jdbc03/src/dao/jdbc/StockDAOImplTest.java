package dao.jdbc;

import static org.junit.Assert.fail;

import org.junit.Test;

import util.Factory;
import dao.IStockDAO;
import entity.Stock;

public class StockDAOImplTest {

	@Test
	public void testFindbyStockNo() throws Exception {
		IStockDAO dao = 
			(IStockDAO) Factory.getInstance(
					"IStockDAO");
		Stock s = dao.findbyStockNo("600015");
		System.out.println(s);
	}

	@Test
	public void testModify() throws Exception {
		IStockDAO dao = 
			(IStockDAO) Factory.getInstance(
					"IStockDAO");
		Stock s = dao.findbyStockNo("600015");
		s.setQty(s.getQty() + 10);
		dao.modify(s);
	}

}
