package com.lsh.domen;
/*
 * 所有领域模型父类
 */
public abstract class Basedemon {
	private int id;

	public Basedemon(int id) {
		this.id = id;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
}
