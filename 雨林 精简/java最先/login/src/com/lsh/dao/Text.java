package com.lsh.dao;

import java.util.List;

import action.Action;

import com.lsh.qq.Person;

public class Text {
	public static void main(String[] args) {
		PersonDAO dao = new PersonDAOImpl();
		List<Person> list = dao.getAll();
		for (Person p : list) {
			System.out.println(p);
		}
		

	}

}
