package day03;
/*
 * �������ı������
 */
public class Test4 {
	public Test4() {
		// TODO Auto-generated constructor stub
		//this ���õ��Ǳ��������Ĺ�����  Ҳ�Ǳ�����ڵ�һ�� 
		//���ܺ�superͬʱ����
		this(1,2);
	}
	
	public Test4(int a, int b){
		System.out.println("��Ҳ����");
	}
	public Test4(int a){
		System.out.println("���Ǳ��๹����");
	}
	public static void main(String[] args) {
		Test4 t = new Test4();
	}
}
