package com.yulin.am;
import java.util.*;

public class ShuzuPaiDemo {

	public static void main(String[] args) {
		
		/**�����һ��5���������飬Ȼ����������ڽ������ �����������һ��������
		 * */
/*		Random rd = new Random();
		int[] arr = new int[5];
		System.out.println("���������ǰ��");
		for(int i=0;i<arr.length;i++){
			int in=rd.nextInt(100)+1;
			arr[i]=in;//�涨������ķ�Χ1~10
			for(int j=0;j<i;j++){
				if(arr[j]==in){
					i--;//���ֲ��ظ�
				}
			}	
		}
		System.out.println("����ǰ��"+Arrays.toString(arr));
		for(int i=0;i<=arr.length-1;i++){//���������
			for(int j=0;j<arr.length-i-1;j++){//ÿһ�ֱȽϵĴ���
				if(arr[j]>arr[j+1]){
					int temp;
					temp=arr[j];
					arr[j]=arr[j+1];
					arr[j+1]=temp;
				}	
				System.out.println("��"+(i+1)+"��,��"+(j+1)+"������:"+Arrays.toString(arr));
				//�鿴�������
			}			
		}
		System.out.println("�����"+Arrays.toString(arr));//Arrays����*/
		
		/**ѡ������5���������飬Ȼ�������������� 
		 */
/*		int[] ins={123,4,56,98,12};
		System.out.println("����ǰ��"+Arrays.toString(ins));		
		for(int i=0;i<ins.length-1;i++){
			int max=0;//��¼���Ԫ�ص��±�
			for(int j=1;j<ins.length-i;j++){
				if(ins[max]<ins[j]){
					max=j;
				}
				//ÿһ�ֱȽϽ���֮�������Ǹ�Ԫ�ص��±�ᱻ������max
			}
			if(max!=ins.length-i-1){
				int temp;
				temp=ins[max];
				ins[max]=ins[ins.length-i-1];//ins[ins.length-i-1]���һ�������±�
				ins[ins.length-i-1]=temp;
			}
		}
		System.out.println("�����"+Arrays.toString(ins));*/
		
//		long now = System.nanoTime();//��õ�ǰϵͳʱ�������
		
		/**�Ƚ����������Ƿ���ͬ*/
/*		int[] arr1={1,3,4,6,8,0};
//		int[] arr2={1,3,4,6,8,0};
		int[] arr2={2,3,4,5,6,7};
		if(Arrays.equals(arr1,arr2)==true){
			System.out.println("��ͬ");
		}else{
			System.out.println("����ͬ");
		}*/
		
		/**��������{1,2,3,4,5}�е�3���ڵ�λ��*/
//		int[] arr={1,2,3,4,5};
//		System.out.println(Arrays.binarySearch(arr, 3));
		
		/**���������򣬲������*/
//		int[] arr={11,54,123,1,5};
//		Arrays.sort(arr);
//		System.out.println(Arrays.toString(arr));

		/**����һ�����飬����Ϊ5��������Ҫ����������д�6��Ԫ��*/
		int[] arr = new int[5];
		arr=Arrays.copyOf(arr,arr.length+1);//copyof ��㸳ֵ
		System.out.println(Arrays.toString(arr));
		
		int[] i1={1,2,3,4};
		int[] i2=i1;//ǳ�㸳ֵ��ֻ�ǰѵ�ַ��ֵ
		i2[0]=99;
		System.out.println(Arrays.toString(i1));
		int[] i3=Arrays.copyOf(i1, 4);
		i3[1]=99;
		System.out.println(Arrays.toString(i1));
		System.out.println(Arrays.toString(i3));
	}


}
