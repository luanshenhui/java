package com.yulin.am;

public class demo2 {
	public static void main(String[] args) {
		for (int y = 0; y < 7; y++) {

			for (int i = 0; i < (7 - y); i++) {

				System.out.print("0");

			}

			for (int x = 0; x < 2 * y + 1; x++) {
				 //if (x == 0 ||y==6||2*y==x|y==3) {

				System.out.print("2");
				 //} else {
				// System.out.print("3");
				 //}
			}

			System.out.println();
		}


		
		for (int y = 0; y < 7; y++) {

			for (int i = 0; i < y; i++) {

				System.out.print("0");

			}

			for (int x = 0; x < 2 * (7-y)-1 ; x++) {
				
				System.out.print("2");
				 
			}

			System.out.println();
		}
		
		
		
		
		
		
		
		
		
		
		
	}
}