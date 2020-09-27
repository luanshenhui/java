package com.yulin.am;
import java.util.*;

public class Array2DDemo {
	/**
	 * 二维数组
	 */
	public static void main(String[] args) {
		//二维数组定义输出
	/*	int[][] arr1 =  new int[4][5];
		arr1[2][3]=1;
		for(int i=0;i<arr1.length;i++){
			for(int j=0;j<arr1[0].length;j++){
				System.out.print(arr1[i][j]);
			}
			System.out.println();
		}*/
		
		/**日照香炉生紫烟			疑飞遥日
		 * 遥看瀑布挂前川	输出		是流看照
		 * 飞流直下三千尺			银直瀑香
		 * 疑是银河落九天			河下布炉
		 * 							落三挂生
		 * 							九千前紫
		 * 							天尺川烟
		 */
/*		String[][] str = {
				{"日","照","香","炉","生","紫","烟"},
				{"遥","看","瀑","布","挂","前","川"},
				{"飞","流","直","下","三","千","尺"},
				{"疑","是","银","河","落","九","天"}
		};
		for(int i=0;i<str[0].length;i++){
			for(int j=str.length-1;j>=0;j--){
				System.out.print(str[j][i]);
			}
			System.out.println();
		}*/
		
		/**++++++++++++++++++++		20个
		 * +				  +		用一个二维数组表示蛇身上的点，
		 * +				  +		在一个框中输出这条蛇
		 * +	oooo		  +		蛇头的坐标是G，其他的是小写o
		 * +	   o		  +
		 * +	   ooooG	  +
		 * +				  +
		 * +				  +
		 * +				  +
		 * ++++++++++++++++++++
		 */
		int[][] sanke = {
				{10,5},
				{9,5},
				{8,5},
				{7,5},
				{6,5},
				{6,4},
				{6,3},
				{5,3},
				{4,3},
				{3,3},
		};
		for(int y=0;y<10;y++){
			for(int x=0;x<20;x++){
				if(y==0 || x==0 || x==19 || y==9){
					System.out.print("+");
				}else if(sanke[0][0]==x && sanke[0][1]==y){
					System.out.print("G");
				}else if(check(sanke,x,y)){
					System.out.print("o");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
		}
		

	}
	public static boolean check(int[][] ins,int x,int y){
		for(int i=0;i<ins.length;i++){
			if(ins[i][0] == x && ins[i][1]==y){
				return true;
			}
		}
		return false;
	}

}

