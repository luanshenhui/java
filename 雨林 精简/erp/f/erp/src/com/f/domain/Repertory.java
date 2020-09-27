/**
 * 
 */
package com.f.domain;

/**
 * @author 冯学明
 *
 * 2015-2-2上午11:34:53
 * 
 *库存表
 * 
 */
public class Repertory extends BaseDomain{
	
	
	
	private Product product;
	private long storage;
	public Repertory(){
		this(0);
	}
	
	public Repertory(long storage) {
		super();
		this.storage = storage;
	}
	public Product getProduct() {
		return product;
	}
	public void setProduct(Product product) {
		this.product = product;
	}
	public long getStorge() {
		return storage;
	}
	public void setStorge(long storage) {
		this.storage = storage;
	}

	@Override
	public String toString() {
		return "Repertory [product=" + product + ", storge=" + storage + "]";
	}
	
	
}
