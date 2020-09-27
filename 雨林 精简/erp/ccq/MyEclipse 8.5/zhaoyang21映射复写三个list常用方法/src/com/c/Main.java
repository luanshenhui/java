package com.c;

import java.util.HashMap;
import java.util.Map;

public class Main {

	
	public static void main(String[] args) {
			Product p1=new Product("笔记本",5000);
			Product p2=new Product("手机",6000);
			Product p3=new Product("矿泉水",4000);
			
			Map<String,Product>map=new HashMap<String,Product>();
			
			map.put("101",p1);
			map.put("102",p2);
			map.put("103",p3);
			
			
			Dao dao=new DAOImpl();
			dao.write(map,"f:\\pouduct.txt");
	}

}
