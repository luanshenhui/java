package com.lsh.chinarc.common;

public enum Enum {

	eA("a","d"),
	eB("d","s");

	private Enum() {
	}

	private Enum(String code, String step) {
		this.code=code;
		this.step=step;
	}

	private String code;

	private String step;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getStep() {
		return step;
	}

	public void setStep(String step) {
		this.step = step;
	}

    public static Enum getRuleCode(String str){
    	Enum b = null;
    	switch (str) {
			case "a":
				b = eA;
				break;
			case "b":
				b = eB;
				break;
			default:
				break;
		}
    	return b;
    }
    public static void main(String[] args) {
		System.out.println(getRuleCode("b").code);
	}
}
