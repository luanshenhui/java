package service;

import java.util.Random;

public class ImageService {
	//A~Z,0~9
	public String getNumber(int size) {
		String chars = "ABCDEFGHIJKLMNOPQ" +
				"RSTUVWXYZ0123456789";
		String number = "";
		Random r = new Random();
		for(int i=0;i<size;i++){
			number += chars.charAt(
					r.nextInt(chars.length()));
		}
		return number;
	}
}
