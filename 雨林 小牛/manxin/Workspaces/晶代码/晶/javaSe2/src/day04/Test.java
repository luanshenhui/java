package day04;

import java.io.File;
import java.io.IOException;

public class Test {
    public static void main(String[] args) throws IOException {
		File dir = new File("."+File.separator+"a"
				               +File.separator+"b"
				               +File.separator+"c"
				               +File.separator+"d");
		if(!dir.exists()){
			dir.mkdirs();
			
		}
		System.out.println("ÎÄ¼þ¼Ð");
		File file = new File(dir,"f.txt");
		if(!file.exists()){
			file.createNewFile();
		}
		System.out.println("hehe");
	}
}
