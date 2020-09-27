package aa;

public class AAA {
	public static void main(String[] args) {
		int i=0;
		AAA a=new AAA();
		BS b=new BS();
		b.m(b);
//		System.out.println(b.j);
	}
}

	class BS{
		int j=0;
		public void  m(BS b){
			//b.j+=1;
			System.out.println(b.j+=1);
	}
}
