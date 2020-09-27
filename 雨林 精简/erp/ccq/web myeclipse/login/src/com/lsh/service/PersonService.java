package com.lsh.service;

public interface PersonService {
	//业务方法
	public abstract boolean islogin(String username, String password);
	
	
	public abstract boolean register(String username, String password);
	
	
}
