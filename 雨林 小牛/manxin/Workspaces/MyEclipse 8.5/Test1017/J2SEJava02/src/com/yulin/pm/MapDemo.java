package com.yulin.pm;
import java.util.*;

public class MapDemo {

	/**
	 * Mapɢ�б�
	 */
	public static void main(String[] args) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("Monty", "����");	//��������
		map.put("�ܴ�", "������");	//��������
		
		System.out.println(map.get("Monty"));	//ȡ����
	}

}
