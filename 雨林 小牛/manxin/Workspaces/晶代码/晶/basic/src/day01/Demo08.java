package day01;
/**
 * 1���ַ���һ��16λ�޷���"����"��
 *    �ַ�����ֵ��unicode����ֵ
 *    ������Χ��0 ~ 65535
 * 2) unicode 8����� 
 *   �涨��'��' �������� 20013
 *         '��' �������� 30000
 *         'A' ������ֵ 65
 *   unicodeӢ�ı�����ASCII����һ��
 * 3) Java char ����֧���� i18n(���ʻ�), ����֧��ȫ������
 * 4) �����ı���ϵͳ�У��ֿ⣨��ģ��ֻ����ʾ20000+���֣�
 * 5�� �ַ������� ����һ��char���������� '��' 
 * 6���ַ����Բ�����ѧ����
 *   
 *   'A' �ı��� 65  
 *   'B' 66
 *    ...
 *    'Z' 90
 *   '0' 48
 *   '1' 49
 *   ...
 *   '9' 57
 *    
 * 7) �����ַ�������ʹ��ת���ַ���д
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
public class Demo08 {
  public static void main(String[] args) {
    char c = 20013;//�ַ���һ������
    System.out.println(c);//��
    c = 45666;//65535
    System.out.println(c);//������ʾ
    // a  97  A  65  0  48
    c = 'A'+2;
    System.out.println(c+"sss");//'C'
    System.out.println((int)'A'); //'A'��10���Ʊ���
    System.out.println((int)'B');
    System.out.println((int)'C');
    //...
    System.out.println((int)'Z');
    // '0' ~ '9'  'a' ~ 'z'  ÿ���� �����ı���
    System.out.println((int)'��');
  }
}






