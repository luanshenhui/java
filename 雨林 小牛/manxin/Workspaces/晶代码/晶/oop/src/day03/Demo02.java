package day03;
/**
 * �������ǲ��ɼ̳е�   ��ʵ�Ǽ̳��˵� ������ ��һ���ɼ��Ե�����  ����
 * �˼̳е�ʱ�����˱������
 */
public class Demo02 {
	public static void main(String[] args) {
		Hoo h1 = new Hoo();//���õ��� Hoo���Ĭ�Ϲ�����
		//Hoo h2 = new Hoo(8);//�����, Hoo����û��Hoo(int) 
		//˵�� Hoo û�м̳� Goo(int) ������
	}
}
class Goo{
	int a;
	Goo(){}
	Goo(int a){	System.out.println("Goo(int)");	}
}
class Hoo extends Goo{
	
}