package day01;
/**
 * �׳��쳣
 * @author Administrator
 *
 */
public class ThrowExceptionDemo {
	public static void main(String[] args) {
		try{
				Person person = new Person();
				person.setAge(10000);//�������������䣬���﷨û��
				System.out.println(person);
		}catch(Exception e){
				/**
				 * �쳣�������������õķ���
				 * void printStackTrace()
				 * ����:��������ջ��Ϣ,���ڰ������ǵ�֪�������
				 *      ��λ��
				 * 
				 * String getMessage()
				 * ����:��ȡ������Ϣ��ͨ���ǵ�֪����ԭ��
				 */
			e.printStackTrace();
 		}
		
	}
}
class Person{
	private int age;
	
	public void setAge(int age){
		if(age<0||age>100){
			//��������ʱ�쳣���׳�������Ϊ������Ϣ
			throw new RuntimeException("���䲻�Ϸ�");
		}
		this.age = age;
	}
	
	public String toString(){
		return "�ҵ�������"+age+"��";
	}
}


