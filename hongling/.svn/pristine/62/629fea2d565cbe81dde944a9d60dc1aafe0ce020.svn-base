package hongling.service.orden;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import centling.business.BlMemberManager;
import centling.business.BlOrdenManager;
import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;

import com.opensymphony.xwork2.ActionSupport;

public class GetOrdenListAction extends ActionSupport {
	
	@Override
	public String execute() throws Exception {
		
		HttpServletRequest request = ServletActionContext.getRequest();
		clothingMap=this.insertClothingMap();
		clientmap=this.insertClientMap();
		datsamap=this.insertStatusMap2();
		request.setAttribute("clothingmap", clothingMap);
		request.setAttribute("clientmap", clientmap);
		request.setAttribute("datsamap", datsamap);
		request.setAttribute("currentOrdenPre", CurrentInfo.getCurrentMember().getOrdenPre());
		cashshow = 1;//是否显示现金管理 1:不显示
		Member member=CurrentInfo.getCurrentMember();
		if(member != null){
			Member parentMember = new MemberManager().getMemberByID(member.getParentID());
			cashshow = BlMemberManager.isDaBUser(member.getGroupID(), parentMember.getGroupID());
		}
		request.setAttribute("cashShow", cashshow);
		//Map map=this.insertStatusMap2();
		List ordens=this.getOrdensList();
		request.setAttribute("ordens", ordens);
		
		return SUCCESS;
	}
	
	private String getGeshiHua(String date){
		String str="";
		String[] strs=date.split("-");
		if(strs[1].length() ==1){
			strs[1]="0"+strs[1];
		}
		if(strs[2].length()==1){
			strs[2]="0"+strs[2];
		}
		str=strs[0]+"-"+strs[1]+"-"+strs[2];
		return str;
	}
	
