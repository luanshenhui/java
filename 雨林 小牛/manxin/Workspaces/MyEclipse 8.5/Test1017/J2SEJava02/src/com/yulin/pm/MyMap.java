package com.yulin.pm;
import java.util.*;

public class MyMap {

	/**
	 * ��ArrayListģ��һ��Map
	 */
	private ArrayList<String> keys = new ArrayList<String>();
	private ArrayList<String> values = new ArrayList<String>();
	
	public void put(String key,String value){
		keys.add(key);
		values.add(value);
	}
	
	public String get(String key){
		int index = keys.indexOf(key);
		String value = values.get(index);
		return value;
	}
	
	
	public static void main(String[] args) {

	}

}
