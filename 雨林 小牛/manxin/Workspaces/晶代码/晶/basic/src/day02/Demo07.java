package day02;
/**
 * �߼����� : &&�� ����   ||�� ����   !�� ���� 
 * &&��& ǰ���Ƕ�·���� �����ǷǶ�·����
 */
public class Demo07 {
	public static void main(String[] args) {
		int age = 62; // 57;
		char sex = 'Ů';
		if( sex == 'Ů' && age >= 60 ){
			System.out.println("��ӭ����! ��������֮��!");
		}else{
			System.out.println("��ӭ�´ι���!");
		}
		//�ж�һ���ַ��Ƿ���Ӣ�Ĵ�д�ַ�
		char c = 'K';//'��'20013 'A' ~ 'Z'  65 ~ 90  65<=c<=90 
		if( c>='A' && c<='Z' ){
			System.out.println("�Ǵ�д��ĸ:"+c); 
		}
		//�ж�һ���ַ��Ǵ�д����Сд��ĸ	
		c = 'h';//104
		if( (c>='A' && c<='Z') || (c>='a' && c<='z')){
			System.out.println("��Ӣ����ĸ:"+c); 
		}
		System.out.println((int)'h'); 
	}
}





