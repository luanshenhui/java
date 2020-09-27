package com.text;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Client {

	

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		File file = new File("f:\\Ա����Ϣ.txt");
		List<Member> list = menthod(file);
		for (Member m : list) {
			System.out.println(m);
		}

	}

	private static List<Member> menthod(File file) {
		FileReader in = null;
		BufferedReader bu = null;
		List<Member> list = new ArrayList<Member>();
		try {

			in = new FileReader(file);// �����ļ��ֽ�������
			bu = new BufferedReader(in);// ���������ַ�������(�ַ�)
			// ���ж�ȡ�ı�
			String str = "";//str��һ�У�whileѭ��һ��
			while ((str = bu.readLine()) != null) {
				//System.out.println(str);
				String[] mm = str.split(",");

//				String name = null;
//				char sex = 0;
//				int age = 0;
//				double salary = 0;
				
				
//				String name=mm[0];
//				char sex=mm[1].charAt(0);
//				int age=Integer.parseInt(mm[2]);
//				double salary=Double.parseDouble(mm[3]);
				Member m = new Member(mm[0], mm[1].charAt(0), Integer.parseInt(mm[2]), Double.parseDouble(mm[3]));
				
				m.setName(mm[0]);
				m.setSex(mm[1].charAt(0));
				m.setAge(Integer.parseInt(mm[2]));
				m.setSalary(Double.parseDouble(mm[3]));
				
				
				list.add(m);

				
//				Member m=new Member(mm[0],mm[1].charAt(0),Integer.parseInt(mm[2]),Double.parseDouble(mm[3]));
//				
//				list.add(m);
				
//				list.add(new Member(mm[0], mm[1].charAt(0), Integer
//						.parseInt(mm[2]), Double.parseDouble(mm[3])));
				
//			while...	
//			String[] arr = str.split(",");
//				Member m=new Member();
//				m.setName(arr[0]);
//				m.setAge([arr[1]);
//				list.add(m));
				
			}

			// �ر�io��

		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("����ļ�·���쳣");
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				bu.close();
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

		return list;
	}

}
