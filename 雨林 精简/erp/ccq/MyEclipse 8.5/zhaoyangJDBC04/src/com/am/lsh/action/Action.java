package com.am.lsh.action;

import java.util.List;

import com.am.lsh.CompanyDAO;
import com.am.lsh.CompanyDAOImpl;
import com.am.lsh.MemDAO;
import com.am.lsh.MemDAOImpl;
import com.lsh.domen.Company;
import com.lsh.domen.Mem;

public class Action {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CompanyDAO dao= new CompanyDAOImpl();
		Company company=dao.getCompanyByID(1);
		System.out.println(company);
		
		MemDAO dao2=new MemDAOImpl();
		Mem member=dao2.getMemByID(2);
		System.out.println("   "+member);
		
		List<Mem>list=company.getList();
		for(Mem m:list){
			System.out.println(m);
		}

	}

}
