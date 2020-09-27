package day04;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public class Test2 {
	public static void main(String[] args) {
		FileInputStream fis = null;
		try {
			 fis = new FileInputStream("a.txt");
			 char a =(char)fis.read();
			 char b =(char)fis.read();
			 System.out.println(a);
			 System.out.println(b);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(fis != null){
				try {
					fis.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
	}
}
