package com.yulin.pm;

public class Circle02 {
	int r;
	int x;
	int y;
	
	public boolean isIn(Circle02Dian p){
//		int dis=(p.x-this.x)*(p.x-this.x)+(p.y-this.y)*(p.y-this.y);	//���������ƽ��
		if(distance(p)<=r){
//		if(dis<=r*r){
			return true;
		}else{
			return false;
		}
	}
	
	public double distance(Circle02Dian p){	
		//����һ���㵽Բ�ĵľ��� Math.sqrt(a);����a�Ŀ���ֵ
		int dis=(p.x-this.x)*(p.x-this.x)+(p.y-this.y)*(p.y-this.y);
		return Math.sqrt(dis);
	}
	
	public boolean isIn(int x,int y){
		Circle02Dian p = new Circle02Dian();
		p.x=x;
		p.y=y;
		return isIn(p);
	}
	
	public double distance(int x,int y){
		Circle02Dian p = new Circle02Dian();
		p.x=x;
		p.y=y;
		return distance(p);
	}
	
	

}
