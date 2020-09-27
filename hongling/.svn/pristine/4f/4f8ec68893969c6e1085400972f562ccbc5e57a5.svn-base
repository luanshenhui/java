package hongling.service.orden;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import sun.misc.BASE64Encoder;
import chinsoft.business.LogisticManager;
import chinsoft.core.DEncrypt;
import chinsoft.entity.Logistic;

public class GetNDInfoByOrdenNo extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String orderNo=request.getParameter("orderNo");
		System.out.println(orderNo);
		Map map=new HashMap();
		Map childmap=new HashMap();
		Logistic logistic=new LogisticManager().getLogisticByOrdenID2(orderNo);
		if(logistic!=null){
			String logisticNo=logistic.getLogisticNo();
			System.out.println(logisticNo);
			map=this.getResultMap(logisticNo);
			childmap=this.createMapByList((List)map.get("list"));
			map.remove("list");
			map.put("childmap", childmap);
			map.put("companyname",logistic.getLogisticCompany());
			map.put("mobile", "400-821-6789");
		}
		else
		{
			map.put("status", "没有物流信息");
		}
		request.setCharacterEncoding("UTF-8");
		request.setAttribute("NDInfo", map);
		
	}
	
	public Map createMapByList(List list){
		Map map=new HashMap();
		if(list.size()>0){
			for (int i=0;i<list.size();i++) {
				map.put(i, list.get(i).toString());
			}
		}
		return map;
	}
	
	public Map getResultMap(String orderNo){
		Map map=null;
		String xml=this.getPostResult(orderNo);
		System.out.println(xml);
		Document doc=null;
		List list=new ArrayList();
		
		try {
			map=new HashMap();
			doc=DocumentHelper.parseText(xml);
			Element rootElt=doc.getRootElement();
			Iterator iteroot=rootElt.elementIterator("BatchQueryResponse");
			//System.out.println(rootElt.elementTextTrim("logisticProviderID"));
			
			Iterator iterorder=rootElt.elementIterator("orders");
			if(iterorder.hasNext()){
				Element eleOrders=(Element)iterorder.next();
				Iterator iterin=eleOrders.elementIterator("order");
				if(iterin.hasNext()){
					Element ele=(Element)iterin.next();
					map.put("mailNo", ele.elementTextTrim("mailNo"));
					Iterator iteriner=(Iterator)ele.elementIterator("steps");
					if(iteriner.hasNext()){
						Element eleer=(Element)iteriner.next();
						Iterator iterxxx=eleer.elementIterator("step");
						while(iterxxx.hasNext()){
							Element elexxx=(Element)iterxxx.next();
							list.add(elexxx.elementTextTrim("acceptTime")+"&"+elexxx.elementTextTrim("acceptAddress")+"--"+elexxx.elementTextTrim("remark"));
						}
						map.put("list", list);
						map.put("status", "正常");
					}
				}
				else
				{
					map.put("status", "没有物流信息");
				}
				
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		
		return map;
	}
	
	public String getPostResult(String orderNo){
		String str="";
		String url="http://www.star360.com.cn/kd/hongxin/fineex/batchQuery";
		String strxml=this.getPostXML(orderNo);
		String strparam=this.getPostParam(strxml, "ndsync123456");
		
		String urlparam="logistics_interface="+strxml+"&data_digest="+strparam;
		str=this.sendPost(url, urlparam);
		return str;
	}
	
	public String sendPost(String url, String param) {
        PrintWriter out = null;
        BufferedReader in = null;
        String result = "";
        try {
            URL realUrl = new URL(url);
            URLConnection conn = realUrl.openConnection(); //realUrl.openConnection();
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            out = new PrintWriter(conn.getOutputStream());
            out.print(param);
            out.flush();
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(),"UTF-8"));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！"+e);
            e.printStackTrace();
        }
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }    

	
	
	public String getPostXML(String orderNo){
		String str="";
		str+="<BatchQueryRequest><logisticProviderID>ND</logisticProviderID>";
		str+="<orders><order><mailNo>";
		str+=orderNo;
		str+="</mailNo></order></orders></BatchQueryRequest>";
		return str;
	}
	
	public String getPostParam(String xml,String key){
		String str="";
		String strxml=xml+key;
		str=URLEncoder.encode(new BASE64Encoder().encode(DEncrypt.md5(strxml).getBytes()));
		return str;
	}
	
	
	public static void main(String[] args) {
		//{mailNo=880052881322, status=正常, childmap={0=acceptTime:2013-10-07 18:38:00.0 CST&acceptAddress:山东即墨能达&status:true&remark:快件离开, 1=acceptTime:2013-10-07 20:37:00.0 CST&acceptAddress:青岛分拨中心&status:true&remark:快件到达, 2=acceptTime:2013-10-07 21:18:00.0 CST&acceptAddress:青岛分拨中心&status:true&remark:快件离开, 3=acceptTime:2013-10-08 00:06:00.0 CST&acceptAddress:潍坊分拨中心&status:true&remark:快件到达, 4=acceptTime:2013-10-08 00:20:00.0 CST&acceptAddress:潍坊分拨中心&status:true&remark:快件离开}, mobile=123456789}
		//<BatchQueryResponse>
		//<logisticProviderID>ND</logisticProviderID>
		//<orders>
		//<order>
		//<mailNo>880052881322</mailNo>
		//<mailType></mailType>
		//<orderStatus></orderStatus>
		//<steps>
		//<step>
		//<acceptTime>2013-10-07 18:38:00.0 CST</acceptTime>
		//<acceptAddress>山东即墨能达</acceptAddress>
		//<name></name>
		//<status>true</status>
		//<remark>快件离开</remark>
		//</step>
		//<step>
		//<acceptTime>2013-10-07 20:37:00.0 CST</acceptTime>
		//<acceptAddress>青岛分拨中心</acceptAddress>
		//<name></name>
		//<status>true</status>
		//<remark>快件到达</remark>
		//</step>
		//<step>
		//<acceptTime>2013-10-07 21:18:00.0 CST</acceptTime>
		//<acceptAddress>青岛分拨中心</acceptAddress>
		//<name></name>
		//<status>true</status>
		//<remark>快件离开</remark>
		//</step>
		//<step>
		//<acceptTime>2013-10-08 00:06:00.0 CST</acceptTime>
		//<acceptAddress>潍坊分拨中心</acceptAddress>
		//<name></name>
		//<status>true</status>
		//<remark>快件到达</remark>
		//</step>
		//<step>
		//<acceptTime>2013-10-08 00:20:00.0 CST</acceptTime>
		//<acceptAddress>潍坊分拨中心</acceptAddress>
		//<name></name>
		//<status>true</status>
		//<remark>快件离开</remark>
		//</step>
		//</steps>
		//</order>
		//</orders>
		//</BatchQueryResponse>
		GetNDInfoByOrdenNo no=new GetNDInfoByOrdenNo();
//	   System.out.println(DEncrypt.md5("<order></order>123456"));
//	  BASE64Encoder encoder=new BASE64Encoder();
//	  String sys=encoder.encode(DEncrypt.md5("<order></order>123456").getBytes());
//	  System.out.println(sys);
//	   try {
//		System.out.println(URLEncoder.encode(sys,"gb2312"));
//	} catch (UnsupportedEncodingException e) {
//		// TODO Auto-generated catch block
//		e.printStackTrace();
//	}
		//YjVlZDFlNjQwMzZhNDYyNDMyYTVmOTQzYTY5Y2JjMDY%3D
		//YjVlZDFlNjQwMzZhNDYyNDMyYTVmOTQzYTY5Y2JjMDY%3D
		System.out.println(no.getPostResult("880052855860"));
		//System.out.println(no.getPostParam(no.getPostXML("12313"),"ndsync123456"));
		//System.out.println(no.createMapByList(no.getResultMap("880052855860")));
		
	}

}
