package day01;
/**
 * finally����
 * @author Administrator
 *
 */
public class FinallyDemo2 {
	public static void main(String[] args) {
		System.out.println(
				test(null) + ","
				+ test("0") + ","
				+ test("")
		);
		/**
		 * ������ĸ�ѡ��:
		 * A:0,0,5  B:1,0,2  C:4,0,5  D:4,4,4
		 */
	}
	public static int test(String str){
		try {
			return str.charAt(0) - '0';
		} catch (NullPointerException e) {
			System.out.println("�����˿�ָ��");
			return 1;
		} catch (RuntimeException e) {
			return 2;
		}catch (Exception e) {
			return 3;
		}finally{
			//ʵ������У�finally�в�Ӧ�ú���return���
			return 4;
		}
	}
}	
