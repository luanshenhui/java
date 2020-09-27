package day04;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;





public class Test1 {
	public static void main(String[] args){
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream("a.txt");
			fos.write('A');
			fos.write('B');
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(fos != null){
				try {
					fos.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		
	}
}
