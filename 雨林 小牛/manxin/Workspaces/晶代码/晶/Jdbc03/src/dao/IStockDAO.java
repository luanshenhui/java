package dao;

import entity.Stock;

public interface IStockDAO {
	public Stock findbyStockNo(String stockNo)
	throws Exception;
	public void modify(Stock s) throws Exception;
}