	private List getOrdensList(){
		if(keyword==null){
			keyword="";
		}else{
			try {
				keyword = new String(keyword.getBytes("iso-8859-1"),"utf-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		if(searchClientID==null){
			searchClientID="-1";
		}
		if(searchClothingID==0){
			searchClothingID=-1;
		}
		if(searchStatusID==null){
			searchStatusID="-1";
		}
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");  
		Date date = new Date();
		// 得到下单开始日期
		String fromdate = null;
		if (fromDate!=null && !"".equals(fromDate)) {
			fromdate = this.getGeshiHua(fromDate);
		}/*else{
			Calendar calendar = Calendar.getInstance();//日历对象
			calendar.setTime(date);//设置当前日期
			calendar.add(Calendar.MONTH, -1);//月份减一
			fromdate = sdf.format(calendar.getTime());  
		}*/
		
		// 得到下单结束日期
		String todate = null;
		if (toDate !=null && !"".equals(toDate)) {
			todate = this.getGeshiHua(toDate);
		}else{
			todate = sdf.format(date);    
		}
		
		// 得到交货开始日期
		String dealdate = null;
		if (dealDate!= null && !"".equals(dealDate)) {
			dealdate = this.getGeshiHua(dealDate);
		}
		
		// 得到交货结束日期
		String dealtoDate = null;
		if (dealToDate!=null && !"".equals(dealToDate)) {
			dealtoDate = this.getGeshiHua(dealToDate);
		}
		
		
		String strMemberCode = CurrentInfo.getCurrentMember().getCode();
		List list=new OrdenManager().getOrdenList(pageindex, CDict.PAGE_SIZE, keyword, strMemberCode, Utility.toSafeInt(searchStatusID), Utility.toSafeInt(searchClothingID), dealdate, dealtoDate, fromdate, todate, searchClientID);
		count=new OrdenManager().getOrdenListCount(keyword, strMemberCode, Utility.toSafeInt(searchStatusID), Utility.toSafeInt(searchClothingID), dealdate, dealtoDate, fromdate, todate, searchClientID);
		if(count%CDict.PAGE_SIZE==0){
			pagecount=count/CDict.PAGE_SIZE;
		}
		else
		{
			pagecount=(count/CDict.PAGE_SIZE)+1;
		}
		return list;
	}
	
	private Map insertStatusMap2(){
		Map map=new LinkedHashMap();
		map.put("10000", ResourceHelper.getValue("Common_All"));
		if(keyword==null){
			keyword="";
		}
		if(searchClientID==null){
			searchClientID="-1";
		}
		if(searchClothingID==0){
			searchClothingID=-1;
		}
		// 得到下单开始日期
		String fromdate = null;
		if (fromDate!=null && !"".equals(fromDate)) {
			fromdate = this.getGeshiHua(fromDate);
		}
		
		// 得到下单结束日期
		String todate = null;
		if (toDate !=null && !"".equals(toDate)) {
			todate = this.getGeshiHua(toDate);
		}
		
		// 得到交货开始日期
		String dealdate = null;
		if (dealDate!= null && !"".equals(dealDate)) {
			dealdate = this.getGeshiHua(dealDate);
		}
		
		// 得到交货结束日期
		String dealtoDate = null;
		if (dealToDate!=null && !"".equals(dealToDate)) {
			dealtoDate = this.getGeshiHua(dealToDate);
		}
		String strMemberCode = CurrentInfo.getCurrentMember().getCode();
		List list=new BlOrdenManager().getStatusList(keyword, strMemberCode, Utility.toSafeInt(searchClothingID), dealdate, dealtoDate, fromdate,todate, searchClientID);
		
		Map map2=null;
		for (int i = 0; i < list.size(); i++) {
			map2=(Map)list.get(i);
			if(Utility.toSafeInt(map2.get("ISSTOP"))==10050){
				map.put("10369", ResourceHelper.getValue("Dict_10369")+"【"+map2.get("C")+"】");
			}
			if(Utility.toSafeInt(map2.get("ISSTOP"))==10051){
				map.put(map2.get("STATUSID").toString(),ResourceHelper.getValue("Dict_"+map2.get("STATUSID").toString())+"【"+map2.get("C")+"】");
			}
		}
		return map;
	}
	
	
	/**
	 * clothingmap
	 * */
	
	private Map insertClothingMap(){

		Map map=new LinkedHashMap();
		List<Dict> clothings=new ClothingManager().getClothing();
		map.put("-1", ResourceHelper.getValue("Common_All"));
		map.put("1", ResourceHelper.getValue("Dict_1"));
		map.put("2", ResourceHelper.getValue("Dict_2"));
		map.put("4", ResourceHelper.getValue("Dict_4"));
		map.put("5", ResourceHelper.getValue("Dict_5"));
		map.put("6", ResourceHelper.getValue("Dict_6"));
		map.put("7", ResourceHelper.getValue("Dict_7"));
		map.put("3", ResourceHelper.getValue("Dict_3"));
		map.put("2000", ResourceHelper.getValue("Dict_2000"));
		map.put("3000", ResourceHelper.getValue("Dict_3000"));
		map.put("6000", ResourceHelper.getValue("Dict_6000"));
		map.put("5000", ResourceHelper.getValue("Dict_5000"));
		map.put("4000", ResourceHelper.getValue("Dict_4000"));
		map.put("90000", ResourceHelper.getValue("Dict_90000"));
		map.put("95000", ResourceHelper.getValue("Dict_95000"));
		map.put("98000", ResourceHelper.getValue("Dict_98000"));
		
		return map;
	}
	
	/**
	 * clientmap
	 * */
	
	private Map insertClientMap(){
		Map map=new LinkedHashMap();
		String memberCode = CurrentInfo.getCurrentMember().getCode();
		List<Member> clients = new OrdenManager().getOrdensClient(memberCode);
		map.put("-1", ResourceHelper.getValue("Common_All"));
		for (Member member : clients) {
			map.put(member.getID(), member.getName());
		}
		return map;
	}
	/**
	 * protery
	 * */
	private int searchClothingID;
	private String searchStatusID;
	private String searchClientID;
	private String fromDate;
	private String toDate;
	private String dealDate;
	private String dealToDate;
	private String keyword;
	
	private int pageindex;
	private int count;
	private int pagecount;
	private int cashshow;
	
	
	public int getPagecount() {
		return pagecount;
	}

	public void setPagecount(int pagecount) {
		this.pagecount = pagecount;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public int getPageindex() {
		return pageindex;
	}

	public void setPageindex(int pageindex) {
		this.pageindex = pageindex;
	}
	private Map clothingMap;
	public Map getClothingMap() {
		return clothingMap;
	}
	public void setClothingMap(Map clothingMap) {
		this.clothingMap = clothingMap;
	}

	private Map clientmap;
	
	public Map getClientmap() {
		return clientmap;
	}

	public void setClientmap(Map clientmap) {
		this.clientmap = clientmap;
	}

	private Map datsamap;
	
	public Map getDatsamap() {
		return datsamap;
	}

	public void setDatsamap(Map datsamap) {
		this.datsamap = datsamap;
	}

	public int getSearchClothingID() {
		return searchClothingID;
	}
	public void setSearchClothingID(int searchClothingID) {
		this.searchClothingID = searchClothingID;
	}
	public String getSearchStatusID() {
		return searchStatusID;
	}
	public void setSearchStatusID(String searchStatusID) {
		this.searchStatusID = searchStatusID;
	}
	public String getSearchClientID() {
		return searchClientID;
	}
	public void setSearchClientID(String searchClientID) {
		this.searchClientID = searchClientID;
	}
	public String getFromDate() {
		return fromDate;
	}
	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}
	public String getToDate() {
		return toDate;
	}
	public void setToDate(String toDate) {
		this.toDate = toDate;
	}
	public String getDealDate() {
		return dealDate;
	}
	public void setDealDate(String dealDate) {
		this.dealDate = dealDate;
	}
	public String getDealToDate() {
		return dealToDate;
	}
	public void setDealToDate(String dealToDate) {
		this.dealToDate = dealToDate;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public int getCashshow() {
		return cashshow;
	}

	public void setCashshow(int cashshow) {
		this.cashshow = cashshow;
	}

}
