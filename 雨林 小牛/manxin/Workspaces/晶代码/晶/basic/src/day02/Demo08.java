package day02;
/**
 * 短路逻辑运算 与 非短路逻辑运算 
 * && 是短路逻辑运算当第一个表达式是false时候，就直接得结果
 * & 非短路逻辑运算
 * 建议：工作中大多使用 && 实现短路逻辑
 */
public class Demo08 {
	public static void main(String[] args) {
		int age = 25; // 57;
		char sex = '男';
		if( sex == '男' || age++ >= 60 ){
			System.out.println("欢迎光临! 体验养生之美!");
		}else{
			System.out.println("欢迎下次光临!");
		}
		System.out.println(age);//25 发生短路了,age++ 没有执行
		
		if( sex == '女' & age++ >= 6){
			System.out.println("欢迎光临! 体验养生之美!");
		}else{
			System.out.println("欢迎下次光临!");
		}
		System.out.println(age);//26 发生非短路了,age++ 执行

	}

}
