package zhaoyang2;

public class C {

	public Employee m(Employee[] arr) {
		Employee emp=arr[0];
		for(int i=0;i<arr.length;i++){
			if(arr[i].getSalary()>arr[0].getSalary()){
				emp=arr[i];
			}
		}
		return emp;
	}

}
