package day01;
/**
 * finally语句块
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
		 * 输出的四个选项:
		 * A:0,0,5  B:1,0,2  C:4,0,5  D:4,4,4
		 */
	}
	public static int test(String str){
		try {
			return str.charAt(0) - '0';
		} catch (NullPointerException e) {
			System.out.println("出现了空指针");
			return 1;
		} catch (RuntimeException e) {
			return 2;
		}catch (Exception e) {
			return 3;
		}finally{
			//实际情况中，finally中不应该含有return语句
			return 4;
		}
	}
}	
