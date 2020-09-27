package com.yulin.am;

public class ExceptionDemo2 {

	/**
	 * 抛出异常 thorws
	 */
	public static void main(String[] args) {
		GuKe gk = new GuKe();
		gk.dianCai();

	}
}

class ChuShi{	//厨师
	public void chaoTDS(TuDou td)throws Exception{
		if(td.c > 0){
			System.out.println("土豆丝做好了！");
		}else{
//			throw new RuntimeException("土豆没有了");
			throw new Exception("土豆没有了");
		}
	}
}

class TuDou{	//土豆
	static int c = 0;
}

class FuWuyuan {	//服务员
	public void zuoCai()throws Exception{
		ChuShi cs = new ChuShi();
		cs.chaoTDS(new TuDou());
	}
}

class GuKe{    //顾客
	public void dianCai(){
		FuWuyuan fwy = new FuWuyuan();
		try {
			fwy.zuoCai();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("换一个菜！");
		} 
	}
}