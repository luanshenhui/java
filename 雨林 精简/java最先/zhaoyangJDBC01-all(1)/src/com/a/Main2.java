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
		
		bank.setName("������");
		bank.setPassword("123123");
		
		dao.update(bank);//��bank�ı仯�ı���ȥ
		//��ʾ���޸�ԭ�򣬸���id�޸����������ֶε�ֵ
		
		bank=dao.findBankID(4);
		System.out.println(bank);

	}

}
