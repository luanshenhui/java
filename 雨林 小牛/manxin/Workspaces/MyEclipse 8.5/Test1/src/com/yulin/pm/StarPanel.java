package com.yulin.pm;
import java.awt.*;
import com.yulin.am.*;
import java.util.*;

public class StarPanel extends Panel {
	public static void main(String[] args){
		MyFrame mf = new MyFrame();
		StarPanel sp = new StarPanel();
		mf.add(sp);
		mf.show();
	}
	@Override
	public void paint(Graphics g){
		//g.drawString("※", 100, 100);
		Random rd = new Random();//创建随机数的工具
		g.setColor(Color.RED);
		for(int i=0;i<400;i++){
		int x = rd.nextInt(800);//随机一个X坐标，范围0-799
		int y = rd.nextInt(600);//
		g.drawString("※", x, y);
	}
  }

}
