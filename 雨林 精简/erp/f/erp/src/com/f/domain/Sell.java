/**
 * 
 */
package com.f.domain;

import com.f.DAO.PersonDAO;
import com.f.DAO.PersonDAOImpl;
import com.f.DAO.ProductDAO;
import com.f.DAO.ProductDAOImpl;
import com.f.DAO.SellDAO;
import com.f.DAO.SellDAOImpl;

/**
 * @author 冯学明
 *
 * 2015-2-2上午11:27:36
 * 销售表(销)
 * 
 */
public class Sell extends BaseDomain{
	private String selldate;
	private int sellmount ;
	private double moneysum;
	private Person person;
	private Product product;
	
	public Sell(){
		this(0,0.0);
	}
	
	public Sell(int sellmount, double moneysum) {
		super();
		this.sellmount = sellmount;
		this.moneysum=moneysum;
	}

	public String getSelldate() {
		return selldate;
	}
	public void setSelldate(String selldate) {
		this.selldate = selldate;
	}
	public int getSellmount() {
		return sellmount;
	}
	public void setSellmount(int sellmount) {
		this.sellmount = sellmount;
	}
	public double getMoneysum() {
		return moneysum;
	}
	public void setMoneysum(double moneysum) {
		this.moneysum = moneysum;
	}
	

	public Person getPerson() {
		return person;
	}

	public void setPerson(Person person) {
		this.person = person;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	@Override
	public String toString() {
		return "Sell [selldate=" + selldate + ", sellmount=" + sellmount
				+ ", moneysum=" + moneysum + "]";
	}	
	public static void main(String[] args) {
		
		SellDAO dao2=new SellDAOImpl();
		
		System.out.println(dao2.getByID(112).getSelldate());
	}
}
