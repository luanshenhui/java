package day03;

import java.util.Arrays;

public class StringSplit {
	public static void main(String[] args) {
		String str = "FGDHWY";
		String[] array = str.split("|");
		System.out.println(Arrays.toString(array));
	}
}
