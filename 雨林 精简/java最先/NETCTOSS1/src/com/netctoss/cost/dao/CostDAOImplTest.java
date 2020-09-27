package com.netctoss.cost.dao;

import static org.junit.Assert.fail;

import java.util.List;

import org.junit.Test;

import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class CostDAOImplTest {

	@Test
	public void testFindAll() {
		ICostDAO dao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		try {
			List<Cost> list=dao.findAll();
			for(Cost c:list){
				System.out.println("id:"+c.getId());
			}
		} catch (DAOException e) {
			e.printStackTrace();
		}
	}

	@Test
	public void testGetTotalPage() {
		ICostDAO dao=DAOFactory.getCostDAO();
		try {
			System.out.println(dao.getTotalPage(3));
		} catch (DAOException e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testFindByPage() {
		ICostDAO dao=DAOFactory.getCostDAO();
		try {
			List<Cost> list=dao.findByPages(1, 3);
			for(Cost cost:list){
				System.out.println("id:"+cost.getId());
			}
		} catch (DAOException e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testFindById() {
		ICostDAO dao=DAOFactory.getCostDAO();
		try {
			Cost c=dao.findById(1);
			System.out.println(c);
		} catch (DAOException e) {
			e.printStackTrace();
		}
	}
	@Test
	public void testFindByName() {
		ICostDAO dao=DAOFactory.getCostDAO();
		try {
			Cost c=dao.findByName("5.9元套餐");
			System.out.println(c);
		} catch (DAOException e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testModify() {
		ICostDAO dao=DAOFactory.getCostDAO();
		try {
			Cost c=dao.findByName("5.9元套餐");
			c.setStatus("1");
			dao.modify(c);
			System.out.println(c);
		} catch (DAOException e) {
			e.printStackTrace();
		}
	}
	@Test
	public void testSave() {
		ICostDAO dao=DAOFactory.getCostDAO();
		try {
			Cost c=new Cost();
			c.setName("aaa");
			c.setBaseDuration(200);
			c.setBaseCost(15.0);
			c.setUnitCost(0.3);
			c.setDescr("lehhe");
			c.setCostType("0");
			dao.save(c);
			System.out.println(dao.findByName("aaa"));
			
		} catch (DAOException e) {
			e.printStackTrace();
		}
	}
	@Test
	public void testASC() {
		ICostDAO dao=DAOFactory.getCostDAO();
		try {
			System.out.println(dao.findByPagesAsc(1, 3, "base_duration"));
		} catch (DAOException e) {
			e.printStackTrace();
		}
	}
}
