package com.yulin.pm;
import java.util.*;

public class ShuZuDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		/**身份证验证：S=Sum(Ai*Wi)，对前17位数字求和，最后一位是校验码
		 * Ai:表示第i位置上的身份证号数字值
		 * Wi：表示第i位置上的加权因子
		 * Wi：7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2
		 * 计算余数：Y=S%11
		 * 通过取余数得到相应的校验码
		 *      Y:0,1,2,3,4,5,6,7,8,9,10
		 * 校验码:1,0,X,9,8,7,6,5,4,3,2
		 * 如果得到余数为1则最后的校验码应该对应0，如果不是，则该身份证号不正确
		 */
		int[] yin={7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
		//			210212111111111111
		char[]jiao={'1','0','X','9','8','7','6','5','4','3','2'};
		
		Scanner scanid = new Scanner(System.in);
		System.out.println("请输入身份证号：");
		long id=scanid.nextLong();
		long a=0;
		int b=String.valueOf(id).length();
		
		long J=id%10;//取出身份证最后一位的验证码
		char YZM = Long.toString(J).charAt(0);
				
		System.out.println("校验码："+J);
		id=id/10;
		int sum=0;
//		int Y=0;
		System.out.println("身份证号："+id);
		for(int i=0;i<b-1;i++)
		{
			a=a*10+id%10;
			id=id/10;
		}
		System.out.println("id："+a);//a为倒置输出的id
		
		//计算出权的和 S
		for(int i=0;i<yin.length;i++){
			sum+=(a%10)*yin[i];
			a/=10;
		}
		System.out.println("权和："+sum);
		
		//计算余数Y
		int Y=sum%11;
		System.out.println("余数："+Y);
	//	System.out.println("jiaojiao："+jiao[Y]);
		
		//验证校验码
		for(int i=0;i<jiao.length;i++){
			System.out.println("jiaojiao："+jiao[Y]);
			if(jiao[Y]==YZM){
				
				System.out.println("您的身份证号是对的~");
				break;
			}else{
				System.out.println("您的身份证号是错的~");
				break;
			}
		}
		System.out.println("校验"+jiao[Y]);
			
	}

}
