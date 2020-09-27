/**
 * 
 */
package com.dongxianglong.domain;

/**
 * @author 董祥龙
 *
 * 2015-2-2上午11:06:19
 * 
 * 进货表类
 */
public class Stock extends BaseDomain {
	
	private String stockdate;
	
	private double stockmount;
	
	private double moneysum;
	
	private Person person=new Person();
	
	private Product product=new Product();
	
	public Stock() {
		this("",0.0,0.0);
	}

	public Stock(String stockdate, double stockmount, double moneysum) {
		super();
		this.stockdate = stockdate;
		this.stockmount = stockmount;
		this.moneysum = moneysum;
	}

	public String getStockdate() {
		return stockdate;
	}

	public void setStockdate(String stockdate) {
		this.stockdate = stockdate;
	}

	public double getStockmount() {
		return stockmount;
	}

	public void setStockmount(double stockmount) {
		this.stockmount = stockmount;
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

	public String toString() {
		return "Stock [moneysum=" + moneysum + ", stockdate=" + stockdate
				+ ", stockmount=" + stockmount + "]";
	}
	
	
	

}
