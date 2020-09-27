package rcmtm.business;

import java.rmi.RemoteException;
import java.security.interfaces.RSAPrivateKey;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import javax.xml.rpc.ServiceException;
import net.sf.json.JSONObject;
import org.hibernate.Query;
import org.hibernate.Transaction;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.entity.OrdenBatch;
import rcmtm.entity.OrdenPay;
import rcmtm.entity.Packets;
import centling.entity.Deal;
import chinsoft.business.CDict;
import chinsoft.business.CashManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.business.XmlManager;
import chinsoft.core.DEncrypt;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.entity.Customer;
import chinsoft.entity.Dict;
import chinsoft.entity.ErrorMessage;
import chinsoft.entity.Errors;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.wsdl.IServiceToBxppServiceLocator;
import flexjson.JSONSerializer;
import rcmtm.entity.ErrorInfo;

public class RcmtmManager {

	DataAccessObject dao = new DataAccessObject();
	
	//根据批次号获取订单号
	public String getOrdensByBatchNo(String strBatchNo){
		String strOrdenIDs="";
		try {
			String hql = "SELECT o.OrdenIDs FROM OrdenBatch o WHERE o.BatchNo = ?";
			Query query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString(0, strBatchNo);
			strOrdenIDs = (String) query.uniqueResult();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return strOrdenIDs;
		
	}
	//根据订单号获取批次号*
	public OrdenBatch getOrdensBySysCode(String strOrdenID){
		OrdenBatch ob = null;
		try {
			String hql = "SELECT ob FROM OrdenBatch ob WHERE ob.OrdenIDs Like ?";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strOrdenID + "%");
			@SuppressWarnings("unchecked")
			List<OrdenBatch> obs = (List<OrdenBatch>)query.list(); 
			if(obs.size()>0){
				ob = obs.get(0);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ob;
		
	}
	//*
	public OrdenBatch getOrdens(String strSysCode){
		OrdenBatch ob = null;
		try {
			String hql = "SELECT ob FROM OrdenBatch ob WHERE ob.SysCodes Like ?";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strSysCode + "%");
			@SuppressWarnings("unchecked")
			List<OrdenBatch> obs = (List<OrdenBatch>)query.list(); 
			if(obs.size()>0){
				ob = obs.get(0);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ob;
		
	}
	//结清订单*
//	public String ReceivedOrden(String strSysCode){
//		String strDetail="";
//		String[] ordenIDs = Utility.getStrArray(strSysCode);
//		for(String sysCode : ordenIDs){
//			OrdenBatch ob = this.getOrdens(sysCode);
//			if(ob != null){
//				strDetail = this.ordenDetail(ob.getBatchNo(),strSysCode);
//			}
//		}
//		return strDetail;
//	}
	
	//生成批次号
	public String generateBatchNo(String strOrdenIDs,String strSysCodes){
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");//设置日期格式
        String strBatchNo =CurrentInfo.getCurrentMember().getOrdenPre()+df.format(new Date());//批次号
        OrdenBatch batch = new OrdenBatch();
        batch.setBatchNo(strBatchNo);
        batch.setOrdenIDs(strOrdenIDs);
        batch.setSysCodes(strSysCodes);
        batch.setStatus(0);
		if(!"".equals(strOrdenIDs) || strOrdenIDs != null){
			dao.saveOrUpdate(batch);
		}
		
		return strBatchNo;
		
	}
	
	//查找批次号*
	public String getOrdenBatchNo(String strOrdenID,String strSysCode){
		OrdenBatch ob = null;
		String strBatchNo ="";
		try {
			String hql = "FROM OrdenBatch ob WHERE ob.OrdenIDs = ? and ob.SysCodes = ?";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, strOrdenID);
			query.setString(1,strSysCode);
			@SuppressWarnings("unchecked")
			List<OrdenBatch> obs = (List<OrdenBatch>)query.list(); 
			if(obs.size()>0){
				ob = obs.get(0);
				strBatchNo = ob.getBatchNo();
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return strBatchNo;
		
	}
	
	//拼接
	public String ordenInfoHtml(String sr_url,String enStr,String code){
        StringBuffer sbHtml = new StringBuffer();
        sbHtml.append("<form id=\"ccbsubmit\" name=\"ccbsubmit\" action=\"" + sr_url + "\" method=\"post\">");
        sbHtml.append("<input type=\"hidden\" name=\"cpcode\" value=\""+ code +"\"/>");
        sbHtml.append("<input type=\"hidden\" name=\"uniondata\" value=\""+enStr+"\"/>");
        sbHtml.append("<input type=\"submit\" value=\"toCBB\" style=\"display:none;\"></form>");
        sbHtml.append("<script>document.forms['ccbsubmit'].submit();</script>");
        
        return sbHtml.toString();
	}
	
	public OrdenPay ordenInfo(String strSrUserID, String strBatchNo, String strHlOrdenID,String code){
		
		String[] strOrdenID = Utility.getStrArray(strHlOrdenID);
		int nAmount = 0;//订单数量
		Double price =0.00;//订单金额
		String unit ="件";//上衣、衬衣、马夹
		String ordenName="";//订单内容
		for(String ordenID : strOrdenID){
			Orden o = new OrdenManager().getOrdenByID(ordenID);
			price += o.getOrdenPrice();
			ordenName += " "+o.getClothingName();
			if(o.getClothingID()==3000){//衬衣
				nAmount += o.getMorePants();
			}else{
				nAmount++;
			}
			if(o.getClothingID() == 2000){
				unit ="条";//西裤
			}else if(o.getClothingID() == 1 || o.getClothingID() == 2){
				unit ="套";//2件套、3件套
			}
		}
		if(strOrdenID.length>1){
			unit ="件";
		}
		
		OrdenPay orden =new OrdenPay();
		//必填
		orden.setCpcode(code);// 企业平台代码
		orden.setOrderid(strBatchNo);// 企业平台订单 批次号
		orden.setUserid(strSrUserID);// 善融帐号
		orden.setTitle("红领服饰 "+ordenName);// 购买商品标题，多个商品可只填写其中一个或以分号分割
		orden.setAmount(nAmount);// 订购数量
		orden.setAmountmoney(price);// 成交金额
		orden.setUnit(unit);// 计价单位(物品的单位)
		//选填
		orden.setPrice(price);// 产品单价
		orden.setThumb("");// 产品图片url，其中一个商品URL地址
		orden.setBuyeraddress("");//收货人地址 
		orden.setBuyername("");// 收货人姓名
		orden.setBuyerpostcode("");// 收货人邮政编码
		orden.setBuyerphone("");// 收货人联系电话
		orden.setNote("");// 订单备注
		
		return orden;
		
	}
	//订单详细信息
	public String ordenDetailInfo(String strBatchNo, List<OrdenBatch> ordenBatchs,String code){
		StringBuffer tradedetail=new StringBuffer("[");
		for(OrdenBatch ob : ordenBatchs){
//			Orden o = new OrdenManager().getordenByOrderId(ob.getOrdenIDs());
			Orden o = (Orden) dao.getEntityByID(Orden.class, ob.getOrdenIDs());
			tradedetail.append("{\"订单号\":").append("\""+o.getOrdenID()+"\"");
			tradedetail.append(",\"客户单号\":").append(o.getUserordeNo()==null ? "\"\"" : "\""+o.getUserordeNo()+"\"");
			Dict clothing = (Dict)dao.getEntityByID(Dict.class, o.getClothingID());
			tradedetail.append(",\"产品分类\":").append("\""+clothing.getName()+"\"");
			Customer customer  = (Customer) dao.getEntityByID(Customer.class, o.getCustomerID());
			tradedetail.append(",\"用户名\":").append("\""+customer.getName()+"\"");
			tradedetail.append(",\"面料\":").append("\""+o.getFabricCode()+"\"");
			tradedetail.append(",\"下单日期\":").append("\""+o.getPubDate()+"\"");
			tradedetail.append(",\"发货日期\":").append(o.getDeliveryDate()==null ? "\"\"" : "\""+o.getDeliveryDate()+"\"");
			tradedetail.append(",\"交货日期\":").append(o.getJhrq()==null ? "\"\"" : "\""+o.getJhrq()+"\"");
			tradedetail.append(",\"已申请发货\":").append("\"否\"");
			Dict status = (Dict)dao.getEntityByID(Dict.class, o.getStatusID());
			tradedetail.append(",\"状态\":").append("\""+status.getName()+"\"").append("},");
		}
		String detail=tradedetail.toString().substring(0, tradedetail.length()-1)+"]";
		String strDetail="{\"cpcode\":\""+ code +"\",\"orderid\":\""+strBatchNo+"\",\"tradelist\":"+detail+"}";
		
		return strDetail;
	}
	public String ordenDetail(String strBatchNo, String strSysCode,String code){
		String[] strOrden = Utility.getStrArray(strSysCode);
		StringBuffer tradedetail=new StringBuffer("[");
		for(String orden : strOrden){
			Orden o = new OrdenManager().getOrdenByOrdenID(orden);
			tradedetail.append("{\"订单号\":").append("\""+o.getOrdenID()+"\"");
			tradedetail.append(",\"客户单号\":").append(o.getUserordeNo()==null ? "\"\"" : "\""+o.getUserordeNo()+"\"");
			Dict clothing = (Dict)dao.getEntityByID(Dict.class, o.getClothingID());
			tradedetail.append(",\"产品分类\":").append("\""+clothing.getName()+"\"");
			Customer customer  = (Customer) dao.getEntityByID(Customer.class, o.getCustomerID());
			tradedetail.append(",\"用户名\":").append("\""+customer.getName()+"\"");
			tradedetail.append(",\"面料\":").append("\""+o.getFabricCode()+"\"");
			tradedetail.append(",\"下单日期\":").append("\""+o.getPubDate()+"\"");
			tradedetail.append(",\"发货日期\":").append(o.getDeliveryDate()==null ? "\"\"" : "\""+o.getDeliveryDate()+"\"");
			tradedetail.append(",\"交货日期\":").append(o.getJhrq()==null ? "\"\"" : "\""+o.getJhrq()+"\"");
			tradedetail.append(",\"已申请发货\":").append("\"否\"");
			tradedetail.append(",\"状态\":").append("\"收到\"").append("},");
		}
		String detail=tradedetail.toString().substring(0, tradedetail.length()-1)+"]";
		String strDetail="{\"cpcode\":\""+ code +"\",\"orderid\":\""+strBatchNo+"\",\"tradelist\":"+detail+"}";
		
		return strDetail;
	}
	
	//支付成功后，更新订单状态、交期、下单扣款记录
	public void saveOrden(Orden orden){
		//订单状态、交期保存更新
		DataAccessObject dao = new DataAccessObject();
		dao.saveOrUpdate(orden);
		//账单详情,只记录不扣款
		Cash cash = new CashManager().getCashByMemberID(orden.getPubMemberID());
		Deal deal = new Deal();
		Date dealDate = new Date(); // 交易日期
		deal.setAccountOut(orden.getOrdenPrice());// 交易金额（支出）
		deal.setDealDate(new java.sql.Date(dealDate.getTime()));
		Double localNum = cash.getNum();//剩余金额
		deal.setDealItemId(2);//下单扣款
		deal.setOrdenId(orden.getOrdenID());// 订单ID（下单或撤销订单时必须填写）
		deal.setMemberId(orden.getPubMemberID());// 用户ID
		deal.setLocalNum(localNum);
		deal.setMemo("建行支付");
		dao.saveOrUpdate(deal);
		System.out.println("善融支付：订单号"+orden.getOrdenID()+";金额"+orden.getOrdenPrice());
	}
	//订单解锁 更新状态、交货日期
	public String updateOrdenStatus(String[] strOrdenIDs,String... params ){
		String strResult="";
		for(String ordenID : strOrdenIDs){
			Orden o = new OrdenManager().getordenByOrderId(ordenID);
			if("10039".equals(Utility.toSafeString(o.getStatusID()))){
				o.setStatusID(10030); //制版
				o.setIsAlipay(10050);
				String strCode = "";
				String strContent = "";
				try {
					String strXml =new IServiceToBxppServiceLocator().getIServiceToBxppPort().doPaymentOrder(o.getSysCode(),null);
					Errors errors=(Errors) XmlManager.doStrXmlToObject(strXml, Errors.class);
					for(ErrorMessage error : errors.getList()){
						strCode = error.getCode();
						strContent = error.getContent();
						if("1".equals(strCode)){//成功，返回code=1，Content=交期
							try {
								SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
								Date date = sf.parse(strContent);
								o.setJhrq(date);
								new RcmtmManager().saveOrden(o);
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
		}
		return strResult;
	}
	
	//批量支付订单
	//查询批次号
	/*public String checkOrdenBatchNo(List<Orden> ordens){
		String strBatchNo ="";
		try {
			String strBatchNos = this.getBatchNo(ordens);//根据订单号获取批次号
			if(!"".equals(strBatchNos)){
				String[] batchNoArray = Utility.getStrArray(strBatchNos);
		       	for(String batchNo : batchNoArray){
		       		long count = this.batchNoCount(batchNo);
		       		if(count == Utility.toSafeLong(ordens.size())){//订单数量一致
		       			int n=0;
		       			List<OrdenBatch> ordenBatchs = this.getBatchNos(batchNo);//根据批次号获取订单号
		       			for(Orden o : ordens){//订单订单是否一致
		       				for(OrdenBatch ob : ordenBatchs){
		       					if(ob.getOrdenIDs().equals(o.getOrdenID())){
		       						n++;
		       					}
		       				}
		       			}
		       			if(n == count){//订单一致，获取批次号
		       				strBatchNo = batchNo;
		       			}else{//订单不一致，修改订单状态 status = -1
		       				for(OrdenBatch ob : ordenBatchs){
		       					ob.setStatus(-1);
		       					dao.saveOrUpdate(ob);
			       			}
		       			}
		       		}else{//数量不一致，修改订单状态 status = -1
		       			this.updateBatchNo(batchNo,-1); 
		       		}
		       	}
			}
	       	
			
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return strBatchNo;
	}*/
	public String checkOrdenBatchNo(List<Orden> ordens){
		String strBatchNo ="";
		String strReturn ="";
		try {
			String strBatchNos = this.getBatchNo(ordens);//根据订单号获取批次号
			if(!"".equals(strBatchNos)){
				String[] batchNoArray = Utility.getStrArray(strBatchNos);
		       	for(String batchNo : batchNoArray){
		       		long count = this.batchNoCount(batchNo);
		       		if(count == Utility.toSafeLong(ordens.size())){//订单数量一致
		       			int n=0;
		       			List<OrdenBatch> ordenBatchs = this.getBatchNos(batchNo);//根据批次号获取订单号
		       			for(Orden o : ordens){//订单订单是否一致
		       				for(OrdenBatch ob : ordenBatchs){
		       					if(ob.getOrdenIDs().equals(o.getOrdenID())){
		       						n++;
		       					}
		       				}
		       			}
		       			if(n == count){//订单一致，获取批次号
		       				strBatchNo = batchNo;
		       			}else{//订单不一致，修改订单状态 status = -1
		       				for(OrdenBatch ob : ordenBatchs){
		       					strReturn += ob.getBatchNo()+",";
		       					ob.setStatus(-1);
		       					dao.saveOrUpdate(ob);
			       			}
		       			}
		       		}else{//数量不一致，修改订单状态 status = -1
		       			strReturn += batchNo+",";
		       			this.updateBatchNo(batchNo,-1); 
		       		}
		       	}
			}
	       	
			
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		if(!"".equals(strReturn)){
			strReturn = strReturn.substring(0, strReturn.length()-1)+";"+strBatchNo;
		}else{
			strReturn = ";"+strBatchNo;
		}
		
		return strReturn;
	}
	//根据订单号获取批次号
	public String getBatchNo(List<Orden> ordens){
		String strBatchNos = "";
		StringBuffer sb = new StringBuffer("SELECT DISTINCT ob.BatchNo FROM OrdenBatch ob WHERE ob.Status = 0 and (ob.OrdenIDs = ? ");
		for(int i=0; i<ordens.size()-1; i++){
			sb.append(" or ob.OrdenIDs = ? ");
		}
		sb.append(" ) ");
		Query query = DataAccessObject.openSession().createQuery(sb.toString());
		query.setString(0, ordens.get(0).getOrdenID());
		for(int i=1; i<ordens.size();i++){
			query.setString(i, ordens.get(i).getOrdenID());
		}
		List list= query.list();
       	if(list != null && list.size()>0){
       		for ( Object batchNo : list) {
       			strBatchNos += Utility.toSafeString(batchNo)+",";
          	 }
       	}
		return strBatchNos;
	}
	//查询同一批次号订单数量
	public long batchNoCount(String strBatchNo){
		long count = 0;
		String hql ="SELECT COUNT(*) FROM OrdenBatch ob WHERE ob.BatchNo = ? ";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setString(0, strBatchNo);
		count = Utility.toSafeLong(query.uniqueResult());
		return count;
		
	}
	//根据批次号获取批次内容
	public List<OrdenBatch> getBatchNos(String strBatchNo){
		List<OrdenBatch> obs = null;
		String hql = "FROM OrdenBatch ob WHERE ob.BatchNo = ?";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setString(0, strBatchNo);
		obs = (List<OrdenBatch>)query.list();
		return obs;
		
	}
	//修改订单状态status =-1,1
	public void updateBatchNo(String strBatchNo,int nStatus){
		String strSQL = "UPDATE OrdenBatch SET status=?  WHERE batchNo=?";
		Transaction transaction=DataAccessObject.openSession().beginTransaction();
		Query query = DataAccessObject.openSession().createSQLQuery(strSQL);
		query.setInteger(0, nStatus);
		query.setString(1, strBatchNo);
		int i = query.executeUpdate();	
		if (i>0) {
			transaction.commit();
		}else {
			transaction.rollback();
		}
	}
	//生成批次号
	public String ordensGenerateBatchNo(List<Orden> ordens){
		
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");//设置日期格式
        String strBatchNo =CurrentInfo.getCurrentMember().getOrdenPre()+df.format(new Date());//批次号
        for(Orden orden : ordens){
        	OrdenBatch batch = new OrdenBatch();
        	 batch.setBatchNo(strBatchNo);
             batch.setOrdenIDs(orden.getOrdenID());
             batch.setSysCodes(orden.getSysCode());
             batch.setStatus(0);
     		 dao.saveOrUpdate(batch);
        }
		
		return strBatchNo;
	}
	//善融待删除批次号
	public String deleteBatchNo(List<Orden> ordens){
		String results="";
		try{
			String strCompany = Utility.toSafeString(CurrentInfo.getCurrentMember().getCompanyID());
			String strBatchNo =  new RcmtmManager().checkOrdenBatchNo(ordens);//查询批次号
			if(!"".equals(strBatchNo)){
				String[] strNo = strBatchNo.split(";");
				if(strNo.length > 0){//需要善融删除的批次号
					 String strRemove = "";//传给善融需要删掉的批次号
					 String strRemoveID ="";
					if(!"".equals(strNo[0])){
						String strs[] = strNo[0].split(",");
						  //这里利用Set是因为 Set是一个不包含重复元素的 collection，自动去掉重复的值
						  Set<String> set = new TreeSet<String>();
						  int len = strs.length;
						  for(int i=0;i<len;i++){
						   set.add(strs[i]);//将所有字符串添加到Set
						  }
						  strs = (String[]) set.toArray(new String[0]);
						  for(int i=0;i<strs.length;i++){
							  strRemove += "\""+strs[i]+"\",";
						  }
						  strRemoveID = strRemove.substring(1, strRemove.length()-2);
						  strRemove = "[" + strRemove.substring(0, strRemove.length()-1) + "]";
					}else if(!"".equals(strNo[1])){
						strRemove ="[\"" +strNo[1]+ "\"]";
						strRemoveID =strNo[1];
					}
					  String strRemoves = "{\"cpcode\":\""+ strCompany +"\",\"orderid\":"+ strRemove +"}";
					  System.out.println("撤销订单红领传递(加密前)"+strRemoves);
					  //接口传送  私钥加密
					  RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
					  String enStr = new CCBRsaUtil().encryptByPriKey(privk,strRemoves);
			          StringBuffer para=new StringBuffer();
			          para.append("cpcode=").append(strCompany).append("&uniondata=").append(enStr);
			          System.out.println("撤销订单红领传递(加密后)"+para.toString());
			        
			          results =	new CCBInterfaceUtil().sendData(ConfigSR.URL_DELETENO,para.toString());
			          
			        //判断返回信息，true 删除系统订单
			          if(!"".equals(results)){
			        	  	JSONObject  js=JSONObject.fromObject(results);
							ErrorInfo error=(ErrorInfo) JSONObject.toBean(js,ErrorInfo.class);
							if(error.isFlag()){
								String ordenId ="";
								List<OrdenBatch> ordenBatch = this.getBatchNos(strRemoveID);
								for(OrdenBatch ob : ordenBatch){
									ordenId += ob.getOrdenIDs()+",";
								}
								results = new OrdenManager().removeOrdens(ordenId.substring(0,ordenId.length()-1));
							}else{
								results = error.getErrormsg();
							}
			          }
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("DeleteBatchNo" + e.getMessage());
		}
		 return results;
	}
	//善融重新绑定
	public String bindingSR(String strSrUserID,String timestamp,String code){
		Packets packets=new Packets();
		packets.setCpcode(code);
		packets.setLoginname("");
		Member member = new MemberManager().getBindingMember(strSrUserID,Utility.toSafeInt(code));
		String strHlUserID = member.getUsername();
		packets.setUserid(strSrUserID);
		packets.setLoginid(strHlUserID);
		packets.setTimestamp(timestamp);
		String strKey ="";
		if("1002".equals(code)){
			strKey = "redcollar";
		}else if("1003".equals(code)){
			strKey = "cameo";
		}
		System.out.println("loginbinding3_auth:"+code+strHlUserID+strSrUserID+timestamp+strKey);
		String auth = DEncrypt.md5(code+strHlUserID+strSrUserID+timestamp+strKey);
		packets.setAuth(auth);
		String json=new JSONSerializer().exclude("*.class").deepSerialize(packets).toString();
		System.out.println(new Date()+"重发绑定信息(加密前):"+json);
		StringBuffer para=new StringBuffer();
		try {
			//私钥加密
			RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			String enStr = new CCBRsaUtil().encryptByPriKey(privk,json);
	        para.append("cpcode=").append(code).append("&uniondata=").append(enStr);
	        System.out.println("重发绑定信息(加密后):"+para.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return para.toString();
	}
	
	//根据订单号获取企业编码
	public String getCpcode(String strOrdenID){
		Orden orden = new OrdenManager().getordenByOrderId(strOrdenID);
		Member member=(Member)dao.getEntityByID(Member.class, orden.getPubMemberID());
		String strCpcode = Utility.toSafeString(member.getCompanyID());
		return strCpcode;
		
	}
	
}
