package com.b;

public class MyException extends Exception{
	//�Զ����쳣���д��һ���вι��췽��
	//������ʾ���Ǵ�����Ϣ
	public MyException(String str){
		super(str);
	}

	
	public static void main(String[] args) {
		// �쳣�ĸ���
		/*
		 * �쳣��5���ؼ���
		 * 
		 * 
		 * �쳣��ϵ(�����쳣��ϵ�ֵ���ȫ�Ǿ������)
		 * Throwable�����쳣�Ķ�������
		 * 		->Error(����)(�����ڴ��洦�����ĳ���Ա������˵Ľ���������)
		 * 		->Exception(�쳣)(�����ǳ���Ա��ص���Ҫ���ǽ�����쳣)
		 * 				->RuntimeException(����ʱ�쳣)(����5�ֳ����쳣)
		 * 
		 * 
		 * �쳣��Ϊ������쳣�ͷǼ�����쳣��
		 * ������쳣���Ǳ��봦��(�����׳�)���쳣�����磺(�̳�)Exception
		 * �Ǽ�����쳣�Ǵ���Ͳ��������ԣ������Ǽ�����쳣�����磺(�̳�)Error,RuntimeException
		 * �Զ����쳣��ֱ�Ӽ̳�Exception�༴�ɡ�
		 * 
		 */
		//�Զ����쳣
		
	}

}
