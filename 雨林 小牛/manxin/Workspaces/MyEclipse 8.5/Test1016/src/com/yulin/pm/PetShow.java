package com.yulin.pm;
import java.awt.*;
import java.util.Scanner;


public class PetShow extends Panel {

	/**MyPanel
	 * @param args
	 */

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("******��ʼ��Ϸ********");
		System.out.println("�������������֣�");
		
		Scanner scan = new Scanner(System.in);//����ɨ����
		String name=scan.next();
		System.out.println("�����ѵ���~��");
		Pet pet = new Pet(name);
		PetFrame pf = new PetFrame();
		PetPanel pp = new PetPanel(pet);
		pf.add(pp);
		pf.show();
		
		pp.addKeyListener(pp);
		pf.addKeyListener(pp);
	}

}
