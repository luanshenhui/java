package day02;
/**
 * ++i
 *
 */
public class Demo05 {
	public static void main(String[] args) {
		int a = 1;
		int b;
		b = ++a;//��++: ������,��ʹ��
		//����˳��: ��++ִ�н���, �ٸ�ֵ=
		// ++ ���� 1) �Ƚ�a��ֵ����1, aΪ2
		// ++ ���� 2) ��ȡa��ֵ2��Ϊ "++a ���ʽ"��ֵ2
		// =  ���� 3) �� "++a ���ʽ"��ֵ2 ��ֵ��b Ϊ 2
		System.out.println(a+","+b);
	}

}



