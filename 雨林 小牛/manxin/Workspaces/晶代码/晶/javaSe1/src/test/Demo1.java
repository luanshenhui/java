package test;

import java.util.ArrayList;
import java.util.List;

public class Demo1 {
	public static void main(String[] args) {
		List list = new ArrayList();
		list.add(1);
		list.add("ss");
		
		//ʵ�ʿ����� ����list����ŵ���ĳһ��Ķ��� �����ܻ���ַźܶ�����
		//�͵Ķ���  �㻹��ʹ�ü���
		//<>�з���  �涨����ֻ�ܷ��������͵�����
		List<String> list1 = new ArrayList<String>();
		list1.add("s");
	}
}
