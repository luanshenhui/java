package com.yulin.exam;
import java.io.*;
/**
 * 子类(填空题)
 * 属性：正确答案
 * 方法：覆盖方法：显示，判断
 */
public class FillingQuestion extends Question{
	private String 正确答案;
	
	public FillingQuestion(){}
	
	public FillingQuestion(String 题干, String 正确答案, int 分数){
		super(题干,分数);
		this.正确答案 = 正确答案;
	}
	
	public String get正确答案() {
		return 正确答案;
	}
	
	public void set正确答案(String 正确答案) {
		this.正确答案 = 正确答案;
	}

	@Override
	public void 显示(){
		System.out.println(get题号() + "." + get题干());
	}
	
	@Override 
	public int 判断(String 用户答案){
		if(正确答案.equals(用户答案)){
			return get分数();
		}else{
			return 0;
		}
	}

}