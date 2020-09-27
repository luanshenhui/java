package com.yulin.pm;

import java.util.Arrays;

public class QuickShort {

	/**
	 * ����Ŀ�������Ͳ�������
	 */
	public static int Partition(int[] a,int p,int r){
		int x=a[r-1];
		int i=p-1;
		int temp;
		for(int j=p;j<=r-1;j++){
			if(a[j-1]<=x){
				//swap(a[j-1],a[i-1]);
				i++;
				temp=a[j-1];
				a[j-1]=a[i-1];
				a[i-1]=temp;
			}
		}
		//swap(a[r-1,a[i+1-1]);
		temp=a[r-1];
		a[r-1]=a[i+1-1];
		a[i+1-1]=temp;
		return i+1;
	}
	
	public static void QuickShort(int[] a,int p,int r){
		if(p<r){
			int q=Partition(a,p,r);
			QuickShort(a,p,q-1);
			QuickShort(a,q+1,r);
		}
	}
	
	//��������
/*	public static void QuickShort(int[] number){
		for(int j=1;j<number.length;j++){
			int temp=number[j];	//ץ���������ŵ�����temp�У����Ժ�֮ǰ�ıȽ�
			int i=j-1;	//ǰһ�����±�
			while(i>=0 && number[i]>temp){
				//��һ��ǰ���ȥ�Ƚϣ�����Ѿ���ǰһ�����󣬾Ͳ���Ҫ����
				number[i+1]=number[i];
				i--;
			}	
				number[i+1]=temp;		//���whileѭ����������������Ѿ�������ˣ�ֱ�ӷ��ڵ�ǰλ��
										//i+1ʵ����=j
		}
	}*/
	public static void main(String[] args) {
		/*��������
		int[] a={23,53,77,36,84,76,93,13,45,24};
		QuickShort(a,1,10);*/
		
		//��������
		int[] number={3,46,26,67,2,35};
		QuickShort(number,1,6);
//		QuickShort(number);
		System.out.println(Arrays.toString(number));
	}

}
