package test;

import java.util.Scanner;

public class Test {
	// 150 4057 6519
	// 150 4045 1502
	// 138 8966 4987
	public static void main(String args[]) {

		// 从控制台?取行数
		@SuppressWarnings("resource")
		Scanner s = new Scanner(System.in);
		int row = s.nextInt();
		// 根据行数定?好二?数?，由于?一行的元素个数不同，所以不定??一行的个数
		int[][] arr = new int[row][];
		// 遍?二?数?
		for (int i = 0; i < row; i++) {
			// 初始化?一行的?个一?数?
			arr[i] = new int[i + 1];
			// 遍??个一?数?，添加元素
			for (int j = 0; j <= i; j++) {
				
				// ?一列的??和?尾元素?1，??的?候，j=0，?尾的?候，j=i
				if (j == 0 || j == i) {
					arr[i][j] = 1;
				} else {// ?一个元素是它上一行的元素和斜?角元素之和
					arr[i][j] = arr[i - 1][j] + arr[i - 1][j - 1];
				}
				System.out.print(arr[i][j] + "\t");
			}
			System.out.println();
		}
	}

}
