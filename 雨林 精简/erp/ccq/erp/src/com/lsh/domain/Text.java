package com.lsh.domain;

import java.util.List;

import com.lsh.dao.CategoryDAO;
import com.lsh.dao.CategoryDAOImpl;
import com.lsh.dao.PersonDAO;
import com.lsh.dao.PersonDAOImpl;
import com.lsh.dao.ProductDAO;
import com.lsh.dao.ProductDAOImpl;
import com.lsh.util.IDUtil;

public class Text {
	public static void main(String[] args) {
		PersonDAO dao = new PersonDAOImpl();
		List<Person> list = dao.getAll();
		for (Person p : list) {
			System.out.println(p);
//			System.out.println(p.getId());
//			System.out.println(p+p.getRoleaction().getRolename());
		}
		
//		Person p=new Person();
//		System.out.println(p.getId());
		
//		long a=IDUtil.getId();
//		Person person=new Person("ÕÅÈý","123","ÄÐ",25,"ring136@.com",13610966561l,2500);
//		dao.add(person);

//		Person person= dao.getByID(1);
//		System.out.println(person);

//		ProductDAO dao = new ProductDAOImpl();
//		List<Product>list = dao.getAll();
//		for (Product p : list) {
//			System.out.println(p);
//		}
		
		
//		CategoryDAO dao = new CategoryDAOImpl();
//		List<Category>list = dao.getAll();
//		for (Category p : list) {
//			System.out.println(p);
//		}
		
//		dao.add(person);
		
	}

}
