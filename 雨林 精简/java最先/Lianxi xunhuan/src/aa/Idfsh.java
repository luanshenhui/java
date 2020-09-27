package aa;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Map.Entry;

public class Idfsh {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int []arr={2,5,9,74,5,6,4,5,546,2,5,3};
		for(int a:arr){
			int index=0;
			//System.out.println(a);
			for(int b:arr){
				if(a==b){
					index++;
				}
			}
		//	SortedSet<Integer>set=new TreeSet<Integer>();
		//	set.add(a);
//			for(Integer i:set){
//				System.out.println(a);
				
				SortedMap<Integer,Integer> map=new TreeMap<Integer,Integer>();
				map.put(a, index);
			
			
			
			Set<Entry<Integer, Integer>> e=map.entrySet();
			for(Entry<Integer, Integer> ss:e){
				System.out.println(ss);
				}
//			}
		}
		

	}

}
