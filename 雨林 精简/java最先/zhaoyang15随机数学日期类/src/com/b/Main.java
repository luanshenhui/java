package com.b;

public class Main {
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Product p1 = new Product(101, "矿泉水", 2.00);
		Product p2 = new Product(102, "方便面", 2.50);

		Category c = new Category(90, "小食品");//创建类别
		
		c.add(p1);
		c.add(p2);

		DAO dao = new DAOImpl();
		
		dao.print(p1);//输出商品信息
		dao.print(p2);
		dao.print(c);//输出类别商品
	}

}
