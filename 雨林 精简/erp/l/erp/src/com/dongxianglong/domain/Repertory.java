/**
 * 
 */
package com.dongxianglong.domain;

/**
 * @author ¶­ÏéÁú
 *
 * 2015-2-2ÉÏÎç11:26:34
 * ¿â´æ±í
 */
public class Repertory extends BaseDomain {
	
	private double storage;
	
	private Product product=new Product();
	
	public Repertory() {
		this(0.0);
	}

	public Repertory(double storage) {
		super();
		this.storage = storage;
	}

	public double getStorage() {
		return storage;
	}

	public void setStorage(double storage) {
		this.storage = storage;
	}

	
	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public String toString() {
		return "Repertory [storage=" + storage + "]";
	}
	
	

}
