package com.yulin.card;

import java.util.*;

public class Game {

	/**
	 * ����54���˿���
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
	 * ������ϴ��=����
	 * 		���ƣ��ֱ�ŵ�����������
	 * 		���ƣ�����
	 */
	
	public Card[] createCards(){
		// ����54����
		Card[] cards = new Card[54];
		int index = 0;	//�ڼ����˿���
		for(int h = Card.FANGPIAN;h <= Card.HEITAO;h++){
			for(int p = Card.THREE;p <= Card.TOW;p++){
				cards[index++] = new Card(p,h);
			}
		}
		cards[index++] = new Card(Card.GHOST,Card.SMAIL);
		cards[index++] = new Card(Card.GHOST,Card.LARGE);
		
		return cards;
	}
	
	//ֻ�����54���˿���
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
	
	//ϴ��
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
	
	//����
	public void faPai(){
		int index = 0;
		for(int i = 0;i < 54;){
			p1[index] = cards[i++];
			p2[index] = cards[i++];
			p3[index] = cards[i++];
			index++;
		}
	}
	
	//����,��������е��ƽ�������
	public void maPai(){
		//������ϵͳ�е�Arrays.sort�ķ���ʱ�����Զ����������compareTo����
		//�����д��compareTo���������Զ�������д���
		//compareTo�᷵������ֵ������0��ֵ������0��ֵ��С��0��ֵ
		Arrays.sort(p1);
		Arrays.sort(p2);
		Arrays.sort(p3);
	}
	
	//��ʾ���ƺ����
	public void show(){
		System.out.println(Arrays.toString(p1));
		System.out.println(Arrays.toString(p2));
		System.out.println(Arrays.toString(p3));
	}
}
