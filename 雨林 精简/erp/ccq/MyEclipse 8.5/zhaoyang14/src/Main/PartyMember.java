package Main;

public class PartyMember extends Farther implements A {

	private int time;

	public PartyMember(String name, int time) {
		super(name);
		this.time = time;
	}

	public int getTime() {
		return time;
	}

	public void setTime(int time) {
		this.time = time;
	}

	@Override
	public boolean ms(A a) {
		PartyMember p1 = (PartyMember) a;
		
		return this.getTime() > p1.getTime();

	}

	@Override
	public String toString() {
		return this.getName()+this.getTime();
	}

}
