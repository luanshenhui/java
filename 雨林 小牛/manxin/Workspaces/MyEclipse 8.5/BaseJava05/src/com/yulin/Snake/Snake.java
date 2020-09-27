package com.yulin.Snake;
import java.util.*;

/**
 * 2014-10-24
 * ���ԣ��������ߡ�����
 * @author Administrator
 */

public class Snake {
	private int w=40;
	private int h=20;
	private int[][] snake ={
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
	private int dir=1;	//1:��	-1����	10����	-10����
	
	int[][] foods = new int[5][2];
	int food=0;	//��¼��ǰ��ʳ��
	
	/**���ܣ�1.�������ܣ���ʾ���ƶ����ı䷽��*/
	public void show(){
		for(int y=0;y<h;y++){
			for(int x=0;x<w;x++){
				if(y==0 || y==h-1 || x==0 || x==w-1){
					System.out.print("+");
				}else if(snake[0][0]==x && snake[0][1]==y){
					System.out.print("��");
				}else if(check(x,y)){
					System.out.print("��");
				}else if(checkFood(x,y)){
					System.out.print("@");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
		}
	}
	
	private boolean check(int x, int y) {
		// ����ߵ������Ƿ������x,y��������
		for(int i=0;i<snake.length;i++){
			//��ά���鵱��һλ������ snake[i][0]Ϊ��i�����x����
			if(snake[i][0]==x && snake[i][1]==y){
				return true;
			}
		}
		return false;
	}

	public void move(){
		if(isEat()){
			snake=Arrays.copyOf(snake, snake.length+1);
			snake[snake.length-1]=new int[2];
		}
			//�����е�ÿ��Ԫ�ض����Ųһλ
		for(int i=snake.length-1;i>0;i--){	
			snake[i][0]=snake[i-1][0];
			snake[i][1]=snake[i-1][1];
		}
		//����һ���µ���ͷ
		int x=dir%10;	//x������ƶ�
		int y=dir/10;	//y������ƶ�
		snake[0][0]+=x;
		snake[0][1]+=y;
		
	}
	
	/**����������ַ�"w,a,s,d"�ı䷽��dir
	 * �ı䷽��ʱ������ֱ�ӵ�ͷ
	 */
	public void change(){
		Scanner scan = new Scanner(System.in);
		String str = scan.nextLine();
		if("w".equals(str)){
			dir=(dir!=10)?-10:10;
		}else if("s".equals(str)){
			dir=(dir!=-10)?10:-10;
		}else if("a".equals(str)){
			dir=(dir!=1)?-1:1;
		}else if("d".equals(str)){
			dir=(dir!=-1)?1:-1;
		}else if("q".equals(str)){
			System.err.println("#�˳���Ϸ#");	//��ʾ�����ɫ
			System.exit(0);
		}
	}
	
	public void createFood(){	//����ʳ��ķ���
		food=5;	//��ʼ��ʳ�������
		Random rd = new Random();
		for(int i=0;i<foods.length;i++){
			int x=rd.nextInt(38)+1;
			int y=rd.nextInt(18)+1;
			//��������������긳��ʳ��
			foods[i][0]=x;
			foods[i][1]=y;
		}
	}
	
	private boolean checkFood(int x,int y){	//����ʳ��ķ���
		for(int i=0;i<foods.length;i++){
			if(foods[i][0]==x && foods[i][1]==y){ 
				return true;
			}
		}
		return false;
	}
	
	private boolean isEat(){
		for(int i=0;i<foods.length;i++){
			if(foods[i][0]==snake[0][0] && foods[i][1]==snake[0][1]){
				foods[i][0]=-1;
				foods[i][1]=-1;
				food--;	//��ʳ�����
			
				if(food<=0){
					createFood();
				}
				return true;
			}
		}
		return false;
	}

	
	/** ��ӵĹ��ܣ�
	 * 	�������жϣ�  1.��ͷײ���Լ�����
	 * 			    2.ײǽ����
	 *  ���ʳ�       1.ʳ���������
	 *  		    2.����֮����ٴ�����
	 */

}