package day03;
/**
 * ����
 *  sum  =   9 +        99       + 999 + 9999 + ... n��9
 * i   =     1           2           3
 * num=0 num*10+9  num*10+9   num*10+9
 *       sum=+num  sum=+num   sum=+num
 *       9+99+999+9999+99999
 *       
 */











public class Demo08 {
	public static void main(String[] args) {
		long sum = 0;
		long num = 0;
		for(int i=1; i<=7; i++){
			//i=2
			num = num*10+9;
			sum += num;//����������ڸ��ٱ����ı仯���
			//System.out.println(i+","+num+", "+sum);//�������
		}
		System.out.println(sum);
	}

}
