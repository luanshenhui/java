package day01;

public class Person1 extends Object {
	public static void main(String[] args) {
		Person2 a = new Person2();
		a.dd();
	}
	public void dd(){
		
	}
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return super.toString();
	}
	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return super.equals(obj);
	}
	@Override
	protected void finalize() throws Throwable {
		// TODO Auto-generated method stub
		super.finalize();
	}
}
class Person2 extends Person1{
	public void P(){
		
	}
}
