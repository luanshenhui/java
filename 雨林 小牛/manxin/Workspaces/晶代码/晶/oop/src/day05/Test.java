package day05;

public class Test {
	int  a = 1;
	class test{
		int a = 3;
		int b =32;
		public void bb(){
			this.a = 2;
			Test.this.a =2;
		}
	}
	public void aa(){
		test t = new test();
		t.b =2;
		
	}
}
class aaa{
	public void aa(){
		//Test.test a = Test.new.test();
		//Outer.Inner in=new Outer.Inner()¡£
	}
}