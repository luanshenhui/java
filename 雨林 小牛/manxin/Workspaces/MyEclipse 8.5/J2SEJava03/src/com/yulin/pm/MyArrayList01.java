package com.yulin.pm;
import java.util.*;

public class MyArrayList01 <E>{
	E[] es = (E[]) new Object[0];
	
	public void add(E e){
		es = Arrays.copyOf(es, es.length + 1);
		es[es.length - 1] = e;
	}
	
	public void remove(E e){
		int index = -1;
		for(int i = 0; i < es.length; i++){
			if(es[i].equals(e)){
				index = i;
				break;
			}
		}
		if(index != -1){
			for(int i = index; i < es.length - 1; i++){
				es[index] = es[index + 1];
			}
			es = Arrays.copyOf(es, es.length - 1);
		}else{
			System.out.println("²»´æÔÚ");
		}
	}
	
	public void set(int index,E e){
		es[index] = e;
	}
	
	public int indexOf(E e){
		int index = -1;
		for(int i = 0; i < es.length; i++){
			if(es.equals(e)){
				index = i;
				break;
			}
		}
		return index;
	}
}
