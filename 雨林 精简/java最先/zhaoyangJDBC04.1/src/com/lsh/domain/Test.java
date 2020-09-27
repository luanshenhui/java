package com.lsh.domain;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSession;//�Ի�



public class Test {

	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//��ȡmybatis���������ļ�
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2��ȡsqlsession����
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//������
			//3��ȡsqlsession����
			SqlSession session=factory.openSession();
			//4ִ��sql���
			//���ļ�
//			Member member=session.selectOne("com.lsh.domain.Member.getMemberByID","3");
//			System.out.println(member);
			//4.2
//			Member member=new Member(10,"����","Ů",4500.5,"�г���");
//			session.insert("com.lsh.domain.Member.add",member);
			//4.3
			Member member=session.selectOne("com.lsh.domain.Member.getMemberByID",2);
			System.out.println(member);
			member.setName("����");
			member.setSex("Ů");
			member.setSalary(10000);
			member.setDepartment("���ز�");
			session.update("com.lsh.domain.Member.update",member);
			//(4.4)
//			session.delete("com.lsh.domain.Member.delete",1);
			//(4.5)��ѯ
//			List<Member>list=session.selectList("com.lsh.domain.Member.all");
//			for(Member m:list){
//				System.out.println(m);
//			}
			session.commit();
			session.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
