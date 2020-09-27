package com.yulin.dangdang.bean;

import java.io.Serializable;

public class Category implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private int turn;
	private String en_name;
	private String name;
	private String description;
	private int parent_id;

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getTurn() {
		return turn;
	}
	public void setTurn(int turn) {
		this.turn = turn;
	}
	public String getEn_name() {
		return en_name;
	}
	public void setEn_name(String enName) {
		en_name = enName;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public int getParent_id() {
		return parent_id;
	}
	public void setParent_id(int parentId) {
		parent_id = parentId;
	}
	
	@Override
	public String toString() {
		return "Category [description=" + description + ", en_name=" + en_name
				+ ", id=" + id + ", name=" + name + ", parent_id=" + parent_id
				+ ", turn=" + turn + "]";
	}
	public Category(int id, int turn, String enName, String name,
			String description, int parentId) {
		super();
		this.id = id;
		this.turn = turn;
		en_name = enName;
		this.name = name;
		this.description = description;
		parent_id = parentId;
	}
	public Category() {
		super();
	}
	
	public class Count{
		private int id;
		public int getId() {
			return id;
		}
		public void setId(int id) {
			this.id = id;
		}
		private String name;
		private int count;
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public int getCount() {
			return count;
		}
		public void setCount(int count) {
			this.count = count;
		}
		public Count() {
			super();
		}
		public Count(int id, String name, int count) {
			super();
			this.id = id;
			this.name = name;
			this.count = count;
		}
		@Override
		public String toString() {
			return "Count [count=" + count + ", id=" + id + ", name=" + name
					+ "]";
		}
	}
}
