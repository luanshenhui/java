package day06;
/**
 * ����ģʽ
 * ��������:
 * 1:˽�л����췽��
 * 2:���徲̬�Ļ�ȡ��ǰ����ʵ���ķ���
 * 3:����˽�еľ�̬�ĵ�ǰ����ʵ������ʼ��
 * ����ģʽ����Ϊ��ÿ�ε��÷������᷵��ͬһ������
 * 
 * ���ڵĵ���ģʽ  �������ù�����������     
 * һЩ��� �Ѿ�ʵ���˵���ģʽ  ���Ժ����Լ�ȥд����ģʽ
 * @author Administrator
 *
 */
public class Singleton {
	//private���εĶ��� �������ڱ�����
	//static���ε�  ����������ֱ�ӵ���  �ڱ����п���ֱ��  ��������ʡ��
	private static Singleton singleton = new Singleton();
	//˽�л����췽��
	private Singleton(){
		
	}
	//����һ����̬�Ŀ��Ի�ȡ��ǰ����ʵ���ķ���
	public static Singleton getSingleton(){
		return singleton;
	}
}


