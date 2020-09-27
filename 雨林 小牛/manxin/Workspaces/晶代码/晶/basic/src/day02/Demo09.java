package day02;
/**
 * 短路的或运算 || 
 * 非短路的或运算 | 
 *
 */
public class Demo09 {
	public static void main(String[] args) {
		int age =25;
		char sex = '女';
		if(sex=='女' || age++ >= 60){
			System.out.println("欢迎！");
		}
		System.out.println(age); //25
		
		if(sex=='女' | age++ >= 60){
			System.out.println("欢迎！");
		}
		System.out.println(age); //26
	}
}






