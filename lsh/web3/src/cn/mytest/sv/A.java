package cn.mytest.sv;



public class A {
	
	public static void main(String[] args) {
		ShipWebServiceImplService fac = new ShipWebServiceImplService();
		ShipWebService s = fac.getShipWebServiceImplPort();
		VslDecIo io = new VslDecIo();
		io.setID("5213");
//		io.setVSLCNNAME("����");
//		io.setVSLENNAME("Ӣ��");
		ServiceResult map = s.vslDecService(io);
		System.out.println(map.getResult());
	}

}
