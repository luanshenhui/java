package com.yulin.am;

public class ExceptionDemo2 {

	/**
	 * �׳��쳣 thorws
	 */
	public static void main(String[] args) {
		GuKe gk = new GuKe();
		gk.dianCai();

	}
}

class ChuShi{	//��ʦ
	public void chaoTDS(TuDou td)throws Exception{
		if(td.c > 0){
			System.out.println("����˿�����ˣ�");
		}else{
//			throw new RuntimeException("����û����");
			throw new Exception("����û����");
		}
	}
}

class TuDou{	//����
	static int c = 0;
}

class FuWuyuan {	//����Ա
	public void zuoCai()throws Exception{
		ChuShi cs = new ChuShi();
		cs.chaoTDS(new TuDou());
	}
}

class GuKe{    //�˿�
	public void dianCai(){
		FuWuyuan fwy = new FuWuyuan();
		try {
			fwy.zuoCai();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("��һ���ˣ�");
		} 
	}
}