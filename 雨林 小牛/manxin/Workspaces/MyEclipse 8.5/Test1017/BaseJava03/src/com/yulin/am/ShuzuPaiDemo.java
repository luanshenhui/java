package com.yulin.am;
import java.util.*;

public class ShuzuPaiDemo {

	public static void main(String[] args) {
		
		/**随机成一个5个数的数组，然后对其排序，在进行输出 ，不能随机出一样的数字
		 * */
/*		Random rd = new Random();
		int[] arr = new int[5];
		System.out.println("随机数排序前：");
		for(int i=0;i<arr.length;i++){
			int in=rd.nextInt(100)+1;
			arr[i]=in;//规定随机数的范围1~10
			for(int j=0;j<i;j++){
				if(arr[j]==in){
					i--;//数字不重复
				}
			}	
		}
		System.out.println("排序前："+Arrays.toString(arr));
		for(int i=0;i<=arr.length-1;i++){//排序的轮数
			for(int j=0;j<arr.length-i-1;j++){//每一轮比较的次数
				if(arr[j]>arr[j+1]){
					int temp;
					temp=arr[j];
					arr[j]=arr[j+1];
					arr[j+1]=temp;
				}	
				System.out.println("第"+(i+1)+"轮,第"+(j+1)+"次排序:"+Arrays.toString(arr));
				//查看排序过程
			}			
		}
		System.out.println("排序后："+Arrays.toString(arr));//Arrays工具*/
		
		/**选择排序，5个数的数组，然后对其排序，再输出 
		 */
/*		int[] ins={123,4,56,98,12};
		System.out.println("排序前："+Arrays.toString(ins));		
		for(int i=0;i<ins.length-1;i++){
			int max=0;//记录最大元素的下标
			for(int j=1;j<ins.length-i;j++){
				if(ins[max]<ins[j]){
					max=j;
				}
				//每一轮比较结束之后，最大的那个元素的下标会被保存至max
			}
			if(max!=ins.length-i-1){
				int temp;
				temp=ins[max];
				ins[max]=ins[ins.length-i-1];//ins[ins.length-i-1]最后一个数的下标
				ins[ins.length-i-1]=temp;
			}
		}
		System.out.println("排序后："+Arrays.toString(ins));*/
		
//		long now = System.nanoTime();//获得当前系统时间的纳秒
		
		/**比较两个数组是否相同*/
/*		int[] arr1={1,3,4,6,8,0};
//		int[] arr2={1,3,4,6,8,0};
		int[] arr2={2,3,4,5,6,7};
		if(Arrays.equals(arr1,arr2)==true){
			System.out.println("相同");
		}else{
			System.out.println("不相同");
		}*/
		
		/**搜索数组{1,2,3,4,5}中的3所在的位置*/
//		int[] arr={1,2,3,4,5};
//		System.out.println(Arrays.binarySearch(arr, 3));
		
		/**给数组排序，并且输出*/
//		int[] arr={11,54,123,1,5};
//		Arrays.sort(arr);
//		System.out.println(Arrays.toString(arr));

		/**定义一个数组，长度为5，但是需要向这个数组中存6个元素*/
		int[] arr = new int[5];
		arr=Arrays.copyOf(arr,arr.length+1);//copyof 深层赋值
		System.out.println(Arrays.toString(arr));
		
		int[] i1={1,2,3,4};
		int[] i2=i1;//浅层赋值：只是把地址赋值
		i2[0]=99;
		System.out.println(Arrays.toString(i1));
		int[] i3=Arrays.copyOf(i1, 4);
		i3[1]=99;
		System.out.println(Arrays.toString(i1));
		System.out.println(Arrays.toString(i3));
	}


}
