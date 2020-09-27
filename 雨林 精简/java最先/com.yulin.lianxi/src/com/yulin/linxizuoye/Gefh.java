package com.yulin.linxizuoye;

public class Gefh {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int[][] arr = new int[10][];
		for (int i = 0; i < arr.length; i++) {
			arr[i] = new int[i + 1];
			arr[i][0] = 1;
			arr[i][i] = 1;
			System.out.println(arr);
		}

		for (int i = 2; i < arr.length; i++) {
			for (int j = 1; j < arr[i].length - 1; j++) {
				arr[i][j] = arr[i - 1][j] + arr[i - 1][j - 1];
				System.out.print(arr[i][j] + "\t");
			}
			System.out.println();
		}

		for (int i = 0; i < arr.length; i++) {
			for (int j = 0; j < arr[i].length; j++) {
				System.out.print(arr[i][j] + "\t");
			}
			System.out.println();
		}

	}

}
