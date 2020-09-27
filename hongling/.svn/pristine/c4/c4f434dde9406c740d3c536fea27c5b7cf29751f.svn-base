package chinsoft.service.webservice;


import java.io.File;
import java.io.FileOutputStream;
import java.rmi.RemoteException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.rpc.ServiceException;

import rcmtm.business.RcmtmManager;
import net.sf.json.JSONObject;

import chinsoft.business.CDict;
import chinsoft.business.LogisticManager;
import chinsoft.business.OrdenManager;
import chinsoft.business.ReceiptManager;
import chinsoft.business.XmlManager;
import chinsoft.core.ConfigHelper;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;
import chinsoft.entity.ErrorMessage;
import chinsoft.entity.Errors;
import chinsoft.entity.Logistic;
import chinsoft.entity.Orden;
import chinsoft.entity.Receipt;
import chinsoft.service.core.Encryption;
import chinsoft.service.member.GetSubMembers;
import chinsoft.wsdl.IServiceToBxppServiceLocator;

public class OrderService {
	private static final String error10="{\"flag\":\"false\",\"error\":10,\"errormsg\":\"金额不符\"}";
	private static final String error11="{\"flag\":\"false\",\"error\":11,\"errormsg\":\"交易失败\"}";
	private static final String error12="{\"flag\":\"false\",\"error\":12,\"errormsg\":\"公司信息不能为空\"}";
	private static final String error13="{\"flag\":\"false\",\"error\":13,\"errormsg\":\"个人信息不能为空\"}";
	private static final String error14="{\"flag\":\"false\",\"error\":14,\"errormsg\":\"无效的订单号\"}";
	private static final String error15="{\"flag\":\"false\",\"error\":15,\"errormsg\":\"物流信息不全\"}";
	private static final String success="{\"flag\":\"true\"}";
	private static final String error16="{\"flag\":\"false\",\"error\":16,\"errormsg\":\"参数格式不对\"}";
	private static final String error17="{\"flag\":\"false\",\"error\":17,\"errormsg\":\"刺绣数据为空\"}";
	private static final String error18="{\"flag\":\"false\",\"error\":18,\"errormsg\":\"发票类型既不是开户行也不是个人\"}";
	private static final String error19="{\"flag\":\"false\",\"error\":19,\"errormsg\":\"都为空你插得啥\"}";
	private static final String error20="{\"flag\":\"false\",\"error\":20,\"errormsg\":\"有异常出没,可能调用接口失败\"}";
	
