package day03;
/**
 * ��ӡ -128 ~ 127 ��ȫ������
 * i = -128 -127 ... 127   i++ 
 */
public class Demo06 {
	public static void main(String[] args) {
		for(int i=-128; i<=127; i++){
			String bin = Integer.toBinaryString(i);
			// i =-1 bin = "11111111... 11" 32�� bin.length()=32
		  // i = 0 bin = "0" bin.length()=1
		  // i = 1 bin = "1" bin.length()=1
		  // i = 7 bin = "111"  bin.length()=3
			//bin.length(); ����ַ����ĳ���, "0"����1
			//"111" ������3
			int n = 32 - bin.length();//n ����Ҫ���"0"�ĸ���
			// i=7  n=29
			for(int j=0; j<n; j++){//���ѭ��ִ����n��
				//int j = 0 1 2 3 ... n-1 <n, j++  ִ����n��
				System.out.print("0");//���n�� '0'
			}
			System.out.println(bin);//��n��0�Ժ����bin����
		}
	}
}
