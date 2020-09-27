package com.a;

public class Main3 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DAO dao=new DAOImpl();
		Bank bank=dao.findBankID(4);
		System.out.println(bank);
		
		dao.delete(bank);
		
		bank=dao.findBankID(4);
		System.out.println(bank);

	}

}