	public  String getOrderPayment(String json){
		String jsonstr;
		String str="";
		JSONObject jsonligistic=null;
		JSONObject jsonreceipt=null;
		JSONObject jsonembroidery=null;
		JSONObject object=null;
		try {
			jsonstr = Encryption.decrypt(json, CDict.DES_KEY);
			object=JSONObject.fromObject(jsonstr.replace("null", "\"\""));
		} catch (Exception e1) {
			object=null;
		}
		if(object!=null){
				String ordenID=Utility.toSafeString(object.get("orderid"));//通过ID取金额
				if("".equals(ordenID)){
					ordenID="0";
				}
				Orden orden=new OrdenManager().getordenByOrderId(ordenID);
				if(orden!=null){
					if("0".equals(Utility.toSafeString(object.get("status")))){
						if((notempty(Utility.toSafeString(object.get("logistic"))))&&(notempty(Utility.toSafeString(object.get("receipt"))))&&(notempty(Utility.toSafeString(object.get("embroidery"))))){
							jsonligistic=JSONObject.fromObject(Utility.toSafeString(object.get("logistic")));
							jsonreceipt=JSONObject.fromObject(Utility.toSafeString(object.get("receipt")));
							jsonembroidery=JSONObject.fromObject(Utility.toSafeString(object.get("embroidery")));
							str=insertBean(orden,jsonligistic, jsonreceipt,jsonembroidery);
						}
						else
						{
							if((notempty(Utility.toSafeString(object.get("logistic"))))&&("".equals(Utility.toSafeString(object.get("embroidery"))))&&("".equals(Utility.toSafeString(object.get("receipt"))))){
								jsonligistic=JSONObject.fromObject(Utility.toSafeString(object.get("logistic")));
								str=this.inserLogistic(orden, jsonligistic);
							}
							if(("".equals(Utility.toSafeString(object.get("logistic"))))&&("".equals(Utility.toSafeString(object.get("embroidery"))))&&(!"".equals(Utility.toSafeString(object.get("receipt"))))){
								jsonreceipt=JSONObject.fromObject(Utility.toSafeString(object.get("receipt")));
								str=this.insertReceipt(orden, jsonreceipt);
							}
							if(("".equals(Utility.toSafeString(object.get("logistic"))))&&(!"".equals(Utility.toSafeString(object.get("embroidery"))))&&("".equals(Utility.toSafeString(object.get("receipt"))))){
								jsonembroidery=JSONObject.fromObject(Utility.toSafeString(object.get("embroidery")));
								str=this.insertEmbroidery(orden, jsonembroidery);
							}
							if((!"".equals(Utility.toSafeString(object.get("logistic"))))&&("".equals(Utility.toSafeString(object.get("embroidery"))))&&(!"".equals(Utility.toSafeString(object.get("receipt"))))){
								//插入 logistic receipt
								jsonligistic=JSONObject.fromObject(Utility.toSafeString(object.get("logistic")));
								jsonreceipt=JSONObject.fromObject(Utility.toSafeString(object.get("receipt")));
								str=this.insertLogisticReceipt(orden, jsonligistic, jsonreceipt);
							}
							if((!"".equals(Utility.toSafeString(object.get("logistic"))))&&(!"".equals(Utility.toSafeString(object.get("embroidery"))))&&("".equals(Utility.toSafeString(object.get("receipt"))))){
								//插入 logistic embroidery
								jsonligistic=JSONObject.fromObject(Utility.toSafeString(object.get("logistic")));
								jsonembroidery=JSONObject.fromObject(Utility.toSafeString(object.get("embroidery")));
								str=this.insertLogisticEmbroidery(orden, jsonligistic, jsonembroidery);
							}
							if(("".equals(Utility.toSafeString(object.get("logistic"))))&&(!"".equals(Utility.toSafeString(object.get("embroidery"))))&&(!"".equals(Utility.toSafeString(object.get("receipt"))))){
								//插入 embroidery receipt
								jsonreceipt=JSONObject.fromObject(Utility.toSafeString(object.get("receipt")));
								jsonembroidery=JSONObject.fromObject(Utility.toSafeString(object.get("embroidery")));
								str=this.insertEmbroideryReceipt(orden, jsonreceipt, jsonembroidery);
								
							}
							if(("".equals(Utility.toSafeString(object.get("logistic"))))&&("".equals(Utility.toSafeString(object.get("embroidery"))))&&("".equals(Utility.toSafeString(object.get("receipt"))))){
								//str=success;
								str=this.getSuccessMsg(orden.getOrdenID());
								
							}
						}
					}
					else
					{
						if("1".equals(Utility.toSafeString(object.get("status")))){
							str=error11;
						}
					}
				}
				else
				{
					str=error14;
				}
			
		} else
		{
			str=error16;
		}
		return str;
	}
	private String logtsticInsert(Orden orden,JSONObject jsonligistic,JSONObject flagstr){
		String str="";
		Logistic logistic=null;
		LogisticManager logisticManager=new LogisticManager();
		String name="";
		String address="";
		String mobile="";
		try {
			name=Utility.toSafeString(jsonligistic.get("name"));
		} catch (Exception e) {
			name="";
		}
		try {
			address=Utility.toSafeString(jsonligistic.get("address"));
		} catch (Exception e) {
			address="";
		}
		try {
			mobile=Utility.toSafeString(jsonligistic.get("mobile"));
		} catch (Exception e) {
			mobile="";
		}
		if(notempty(name)&&notempty(address)&&notempty(mobile)){		
			if(this.notNull(logisticManager.getLogisticByOrdenID2(orden.getOrdenID()))){	
				logistic=logisticManager.getLogisticByOrdenID2(orden.getOrdenID());
				logistic.setName(Utility.toSafeString(jsonligistic.get("name")));
				logistic.setAddress(Utility.toSafeString(jsonligistic.get("address")));
				logistic.setMobile(Utility.toSafeString(jsonligistic.get("mobile")));
				logistic.setTel(Utility.toSafeString(jsonligistic.get("tel")));
				logistic.setSendtime(flagstr.get("msg").toString());
				logisticManager.saveLogistic(logistic);
			}
			else
			{
				logistic=new Logistic();
				logistic.setOrdenID(orden.getOrdenID());
				logistic.setName(Utility.toSafeString(jsonligistic.get("name")));
				logistic.setAddress(Utility.toSafeString(jsonligistic.get("address")));
				logistic.setMobile(Utility.toSafeString(jsonligistic.get("mobile")));
				logistic.setTel(Utility.toSafeString(""));
				logistic.setSendtime(Utility.toSafeString(orden.getDeliveryDate()==null?"":orden.getDeliveryDate()));
				logistic.setSysCode(orden.getSysCode());
				logisticManager.saveLogistic(logistic);
			}
		}
		else
		{
			str=error15;
		}
		return str;
	}
	private void receiptInsert(Orden orden,JSONObject jsonreceipt){
		Receipt receipt=null;
		ReceiptManager receiptManager=new ReceiptManager();
		if(this.notNull(receiptManager.getReceiptByOrdenID2(orden.getOrdenID()))){
			receipt=receiptManager.getReceiptByOrdenID2(orden.getOrdenID());
			receipt.setType(Utility.toSafeString(jsonreceipt.get("type")));
			receipt.setName(Utility.toSafeString(jsonreceipt.get("name")));
			receipt.setIdentity(Utility.toSafeString(jsonreceipt.get("identity")));
			receipt.setAddress(Utility.toSafeString(jsonreceipt.get("address")));
			receipt.setPhone(Utility.toSafeString(jsonreceipt.get("phone")));
			receipt.setBankname(Utility.toSafeString(jsonreceipt.get("bankname")));
			receipt.setBankcardid(Utility.toSafeString(jsonreceipt.get("bankcardid")));
			receiptManager.saveReceipt(receipt);
		}
		else
		{
			receipt=new Receipt();
			receipt.setOrdenID(orden.getOrdenID());
			receipt.setSysCode(orden.getSysCode());
			receipt.setType(Utility.toSafeString(jsonreceipt.get("type")));
			receipt.setName(Utility.toSafeString(jsonreceipt.get("name")));
			receipt.setIdentity(Utility.toSafeString(jsonreceipt.get("identity")));
			receipt.setAddress(Utility.toSafeString(jsonreceipt.get("address")));
			receipt.setPhone(Utility.toSafeString(jsonreceipt.get("phone")));
			receipt.setBankname(Utility.toSafeString(jsonreceipt.get("bankname")));
			receipt.setBankcardid(Utility.toSafeString(jsonreceipt.get("bankcardid")));
			receiptManager.saveReceipt(receipt);
		}
	}
	private String receptInsertBytype(Orden orden,JSONObject jsonreceipt){
		String str="";
		if(!("0".equals(Utility.toSafeString(jsonreceipt.get("type"))))&&!("1".equals(Utility.toSafeString(jsonreceipt.get("type"))))){
			str=error18;
		}
		else
		{
			if("0".equals(Utility.toSafeString(jsonreceipt.get("type")))){
				String name0="";
				String identity0="";
				try {
					name0=Utility.toSafeString(jsonreceipt.get("name"));
				} catch (Exception e) {
					name0="";
				}
				try {
					identity0=Utility.toSafeString(jsonreceipt.get("identity"));
				} catch (Exception e) {
					identity0="";
				}
				if((notempty(name0))&&(notempty(identity0))){
					this.receiptInsert(orden, jsonreceipt);
				}
				else
				{
					str=error13;
				}
				
			}
			if("1".equals(Utility.toSafeString(jsonreceipt.get("type")))){
				String name="";
				String identity1="";
				String address1="";
				String phone1="";
				String bankname1="";
				String bankcardid1="";
					try {
						name=Utility.toSafeString(jsonreceipt.get("name"));
					} catch (Exception e) {
						name="";
					}
					try {
						identity1=Utility.toSafeString(jsonreceipt.get("identity"));
					} catch (Exception e) {
						identity1="";
					}
					try {
						address1=Utility.toSafeString(jsonreceipt.get("address"));
					} catch (Exception e) {
						address1="";
					}
					try {
						phone1=Utility.toSafeString(jsonreceipt.get("phone"));
					} catch (Exception e) {
						phone1="";
					}
					try {
						bankname1=Utility.toSafeString(jsonreceipt.get("bankname"));
					} catch (Exception e) {
						bankname1="";
					}
					try {
						bankcardid1=Utility.toSafeString(jsonreceipt.get("bankcardid"));
					} catch (Exception e) {
						bankcardid1="";
					}
					
					if((notempty(identity1))&&(notempty(address1))&&(notempty(phone1))&&(notempty(bankname1))&&(notempty(bankcardid1))){
						this.receiptInsert(orden, jsonreceipt);
					}
					else
					{
						str=error12;
					}
				
			}
		}
		return str;
	}
	private String  embroideryInsert(Orden orden,JSONObject jsonembroidery){
		String str="";
		OrdenManager ordenManager=new OrdenManager();
		String comstr="";
		String contentstr=",";
		if(notempty(Utility.toSafeString(jsonembroidery.get("color")))){
			comstr+=","+Utility.toSafeString(jsonembroidery.get("color"));
		}
		if(notempty(Utility.toSafeString(jsonembroidery.get("font")))){
			comstr+=","+Utility.toSafeString(jsonembroidery.get("font"));
		}
		if(notempty(Utility.toSafeString(jsonembroidery.get("location")))){
			comstr+=","+Utility.toSafeString(jsonembroidery.get("location"));
		}
		if(notempty(Utility.toSafeString(jsonembroidery.get("size")))){
			comstr+=","+Utility.toSafeString(jsonembroidery.get("size"));
		}
		
		if(notempty(Utility.toSafeString(jsonembroidery.get("content")))){
			contentstr+=Utility.toSafeString(jsonembroidery.get("content"));
		}
		if(",".equals(contentstr)){
			contentstr="";
		}
		String codestr=orden.getCompanysCode()==null?"":orden.getCompanysCode()+comstr;
		String textstr=orden.getComponentTexts()==null?"":orden.getComponentTexts()+contentstr;
		
		if((notempty(comstr))&&(notempty(contentstr))){
			ordenManager.UpdateOrdenByComp(orden.getOrdenID(), codestr, textstr);
		}
		else
		{
			str=error17;
		}
		
		return str;
		
	}
	
