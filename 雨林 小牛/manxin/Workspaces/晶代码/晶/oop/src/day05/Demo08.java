package day05;
/**
 * �ڲ��ࣺ ���������ڲ����߷����� ���ࡣ
 *   �ڲ������ҪĿ���Ƿ�װ��������Ķ��巶Χ
 *  �ڲ�����Թ�������ⲿ������Ժͷ���
 */
public class Demo08 {
	public static void main(String[] args) {
		Koo k = new Koo();
		k.t();
	}
}
class Koo{
	int a = 8;
	public void t(){
		Foo f = new Foo();	f.test();
	}
	//�ڲ���, �ڲ�����Թ����ⲿ������� a
	class Foo{
		public void test(){
			System.out.println(Koo.this.a);//���� Koo��a����
		}
	}
}
