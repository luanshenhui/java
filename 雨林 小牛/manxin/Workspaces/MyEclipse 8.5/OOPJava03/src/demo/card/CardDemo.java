package demo.card;

public class CardDemo {
	private int p;
	private int h;
	
	public static final int S = 0;
	public static final int SI = 0;
	public static final int WU = 0;
	public static final int LIU = 0;
	public static final int QI = 0;
	public static final int BA = 0;
	public static final int QIU = 0;
	public static final int SHI = 0;
	public static final int J = 0;
	public static final int Q = 0;
	public static final int K = 0;
	public static final int A = 0;
	public static final int ER = 0;
	public static final int GOUST = 0;
	
	public static final int FANGPIAN = 0;
	public static final int MEIHUA = 0;
	public static final int HONGTAO = 0;
	public static final int HEITAO = 0;
	public static final int XIAO = 0;
	public static final int DA = 0;
	
	public static final String[] ps = {"3","4","5","6","7","8","9","10","J","Q","K","A","2"};
	
	public static final String[] hs = {"方片","梅花","红桃","黑桃","大","小"};
	
	public CardDemo(){}

	public int getP() {
		return p;
	}

	public void setP(int p) {
		this.p = p;
	}

	public int getH() {
		return h;
	}

	public void setH(int h) {
		this.h = h;
	}
	
	@Override 
	public String toString(){
		return "["+hs[h]+ps[p]+"]";
	}
	
	@Override 
	public boolean equals(Object o){
		if(o == null){
			return false;
		}
//		if(o instanceof Card){}
		return false;
	}
	
}
