package com.a;

public class B {
	public static void main(String[] args) {
		/*
		 * java�����쳣�Ĵ�������2��
		 * 1��������(�Լ�����)��try��catch��finally
		 * try;�������ܳ����쳣�Ĵ���
		 * catch�������Ӧ���쳣��Ȼ������쳣��Ϣ�����¼�쳣��Ϣ
		 * finally:�����Ƿ����쳣�׳�����һ����ִ�е����顣
		 * 2���׳�(���õĴ���)��throw��throws
		 * throw���ڴ����ں���(������)�ڲ��׳��쳣��
		 * throws���ں������������崦�����׳��쳣��
		 */
		try{
		String str=null;
		//�������쳣ʱ�����������ֹ���׳��쳣//���������ֹ
			System.out.println(str.equals("abc"));
		}catch(NullPointerException e){
			//����쳣��Ϣ
			e.printStackTrace();
			System.out.println("�������׳���һ����ִ����");
		}catch(ArithmeticException e){
			//����쳣��Ϣ
			e.printStackTrace();
			System.out.println("�������׳���һ����ִ����");
		}catch(/*ArrayIndexOutOfBounds*/Exception e){
			//����쳣��Ϣ
			e.printStackTrace();
			System.out.println("�������׳���һ����ִ����");
		}finally{
			System.out.println("����ִ�е�����");
		}
		}
}
