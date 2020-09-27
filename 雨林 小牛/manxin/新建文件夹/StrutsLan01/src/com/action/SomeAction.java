package com.action;

public class SomeAction {

	public SomeAction() {
		System.out.println("SomeAction()...");
	}
	public String execute(){
		System.out.println("SomeAction.execute()...");
		return "success";
	}
}
