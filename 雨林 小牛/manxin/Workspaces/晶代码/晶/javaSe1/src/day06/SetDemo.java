package day06;

import java.util.HashSet;
import java.util.Random;
import java.util.Set;

/**
 * Set����
 * ���ظ���
 * @author Administrator
 *
 */
public class SetDemo {
	public static void main(String[] args) {
		Set<Integer> set = new HashSet<Integer>();
		set.add(1);
		set.add(1);//�ظ�Ԫ�ز�����ӵ�Set������
		System.out.println("size:"+set.size());
		
		/**
		 * �򼯺������20�����ظ��������
		 * 0-100֮��
		 */
		Random r = new Random();
		int sum = 0;
//		while(set.size()<20){
//			//�������һ�����ַ���set����
//			set.add(r.nextInt(100));
//			sum++;
//		}
		for(;set.size()<20;sum++){
			set.add(r.nextInt(100));
		}
		
		System.out.println(set);
		System.out.println("���������:"+sum+"������");
		
		/**
		 * ��дһ��1+2+3+....100
		 * ÿ���ۼӺ�Ҫ������
		 * ����Ҫ�󲻵ó���20(30)��
		 * �ڳ����в��ܳ���for while���
		 */
	}
}











