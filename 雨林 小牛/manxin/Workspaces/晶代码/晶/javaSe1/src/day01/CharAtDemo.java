package day01;
/**
 * ʹ���ַ���charAt��������ɻ��Ĳ���
 * @author Administrator
 *
 */
public class CharAtDemo {
	public static void main(String[] args) {
		//					  0 1 2 3 4 5 6 7 8
		String str = "�Ϻ�����ˮ���Ժ���";
		/**
		 * �����ĵ�˼·:
		 * ����λ�õ��ַ��͵���λ�õ��ַ�һ�����ǻ���
		 */
		for(int i = 0;i<str.length()/2;i++){
			if(
					str.charAt(i)
					!=
					str.charAt(str.length()-1-i)
			){
				System.out.println("���ǻ���");
				return;
			}
		}
		
		System.out.println("�ǻ���");
	}
}	



