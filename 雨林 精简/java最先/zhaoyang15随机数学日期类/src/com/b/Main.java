package com.b;

public class Main {
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Product p1 = new Product(101, "��Ȫˮ", 2.00);
		Product p2 = new Product(102, "������", 2.50);

		Category c = new Category(90, "СʳƷ");//�������
		
		c.add(p1);
		c.add(p2);

		DAO dao = new DAOImpl();
		
		dao.print(p1);//�����Ʒ��Ϣ
		dao.print(p2);
		dao.print(c);//��������Ʒ
	}

}
