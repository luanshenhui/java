package chinsoft.service.dict;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import centling.entity.FabricPrice;
import chinsoft.business.DictManager;
import chinsoft.business.XmlManager;
import chinsoft.core.ConfigHelper;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;
import chinsoft.entity.CurableStyle;
import chinsoft.entity.Dict;
import chinsoft.entity.Fabric;
import chinsoft.filter.AuthHessianProxyFactory;
import chinsoft.service.core.BaseServlet;
import chinsoft.wsdl.IServiceToRcmtm;

public class EditDict  extends BaseServlet{
	private static final long serialVersionUID = -6199897803965585606L;
	
	private String WebService_NameSpace = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_NameSpace"));
	private String WebService_Bxpp_Address = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_Bxpp_Address"));
	private String WebService_RCMTM_Address = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_RCMTM_Address"));

	DataAccessObject dao = new DataAccessObject();
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {
			String type = request.getParameter("type");
			if("del".equals(type)){
				String dictID = request.getParameter("dictID");//工艺
				String[] dictIds = dictID.split(",");
				for(String id : dictIds){
					new DictManager().deleteDictFromDB(Utility.toSafeInt(id));
				}
				DictManager.reloadDictById(dictIds);
			}else if("add".equals(type)){
				request.setCharacterEncoding("utf-8");  
				String dictID = new String(request.getParameter("myDict").getBytes("ISO8859-1"),"UTF-8");
//				System.out.println(dictID);
				JSONArray array = JSONArray.fromObject(dictID);
				String dicts = "";
				for(int i = 0; i < array.size(); i++){
		            JSONObject jsonObject = array.getJSONObject(i);
		            Dict dict = new Dict();
		            dicts += jsonObject.get("1")+",";
		            dict.setID(Utility.toSafeInt(jsonObject.get("1")));
		            dict.setName(Utility.toSafeString(jsonObject.get("2")));
		            dict.setCategoryID(Utility.toSafeInt(jsonObject.get("3")));
		            dict.setCode(Utility.toSafeString(jsonObject.get("4")));
		            dict.setSequenceNo(Utility.toSafeInt(jsonObject.get("5")));
		            dict.setParentID(Utility.toSafeInt(jsonObject.get("6")));
		            dict.setStatusID(Utility.toSafeInt(jsonObject.get("7")));
		            dict.setConstDefine(Utility.toSafeString(jsonObject.get("8")));
		            dict.setEcode(Utility.toSafeString(jsonObject.get("9")));
		            if(Utility.toSafeInt(jsonObject.get("10")) != -1){
		            	dict.setExclusionGroupID(Utility.toSafeInt(jsonObject.get("10")));
		            }
		            if(Utility.toSafeInt(jsonObject.get("11")) != -1){
		            	dict.setMediumGroupID(Utility.toSafeInt(jsonObject.get("11")));
		            }
		            if(Utility.toSafeInt(jsonObject.get("12")) != -1){
		            	dict.setIsDefault(Utility.toSafeInt(jsonObject.get("12")));
		            }
		            dict.setBodyType(Utility.toSafeString(jsonObject.get("13")));
		            dict.setMemo(Utility.toSafeString(jsonObject.get("14")));
		            dict.setZindex(Utility.toSafeInt(jsonObject.get("15")));
		            dict.setColorLinkIDs(Utility.toSafeString(jsonObject.get("16")));
		            dict.setShapeLinkIDs(Utility.toSafeString(jsonObject.get("17")));
		            dict.setExtension(Utility.toSafeString(jsonObject.get("18")));
		            if(Utility.toSafeInt(jsonObject.get("19")) != -1){
		            	dict.setIsElement(Utility.toSafeInt(jsonObject.get("19")));
		            }
		            dict.setEn(Utility.toSafeString(jsonObject.get("20")));
		            dict.setPosition(Utility.toSafeString(jsonObject.get("21")));
		            if(Utility.toSafeInt(jsonObject.get("22")) != -1){
		            	dict.setIsSingleCheck(Utility.toSafeInt(jsonObject.get("22")));
		            }
		            if(Utility.toSafeDouble(jsonObject.get("23")) != 0){
		            	dict.setPrice(Utility.toSafeDouble(jsonObject.get("23")));
		            }
		            if(Utility.toSafeDouble(jsonObject.get("24")) != 0){
		            	dict.setOccupyFabric(Utility.toSafeDouble(jsonObject.get("24")));
		            }
		            dict.setAffectedAllow(Utility.toSafeString(jsonObject.get("25")));
		            dict.setAffectedDisabled(Utility.toSafeString(jsonObject.get("26")));
		            if(Utility.toSafeInt(jsonObject.get("27")) != -1){
		            	dict.setNotShowOnFront(Utility.toSafeInt(jsonObject.get("27")));
		            }
		            dict.setParentFabric(Utility.toSafeString(jsonObject.get("28")));
		            if(Utility.toSafeDouble(jsonObject.get("29")) != 0){
		            	dict.setDollarPrice(Utility.toSafeDouble(jsonObject.get("29")));
		            }
		            dict.setDe(Utility.toSafeString(jsonObject.get("30")));
		            dict.setFr(Utility.toSafeString(jsonObject.get("31")));
		            dict.setJa(Utility.toSafeString(jsonObject.get("32")));
		            if(Utility.toSafeInt(jsonObject.get("33")) != -1){
		            	dict.setIsShow(Utility.toSafeInt(jsonObject.get("33")));
		            }
		            
		            new DictManager().saveDicts(dict);
		        }
				String[] dictIds = dicts.split(",");
				DictManager.reloadDictById(dictIds);
			}else if("check".equals(type)){
				String dictID = request.getParameter("checkID");//工艺id
				Dict dict = DictManager.getDictFromDB(Utility.toSafeInt(dictID));
				if(dict != null){
					output(dict);
				}
			}else if("checkStyle".equals(type)){
				String StyleID = request.getParameter("styleID");
				List<CurableStyle> cs = DictManager.getStyleByCode(StyleID);
				if(cs.size()>0){
					output(cs);
				}
			}else if("styleDel".equals(type)){
				String StyleID = request.getParameter("delStyleID");
				String[] StyleIDs = StyleID.split(",");
				try {
					for(String id : StyleIDs){
						DictManager.delStyleByCode(id);
					}
				} catch (Exception e) {
					e.printStackTrace();
					output("fail");
				}
				output("OK");
			}else if("styleAdd".equals(type)){
				String StyleID = request.getParameter("addStyleID");
				String styleJson = "";
//				String styleJson ="[{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4471\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4472\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4473\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR447\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4474\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4475\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4476\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4477\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4478\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR4479\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR44710\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR44711\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR44712\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR44713\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR44714\",\"remark\":\"\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"},{\"code\":\"HXFR447a\",\"ecode\":\"HXFR44715\",\"remark\":\"瑞璞领标\",\"status\":\"7\",\"closestatus\":\"0\",\"lockstatus\":\"0\"}]";
//				WebService_Bxpp_Address = "http://172.16.6.78/Services/services/BxppService?wsdl";
				try {
					Object[] params = new Object[] {StyleID};
					Class<?>[] classTypes = new Class<?>[] {String.class};
					styleJson = Utility.toSafeString(XmlManager.invokeService(WebService_Bxpp_Address, WebService_NameSpace,
							"getStyleInfoByCode", params, classTypes));
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				if (styleJson.length() > 0) {
					JSONArray array = JSONArray.fromObject(styleJson);
					CurableStyle cs = null;
					int maxN =DictManager.getStyleMaxID();
					for(int i = 0; i < array.size(); i++){
						maxN++;
						cs = new CurableStyle();
			            JSONObject jsonObject = array.getJSONObject(i);
			            cs.setEcode(jsonObject.getString("code"));//款式号
			            cs.setCode(jsonObject.getString("ecode"));//工艺
			            cs.setRemark(jsonObject.getString("remark"));//备注
			            cs.setStatus(jsonObject.getInt("status"));//状态
			            cs.setCloseStatus(jsonObject.getInt("closestatus"));//关闭状态
			            cs.setLockStatus(jsonObject.getInt("lockstatus"));//锁状态
			            cs.setID(maxN);
			            
			            DictManager.addStyleByCode(cs);
					}
					output(styleJson);
				}else{
					output("fail");
				}
			}else if("exportFabirc".equals(type)){
				
				try {
//					WebService_RCMTM_Address = "http://172.16.6.78/Services/remoting/RcmtmService";
					AuthHessianProxyFactory factory = new AuthHessianProxyFactory();
					IServiceToRcmtm fabric = (IServiceToRcmtm) factory.create(IServiceToRcmtm.class, WebService_RCMTM_Address);
					
					JsonConfig jsonConfig = new JsonConfig();
					jsonConfig.setArrayMode(JsonConfig.MODE_OBJECT_ARRAY);
					Session session = DataAccessObject.openSession();
					Transaction transaction = session.beginTransaction();
					
					String fabrics = fabric.getFabric();
					JSONArray jsonf =JSONArray.fromObject(fabrics);
					jsonConfig.setRootClass(Fabric.class);
					Fabric[] fabricL=(Fabric[]) JSONArray.toArray(jsonf, jsonConfig);
					
					String hql = "delete from Fabric";
					Query query=session.createQuery(hql);
					query.executeUpdate();

					int i=0;
					for(Fabric f : fabricL){
						if (i%25==0) {
							System.out.println(i);
							session.flush();
				            session.clear();
						}
						dao.save(session,f);
						i++;
					}
					transaction.commit();
					DataAccessObject.closeSession();
					
					output("OK");
				} catch (Exception e) {
					e.printStackTrace();
					output("fail");
				}
			}else if("exportFabircPrice".equals(type)){
				
				try {
//					WebService_RCMTM_Address = "http://172.16.6.78/Services/remoting/RcmtmService";
					AuthHessianProxyFactory factory = new AuthHessianProxyFactory();
					IServiceToRcmtm fabric = (IServiceToRcmtm) factory.create(IServiceToRcmtm.class, WebService_RCMTM_Address);
					
					JsonConfig jsonConfig = new JsonConfig();
					jsonConfig.setArrayMode(JsonConfig.MODE_OBJECT_ARRAY);
					Session session = DataAccessObject.openSession();
					Transaction transaction = session.beginTransaction();
					String fabricPrics = fabric.getFabricPrice();
					JSONArray jsonfp =JSONArray.fromObject(fabricPrics);
					JsonConfig jsonConfigfp = new JsonConfig();
					jsonConfigfp.setArrayMode(JsonConfig.MODE_OBJECT_ARRAY);
					jsonConfigfp.setRootClass(FabricPrice.class);
					FabricPrice[] priceL=(FabricPrice[]) JSONArray.toArray(jsonfp, jsonConfigfp);
					
					String hql = "delete from FabricPrice";
					Query query=session.createQuery(hql);
					query.executeUpdate();
					
					int i=0;
					for(FabricPrice fp : priceL){
						if (i%25==0) {
							System.out.println(i);
							session.flush();
				            session.clear();
						}
						dao.save(session,fp);
						i++;
					}
					transaction.commit();
					DataAccessObject.closeSession();
					
					output("OK");
				} catch (Exception e) {
					e.printStackTrace();
					output("fail");
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			output("fail");
		}
	}
}
