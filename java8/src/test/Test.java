package test;

import java.util.Scanner;

public class Test {
	// 150 4057 6519
	// 150 4045 1502
	// 138 8966 4987
	public static void main(String args[]) {

		// ���T����?��s��
		@SuppressWarnings("resource")
		Scanner s = new Scanner(System.in);
		int row = s.nextInt();
		// �����s����?�D��?��?�C�R��?��s�I���f�����s���C���ȕs��??��s�I����
		int[][] arr = new int[row][];
		// ��?��?��?
		for (int i = 0; i < row; i++) {
			// ���n��?��s�I?����?��?
			arr[i] = new int[i + 1];
			// ��??����?��?�C�Y�����f
			for (int j = 0; j <= i; j++) {
				
				// ?���I??�a?�����f?1�C??�I?��Cj=0�C?���I?��Cj=i
				if (j == 0 || j == i) {
					arr[i][j] = 1;
				} else {// ?�꘢���f�������s�I���f�a��?�p���f�V�a
					arr[i][j] = arr[i - 1][j] + arr[i - 1][j - 1];
				}
				System.out.print(arr[i][j] + "\t");
			}
			System.out.println();
		}
	}

}
