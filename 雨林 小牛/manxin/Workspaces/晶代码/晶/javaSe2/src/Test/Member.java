package Test;

public class Member extends Object{

	private String name;
	private double salary;
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public double getSalary() {
		return salary;
	}
	public void setSalary(double salary) {
		this.salary = salary;
		
	}
	public Member()
	{
		this("");
	}
	public Member(String name)
	{
		this(name,0);
	}
	
	public Member(String name,double salary)
	{
		this.name=name;
		this.salary=salary;
		
	}
	@Override
	public String toString() {
		return "ƒ„’Ê∫√";
    }
	
	public static void main(String[] args)
	{
		Member member=new Member("’‘¡˘",5500.0);
		
		System.out.println(member.toString());
	}
	
	
}
