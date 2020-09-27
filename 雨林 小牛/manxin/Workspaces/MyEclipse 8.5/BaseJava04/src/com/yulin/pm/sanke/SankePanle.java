package com.yulin.pm.sanke;
import java.awt.*;
import java.util.*;

public class SankePanle extends Panel{
	public static void mian(String[] args){
		SankeFrame sf = new SankeFrame();
		SankePanle sp = new SankePanle();
		sf.add(sp);
		sf.show();		
	}
	public void paint(Graphics g){
		Random rd = new Random();
		g.setColor(Color.red);
	}

}
