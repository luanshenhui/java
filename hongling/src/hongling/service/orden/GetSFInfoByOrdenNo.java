package hongling.service.orden;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import chinsoft.business.LogisticManager;
import chinsoft.core.DateHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Logistic;

public class GetSFInfoByOrdenNo extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String orderNo=request.getParameter("ordenNo");
		Logistic logistic = new LogisticManager().getLogisticByOrdenID(Utility.toSafeString(orderNo));
		Map SFmap=new HashMap();
		if(logistic.getOrdenID()!=null){
			SFmap=this.createSFmap(logistic);
		}
		else
		{
			SFmap.put("logisticStatus", "没有交易记录");
		}
		response.setCharacterEncoding("UTF-8");
		request.setAttribute("SFmap", SFmap);
		
	}
	public Map createSFmap(Logistic logistic){
		Map map=new HashMap();
		String ERR="ERR";
		String OK="OK";
		String logisticStatus="";
		List infoList=new ArrayList();
		Map infomap=new HashMap();
		Map infoMap=this.createSFDynamicInfo(logistic.getLogisticNo());
		if(infoMap.containsKey(ERR)){
		  Map errormap=(Map)infoMap.get(ERR);
		  logisticStatus=Utility.toSafeString(errormap.get("error"));
		}
		if(infoMap.containsKey(OK)){
		  Map successmap=(Map)infoMap.get(OK);
		  infoList=(List)successmap.get("success");
		  if(infoList.size()<=0){
			  logisticStatus="您的订单已经交易很久了";
		  }
		  else
		  {
			  logisticStatus="正常";
			  for (int i = 0; i < infoList.size(); i++) {
				  String infos=infoList.get(i).toString();
				  infos=infos.substring(0,infos.indexOf("opcode")).replace("accept_time", "").replace("remark", "");
				  infomap.put(i+1,infos.substring(0, infos.indexOf("accept_address"))+infos.substring((infos.indexOf("accept_address")+"accept_address".length()), infos.length()));
			}
			  System.out.println(infomap);
			  infoList.clear();
			  infoList.add(infomap);
			  
		  }
		}
		map.put("logisticCompany",logistic.getLogisticCompany());
		map.put("mobile", "4008-111-111");
		map.put("logisticNo", logistic.getLogisticNo());
		map.put("logisticStatus", logisticStatus);
		map.put("SFinfo", infoList);
		return map;
	}
	public Map<String,Map> createSFDynamicInfo(String logisticNo){
		Map<String,Map> map=new HashMap<String, Map>();
		Map tmap=new HashMap();
		Document doc=null;
		List attrList=null;
		Attribute attr=null;
		List<String> infoList=new ArrayList<String>();
		List dlist=new ArrayList();
		String xml=this.getSFXML(logisticNo);
		try {
			doc=DocumentHelper.parseText(xml);
			Element rootElt=doc.getRootElement();
			Iterator iter=rootElt.elementIterator("Head");
			String headTxt=rootElt.elementTextTrim("Head");
			if("OK".equals(headTxt)){
				Iterator iterBody=rootElt.elementIterator("Body");
				  if(iterBody.hasNext()){
					  Element itemEle=(Element)iterBody.next();
					  Iterator iterRouteResponse=itemEle.elementIterator("RouteResponse");
					  if(iterRouteResponse.hasNext()){
						  Element elm=(Element)iterRouteResponse.next();
						  Iterator iterRoute=elm.elementIterator("Route");
						  while(iterRoute.hasNext()){
							  Element e=(Element)iterRoute.next();
							  attrList=e.attributes();
							  for (int i = 0; i < attrList.size(); i++) {
								  attr=(Attribute)attrList.get(i);
								  infoList.add(attr.getName()+attr.getValue());
							  }  
						  }
					  }
					  for (int i = 0; i <infoList.size(); i=i+4) {
							dlist.add((infoList.get(i+1).toString()+infoList.get(i+2).toString()+infoList.get(i).toString()+infoList.get(i+3).toString()));	
					  }
					  tmap.put("success", dlist);
					  map.put("OK", tmap);
				}
				else
				{
					tmap.put("success", dlist);
					map.put("OK", tmap);
				}
			}
			if("ERR".equals(headTxt)){
				String iterError=rootElt.elementTextTrim("ERROR");
				tmap.put("error", iterError);
				map.put("ERR", tmap);
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return map;
	}
	public String getSFXML(String logisticNo){
		String sfxml="";
		StringBuilder sbxml=new StringBuilder();
		sbxml.append("<Request service='RouteService' lang='zh-CN'>")
		.append("<Head>307cf785a5f64b7eb67794e4adf90fe3,a1e2965dbdca431fbd4a8f45a44aa967</Head>")
		.append("<Body>")
		.append("<RouteRequest tracking_type='1' tracking_number=")
		.append("'"+logisticNo+"'")
		.append("/></Body></Request>");
		sfxml=new LogisticManager().getSFinfoByWebservice(sbxml.toString());
		return sfxml;
	}//18563936826
	
	public static void main(String[] args) {
		//System.out.println(new GetSFInfoByOrdenNo().createSFmap("966995576646"));
	}
 
}
