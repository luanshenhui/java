package CaiShuGame;
import java.util.*;

public class Game {

	/**
	 * 猜数字游戏：
	 *	1.随机生成4个个位数
	 *	2.向控制台输入你猜的数
	 *	3.显示你猜的结果a,b
	 *	4.a表示数对的个数
	 *	5.b表示，数和位置都对的个数
	 *	6.全部猜中游戏结束，显示猜的次数
	 *	
	 *	升级：选择游戏等级，简单，中级，困难，大师，分别猜4,6,8,10个数字
	 *
	 *	未解决：大师级数组长度不够
	 */
	public static void main(String[] args) {
		Game g = new Game();
		g.show();

	}
	//随机出不重复的数组
	public int[] create(){
		Random rd = new Random();
		int[] arr = new int[10];
		for(int i = 0; i < arr.length; i++){
			int in = rd.nextInt(10);
			arr[i] = in;
			for(int j = 0; j < i; j++){
				if(arr[j] == in){
					i--;
				}
			}
		}
		return arr;
	}
	
	//输入4位数
	public int[] input(){
		Scanner scan = new Scanner(System.in);
		int[] input = new int[10];
		System.out.println("请输入0-9之间的数字：");
		int in = scan.nextInt();
		int length = Integer.toString(in).length();
		input = Arrays.copyOf(input, length);
		for(int i = input.length - 1; i >= 0; i--){
			input[i] = in % 10;
			in /= 10;
		}
		return input;
	}
	
	//数对的方法
	public int check1(int[] arr,int[] input){
		int count = 0;
		for(int i = 0; i < arr.length; i++){
			for(int j = 0; j < input.length; j++){
				if(arr[i] == input[j]){
					count ++ ;
					break;
				}
			}
		}
		return count;
	}
	
	//数与位置都对的
	public int check2(int[] arr,int[] input){
		int count = 0;
		for(int i = 0; i < arr.length; i++){
			if(arr[i] == input[i]){
				count ++ ;
			}
		}
		return count;
	}
	
	//难度生成
	int leven = 0;
	public int[] select(){
		System.out.println("请选择难度：");
		System.out.println("1.简单   2.中级   3.困难    4.大师");
		Scanner scan = new Scanner(System.in);
		int in = scan.nextInt();
		int[] arr = create();
		if(in == 1){
			arr = Arrays.copyOf(arr, 4);
			leven = 4;
		}else if(in == 2){
			arr = Arrays.copyOf(arr, 6);
			leven = 6;
		}else if(in == 3){
			arr = Arrays.copyOf(arr, 8);
			leven = 8;
		}else if(in == 4){
			arr = Arrays.copyOf(arr, 10);
			leven = 10;
		}
		return arr;
	}
	
	public void show(){
		System.out.println("*********游戏开始*********");
		int[] arr = select();
		System.out.println("随机出的数组：" + Arrays.toString(arr));
		int[] input = input();
		System.out.println("输入的数组是：" + Arrays.toString(input));
		int count = 1;
		while(true){
			int a = check1(arr,input);
			int b = check2(arr,input);
			System.out.println(a + "," + b);
			if(b == leven){
				System.out.println("游戏结束");
				System.out.println("您猜了" + count + "次");
				break;
			}else{
				input = input();
				count++;
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
