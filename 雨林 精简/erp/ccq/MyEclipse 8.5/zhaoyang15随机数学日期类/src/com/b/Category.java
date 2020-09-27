package com.b;

public class Category extends Farther {
	Product[] arr = new Product[2];
	int i = 0;

	public Category(int id, String name) {
		super(id, name);
	}

	public void add(Product p1) {
		// TODO Auto-generated method stub
		arr[i++] = p1;
	}

	@Override
	public String toString() {
		String s = this.getName() + this.getId();
		for (Product q : arr) {
			s = s + q;
		}
		return s;
	}

}
