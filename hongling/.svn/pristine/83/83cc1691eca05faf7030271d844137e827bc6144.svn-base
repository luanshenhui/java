package rcmtm.member;

import java.security.interfaces.RSAPrivateKey;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.encrypt.CCBRsaUtil;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class CheckBatchNo extends BaseServlet {

	private static final long serialVersionUID = -3852715900655015773L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			//根据订单号生成批次号
			String strOrdenId =Utility.toSafeString(getParameter("ordenIds"));//批量支付
			String strResult = "";
			if("".equals(strOrdenId)){//单个支付
				String strHlOrdenID = getParameter("ordenID");
				String strHlSysCode = getParameter("sysCode");
				
				Orden o = new Orden();
				o.setOrdenID(strHlOrdenID);
				o.setSysCode(strHlSysCode);
				List<Orden> ordens = new ArrayList<Orden>();
				ordens.add(o);
				//善融待删除批次号
				this.deleteBatchNo(ordens);
			}else{
				//批量支付
				String[] strOrdenIds=Utility.getStrArray(strOrdenId);
				List<Orden> ordens = new ArrayList<Orden>();
				for(String strId : strOrdenIds){
					Orden orden = this.getOrdenByID(strId);
					if(!CDict.OrdenStatusStayPayments.getID().equals(orden.getStatusID())){
						strResult = "请选择待支付状态订单"; 
						break;
					}
					if("".equals(strResult)){
						ordens.add(orden);
					}
				}
				
				if("".equals(strResult)){
					//善融待删除批次号
					this.deleteBatchNo(ordens);
				}
				
				output(strResult);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("CheckBatchNo" + e.getMessage());
		}
	}
	//善融待删除批次号
	public void deleteBatchNo(List<Orden> ordens){
		try{
			String strCompany = Utility.toSafeString(CurrentInfo.getCurrentMember().getCompanyID());
			String strBatchNo =  new RcmtmManager().checkOrdenBatchNo(ordens);//查询批次号
			if(!"".equals(strBatchNo)){
				String[] strNo = strBatchNo.split(";");
				if(strNo.length == 2){//新批次号
					HttpContext.setSessionValue("SessionKey_NewSrBatchNo", strNo[1]);
				}
				if(strNo.length > 0 && !"".equals(strNo[0])){//需要善融删除的批次号
					  String strs[] = strNo[0].split(",");
					  //这里利用Set是因为 Set是一个不包含重复元素的 collection，自动去掉重复的值
					  Set<String> set = new TreeSet<String>();
					  int len = strs.length;
					  for(int i=0;i<len;i++){
					   set.add(strs[i]);//将所有字符串添加到Set
					  }
					  strs = (String[]) set.toArray(new String[0]);
					  String strRemove = "";//传给善融需要删掉的批次号
					  for(int i=0;i<strs.length;i++){
						  strRemove += "\""+strs[i]+"\",";
					  }
					  strRemove = "[" + strRemove.substring(0, strRemove.length()-1) + "]";
					  String strRemoves = "{\"cpcode\":\""+ strCompany +"\",\"orderid\":"+ strRemove +"}";
					  System.out.println("待删除批次号红领传递(加密前)"+strRemoves);
					  //接口传送  私钥加密
					  RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
					  String enStr = new CCBRsaUtil().encryptByPriKey(privk,strRemoves);
			          StringBuffer para=new StringBuffer();
			          para.append("cpcode=").append(strCompany).append("&uniondata=").append(enStr);
			          System.out.println("待删除批次号红领传递(加密后)"+para.toString());
			        
					output(new CCBInterfaceUtil().sendData(ConfigSR.URL_DELETENO,para.toString()));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("DeleteBatchNo" + e.getMessage());
		}
	}
	
}