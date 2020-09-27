package com.yulin.pm;

import java.util.*;

/**
 * ArrayList泛型
 * 1.定义
 * 2.增删改查 
 **/
public class MyArrayList<E> {
	E[] es = (E[]) new Object[0];	
	
	public void add(E e){
		es = Arrays.copyOf(es, es.length + 1);	//扩容
		es[es.length - 1] = e;	//将元素放入最后一个位置
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
			System.err.println("该元素不存在");
		}
	}
	
	public void set(int index, E e){
			es[index] = e;
	}
	
	public int indexOf(E e){
		int index = -1;
		for(int i = 0; i < es.length; i++){
			if(es[i].equals(e)){
				index = i;
				break;
			}
		}
		return index;
	}
}
