package com.a;

public class Text {

	public static void main(String[] args) {
		//�ͻ���
		
	//	Car/*Audi*/ car=new Audi();
//		car.driver();
		
		//1����ת��(���������֮�������ת��)
		
	//���/����	 ����/��ʾ��=new
		/*   Audi audi=new Audi();
		
		//����ת����
		Car car=audi;//�����͸��������ͣ�һ��ʱ��ȫ��
		//����������ת����Ҫǿ������ת��
		Audi a=(Audi)car;    */
	//	Benz b=(Benz)car;//�������
		//Ϊ�˷�ֹ����ת���쳣����Ҫʹ��instanceof�������
		//���car��Audi�Ķ�����Ϊtrue��������false
		Car car=new Audi();
		if(car instanceof Audi){
			Audi audi=(Audi)car;
		}
		//�̳й�ϵ�µĳ�ʼ��˳��//
		//һ�����ǣ���̬���Ǿ�̬�����췽��
		//�̳й�ϵ���ǡ����ྲ̬�����ྲ̬������Ǿ�̬�����๹�졷����Ǿ�̬�����๹��
	}
//final���α�����ʾ����(������ͬʱ�������ʼ��)
	//final �������ʾ�㶨������࣬�����������౻�̳�
	//final ���εķ������ܱ���д
}
