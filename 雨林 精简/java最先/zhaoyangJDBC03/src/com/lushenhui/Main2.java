package com.lushenhui;

import java.util.List;

public class Main2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MemberDAO dao=new MemberDAOImpl();
		List<Member>list=dao.search("С",2000,5000);
		
		for(Member m:list){
			System.out.println(m);
		}

	}

}
