package com.yulin.pm;
import java.util.*;

public class MyMap01 <K,V>{
	class Entry{
		private K key;
		private V value;
		public K getKey() {
			return key;
		}
		public void setKey(K key) {
			this.key = key;
		}
		public V getValue() {
			return value;
		}
		public void setValue(V value) {
			this.value = value;
		}
		@Override
		public int hashCode() {
			return key.hashCode();
		}
		@Override
		public boolean equals(Object obj) {
			Entry e = (Entry)obj;
			return this.key.equals(e.key);
		}
	}
	private Set<Entry> entrys = new HashSet<Entry>();
	private Set<K> keys = new HashSet<K>();
	
	public void put(K key,V value){
		keys.add(key);
		Entry e = new Entry();
		e.setKey(key);
		e.setValue(value);
		entrys.add(e);
	}
	
	public void remove(K key){
		keys.remove(key);
		Entry e = new Entry();
		e.setKey(key);
		entrys.remove(e);
	}
	
	public V get(K key){
		for(Entry e : entrys){
			if(e.getKey().equals(key)){
				return e.getValue();
			}
		}
		return null;
	}
}
