package com.yulin.am;
import java.util.*;

public class Array2DDemo {
	/**
	 * ��ά����
	 */
	public static void main(String[] args) {
		//��ά���鶨�����
	/*	int[][] arr1 =  new int[4][5];
		arr1[2][3]=1;
		for(int i=0;i<arr1.length;i++){
			for(int j=0;j<arr1[0].length;j++){
				System.out.print(arr1[i][j]);
			}
			System.out.println();
		}*/
		
		/**������¯������			�ɷ�ң��
		 * ң���ٲ���ǰ��	���		��������
		 * ����ֱ����ǧ��			��ֱ����
		 * �������������			���²�¯
		 * 							��������
		 * 							��ǧǰ��
		 * 							��ߴ���
		 */
/*		String[][] str = {
				{"��","��","��","¯","��","��","��"},
				{"ң","��","��","��","��","ǰ","��"},
				{"��","��","ֱ","��","��","ǧ","��"},
				{"��","��","��","��","��","��","��"}
		};
		for(int i=0;i<str[0].length;i++){
			for(int j=str.length-1;j>=0;j--){
				System.out.print(str[j][i]);
			}
			System.out.println();
		}*/
		
		/**++++++++++++++++++++		20��
		 * +				  +		��һ����ά�����ʾ�����ϵĵ㣬
		 * +				  +		��һ���������������
		 * +	oooo		  +		��ͷ��������G����������Сдo
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

