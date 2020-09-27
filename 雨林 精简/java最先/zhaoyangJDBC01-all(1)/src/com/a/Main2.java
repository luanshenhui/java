package com.a;

public class Main2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DAO dao=new DAOImpl();
		Bank bank=dao.findBankID(4);
		System.out.println(bank);
		
		bank.setName("张三三");
		bank.setPassword("123123");
		
		dao.update(bank);//把bank的变化改表里去
		//提示：修改原则，根据id修改其余所有字段的值
		
		bank=dao.findBankID(4);
		System.out.println(bank);

	}

}
