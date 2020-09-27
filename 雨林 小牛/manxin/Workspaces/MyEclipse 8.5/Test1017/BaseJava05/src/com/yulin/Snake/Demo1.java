package com.yulin.Snake;
import java.util.*;

public class Demo1 {
	
	int h=20;
	int w=40;
	int[][] snake={
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
	int die=1;//1:ÓÒ	-1£º×ó	-10£ºÏÂ	+10£ºÉÏ
	
	public void show(){
		for(int i=0;i<h;i++){
			for(int j=0;j<w;j++){
				if(i==0 || i==h-1 || j==0 || j==w-1){
					System.out.print("+");
				}else if(snake[0][0]==j && snake[0][1]==i){
					System.out.print("¡ñ");
				}else if(check(j,i)){
					System.out.print("¡ğ");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
		}
	}
	
	public boolean check(int x,int y){
		for(int i=0;i<snake.length;i++){
			if(snake[i][0]==x && snake[i][1]==y){
				return true;
			}
		}
		return false;
	}
	
	public void move(){
		Scanner scan = new Scanner(System.in);
		String str = scan.next();
		if("w".equals(str)){
//			dir=(dir!=10)?
		}
	}
	
	
	
	
	
	
	
	

}
