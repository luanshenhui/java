package day02;
/**
 * 逻辑运算 : &&与 并且   ||或 或者   !非 否则 
 * &&和& 前者是短路运算 后者是非短路运算
 */
public class Demo07 {
	public static void main(String[] args) {
		int age = 62; // 57;
		char sex = '女';
		if( sex == '女' && age >= 60 ){
			System.out.println("欢迎光临! 体验养生之美!");
		}else{
			System.out.println("欢迎下次光临!");
		}
		//判断一个字符是否是英文大写字符
		char c = 'K';//'中'20013 'A' ~ 'Z'  65 ~ 90  65<=c<=90 
		if( c>='A' && c<='Z' ){
			System.out.println("是大写字母:"+c); 
		}
		//判断一个字符是大写或者小写字母	
		c = 'h';//104
		if( (c>='A' && c<='Z') || (c>='a' && c<='z')){
			System.out.println("是英文字母:"+c); 
		}
		System.out.println((int)'h'); 
	}
}





