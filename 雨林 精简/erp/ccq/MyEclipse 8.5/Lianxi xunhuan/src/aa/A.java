package aa;

public class A {
	public static void main(String[] args) {
		
		for(int i=1;i<10;i++){
			for(int j=1;j<=i;j++){
				System.out.print(j+"X"+i+"="+i*j+"\t");
			}
			System.out.println();
		}
		
		
		for(int i=1;i<10;i++){
			for(int j=1;j<=10-i;j++){
		//		System.out.print(j+"X"+(10-i)+"="+j*(10-i)+"\t");
			}
			//System.out.println();
		}
		
		
//		int[]arr={1,2,3,8};
//		int[]ars={1,5,6,8};
//		
//		int count=m(arr,ars);
//		System.out.println(count);
//		
//	}
//
//	private static int m(int[] arr, int[] ars) {
//		int count=0;
//		for(int i:arr){
//			for(int j:ars){
//				if(i==j){
//					count++;
//				}
//			}
//		}
//		return count;
	}
	
public static int m1(int n){
	 
	if(n==2){
		return 1;
	}
	if(n==1){
		return 0;
	}
	System.out.println(m1(n-1)+m1(n-2));
//	return m1(n-1)+m1(n-2);
	return m1(n-1)+m1(n-2);
}

	

}
