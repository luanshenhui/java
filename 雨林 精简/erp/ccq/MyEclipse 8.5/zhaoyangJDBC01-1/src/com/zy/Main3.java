package com.zy;

public class Main3 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Dao dao=new DaoImpl();
		Bank bank=dao.findBankByID(9);
		System.out.println(bank);
		
		dao.delete(bank);
		
		bank=dao.findBankByID(9);
		System.out.println(bank);

	}

}
