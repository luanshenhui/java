package com.yulin.pm;
import java.awt.*;
import java.util.Scanner;


public class PetShow extends Panel {

	/**MyPanel
	 * @param args
	 */

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("******开始游戏********");
		System.out.println("请输入宠物的名字：");
		
		Scanner scan = new Scanner(System.in);//创建扫描仪
		String name=scan.next();
		System.out.println("宠物已诞生~！");
		Pet pet = new Pet(name);
		PetFrame pf = new PetFrame();
		PetPanel pp = new PetPanel(pet);
		pf.add(pp);
		pf.show();
		
		pp.addKeyListener(pp);
		pf.addKeyListener(pp);
	}

}
