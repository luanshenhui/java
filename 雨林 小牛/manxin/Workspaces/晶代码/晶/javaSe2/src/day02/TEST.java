package day02;

import java.io.File;
import java.io.IOException;

public class TEST {
	public static void main(String[] args) {
		File a = new File("."+File.separator+"a");
		if(!a.exists()){
			a.mkdir();
		}
		File b = new File(a,"."+File.separator+"b");
		if(!b.exists()){
			b.mkdir();
		}
		File c = new File(b,"."+File.separator+"c");
		if(!c.exists()){
			c.mkdir();
		}
		File d = new File(c,"."+File.separator+"d");
		if(!d.exists()){
			d.mkdir();
		}
		File e = new File(d,"."+File.separator+"e");
		if(!e.exists()){
			e.mkdir();
		}
		File f = new File(e,"text.txt");
		if(!f.exists()){
			try {
				f.createNewFile();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		
		
	}
}
