package day01;
/*
 * ���ںܶ��඼ʹ�����session�������
 * ������ʹ�ü̳����ֶ�������  Ҳ����
 * �ںܶ಻ͬ���඼��̳������  
 * ��ô�̳���������һ��session����
 * Ȼ����˼��һ��  ��session�������������ʲô��
 */
public class Person {
	//һ����Ķ�����Ե�����һ����ĳ�Ա����
	Person a1 = new Person();
	//son a1 = new son();
	public Person getA(){
		return a1;
	}
	public void cc(){
		a1.cc();
	}
}
class son extends Person{
	public void test(){
		a1.cc();
		a1.getA();
	}
}
class a extends Person{ 
	public void d(){
		a1.cc();
		}
	}
