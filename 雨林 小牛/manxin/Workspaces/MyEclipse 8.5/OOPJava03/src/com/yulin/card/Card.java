package com.yulin.card;

/**
 * 2014-10-29
 * 扑克牌
 */

public class Card implements Comparable<Card>{
	private int p;	//点数
	private int h;	//花色
	
	//点数
	public static final int THREE = 0;
	public static final int FOUR = 1;
	public static final int FIVE = 2;
	public static final int SIX = 3;
	public static final int SEVEN = 4;
	public static final int EIGHT = 5;
	public static final int NINE = 6;
	public static final int TEN = 7;
	public static final int J = 8;
	public static final int Q = 9;
	public static final int K = 10;
	public static final int A = 11;
	public static final int TOW = 12;
	public static final int GHOST = 13;
	
	//花色 	方片 > 梅花 > 红桃 > 黑桃
	public static final int FANGPIAN = 0;
	public static final int MEIHUA = 1;
	public static final int HONGTAO = 2;
	public static final int HEITAO = 3;
	public static final int SMAIL = 4;
	public static final int LARGE = 5;
	
	public static final String[] ps = {
		"3","4","5","6","7","8","9","10","J","Q","K","A","2","王"
	};
	
	public static final String[] hs = {
		"方片","梅花","红桃","黑桃","小","大"
	};
	
	public Card(){}
	
	public Card(int p, int h){
		this.p = p;
		this.h = h;
	}
	
	public void setP(int p){	//给私有属性赋值
		this.p = p;
	}
	
	public int getP(){	//获得私有属性的值
		return this.p;
	}
	
	public void setH(int h){
		this.h = h;
	}
	
	public int getH(){
		return this.h;
	}
	
	@Override
	public String toString(){
		return "["+hs[h]+ps[p]+"]";
	}
	
	@Override 
	public boolean equals(Object o){
		/**1.验证比较对象是否为空
		 * 2.验证比较对象的类型是否匹配
		 * 3.自定义的比较方式
		 */
		if(o == null){
			return false;
		}
		if(o instanceof Card){	//检验o指向的类型是否是Card
			Card c = (Card)o;	//强制类型转换
			if(c.p == this.p && c.h == this.h){
				return true;
			}
			//或写成：return c.p == this.p && c.h == this.h;
		}
		return false;
	}
	
	@Override
	public int hashCode(){
		return p * 1234 + h * 4321;
	}

	@Override
	public int compareTo(Card o) {	//比较：>0: 大于；<0 ： 小于；=0： 表示等于
		return (this.p * 1000 + this.h) - (o.p * 1000 + o.h);
	}
}