	private  String inserLogistic(Orden orden,JSONObject jsonligistic){
		String str="";
		String strl="";
		JSONObject flagstr=this.getSuccessMsg2(orden.getOrdenID(),new LogisticManager().getLogisticBean(jsonligistic));
		if(flagstr!=null){
			if(("OK".equals(flagstr.get("flag").toString()))){
				strl=this.logtsticInsert(orden, jsonligistic, flagstr);
				if("".equals(strl)){
					str="{\"flag\":true,\"msg\":\""+flagstr.get("msg").toString()+"\"}";
				}
				else
				{
					str=this.logtsticInsert(orden, jsonligistic, flagstr);
				}
			}
			else
			{
				str=this.getSuccessMsg(orden.getOrdenID());
			}
		}
		else
		{
			str=error20;
		}
		return str;
	}
	private  String insertReceipt(Orden orden,JSONObject jsonreceipt){
		String str="";
		String strr="";
		JSONObject flagstr=this.getSuccessMsg2(orden.getOrdenID());
		if(flagstr!=null){
			if(  ("OK".equals(flagstr.get("flag").toString()))){
				strr=this.receptInsertBytype(orden, jsonreceipt);
				if(notempty(strr)){
					str=strr;
				}
				else
				{
					str="{\"flag\":true,\"msg\":\""+flagstr.get("msg").toString()+"\"}";
				}
			}
			else
			{
				str=this.getSuccessMsg(orden.getOrdenID());
			}
		}
		else
		{
			str=error20;
		}
		return str;
	}
	private String insertEmbroidery(Orden orden,JSONObject jsonembroidery){
		String str="";
		String stre="";
		JSONObject flagstr=this.getSuccessMsg2(orden.getOrdenID());
		if(flagstr!=null){
			if(  ("OK".equals(flagstr.get("flag").toString()))){
				stre=this.embroideryInsert(orden, jsonembroidery);
				if("".equals(stre)){
					str="{\"flag\":true,\"msg\":\""+flagstr.get("msg").toString()+"\"}";
				}
				else
				{
					str=stre;
				}	
			}
			else
			{
				str=this.getSuccessMsg(orden.getOrdenID());
			}
		}
		else
		{
			str=error20;
		}
		
		
		return str;
	}
	private String insertEmbroideryReceipt(Orden orden,JSONObject jsonreceipt,JSONObject jsonembroidery){
		String str="";
		JSONObject flagstr=this.getSuccessMsg2(orden.getOrdenID());
		if(flagstr!=null){
			if(  ("OK".equals(flagstr.get("flag").toString()))){
				String stre=this.embroideryInsert(orden, jsonembroidery);
				String strr=this.receptInsertBytype(orden, jsonreceipt);
				if(!notempty(stre)&&!notempty(strr)){
					str="{\"flag\":true,\"msg\":\""+flagstr.get("msg").toString()+"\"}";
				}
				else
				{
					if(notempty(stre)){
						str=stre;
					}
					if(notempty(strr)){
						str=strr;
					}
					if(notempty(stre)&&(notempty(strr))){
						str=error19;
					}
				}
				
			}
			else
			{
				str=this.getSuccessMsg(orden.getOrdenID());
			}
		}
		else
		{
			str=error20;
		}
		
		return str;
	}
	private String insertLogisticEmbroidery(Orden orden,JSONObject jsonligistic,JSONObject jsonembroidery){
		String str="";
		String strl="";
		String stre="";
		JSONObject flagstr=this.getSuccessMsg2(orden.getOrdenID(),new LogisticManager().getLogisticBean(jsonligistic));
		if(flagstr!=null){		
			if(  ("OK".equals(flagstr.get("flag").toString()))){
				strl=this.logtsticInsert(orden, jsonligistic, flagstr);
				stre=this.embroideryInsert(orden, jsonembroidery);
				if("".equals(strl)){
					if("".equals(stre)){
						str="{\"flag\":true,\"msg\":\""+flagstr.get("msg").toString()+"\"}";
					}
					else
					{
						str=stre;
					}
				}
				else
				{
					str=strl;
				}
			}
			else
			{
				str=this.getSuccessMsg(orden.getOrdenID());
			}
		}
		else
		{
			str=error20;
		}
		return str;
		
	}
	private String insertLogisticReceipt(Orden orden,JSONObject jsonligistic,JSONObject jsonreceipt){
		String str="";
		String strl="";
		String strr="";
		JSONObject flagstr=this.getSuccessMsg2(orden.getOrdenID(),new LogisticManager().getLogisticBean(jsonligistic));
		if(flagstr!=null){
			if(("OK".equals(flagstr.get("flag").toString()))){
				strl=this.logtsticInsert(orden, jsonligistic, flagstr);
				strr=this.receptInsertBytype(orden, jsonreceipt);
				if("".equals(strl)){
					if("".equals(strr)){
						str="{\"flag\":true,\"msg\":\""+flagstr.get("msg").toString()+"\"}";
					}
					else
					{
						str=strr;
					}
				}
				else
				{
					str=strl;
				}
			}
			else
			{
				str=this.getSuccessMsg(orden.getOrdenID());
			}
		}
		else
		{
			str=error20;
		}
		return str;
	}
	private String insertBean(Orden orden,JSONObject jsonligistic,JSONObject jsonreceipt,JSONObject jsonembroidery){
		String str="";
		String strl="";
		String strr="";
		String stre="";
		JSONObject flagstr=this.getSuccessMsg2(orden.getOrdenID(),new LogisticManager().getLogisticBean(jsonligistic));
		if(flagstr!=null){
			if(("OK".equals(flagstr.get("flag").toString()))){
				strl=this.logtsticInsert(orden, jsonligistic, flagstr);
				strr=this.receptInsertBytype(orden, jsonreceipt);
				stre=this.embroideryInsert(orden, jsonembroidery);
				if("".equals(strl)){
					if("".equals(strr)&&"".equals(stre)){
						str="{\"flag\":true,\"msg\":\""+flagstr.get("msg").toString()+"\"}";
					}
					else
					{
						str=error19;
					}
				}
				else
				{
					str=strl;
				}
				
			}
			else
			{
				str=this.getSuccessMsg(orden.getOrdenID());
			}
		}
		else
		{
			str=error20;
		}
		return str;
	}
	private boolean notempty(String str){
		boolean b=false;
		if(!"".equals(str)){
			b=true;
		}
		return b;
	}
	private boolean notNull(Object obj){
		boolean b=false;
		if((!"".equals(Utility.toSafeString(obj)))||obj!=null){
			b=true;
		}
		return b;
	}
	
