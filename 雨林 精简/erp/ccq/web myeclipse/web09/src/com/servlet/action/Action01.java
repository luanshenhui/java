package com.servlet.action;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * (һ)ͨ��Servlet�������������
 * ��һ�׶Σ���ʼ���׶Σ�
 * 			�������һ�ε����ʱ��ִ�У�����ִֻ��һ�Ρ�
 * 			���� init()��init(ServletConfig config)ͬʱ���ڣ��������вεĳ�ʼ�������� 
 * �ڶ��׶Σ�����ҵ��׶�
 * 			�����󵽴��ʱ��͵��ã�ִ�ж�Σ����������ִ�ж��ٴ�
 * 			����Service��doGet��doPost��������
 * 			�������ȵ���service������service���ж��������ͣ����get���������doGet����
 * 			����ҵ�������post��������service���������doPost����������ҵ��
 * �����׶Σ����ٽ׶�
 * 			��web������ֹͣʱ��ִ�У�Ҳ��ִֻ��һ�Ρ�
 * ע��һ����web������(����)�ڵ����������ڵķ�����
 * ע�����web��������ΪServlet���ֻ����һ������Ȼ��ÿ��������һ���߳���������Ӧ����
 */
public class Action01 extends HttpServlet{

	
	//��ʼ���Ľ׶�
	public void init() throws ServletException {
		System.out.println("��һ�׶Σ���ʼ���׶�");
	}


	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
	System.out.println("�ڶ��׶Σ�����ҵ��׶�");
	}


	
	public void destroy() {
		System.out.println("�����׶Σ����ٽ׶�");
	}
	
}
