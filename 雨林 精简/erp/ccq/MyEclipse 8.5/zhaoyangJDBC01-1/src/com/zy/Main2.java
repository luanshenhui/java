package com.zy;

public class Main2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Dao dao=new DaoImpl();
		Bank bank=dao.findBankByID(1);
		System.out.println(bank);
		
		bank.setName("������");
		bank.setPassword("123123");
		
		dao.update(bank);//��bank�ı仯�ı���ȥ
		//��ʾ���޸�ԭ�򣬸���id�޸����������ֶε�ֵ
		
		bank=dao.findBankByID(1);
		System.out.println(bank);

	}

}
