package day04;
/**
 * �ҵ� 100 ~ 999 ֮���ȫ��ˮ�ɻ�����3λ�������� 
 *  һ����λ��   ��ÿһλ�����ó��� Ȼ��ÿһλ������  ���  ����ԭ������
 * 1) �ȼ���һ���� num �Ƿ���ˮ�ɻ���
 *    1.1 ��ÿλ�����ۼ�3�η��ĺ� �� ԭʼ�� ���бȽ�
 * 2) �ٲ��� 100 ~ 999 ��Χ�ڵ�ȫ��ˮ�ɻ���
 */
public class Demo02 {
	public static void main(String[] args) {
		for(int n=100; n<=999; n++){
			//n=100 ~ 999
			//int n = 153;
			int num = n;
			int sum = 0;
			do{
				int last = num%10;
				sum += last*last*last;//3�η���
				num /= 10;
				//System.out.println(last+","+num+","+sum); 
			}while(num!=0);
			if(sum == n){
				System.out.println(n+"��ˮ�ɻ���");
			}
		}
	}
}



