package chinsoft.tempService;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import sun.misc.BASE64Encoder;

public class Test {
	public static void main(String[] args) {
//		String[] arr = Utility.getStrArray("10133:30,10114:35,10113:35,10137:15,10111:40,10136:60,10134:55,10129:80,10127:75,10128:40,10108:88,99,10105:65,10120:65,10102:85,10123:60,10126:75,10117:55");
//		System.out.println(Arrays.toString(arr));
		String value = "administrator";
		try {
			MessageDigest md = MessageDigest.getInstance("md5");
			byte md5[] = md.digest(value.getBytes());
			BASE64Encoder encode = new BASE64Encoder();
		 	System.out.println(encode.encode(md5));
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		
	}
	
}
