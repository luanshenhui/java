package com.yulin.lsh;

import java.util.List;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		DAO dao=new DAOImpl();
		
		Member member=new Member(1,"����",30);
		//���(ʹ��������������)
		dao.add(member); 
		//�������ֲ�ѯԱ��(����Ա������Ψһ)
		member=dao.getMemberByName("����");
//		//����Ա��
		dao.update("��");
//		ɾ��
		dao.delete(member);
//		//������
		List<Member>list=dao.getAll();
		System.out.println(list);
	}

}