	private String getSuccessMsg(String ordenID,String... params){
		String[] ordenIDs={ordenID};
//		return new RcmtmManager().updateOrdenStatus(ordenIDs,params);
		return this.updateOrdenStatus(ordenIDs, params);
	}
	private JSONObject getSuccessMsg2(String ordenID,String... params){
		JSONObject json=null;
		
		try {
			String str=this.getSuccessMsg(ordenID, params);
			json=JSONObject.fromObject(str);
		} catch (Exception e) {
			json=null;
		}
		return json;
	}
	//订单解锁 更新状态、交货日期
	public String updateOrdenStatus(String[] strOrdenIDs,String... params ){
		String strResult="";
		for(String ordenID : strOrdenIDs){
			Orden o = new OrdenManager().getordenByOrderId(ordenID);
			o.setStatusID(10030); //制版
			o.setIsAlipay(10050);
			String strCode = "";
			String strContent = "";
			try {
				String strXML=null;
				if (null!=params&&params.length>0) {
					strXML=params[0];
				}
				String strXml =new IServiceToBxppServiceLocator().getIServiceToBxppPort().doPaymentOrder(o.getSysCode(),strXML);
//					String strXml =new IServiceToBxppServiceLocator().getIServiceToBxppPort().doPaymentOrder(o.getSysCode(),null);
				Errors errors=(Errors) XmlManager.doStrXmlToObject(strXml, Errors.class);
				for(ErrorMessage error : errors.getList()){
					strCode = error.getCode();
					strContent = error.getContent();
					if("1".equals(strCode)){//成功，返回code=1，Content=交期
						try {
							SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
							Date date = sf.parse(strContent);
							o.setJhrq(date);
//								new RcmtmManager().saveOrden(o);
							DataAccessObject dao = new DataAccessObject();
							dao.saveOrUpdate(o);
							strResult="{\"flag\":\"OK\",\"msg\":\""+sf.format(date)+"\"}";
						} catch (Exception e) {
							strResult = "{\"flag\":false,\"error\":103,\"errormsg\":\"交期未返回\"}";//返回错误信息
						}
					}else{//失败，返回code=0
						strResult = "{\"flag\":false,\"error\":103,\"errormsg\":\""+strContent+"\"}";//返回错误信息
					}
				}
			} catch (RemoteException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (ServiceException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		return strResult;
	}
	
	
	/**
	 * 返回JSON 成功（success）：{1:imgName}  失败{0:errInfo}
	 * @param fileByte
	 * @param fileName
	 * @return
	 */
	public String uploadOrdenphoto(byte[] fileByte,String fileName){
		if(fileByte.length>500*1024){
			return "{0:\"图片不能超过500K\"}";
		}else if(fileName.length()>10){
			return "{0:\"图片名过长\"}";
		}
		
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
		String dateStr = format.format(new Date());
		StringBuffer strPath = new StringBuffer();
		//这竟然把图存在资源文件夹下了。。。诡异啊
		strPath.append(ConfigHelper.getContextParam().get("CfgPath"));// 获取资源文件的路径
		strPath.append("upload\\");
		File file = new File(strPath.toString());
		if(!file.exists()){
			file.mkdir();
		}
//		System.out.println(file.getPath());
		strPath.append(dateStr);
		strPath.append("-");
		strPath.append(fileName);
		FileOutputStream out;
		try {
			out = new FileOutputStream(new File(strPath.toString()));
			out.write(fileByte);
			out.close();
		} catch (Exception e) {
			System.out.println("\"读取图片失败\"");
//			e.printStackTrace();
			return "{0:\"服务器异常，请稍后重试\"}";
		}
		return "{1:\""+dateStr+"-"+fileName+"\"}";
	}
	
}
