package com.test.client;

public class MainClass {
//	public static void main(String[] args) {
//	ShipWebServiceImplService fac = new ShipWebServiceImplService();
//	ShipWebService s = fac.getShipWebServiceImplPort();
//	VslUpdateDecIo io = new VslUpdateDecIo();
//	io.setVSLDECID("01101515");//不可为空	主键传�?过来�?                                            
//	io.setVSLCNNAME("中f");//不可为空	中文船名                                                 
//                                   
//	ServiceResult map = s.vslAprService(io);
//	System.out.println(map);
//	}
	
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
				ShipWebServiceImplService fac = new ShipWebServiceImplService();
				ShipWebService s = fac.getShipWebServiceImplPort();
				VslDecIo io = new VslDecIo();
				io.setVSLDECID("01101515");//不可为空	主键传�?过来�?                                            
				io.setVSLCNNAME("中文船名中文船名中文船名对");//不可为空	中文船名                                                 
				io.setVSLENNAME("英文船名");//不可为空	英文船名                                                 
				io.setCOUNTRYCNNAME("中文国籍");//不可为空	中文国籍                                             
				io.setCOUNTRYENNAME("英文国籍");//不可为空	英文国籍                                             
				io.setCALLSIGN("呼号");//不可为空	呼号                                                   
				io.setTOTALTON("吨数");//不可为空	吨数                                                   
				io.setNETTON("净吨");//不可为空	�?��                                                     
				io.setVOYAGENO("航次");//不可为空	航次                                                   
				io.setLOADPORT("始发");//不可为空	始发�?                                                 
				io.setSHIPTYPE("船舶类型 ");//不可为空	船舶类型                                                 
				io.setHAVECORPSE("有无尸体");//不可为空	船上有无尸体                                               
				io.setHAVEBIER("有无棺椁");//不可为空	船上有无棺椁                                               
				io.setCURCARGOSIT("载货种类数量及预靠泊地点");//不可为空	载货种类数量及预靠泊地点                                     
				io.setHISCARGOSIT("上航次载货种类数量及本次到港作业任务");//不可为空	上航次载货种类数量及本次到港作业任务                               
				io.setSHIPPERPSNNUM("船员人数");//不可为空	船员人数                                             
				io.setVISITORPSNNUM("旅客人数");//不可为空	旅客人数                                             
				io.setSTARTSHIPSIT("发航港及出发日期");//不可为空	发航港及出发日期                                         
				io.setESTARRIVDATE("2018-01-01 00:00:00");//不可为空	预计抵达日期及时�?                                       
				io.setLASTFOURPORT("近四周寄港及日期");//不可为空	近四周寄港及日期                                         
				io.setSHIPSANITCERT("船舶免予卫生控制措施证书日期");//不可为空	船舶免予卫生控制措施证书/船舶卫生控制措施证书签发港及日期                    
				io.setTRAFCERT("工具卫生证书签发港及日期 ");//不可为空	交�?工具卫生证书签发港及日期                                      
				io.setHAVINGPATIENT("穿上有无病人");//不可为空	船上有无病人                                           
				io.setHAVINGCORPSE("船上是否有人非因意外死亡 ");//不可为空	船上是否有人非因意外死亡                                     
				io.setHAVINGMDKMDICPS("在航海中船上是否有鼠类或其它医学媒介生物反常死亡 ");//不可为空	在航海中船上是否有鼠类或其它医学媒介生物反常死亡                     
				io.setDECORG("申报单位 ");//不可为空	申报单位                                                     
				io.setDECDATE("2018-01-01 00:00:00");//不可为空	申报时间                                                     
				io.setDECUSER("申报人员 ");//不可为空	申报人员                                                     
				io.setQUARTYPEDEC("1");//不可为空	�?��方式（申报）                                       
				io.setAPPROVEDATE("2018-01-01 00:00:00");//可为�?审批时间(审批)                                              
				io.setAPPROVEUSER("审批人员");//可为�?审批人员(审批)                                              
				io.setINSPORGCODE("监管局");//不可为空	监管�?���?                                         
				io.setINSPORGNAME("ss");//不可为空	监管�?���?                                         
				io.setQUARTYPEAPPR("ff");//可为�?�?��方式（审批）                                          
				io.setCHECKRST("ss");//可为�?登轮�?��结果（审批）                                             
				ServiceResult map = s.vslDecService(io);
				System.out.println(map.getResult());
	}
}