package com.yulin.lsh;

import java.util.List;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		DAO dao=new DAOImpl();
		
		Member member=new Member("����",30);
		//���(ʹ��������������)
		dao.add(member); 
		//�������ֲ�ѯԱ��(����Ա������Ψһ)
		member=dao.getMemberByName("����");
		//����Ա��
		member.setName("����");
		member.setAge(40);
		dao.update(member);
//		ɾ��
//		dao.delete(member);
//		//������
		List<Member>list=dao.getAll();
		System.out.println(list);
	}

}
