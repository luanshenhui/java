package day02;
/**
 * ��·�Ļ����� || 
 * �Ƕ�·�Ļ����� | 
 *
 */
public class Demo09 {
	public static void main(String[] args) {
		int age =25;
		char sex = 'Ů';
		if(sex=='Ů' || age++ >= 60){
			System.out.println("��ӭ��");
		}
		System.out.println(age); //25
		
		if(sex=='Ů' | age++ >= 60){
			System.out.println("��ӭ��");
		}
		System.out.println(age); //26
	}
}






