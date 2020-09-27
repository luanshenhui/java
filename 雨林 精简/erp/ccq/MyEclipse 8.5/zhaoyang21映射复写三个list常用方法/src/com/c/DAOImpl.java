package com.c;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

public class DAOImpl implements Dao {

	@Override
	public void write(Map<String, Product> map, String string) {
//		Set<Entry<String,Product>>ent=map.entrySet();
//		Iterator<Entry<String,Product>> iter=ent.iterator();
//		while(iter.hasNext()){
//			Entry<String,Product> ss=iter.next();
//		}
		
		
		try {
			File file = new File("f:\\product.txt");
			FileWriter in = new FileWriter(file);
			BufferedWriter bf = new BufferedWriter(in);
			
			Set<Entry<String,Product>>ent=map.entrySet();
			Iterator<Entry<String,Product>> iter=ent.iterator();
			while(iter.hasNext()){
				Entry<String,Product> ss=iter.next();
				String a=ss.getKey();
				Product p=ss.getValue();
				bf.write(ss.toString());
				bf.write("\r\n");
				//bf.write(ss.getKey());
				//bf.write(ss.getValue().toString());
			}
			bf.close();
			in.close();

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
