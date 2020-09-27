package com.yulin.pm.sanke;
import java.util.*;

public class Panel1 {
	int h=10;	//全局变量：整个类中都可以使用
	int w=20;
	int[][] point = {
			{3,5}
	};
	public void show(){
		for(int y=0;y<h;y++){
			for(int x=0;x<w;x++){	//局部变量
				if(y==0 || y==h-1 || x==0 || x==w-1){
					System.out.print("+");
				}else if(check(x,y)){
					System.out.print("■");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
		}
	}
	
	//方块位置
	private boolean check(int x,int y){
		for(int i=0;i<point.length;i++){
			if(point[i][0] == x && point[i][1] == y){
				return true;
			}			
		}
		return false;		
	}
	
	//方块移动 改变X坐标Y坐标
	private void move(){
		Scanner scan = new Scanner(System.in);
		String str=scan.next();
		if("w".equals(str)){	//判断str 是不是w
			for(int i=0;i<point.length;i++){
				point[i][1]-=1;
				if(point[i][1]==0){	//穿墙效果
					point[i][1]=h;
				}
			}
		}else if("s".equals(str)){
			for(int i=0;i<point.length;i++){
				point[i][1]+=1;
			}
		}else if("a".equals(str)){
			for(int i=0;i<point.length;i++){
				point[i][0]-=1;
			}
		}else if("d".equals(str)){
			for(int i=0;i<point.length;i++){
				point[i][0]+=1;
			}
		}else{
			System.out.print("按错键了");
		}
		
	}
	
	public static void main(String[] args){
		Panel1 p = new Panel1();
		p.show();
		while(true){
			p.move();
			p.show();
		}
	}
}
