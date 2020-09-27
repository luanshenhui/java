package com.lsh.domain;

/**
 * 
 * @author èïÉ÷»Ô
 *
 * 2015-2-2ÉÏÎç11:55:03
 * 
 * ¿â´æ±í
 */
public class Repertory extends BaseDomain {
	
	
	 private int storage;
	 private Product product=new Product();
	 
	 
	public Repertory() {
		
	}
	public Repertory(int storage) {
		super();
		this.storage = storage;
	}
	public int getStorage() {
		return storage;
	}
	public void setStorage(int storage) {
		this.storage = storage;
	}
	
	public Product getProduct() {
		return product;
	}
	public void setProduct(Product product) {
		this.product = product;
	}
	@Override
	public String toString() {
		return "Repertory [storage=" + storage + "]";
	}

}
