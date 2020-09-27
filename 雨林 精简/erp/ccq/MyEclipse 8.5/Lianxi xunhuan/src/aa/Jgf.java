package aa;

public class Jgf {
	public static void main(String[] args) {
		int[]arr={1,5,2,60,8,4,0,2,4};
		//for(int i=0;i<arr.length;i++){
			for(int j=0;j<arr.length-1;j++){
				if(arr[j]>arr[j+1]){
					int s=arr[j];
					arr[j]=arr[j+1];
					arr[j+1]=s;
				}
			}
		//}
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		
	}
}
