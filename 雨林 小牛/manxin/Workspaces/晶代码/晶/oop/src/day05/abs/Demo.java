package day05.abs;
/*
 * ���󷽷�һ���ڳ���������
 * ��ô�㲻˵�ӿ��ﶼ�ǳ��󷽷���  �ӿ���һ������ĳ�����
 *   ���ǳ����಻һ���г��󷽷�
 *   ������������Գ��� �����б���  ���Գ��󷽷�  ��������ͨ����
 *   �ӿ�  ֻ���г���  ֻ�ܳ��󷽷�
 *   �ӿ���һ������Ĺ淶
 *   �������й����� Ϊʲô�� ��Ϊ�������б���  ��Ҫ����������ʼ��
 *   �ӿ�û�й����� Ϊʲô���ӿ��ж��ǳ���
 *   �ӿںͳ����඼����ʵ����  Ϊʲô��  ��Ϊ���������涼�г��󷽷�
 *   ���󷽷�û�з�����  �������÷���û���κ�����
 *   ������һ�����̳�  Ϊʲô?   ��̬��
 *   �ӿ�һ����ʵ��
 *   
 *   ������ĸо��� �����ǳ���������˽ӿ�
 *   ΪʲôҪ�нӿ�  ������һ���������أ�
 *   ΪʲôҪ��ƽӿںͳ������أ�
 *   ϰ��ƽ �ӿ�  ���ǿ ������
 */
public interface Demo {
	public abstract int a();
	public abstract int a1();
	public abstract int a2();
}
interface Demo1{
	
}
abstract class A implements Demo,Demo1{

	@Override
	public int a() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int a1() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int a2() {
		// TODO Auto-generated method stub
		return 0;
	}
	
}
class B extends A{
	
}