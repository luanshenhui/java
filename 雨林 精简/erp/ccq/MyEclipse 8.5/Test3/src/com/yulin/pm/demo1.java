package com.yulin.pm;

public class demo1 {
	public static void main(String[] args) {
		for (int j = 0; j < 5; j++) {// ��������
			for (int n = 0; n < (5 - j); n++) {// ÿһ�еĸ���
				System.out.print("k");
			}

			for (int i = 0; i <= 2 * j; i++)

			{

				if (i == 2 * j /* || j == 4 */|| i == 0 || j == 0) {
					System.out.print("*");
				} else {
					System.out.print("0");

				}

			}
			System.out.println();

		}
		for (int p = 0; p < 4; p++) {
			for (int n = 0; n <= p + 1; n++) {
				System.out.print("h");

			}
			for (int i = 0; i <= 10 - p; i++)
				
			{
				System.out.print("x");

			}System.out.println();
			
		}
	}

}
