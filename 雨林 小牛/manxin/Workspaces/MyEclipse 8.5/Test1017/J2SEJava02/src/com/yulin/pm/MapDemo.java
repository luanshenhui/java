package com.yulin.pm;
import java.util.*;

public class MapDemo {

	/**
	 * Map散列表
	 */
	public static void main(String[] args) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("Monty", "明明");	//增加数据
		map.put("熊大", "朴艳明");	//增加数据
		
		System.out.println(map.get("Monty"));	//取数据
	}

}
