package aa;

public class Kdrhs {
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		int[][] arr = new int[10][2];
		for (int i = 0; i < arr.length; i++) {
			// System.out.println(arr[i]);
			arr[i] = new int[i + 1];
			// System.out.println(arr[i]);
			// System.out.println("----------");
		}
		for (int i = 0; i < arr.length; i++) {
			arr[i][0] = 1;
			arr[i][i] = 1;
		}
		for (int i = 2; i < arr.length; i++) {
			for (int j = 1; j < arr[i].length - 1; j++) {
				arr[i][j] = arr[i - 1][j] + arr[i - 1][j - 1];

			}

		}

		for (int i = 0; i < arr.length; i++) {
			for (int j = 0; j < arr[i].length; j++) {
				System.out.println(arr[i][j] + "\t");
				System.out.print(arr[i][j] + "\t");
			}
			System.out.println();
		}

	}

}
