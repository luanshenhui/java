package com.zhaoyang;

public class JDBC05 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub���
		Bank bank=new Bank(10,"����","1245",5000);
		DAO dao=new DAOImpl();
		//
		dao.add(bank);//���˺Ŷ�����ӵ����ݿ���
		
		Bank bank2=dao.findBankID(3);//�鳭id=3���˺Ŷ���
		
		System.out.println(bank2);

	}

}
