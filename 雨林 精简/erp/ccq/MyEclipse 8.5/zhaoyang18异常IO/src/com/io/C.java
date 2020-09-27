package com.io;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class C {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String s1="f:\\a.txt";
		String s2="f:\\b.txt";
		//
		copy(s1,s2);

	}

	private static void copy(String s1, String s2) {
		// TODO Auto-generated method stub
		FileReader in = null;
		BufferedReader bu=null;
		BufferedWriter bw =null;
		FileWriter inf = null;
		try {
			File f1=new File("f:\\file.txt");
			File file = new File("f:\\x.txt");
			in=new FileReader(f1);
			bu=new BufferedReader(in);
			
			inf = new FileWriter(file,true);
			bw = new BufferedWriter(inf);
			
			String str="000";
			while((str=bu.readLine())!=null){
				System.out.println(str);			
				
					bw.write(str);
					bw.write("\r\n");
				
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			try {
				bw.close();
				inf.close();
				bu.close();
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	
}

