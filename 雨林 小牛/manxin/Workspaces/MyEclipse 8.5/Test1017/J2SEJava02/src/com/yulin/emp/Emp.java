package com.yulin.emp;

public class Emp {
	private int empId;
	private String name;
	private int deptId;		//部门编号
	private int salary;	//工资
	private int age;	
	private String hireDate;	//入职时间
	
	public Emp() {
		super();
		// 无参数的构造方法
	}
	
	public Emp(int empId, String name, int salary, int age, String hireDate) {
		super();
		this.empId = empId;
		this.name = name;
		this.salary = salary;
		this.age = age;
		this.hireDate = hireDate;
	}
	public int getEmpId() {
		return empId;
	}
	public void setEmpId(int empId) {
		this.empId = empId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getDeptId() {
		return deptId;
	}
	public void setDeptId(int deptId) {
		this.deptId = deptId;
	}
	public int getSalary() {
		return salary;
	}
	public void setSalary(int salary) {
		this.salary = salary;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public String getHireDate() {
		return hireDate;
	}
	public void setHireDate(String hireDate) {
		this.hireDate = hireDate;
	}

	@Override
	public String toString() {
		return "Emp [empId=" + empId + ", hireDate=" + hireDate + ", name="
				+ name + "]";
	}
	
	@Override
	/**
	 * 1.不为空
	 * 2.类型匹配
	 * 3.自定义规则
	 */
	public boolean equals(Object o){
		if(o == null){
			return false;
		}
		if(o instanceof Emp){
			Emp e = (Emp)o;
			if(this.empId == e.empId && this.name.equals(e.name)){
				return true;
			}
		}
		return false;
	}
	
	@Override
	public int hashCode(){
		return this.empId * 1001;
	}
	
}
