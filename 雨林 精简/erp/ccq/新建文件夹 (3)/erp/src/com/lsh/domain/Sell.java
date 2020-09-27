/**
 * 
 */
package com.lsh.domain;

/**
 * @author 栾慎辉
 *
 * 2015-2-2上午11:41:40
 * 
 * 销售表
 * 
 */
public class Sell extends BaseDomain {
	
	private String selldate;
	private String sellmount;
	private String moneysum;
	private Person person=new Person();
	private Product product=new Product();
	
	
	public Sell() {
		this("","","");
	}
	public Sell(String selldate, String sellmount, String moneysum) {
		super();
		this.selldate = selldate;
		this.sellmount = sellmount;
		this.moneysum = moneysum;
	}
	public String getSelldate() {
		return selldate;
	}
	public void setSelldate(String selldate) {
		this.selldate = selldate;
	}
	public String getSellmount() {
		return sellmount;
	}
	public void setSellmount(String sellmount) {
		this.sellmount = sellmount;
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
		return "Sell [moneysum=" + moneysum + ", selldate=" + selldate
				+ ", sellmount=" + sellmount + "]";
	}
	
	

}
