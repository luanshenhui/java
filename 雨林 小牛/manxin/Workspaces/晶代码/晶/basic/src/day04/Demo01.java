package day04;
/**
 * while��do  while������  while�����ж���ִ��  do  while����ִ�к��ж�
 * do while����ִ��һ�� 
 * 
 * do{
 *   //ѭ����(1)
 * }while(ѭ������(2));
 * 
 * ִ�����̣�
 * {(1)->(2)}-true->{(1)-(2)}-true->{(1)->(2)}-false->����
 * 
 * �ص㣺ѭ������������ѭ������λ���жϣ�ѭ�����ȱ�ִ��
 * ʾ������һ��������ת���� 
 *   1) ȡ�����������һλ
 *   2) �ۼ�
 *   3) ������ȥ���һλ
 *   4) ���������Ϊ�� ���� (1)
 */
public class Demo01 {
	public static void main(String[] args) {
		int num = 52833;
		int sum = 0;
		do{
			int last = num%10;
			sum = sum*10 + last;
			num /= 10;
			System.out.println(last+","+num+","+sum); 
		}while(num != 0);//��� num!=0 ����true ���ٴ�ִ��ѭ�� 
		System.out.println(sum); 
	}
}



