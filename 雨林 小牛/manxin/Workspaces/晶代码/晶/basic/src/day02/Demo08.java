package day02;
/**
 * ��·�߼����� �� �Ƕ�·�߼����� 
 * && �Ƕ�·�߼����㵱��һ�����ʽ��falseʱ�򣬾�ֱ�ӵý��
 * & �Ƕ�·�߼�����
 * ���飺�����д��ʹ�� && ʵ�ֶ�·�߼�
 */
public class Demo08 {
	public static void main(String[] args) {
		int age = 25; // 57;
		char sex = '��';
		if( sex == '��' || age++ >= 60 ){
			System.out.println("��ӭ����! ��������֮��!");
		}else{
			System.out.println("��ӭ�´ι���!");
		}
		System.out.println(age);//25 ������·��,age++ û��ִ��
		
		if( sex == 'Ů' & age++ >= 6){
			System.out.println("��ӭ����! ��������֮��!");
		}else{
			System.out.println("��ӭ�´ι���!");
		}
		System.out.println(age);//26 �����Ƕ�·��,age++ ִ��

	}

}
