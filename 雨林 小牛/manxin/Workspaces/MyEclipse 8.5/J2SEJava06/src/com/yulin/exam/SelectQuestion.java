package com.yulin.exam;
import java.io.*;
/**
 * 子类(选择题)
 * 属性：选项、正确答案
 * 方法：覆盖方法：显示，判断对错
 */
public class SelectQuestion extends Question{
	
	private String 正确答案;
	private String[] 选项;
	
	public String get正确答案() {
		return 正确答案;
	}
	public void set正确答案(String 正确答案) {
		this.正确答案 = 正确答案;
	}
	public String[] get选项() {
		return 选项;
	}
	public void set选项(String[] 选项) {
		this.选项 = 选项;
	}
	
	public SelectQuestion(){}
	
	public SelectQuestion(String 题干, String[] 选项, String 正确答案, int 分数){
		super(题干,分数);
		this.选项 = 选项;
		this.正确答案 = 正确答案;
	}
	
	@Override 
	public void 显示(){
		System.out.println(get题号() + "." + get题干());
		System.out.println("\t+A." + get选项()[0]);
		System.out.println("\t+B." + get选项()[1]);
		System.out.println("\t+C." + get选项()[2]);
		System.out.println("\t+D." + get选项()[3]);
	}
	
	@Override 
	public int 判断(String 用户答案){
		if(正确答案.equals(用户答案)){
			return get分数();
		}
		return 0;
	}
}
