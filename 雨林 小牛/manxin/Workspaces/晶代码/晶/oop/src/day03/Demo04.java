package day03;
/**
 * 2) �������û���޲���������,�������ʹ��super() ����
 *  ����Ĺ�����.
 * ��̽���: (Java Bean�淶)�����඼�ṩ�޲���������!
 */
public class Demo04 {
	public static void main(String[] args) {
		Boo b = new Boo();
	// ������: A.�����   B.�����쳣   C.��   D.Aoo(int)
	}
}
class Aoo{
	Aoo(int a){
		System.out.println("Aoo(int)"); 
	}
}
//class Boo extends Aoo{}//�������, û���޲���Aoo()������
class Boo extends Aoo{
	//Boo(){}//�������, Aoo����û�� Aoo()������
	Boo(){
		//super();//�������.
		super(8);//���� Aoo �� Aoo(int) ������
	}
}



