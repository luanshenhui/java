package com.zhaoyang04;

public abstract class IdFarther {
	private int id;

	/**
	 * @param id
	 */
	public IdFarther(int id) {
		super();
		this.id = id;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	@Override
	public String toString() {
		return "IdFarther [id=" + id + "]";
	}
	
}
