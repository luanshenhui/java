package day01;
import java.util.Random;//Java �����API
/**
 * ������� A ~ Z ��ĳ���ַ� 
 * 1�����ʹ������� API
 * 2�������ǿ��Բ��������
 */
public class Demo10 {
  public static void main(String[] args) {
    Random random = new Random();
    //random.nextInt(26)�������ɷ�Χ [0,26)����� 
    //()������Ƿ�Χ���߸���   + ���������Ǵ��Ŀ�ʼ
    int n = random.nextInt(26)+0;
    System.out.println(n);
    //'A' + n , n ��Χ [0,26)  
    char c = (char)('A'+n);
    System.out.println(c); 
    //System.out.println('��'*'��'); 
  }
}


