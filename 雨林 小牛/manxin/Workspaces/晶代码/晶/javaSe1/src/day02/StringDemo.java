package day02;
/**
 * 修改字符串的效率
 * @author Administrator
 *
 */
public class StringDemo {
	public static void main(String[] args) {
		String str = "a";
		for(int i=0;i<1000000;i++){
			str+="a";
		}
		
	}
}
