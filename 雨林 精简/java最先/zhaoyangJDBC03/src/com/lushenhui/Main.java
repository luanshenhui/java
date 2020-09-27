package com.lushenhui;

import java.util.List;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MemberDAO dao=new MemberDAOImpl();
		List<Member>list=dao.getAll();
		for(Member member:list){
			System.out.println(member);
		}
	}

}
