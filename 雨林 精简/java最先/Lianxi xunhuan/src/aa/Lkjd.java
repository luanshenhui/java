package aa;

import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Map.Entry;

public class Lkjd {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int []arr={1,1,2};
		SortedMap<Integer,Integer>map=new TreeMap<Integer,Integer>();
		map.put(1,2);
		map.put(2,2);
		map.put(1,2);
		map.put(2,2);
//		for(int a:arr){
//			map.put(a,1);
//		}
		
		for(Entry<Integer, Integer> i:map.entrySet()){
			System.out.println(i);
		}
		
	}

}
