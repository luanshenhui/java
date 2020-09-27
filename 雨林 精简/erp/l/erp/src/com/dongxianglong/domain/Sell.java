/**
 * 
 */
package com.dongxianglong.domain;

/**
 * @author 董祥龙
 *
 * 2015-2-2上午11:18:56
 * 销售表类
 */
public class Sell extends BaseDomain {

	
	private String selldate;
	
	private double number;
	
	private double moneysum;
	
	private Person person=new Person();
	
	private Product product=new Product();

	public Sell() {
		this("",0.0,0.0);
	}
	public Sell(String selldate, double number, double moneysum) {
		super();
		this.selldate = selldate;
		this.number = number;
		this.moneysum = moneysum;
	}

	public String getSelldate() {
		return selldate;
	}

	public void setSelldate(String selldate) {
		this.selldate = selldate;
	}

	public double getNumber() {
		return number;
	}

	public void setNumber(double number) {
		this.number = number;
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
		return "Sell [moneysum=" + moneysum + ", number=" + number
				+ ", selldate=" + selldate + "]";
	}
	
	
}
