package com.b;

public class Product extends Farther{

	private double price;

	public Product(int id, String name,double price) {
		super(id,name);
		this.price=price;
		
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	@Override
	public String toString() {
		return this.getName()+this.getId()+this.getPrice();
	}

}
