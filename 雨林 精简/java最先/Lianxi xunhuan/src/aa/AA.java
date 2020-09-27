package aa;

public class AA {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int is = 25368643;
		int a = 0;
		int s = String.valueOf(is).length();
		System.out.println(is / 10);
		for (int i = 0; i < s; i++) {

			a = a*10 + is % 10;
			is = is / 10;
		}
		System.out.println(is);
		System.out.println(a);
	}

}
