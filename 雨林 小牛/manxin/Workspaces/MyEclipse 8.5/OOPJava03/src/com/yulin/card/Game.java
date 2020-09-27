package com.yulin.card;

import java.util.*;

public class Game {

	/**
	 * 生成54张扑克牌
	 */
	public static void main(String[] args) {
		Game game = new Game();
//		Card[] cards = game.createCards();
		game.showCard();
//		game.xiCards(cards);
		game.xiCards();
		game.showCard();
		game.faPai();
		game.maPai();
		game.show();
	}
	
	public Game(){
		cards = createCards();
	}
	
	/**
	 * 方法：洗牌=打乱
	 * 		发牌：分别放到三个数组中
	 * 		码牌：排序
	 */
	
	public Card[] createCards(){
		// 创建54张牌
		Card[] cards = new Card[54];
		int index = 0;	//第几张扑克牌
		for(int h = Card.FANGPIAN;h <= Card.HEITAO;h++){
			for(int p = Card.THREE;p <= Card.TOW;p++){
				cards[index++] = new Card(p,h);
			}
		}
		cards[index++] = new Card(Card.GHOST,Card.SMAIL);
		cards[index++] = new Card(Card.GHOST,Card.LARGE);
		
		return cards;
	}
	
	//只能输出54张扑克牌
	public void showCard(){
		int index = 0;
		for(int i = 0;i < 4;i++){
			for(int j = 0; j < 13; j++){
				System.out.print(cards[index++]);
			}
			System.out.println();
		}
		System.out.println(cards[index++]);
		System.out.println(cards[index++]);
	}
	
	//洗牌
	public void xiCards(){
		Random rd = new Random();
		for(int i = 0; i < cards.length; i++){
			int a = rd.nextInt(54);
			int b = rd.nextInt(54);
			
			Card card = cards[a];
			cards[a] = cards[b];
			cards[b] = card;
		}
	} 
	
	Card[] cards = new Card[54];
	Card[] p1 = new Card[18];
	Card[] p2 = new Card[18];
	Card[] p3 = new Card[18];
	
	//发牌
	public void faPai(){
		int index = 0;
		for(int i = 0;i < 54;){
			p1[index] = cards[i++];
			p2[index] = cards[i++];
			p3[index] = cards[i++];
			index++;
		}
	}
	
	//码牌,对玩家手中的牌进行排序
	public void maPai(){
		//当调用系统中的Arrays.sort的方法时，会自动调用里面的compareTo方法
		//如果重写了compareTo方法，会自动调用重写后的
		//compareTo会返回三种值，大于0的值，等于0的值，小于0的值
		Arrays.sort(p1);
		Arrays.sort(p2);
		Arrays.sort(p3);
	}
	
	//显示码牌后的牌
	public void show(){
		System.out.println(Arrays.toString(p1));
		System.out.println(Arrays.toString(p2));
		System.out.println(Arrays.toString(p3));
	}
}
