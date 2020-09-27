package Main;

public class Sorter {
	private int i=0;

	A[]arr=new A[4];
	public void add(A farther) {
		//PartyMember	partyMember=(PartyMember)Farther;
		arr[i++]=farther;
		
		
	}

	public void display() {
		//A[]arr=new A[4];
		for(int i=0;i<arr.length;i++){
			for(int j=0;j<arr.length-i-1;j++){
				A o=arr[j];
				if(arr[j].ms(arr[j+1])){
					arr[j]=arr[j+1];
					arr[j+1]=o;
				}
			}
		}
		for(A aa:arr){
			System.out.println(aa);
		}
		
	}

	
		
	}


