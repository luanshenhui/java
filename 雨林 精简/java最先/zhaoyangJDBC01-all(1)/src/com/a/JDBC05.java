package com.a;


public class JDBC05 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub余额
		Bank bank=new Bank(1,"小青","1245",2500);
		DAO dao=new DAOImpl();
		//
		dao.add(bank);//将账号对象添加到数据库中
		
		Bank bank2=dao.findBankID(3);//查抄id=3的账号对象
		
		System.out.println(bank2);

	}

}
