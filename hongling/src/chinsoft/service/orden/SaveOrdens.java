package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.bean.OrdenBean;
import chinsoft.business.CDict;
import chinsoft.business.CompanysManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.FabricManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Companys;
import chinsoft.entity.Fabric;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;
import chinsoft.service.core.Encryption;
import flexjson.JSONSerializer;

public class SaveOrdens extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			this.setTempCustomer(strFormData);
			Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);
			Object[] keys = maps.keySet().toArray();

			for (Object key : keys) {
				String strKey = Utility.toSafeString(key);
				if(strKey.startsWith("fabric_")){
					String value = Utility.toSafeString(maps.get(strKey));
					for(Orden orden:this.getTempOrdens()){
						if(("fabric_" + orden.getOrdenID()).equals(strKey)){
							orden.setFabricCode(value);
							Fabric fabric = new FabricManager().getFabricByCode(value);
							if(fabric != null){
								orden.setFabricID(fabric.getID());
							}else{
								orden.setFabricID(null);
							}
						}
					}
				}
			}
			
			@SuppressWarnings("unchecked")
			List<Orden> ordens =  (List<Orden>)HttpContext.getSessionValue(CDict.SessionKey_Ordens);
			if(ordens == null){
				ordens = new ArrayList<Orden>();
			}
			String strResult = Utility.RESULT_VALUE_OK;
			
			int clothingID = ordens.get(ordens.size()-1).getClothingID();
			for (int i = 0; i < ordens.size(); i++) {
				ordens.get(i).setUserordeNo(Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "userNo")));
				ordens.get(i).setStatusID(CDict.OrdenStatusSaving.getID());
				ordens.get(i).setComponents(this.processBiao(ordens.get(i)));
			}
			String strcheckUserOrdenNo= new OrdenManager().checkUserOrdenNo(ordens);//检查客户单号
			for (int i = 0; i < ordens.size(); i++) {
				if(!"".equals(strcheckUserOrdenNo)){
					strResult = strcheckUserOrdenNo;
					ordens.get(i).setUserordeNo("");
				}
			}
			ordens= new OrdenManager().embroideContents(ordens);
			String strTempResult = new OrdenManager().submitOrdens(this.getTempCustomer(), ordens);
			if (!"".equals(strTempResult)) {
				strResult += strTempResult;
			}
			try{
				this.clearTempOrdens();
				HttpContext.setSessionValue(CDict.SessionKey_ClothingID, clothingID);
				this.fixCameoDefaultComponents(clothingID);
			}
			catch(Exception e){}
			
			//处理非普通用户订单
			Object obj=request.getSession().getAttribute("company");
			if (obj!=null) {
				Companys company=(Companys) obj;
				List<OrdenBean> list=new ArrayList<OrdenBean>();
				Member member=CurrentInfo.getCurrentMember();
				for (Orden orden : ordens) {
					OrdenBean bean=new OrdenBean();
					bean.setCpcode(company.getCompanycode());
					bean.setOrderid(orden.getOrdenID());
					if(company.getSingOnBean() != null){
						bean.setUserid(company.getSingOnBean().getCustomerID());
					}
					bean.setTitle(orden.getClothingName());
					bean.setAmount(1);
					
					double price=0.00;
					String cmt=company.getCmt()!=null?company.getCmt():"";
					String[] cmts=cmt.split(",");
					for (String string : cmts) {
						String[] objs=string.split(":");
						if (objs[0].equals(DictManager.getDictByID(orden.getClothingID()).getEcode())) {
							price=Utility.toSafeDouble(objs[1]);
						}
					}
					bean.setAmountmoney(price>0?price:orden.getOrdenPrice());
					bean.setUnit(member.getMoneySignName());
					bean.setPrice(orden.getOrdenPrice());
					bean.setBuyeraddress(orden.getCustomer().getAddress());
					bean.setBuyername(orden.getCustomer().getName());
					bean.setBuyerphone(orden.getCustomer().getTel());
					list.add(bean);
				}
				String json=new JSONSerializer().exclude("*.class").deepSerialize(list);
				System.out.println(json);
				json=Encryption.encrypt(json.toString(), company.getCompanycode());
				strResult=CompanysManager.packageForm(""+json, company.getReturnaddress(), "orders");
			}
			output(strResult);
		} catch (Exception err) {
			err.printStackTrace();
			LogPrinter.debug(err.getMessage());
		}
	}

	
}