package com.yulin.pm;
import com.yulin.pm.Wo.No;	//�ⲿ���൱���ڲ����һ����
import com.yulin.pm.Wo.Sno;
public class InnerClassDemo1 {

	/**
	 *�ڲ�����ⲿ���Ӧ��
	 */
	public static void main(String[] args) {
//		No no = new No();	//�����������޷�ֱ�Ӵ����ڲ����ʵ��
		Wo wo = new Wo();
		No no = wo.new No();	//�ڲ�����Ҫͨ���ⲿ��Ķ�������������
		no.no();	//����ͨ�������������ڲ���ķ���
		
		Sno sno = new Sno();	//��̬�ڲ������ֱ�Ӵ���ʵ��
		sno.sno();
	}

}
class Wo{
	int a = 0;
	No no = new No();	//���ⲿ���д���һ���ڲ����ʵ��������ʹ�����еķ���
	
	public void wo(){
		no.no();
		System.out.println("�����ⲿ��ķ���");
	}
	class No{
		public void no(){
			System.out.println(a);
//			wo();	//��Ա�ڲ�����Է����ⲿ���еķ���������
		}
	}
	static int sa = 0;
	static class Sno{
		public void sno(){
			System.out.println(sa);		//��̬�ڲ���ֻ�ܵ��þ�̬�����Ժͷ���
		}
	}
}

