package day03;
/**
 * StringBuilder��Ϊ���޸��ַ�������Ƶ���
 * @author Administrator
 *
 */
public class StringBuilderDemo {
	public static void main(String[] args) {
		String str = "Ŭ��ѧϰjava,Ϊ�˱���ó���";
		/**
		 * ����StringBuilder�����޸��ַ���
		 */
		StringBuilder builder = new StringBuilder(str);
		//���ַ���ĩβ׷��һ���ַ���"!!!"
		builder.append("!!!");
		//��ȡStringBuilder�޸ĺ���ַ���
		String str1 = builder.toString();
		System.out.println(str1);
		
		/**
		 * ���ַ�������λ�ò���������
		 * builder.insert(offset, b)
		 * ����1:ָ���ַ���λ����������0��ʼ
		 * ����2:���������
		 * 0 1 2 3 456789 0 1 2 3 
		 * Ŭ��ѧϰjava,Ϊ�˱���ó���!!!
		 * Ŭ��ѧϰjava,����Ϊ�˱���ó���  !!!
		 */
		builder.insert(9, "����");
		System.out.println(builder);
		
		/**
		 * Ŭ��ѧϰjava,����Ϊ�˱���ó���  !!!
		 * ����,����Ϊ�˱���ó���!!!
		 * builder.replace(start, end, str1)
		 * �滻�ַ���
		 * ����1:���滻���ݵ���ʼλ��
		 * ����2:���滻���ݵĽ���λ��
		 * ����3:�滻������
		 */
		builder.replace(0, 8, "����");
		System.out.println(builder);
		
		/**
		 * ����,����Ϊ�˱���ó���!!!
		 * ����,����Ϊ��
		 * delete(int start, int end)
		 * ɾ���ַ����еĲ�������
		 * ����1:Ҫɾ������ʼλ��
		 * ����2:Ҫɾ���Ľ���λ��
		 */
		/**
		 * StringBuilder����Щ�޸ķ������з���ֵ
		 * ����ֵ����StringBuilder��ʵ����
		 * ���ﷵ�صĶ��ǵ�ǰbuilder��
		 * ��Щ�������һ�䶼�� return this;
		 */
		builder.delete(7, builder.length())
		.append("�ı�����!");
		System.out.println(builder);
		/**
		 * �ַ�����ת
		 */
		builder.reverse();
		System.out.println(builder);
	}
}





