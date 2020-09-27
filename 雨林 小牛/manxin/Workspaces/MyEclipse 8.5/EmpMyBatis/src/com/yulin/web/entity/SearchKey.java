package com.yulin.web.entity;

public class SearchKey {
	private String keyWord;
	private int max;
	private int min;
	
	public String getKeyWord() {
		return keyWord;
	}
	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}
	public int getMax() {
		return max;
	}
	public void setMax(int max) {
		this.max = max;
	}
	public int getMin() {
		return min;
	}
	public void setMin(int min) {
		this.min = min;
	}
	public SearchKey(String keyWord, int max, int min) {
		super();
		this.keyWord = keyWord;
		this.max = max;
		this.min = min;
	}
	public SearchKey() {
		super();
	}
	@Override
	public String toString() {
		return "SearchKey [keyWord=" + keyWord + ", max=" + max + ", min="
				+ min + "]";
	}
	
}
