package chinsoft.service.webservice;

import java.util.ArrayList;
import java.util.List;
import javax.jws.WebParam;
import chinsoft.business.CDict;
import chinsoft.business.LogisticManager;
import chinsoft.business.OrdenManager;
import chinsoft.business.ReceiptManager;
import chinsoft.business.XmlManager;
import chinsoft.core.ResourceHelper;
import chinsoft.entity.Customer;
import chinsoft.entity.Logistic;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.entity.Receipt;
import chinsoft.service.core.Encryption;

public class XmlService {

	public static String submitOrder(String strXml) {
		List<Orden> ordens = new ArrayList<Orden>();
//		strXml = "<Order>"+
//				"<OrderInformation>"+	
//				"<OrderDate>2012-09-22</OrderDate>"+
//				"<Createman>TESTAA</Createman>"+
//				"<Password>123456</Password>"+
//				"<ClothingID>1</ClothingID>"+
//				"<SizeCategoryID>10053</SizeCategoryID>"+
//				"<SizeAreaID>10201</SizeAreaID>"+
//				"<Fabrics>DBL625A1</Fabrics>"+
//				"<SizeUnitID>10266</SizeUnitID>"+
//				"<ClothingStyle>20100</ClothingStyle>"+
//				"<CustormerBody>10368,10088,10092,10090,10091,10087,10085,10086</CustormerBody>"+
//				"<ClothingSize>10133:33,10137:,10136:,10134:56,10129:33,10127:99,10128:,10120:66,10123:70,10126:99,10117:55,10114:66,10113:66,10111:45,10108:89,80,10105:77,10102:89</ClothingSize>"+
//				"</OrderInformation>"+	
//				"<CustomerInformation>"+	
//				"<CustomerName>alipy</CustomerName>"+
//				"<Height>178</Height>"+
//				"<HeightUnitID>10266</HeightUnitID>"+
//				"<Weight>62</Weight>"+
//				"<WeightUnitID>10261</WeightUnitID>"+
//				"<Email>bolatusda@126.com</Email>"+
//				"<Address>青岛</Address>"+
//				"<Tel>13697656980</Tel>"+
//				"<GenderID>10040</GenderID>"+
//				"</CustomerInformation>	"+
//				"<OrderDetails>"+
//				"<OrderDetail id = '1'>"+
//				"<OrderDetailInformation>"+		
//				"<SizeSpecChest></SizeSpecChest>"+	
//				"<SizeSpecHeight>34S</SizeSpecHeight>"+	
//				"<Categories>3</Categories>"+	
//				"<Quantity>2</Quantity>"+	
//				"<BodyStyle>10284</BodyStyle>"+	
//				"</OrderDetailInformation>"+		
//				"<EmbroideryProcess>"+		
//				"<Embroidery id = '1'>"+	
//				"<Location>427</Location>"+	
//				"<Font>528</Font>"+
//				"<Color>450</Color>"+
//				"<Content>421:SA</Content>"+
//				"<Size></Size>"+
//				"</Embroidery>"+
//				"<Embroidery id = '2'>"+	
//				"<Location>1467</Location>"+	
//				"<Font>530</Font>"+
//				"<Color>484</Color>"+
//				"<Content>421:SA3</Content>"+
//				"<Size></Size>"+
//				"</Embroidery>"+
//				"</EmbroideryProcess>"+	
//				"<Style></Style>"+
//				"<OrdersProcess>38,52,100,131,146,379,565</OrdersProcess>"+	
//				"<OrdersProcessContent>20111:钉红领商标</OrdersProcessContent>"+	
//				"</OrderDetail>"+
//				"<OrderDetail id = '2'>"+
//				"<OrderDetailInformation>"+		
//				"<SizeSpecChest></SizeSpecChest>"+	
//				"<SizeSpecHeight>28R</SizeSpecHeight>"+	
//				"<Categories>2000</Categories>"+	
//				"<Quantity>2</Quantity>"+	
//				"<BodyStyle>10284</BodyStyle>"+	
//				"</OrderDetailInformation>"+		
//				"<EmbroideryProcess>"+		
//				"<Embroidery id = '3'>"+	
//				"<Location>2208</Location>"+	
//				"<Font>2588</Font>"+
//				"<Color>2457</Color>"+
//				"<Content>2207:LOVE</Content>"+
//				"<Size></Size>"+
//				"</Embroidery>"+
//				"</EmbroideryProcess>"+	
//				"<Style></Style>"+
//				"<OrdersProcess>2050,2070</OrdersProcess>"+	
//				"<OrdersProcessContent></OrdersProcessContent>"+	
//				"</OrderDetail>"+	
//				"</OrderDetails>"+	
//				"<Logistic>"+
//				"<Name></Name>"+
//				"<Address></Address>"+
//				"<Mobile></Mobile>"+
//				"<Tel></Tel>"+
//				"<SendTime></SendTime>"+
//				"</Logistic>"+	
//				"<Receipt>"+
//				"<Type>0</Type>"+
//				"<Name>xxx</Name>"+
//				"<Identity>xxx</Identity>"+
//				"<Address>xxx</Address>"+
//				"<Phone>xxx</Phone>"+
//				"<Bankname>xxx</Bankname>"+
//				"<Bankcardid>xxx</Bankcardid>"+
//				"</Receipt>"+		
//				"</Order>";

		String end = "";
		try {
//			strXml="C8AFC26A130CAF4C6729728D81C1C257259A4FCBCBCEAF8205FF9DB9F121B18B1CFF8A5B6BF9FAF4A91CBE7FC102086EED4706E81C7E0910F8D9DA90FDCCA8B787C9FBAB4819D0BE5A2E2479239B1A56D97B0949A6D68CFA1FB052A1F7AF98271AF93BEA2F083CE53AF7799A6C21A994A8396CAE80F87427ADA57938FC7F2F18A5D7CC13AD81FA7065B3D84248EFA2F35D11819B133A8EE0BA46F9AF6057CFE525D7E0D729F5E486EBFCA093128BD224D7FB134CB3BCD31B254A4EEBF1679FACC5E6F03254656A7A331DB2B339B886D5A0639687F98B3468BD1E2B5F1D9CA42BBB11C75499C3224654B3C4FA172F0F476D420A1F4D1EB824A5C0381725DD2B3B9E7B26A8E816ADAF181AF612F92E51EC7BEEADE3D00ACD00E11150EE018543A4570F5BB9FBC48F7E52AB440D2C194D995DA4C65DCB3F4E7561C8E7C152F53E0F711EE04BA90BB3009F7AC720328F93E0C9B939ADF134F8A03F2D48221EA57CB24443A08CDF200B5B8FAFAB684457A6CDA3E183081FF2A1FAF56857920A1228608452E7B61E3E81922521389CF8B187622C4AC6D40727D0A0737C15DC7406511D6D50DE6ADC07C8D55C6EC942145A1F7C3FB15B7D909C31855EF83DB10243B7F94FBAFC20A8C193F71D5EAB3952A8632FF20FB347FB620380453129D42EF0497A0E748C04DB7C9441E2591F3D4F36317EDFB9515E9A5EC3D0D56714442A823BE47EF2510A5ACA6DFE914ABC0A19B9333277FDC05E474AC6C99DA0B8C23F04D2EDB9A7F8275232A374E7FB9DCD9F6405928650BDD9A86986C5E376FDF2D0C6CC974614262D61AD5C37552214D16ABCB88DE937C95ED1C55C675A05DE81514FBAAD29CE1A9688AB91FF53A010FEF62836EFA99C920352763BD621315526E0016B15F27A2780E877236A17F23EF11AD215766E99EBF5A48D5E78BB1F791C6E98A94654C2D9D4FF20E8E6C6073630D666AD487C556EDA08407B7A44C8BD9F5DC87A3D01B90057D03A96E9613EC4D822B778D51B93F50DDD670EC6FEDDAAB5948CB9ED28BA91F6F7A1D574C854D8AC745C2C49C928C3B8B22E54FB39B6DE5E75BF4096CBB3A23CA3AF6A05C66F42F02F5E30D2E47E201FCBD34F6395D1E72AF967EBCB503330F28AE554820F73CAEFC3B6C7CB44D1314CC47D0A8E796FAC021262F73062873DCD5AD9E82C44EC400D670E9389DBCF9AB7FAD6CB54F24358F989C8D56A973FEB286B7354D2D2D38B261833528C8EF95D4DEB98E10EDF9D28B46910135161E90E61FE21A22337C77EEE1D4F68CCE2A8E9EF62C63F8A0CE640481260D8134DEC81C60982F08395035B68B2464768128A0F8FAE99C21855A054D0F2CDAC04FD6382B24520B1CCB2E7922C14D94713BE71E3368A82888BC0602A8E7140EB4F2870A61A08C81C884C7E36FC656FC0D768330057B2768E6ADA6D01EBA452C7F8B87963D92D26F133F389282CF6E87A0C02DE0FF5574850065C7F9B7581A6B1420CE801A68F9AD8E9C19C5299C51760AAF2EC234D6A317C89305343572CE5E55E87BB629365DF428CC41FB97174E91662B0BDBADC020D971C31557A22DC46E1219D33897904E5BF190A2B244BB4A17F5B602F5557DE96C13137A085F772AE682BD4CAA6236ED62E65A728795F0BB62E8CFDE37C395FAA7AD340C58A75E2DFFC0394779C246CB8EB8B189908C7EF8DE8014708A9F140D2BF757A8A103FEE370E2313ADC75A16CAF04C74A4A13999EC46BD673FDFE2E9A0DA7F86FCB4815104912E541C5948E07507DD72BFC09808C5059DC52615D5F864944050D7FE4F121568942B1245A2FC065EE571E35B5AB53F46235A0C29DABC54AEF422B648101359B0C9838D2DFAFFC19F245A4DF582A93EFDBCE8E5947CFA08325B4F4D206400BBEADE8C080788C20CB13CB9C1E340844FA90D8235E17EF2D207944DF4944D0BD72B4C408B8F170EA3FE6DEF77C6D85BFE26DE03CB01B4A041A8437E7013A302556719F5E0FAE4A117ADCA0F91619B66A28A025E4923128E7EBFB69A322F8C860CDAF5D25D339033F427B3C8BFB1179A61B4E8B5489DD9F309EC48AD430C867EB4DCDDCD3D3D6B6823C6EC95629742EBF139690003485D17838D8B405E5CB062ED1A53A7648CA1352516734E21B27A3D1A3BEEA74221026DC1877A47FF61410958E24F9679A7F2CA458A590EC82C9A4485847AF7A0F23B6B7F72628676DE31482546A83B76B67913EC560CED6A42A3F5DE833E61E120E211644B0BB26658096DD3B858FF73935DB4BB0EC225E01B55EC0F014D7671EC94FA6481354995712187487236097185998EA060213B973C33E17D8D9B6FB6682FF57542AF84E4CF037CDF2C80BF66B2DDA9FFD3F227293A9AA5C6F01BA996BF86C0D71C238D69BAF7CF039AF0646D74AD3389D844A61CE8F4C50C4C67014E2654C89E08BB377F5D00973CD950F7AF2D9FB3CBB5812A4248A72BD9273119050D1F1497A8663E642987F22449AD58CF02D17682D602085092E70166D57AA616542B2D481F98665F3F48D640CD1B21AE2B0CE5B89A2308616397BECFAB3BECF78773342DF603A81747233EC1101CBA83FA34FF4EC28660DB7FA829FD55BDB2263922ECA7FBDC44BD033F67F9289DC07485722EC607394CA3CEFED44E307259E3DB4252992D770DDD36C90FAF37EE6A3722E5DE91AA396083D334F128B280";
//			strXml="<?xml version='1.0' encoding='UTF-8'?> <Order><OrderInformation><OrderDate>2013-12-12 13:50:49</OrderDate><Createman>TESTAA</Createman><Password>123456</Password><ClothingID>3000</ClothingID><SizeCategoryID>10053</SizeCategoryID><SizeAreaID></SizeAreaID><Fabrics>CGMP052</Fabrics><SizeUnitID>10266</SizeUnitID><ClothingStyle>20100</ClothingStyle><CustormerBody>10087,10088,10086,10090,10091,10092</CustormerBody><ClothingSize>10102:110.0,10105:96.0,10108:106.0,10113:69.0,10114:69.0,10117:82.0,10111:46.0,10133:38.0,10135:24.0,10173:82.0,10140:40.0</ClothingSize><CompanyCode></CompanyCode><VersionCode>2</VersionCode><Save>1</Save><UserNo>MPD791</UserNo><JTSize>10101:,10102:,10105:,10108:,10110:,10111:,10113:,10114:,10115:,10116:,10117:,10130:,10131:,10172:</JTSize></OrderInformation><CustomerInformation><CustomerName>Andreas Nikoleris Ring Nicole</CustomerName><Height>188.0</Height><HeightUnitID>10266</HeightUnitID><Weight>0.0</Weight><WeightUnitID>10260</WeightUnitID><Email></Email><Address></Address><Tel></Tel><GenderID>10040</GenderID></CustomerInformation><OrderDetails><OrderDetail id ='1'><OrderDetailInformation><SizeSpecChest></SizeSpecChest><SizeSpecHeight></SizeSpecHeight><Categories>3000</Categories><Quantity>1</Quantity><BodyStyle>10284</BodyStyle></OrderDetailInformation><EmbroideryProcess><Embroidery id ='1'><Location>3247</Location><Font>3625</Font><Color>3670</Color><Content>3676:NA</Content><Size></Size></Embroidery></EmbroideryProcess><Style></Style><OrdersProcess>3028,3040,3059,3086,3095,3945,50770,3862,7086,3804,3821</OrdersProcess><OrdersProcessContent>3981:CGMP044,3940:CGMP044,3421:914,50164:FYBSBO39S</OrdersProcessContent></OrderDetail></OrderDetails></Order>";
//			strXml = Encryption.encrypt(strXml,  CDict.DES_KEY);//加密
			System.out.println("XML订单导入接口(解密前)："+strXml);
			String strOrdenXml =Encryption.decrypt(strXml, CDict.DES_KEY);// 解密
			System.out.println("XML订单导入接口(解密后)："+strOrdenXml);
			Orden orden = XmlManager.getOrdenFromXml(strOrdenXml);//订单信息
			Logistic logistic = XmlManager.getLogisticFromXml(strOrdenXml);//物流信息
			Receipt receipt = XmlManager.getReceiptFromXml(strOrdenXml);//发票信息
			if (orden == null) {
				end = "<Orden><Result>FAIL</Result><OrdenID></OrdenID><Content>"+ResourceHelper.getValue("Orden_Fail")+"</Content></Orden>";
			} else {
				String result="";
				/*String result = new XmlManager().validateOrden(orden);// 工艺冲突
				if ("".equals(result)) {// 无冲突工艺*/					
				ordens.add(orden);
				Customer customer = orden.getCustomer();
				result = new OrdenManager().submitOrdens(customer, ordens);// 保存订单
				if("1".equals(orden.getMemo())){
					orden.setMemo("");
					end = "<Orden><Result>SUCCESS</Result><OrdenID>"+orden.getOrdenID()+"</OrdenID><Content></Content></Orden>";
				}else{
					if ("".equals(result)){//订单保存成功
						if(logistic != null){//物流信息
							logistic.setOrdenID(orden.getOrdenID());
							logistic.setSysCode(orden.getSysCode());
							new LogisticManager().saveLogistic(logistic);
						}
						if(receipt != null){//发票信息
							receipt.setOrdenID(orden.getOrdenID());
							receipt.setSysCode(orden.getSysCode());
							new ReceiptManager().saveReceipt(receipt);
						}
						for(Orden o : ordens){
							orden.setStatusID(10039);//待支付状态
							List<OrdenDetail> details = o.getOrdenDetails();
							for(OrdenDetail detail : details){
								detail.setID(null);
								detail.setOrdenID(null);
							}
						}
						try{
							result = new OrdenManager().submitOrdens(customer, ordens);// 提交订单(待支付)
						}catch(Exception e){
							result ="<Orden><Result>FAIL</Result><OrdenID></OrdenID><Content>"+ResourceHelper.getValue("Orden_Fail")+"</Content></Orden>";
						}
						if ("".equals(result)) {// 订单提交成功
							end = "<Orden><Result>SUCCESS</Result><OrdenID>"+orden.getOrdenID()+"</OrdenID><Content></Content></Orden>";
						}else{//提交失败，删除订单
							end = "<Orden><Result>FAIL</Result><OrdenID></OrdenID><Content>"+ result+"</Content></Orden>";
							new OrdenManager().removeOrdens(orden.getOrdenID());
							if(logistic != null){//物流信息
								new LogisticManager().removeLogisticByOrdenID(orden.getOrdenID());
							}
							if(receipt != null){//发票信息
								new ReceiptManager().removeReceiptByOrdenID(orden.getOrdenID());
							}
						}
					}else{
						end = result;
					}
				}
				/*} else {
					end = result;
				}*/
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
//			e.printStackTrace();
			end = "<Orden><Result>FAIL</Result><OrdenID></OrdenID><Content>"+ResourceHelper.getValue("Orden_Fail")+"</Content></Orden>";
		}
		System.out.println(end);
		return end;
	}

	// 订单驳回，修改订单状态10035、交货日期null
	public static int updateOrderStatusJhrq(
			@WebParam(name = "订单系统单号") String strSysCode) {
		int i = OrdenManager.updateOrderStatusJhrq(strSysCode);
		return i;
	}
}
