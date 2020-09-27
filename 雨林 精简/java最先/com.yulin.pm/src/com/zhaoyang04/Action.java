package com.zhaoyang04;

import java.util.List;



public class Action {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CompanyDAO dao= new CompanyDAOIpml();
		Company company=dao.getAllById(1);
		System.out.println("     ??    " +company);
		
//		MemDAO dao2=new MemDAOImpl();
//		Mem member=dao2.getMemByID(2);
//		System.out.println("   "+member);
		
		List<Mem>list=company.getList();
		for(Mem m:list){
			System.out.println("     !!     "+ m);
		}

	}

}
