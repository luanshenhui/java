package com.yulin.pm;
import java.util.*;

public class ShuZuDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		/**���֤��֤��S=Sum(Ai*Wi)����ǰ17λ������ͣ����һλ��У����
		 * Ai:��ʾ��iλ���ϵ����֤������ֵ
		 * Wi����ʾ��iλ���ϵļ�Ȩ����
		 * Wi��7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2
		 * ����������Y=S%11
		 * ͨ��ȡ�����õ���Ӧ��У����
		 *      Y:0,1,2,3,4,5,6,7,8,9,10
		 * У����:1,0,X,9,8,7,6,5,4,3,2
		 * ����õ�����Ϊ1������У����Ӧ�ö�Ӧ0��������ǣ�������֤�Ų���ȷ
		 */
		int[] yin={7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
		//			210212111111111111
		char[]jiao={'1','0','X','9','8','7','6','5','4','3','2'};
		
		Scanner scanid = new Scanner(System.in);
		System.out.println("���������֤�ţ�");
		long id=scanid.nextLong();
		long a=0;
		int b=String.valueOf(id).length();
		
		long J=id%10;//ȡ�����֤���һλ����֤��
		char YZM = Long.toString(J).charAt(0);
				
		System.out.println("У���룺"+J);
		id=id/10;
		int sum=0;
//		int Y=0;
		System.out.println("���֤�ţ�"+id);
		for(int i=0;i<b-1;i++)
		{
			a=a*10+id%10;
			id=id/10;
		}
		System.out.println("id��"+a);//aΪ���������id
		
		//�����Ȩ�ĺ� S
		for(int i=0;i<yin.length;i++){
			sum+=(a%10)*yin[i];
			a/=10;
		}
		System.out.println("Ȩ�ͣ�"+sum);
		
		//��������Y
		int Y=sum%11;
		System.out.println("������"+Y);
	//	System.out.println("jiaojiao��"+jiao[Y]);
		
		//��֤У����
		for(int i=0;i<jiao.length;i++){
			System.out.println("jiaojiao��"+jiao[Y]);
			if(jiao[Y]==YZM){
				
				System.out.println("�������֤���ǶԵ�~");
				break;
			}else{
				System.out.println("�������֤���Ǵ��~");
				break;
			}
		}
		System.out.println("У��"+jiao[Y]);
			
	}

}
