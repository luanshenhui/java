package day01;
/**
 *  * 7) �����ַ�������ʹ��ת���ַ���д
 *   '\n' new line ����
 *   '\r' return �س�
 *   '\t' tab �ַ�
 *   '\\' \ �ַ�
 *   '\'' ������
 *   '\"' ˫����
 *   '\u4e2d' unicode 16���Ʊ���  
 * 8) �����ַ�Ҳ���ַ����磺�س������У��˸�ȣ�
 *    ���ǿ����ַ������ʾЧ��������
 */
public class Demo09 {
  public static void main(String[] args) {
    char c = '\'';
    System.out.println(c);//'
    c = '\u4e2d';
    System.out.println(c);//��
    c = '\b';
    System.out.println(c);
  }
}




