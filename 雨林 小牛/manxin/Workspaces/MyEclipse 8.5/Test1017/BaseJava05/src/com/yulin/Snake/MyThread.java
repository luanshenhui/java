package com.yulin.Snake;


public class MyThread extends Thread{
Snake snake;
	
	public MyThread(Snake snake){
		this.snake = snake;
	}
	@Override
	public void run(){
//		snake.move();
		snake.change();
	}
}
