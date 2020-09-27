/**
 * 
 */
package com.lsh.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * @author 栾慎辉
 *
 * 2015-2-2上午11:19:12
 * 
 * 进货表
 */
public class Stock extends BaseDomain {
	
	private String stockdate;
	private String stockmount; 
	private String moneysum;
	private Person person=new Person();
	private Product product =new Product();
	
	
	public Stock() {
		this("","","");
	}
	public Stock(String stockdate, String stockmount, String moneysum) {
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
	public String getStockmount() {
		return stockmount;
	}
	public void setStockmount(String stockmount) {
		this.stockmount = stockmount;
	}
	public String getMoneysum() {
		return moneysum;
	}
	public void setMoneysum(String moneysum) {
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
		return "Stock [moneysum=" + moneysum + ", stockdate=" + stockdate
				+ ", stockmount=" + stockmount + "]";
	};

}
