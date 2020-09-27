package com.c;


import java.util.*;
import java.util.Map.Entry;


public class A {
	public static void main(String[] args) {
		Member m1=new Member("张三",3000);// TODO Auto-generated method stub
		Member m2=new Member("李四",4000);// TODO Auto-generated method stub
		Member m3=new Member("王五",5000);// TODO Auto-generated method stub
		
		Map<String,Member>map=new HashMap<String,Member>();
		map.put("101",m1);
		map.put("102",m2);
		map.put("103",m3);
		m1(map);//打印所有员工信息
		
		//查找工资最高员工
		Member member=m2(map);
		System.out.println(member);

	}

	private static Member m2(Map<String, Member> map) {
		Set<Entry<String, Member>>set=map.entrySet();
		Iterator<Entry<String, Member>>iter=set.iterator();
		//Member member=map.values().iterator().next();
		//for(Member e:map.values())
		Member i=null;
		double a=0;
		while(iter.hasNext()){
			Entry<String, Member>ss=iter.next();
			if(ss.getValue().getSalary()>a){
				a=ss.getValue().getSalary();
			i=ss.getValue();
			}
			//System.out.println("k"+ss);
		}
		return i;
		
	}

	private static void m1(Map<String, Member> map) {
		// TODO Auto-generated method stub
		Set<Entry<String, Member>>set=map.entrySet();
		Iterator<Entry<String, Member>>iter=set.iterator();
		while(iter.hasNext()){
			Entry<String, Member>ss=iter.next();
			System.out.println("j"+ss);
		}
	}

}
