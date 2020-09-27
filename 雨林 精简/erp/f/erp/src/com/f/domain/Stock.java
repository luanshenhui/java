/**
 * 
 */
package com.f.domain;

/**
 * @author 冯学明
 *
 * 2015-2-2上午11:18:47
 * 
 *进货表(进)
 */
public class Stock extends BaseDomain{
		private String stockdate;
		private int stockmount;
		private double moneysum;
		
		private Person person;
		private Product product;
		
		public Stock() {
			this(0,0.0,null,null);
		}		
		
		public Stock( int stockmount, double moneysum,
				Person person, Product product) {
			super();
			
			this.stockmount = stockmount;
			this.moneysum = moneysum;
			this.person = person;
			this.product = product;
		}

		public String getStockdate() {
			return stockdate;
		}
		public void setStockdate(String stockdate) {
			this.stockdate = stockdate;
		}
		public int getStockmount() {
			return stockmount;
		}
		public void setStockmount(int stockmount) {
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
		@Override
		public String toString() {
			return "Stock [stockdate=" + stockdate + ", stockmount="
					+ stockmount + ", moneysum=" + moneysum + ", person="
					+ person + ", product=" + product + "]";
		}
		
		
		
}
