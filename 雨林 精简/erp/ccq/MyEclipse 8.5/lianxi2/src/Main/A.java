package Main;

public class A {
	

		private String name = "����";

		private int age = 30;

		// �ࣺͼֽ��ģ�塣
		// ��������ĳ�Ա��������ĳ�Ա������
		// ��Ա�����������ж���ı���������Ա������������ʾ������Ժ�״̬��
		// ��Ա�����������ܶ���ķ���������Ա������������ʾ��Ķ�������Ϊ��
		// ���췽��������������ͬ����û�з���ֵ��Ҳ����void�ؼ��֡�
		// ���췽�������ã�һ�Ǵ������󣬶��ǳ�ʼ����
		// ���췽��ע�⣺�����д���췽����ϵͳ���ṩһ��Ĭ�ϵ��޲εĹ��췽����

		public A() {

		}

		public A(int a) {

		}

		// ����ʵ����ʵ�塣

		public static void run() {
			System.out.println("�ܲ�");
		}

		public static void eat() {
			System.out.println("�Է�");
		}

		public static void main(String[] args) {

			// ����������﷨��ʽ��
			// ������� �������� = new�ؼ��� ��Ĺ��췽��();
			A a = new A(4);
			System.out.println(a.name);
			//System.out.println(a.age);
			//a.eat();
			//a.run();

		}

	}


