package day06;
/**
 * ģ��ģʽ
 * @author Administrator
 *
 */
public abstract class Person {
	/**
	 * ���к������ҽ���
	 */
	public void sayHello(){
		//��ͬ�Ĳ��ֶ���������
		System.out.println("��Һ�!");
		
		//ϸ�ڵĲ�ͬ�ӳٵ�����ȥʵ��
		System.out.println(getInfo());
		
		System.out.println("�ټ�!");
	}
	
	public abstract String getInfo();
}

//ѧ��
class Student extends Person{

	@Override
	public String getInfo() {
		return "����һ��ѧ����������12��Сѧ!";
	}
	
}

class Teacher extends Person{
	@Override
	public String getInfo() {
		
		return "����һ����ʦ����Ҳ��֪���һ�ʲô��";
	}
	
}


