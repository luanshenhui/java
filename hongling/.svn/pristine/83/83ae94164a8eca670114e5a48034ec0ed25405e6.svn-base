package rcmtm.synchronousDealCash;

import java.rmi.RemoteException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.hibernate.Session;
import org.hibernate.Transaction;

import oa.weaver.services.RequestService.RequestService;
import oa.weaver.services.RequestService.RequestServiceHttpBindingStub;
import oa.weaver.services.RequestService.RequestServiceLocator;
import oa.weaver.services.WorkflowService.WorkflowService;
import oa.weaver.services.WorkflowService.WorkflowServiceHttpBindingStub;
import oa.weaver.services.WorkflowService.WorkflowServiceLocator;
import oa.weaver.soa.workflow.request.Cell;
import oa.weaver.soa.workflow.request.DetailTable;
import oa.weaver.soa.workflow.request.RequestInfo;
import oa.weaver.soa.workflow.request.Row;
import oa.weaver.workflow.webservices.WorkflowRequestInfo;
import centling.business.BlDealManager;
import centling.business.BlMemberManager;
import centling.business.CDealItem;
import centling.entity.Deal;
import chinsoft.business.CDict;
import chinsoft.business.CashManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.InterfaceOperateInfoManager;
import chinsoft.business.MemberManager;
import chinsoft.business.WorkflowRequestInfoItemsManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.entity.Cash;
import chinsoft.entity.InterfaceOperateInfo;
import chinsoft.entity.Member;
import chinsoft.entity.WorkflowRequestinfoItems;

public class SearchDealCashDao {
	
	InterfaceOperateInfoManager ioimDao =new InterfaceOperateInfoManager();
	WorkflowRequestInfoItemsManager wriimDao =new WorkflowRequestInfoItemsManager();
	MemberManager mmDao =new MemberManager();
	CashManager cashManager=new CashManager();
	BlDealManager dmDao=new BlDealManager();
	
	public List<RequestInfo> getMaterialVolumeProcess(Long userId,Long workflowId, Date date){
		LogPrinter.info("oa料册扣费信息获取开始");
		oa.weaver.services.WorkflowService.WorkflowServiceHttpBindingStub binding;
		oa.weaver.services.RequestService.RequestServiceHttpBindingStub binding2;
		try {
			WorkflowService service = new WorkflowServiceLocator();
			binding=(WorkflowServiceHttpBindingStub) service.getWorkflowServiceHttpPort();
			RequestService service2 = new RequestServiceLocator();
			binding2=(RequestServiceHttpBindingStub) service2.getRequestServiceHttpPort();
		} catch (javax.xml.rpc.ServiceException e) {
			LogPrinter.info("oa料册扣费连接异常");
			LogPrinter.error(e);
			if (e.getLinkedCause() != null){
				e.getLinkedCause().printStackTrace();
			}
			throw new junit.framework.AssertionFailedError("JAX-RPC ServiceException caught: " + e);
		}
		binding.setTimeout(60000);
		String []  conditions=new String[2];
		conditions[0]="t1.workflowid="+workflowId;
		Date dateend=date;
		Calendar cal=Calendar.getInstance(); 
		cal.setTime(dateend);
		cal.add(Calendar.HOUR, -1);
		Date datestart = cal.getTime();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String startDate=sdf.format(datestart);
		String endDate=sdf.format(dateend);
		
		conditions[1]=" t1.lastoperatedate||"+"' '"+"||t1.lastoperatetime>='"+startDate+"' and t1.lastoperatedate||"+"' '"+"||t1.lastoperatetime<'"+endDate+"'";
		int count=0;
			try {
				count = binding.getProcessedWorkflowRequestCount(userId.intValue(), conditions);
			} catch (RemoteException e) {
				LogPrinter.info("oa料册接口获取归档数量时发生异常");
				LogPrinter.error(e);
				e.printStackTrace();
			}
		int pagesize=50;
		int pageNum=0;
		if(count%pagesize==0){
			pageNum=count/pagesize;
			if(count<pagesize){
				pageNum=1;
			}
		}else{
			pageNum=count/pagesize+1;
		}
		List<RequestInfo> infoList=new ArrayList<RequestInfo>();
		for(int i=0;i<pageNum;i++){
			WorkflowRequestInfo[] temp;
			try {
				temp = binding.getProcessedWorkflowRequestList(i, pagesize, count, userId.intValue(), conditions);
				for(WorkflowRequestInfo workflowRequestInfo:temp){
					RequestInfo requestInfo;
					try {
						requestInfo = binding2.getRequest(Integer.parseInt(workflowRequestInfo.getRequestId()));
						infoList.add(requestInfo);
					} catch (Exception e) {
						LogPrinter.info("oa料册接口获取详细信息发生异常");
						LogPrinter.error(e);
						e.printStackTrace();
					} 
				}
			} catch (RemoteException e) {
				LogPrinter.info("oa料册接口获取已归档流程发生异常");
				LogPrinter.error(e);
				e.printStackTrace();
			}
		}
		if(null!=infoList&&infoList.size()>0){
			if(count ==infoList.size()){
				return infoList;
			}
		}
		return null;
	}
	
	public List<RequestInfo> getMaterialProcess(Long userId,Long workflowId, Date date){
		
		oa.weaver.services.WorkflowService.WorkflowServiceHttpBindingStub binding;
		oa.weaver.services.RequestService.RequestServiceHttpBindingStub binding2;
		
		try {
			WorkflowService service = new WorkflowServiceLocator();
			binding=(WorkflowServiceHttpBindingStub) service.getWorkflowServiceHttpPort();
			RequestService service2 = new RequestServiceLocator();
			binding2=(RequestServiceHttpBindingStub) service2.getRequestServiceHttpPort();
		} catch (javax.xml.rpc.ServiceException e) {
			LogPrinter.info("oa材料发货接口连接时发生异常");
			LogPrinter.error(e);
			if (e.getLinkedCause() != null){
				e.getLinkedCause().printStackTrace();
			}
			throw new junit.framework.AssertionFailedError("JAX-RPC ServiceException caught: " + e);
		}
		binding.setTimeout(60000);
		String []  conditions=new String[2];
		conditions[0]="t1.workflowid="+workflowId;
		Date dateend=date;
		Calendar cal=Calendar.getInstance(); 
		cal.setTime(dateend);
		cal.add(Calendar.HOUR, -1);
		Date datestart = cal.getTime();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String startDate=sdf.format(datestart);
		String endDate=sdf.format(dateend);
		conditions[1]=" t1.lastoperatedate||"+"' '"+"||t1.lastoperatetime>='"+startDate+"' and t1.lastoperatedate||"+"' '"+"||t1.lastoperatetime<'"+endDate+"'";
		int count=0;
		try {
			count = binding.getProcessedWorkflowRequestCount(userId.intValue(), conditions);
		} catch (RemoteException e) {
			LogPrinter.info("oa材料发货接口获取归档数量发生异常");
			LogPrinter.error(e);
			e.printStackTrace();
		}
		int pagesize=50;
		int pageNum=0;
		if(count%pagesize==0){
			pageNum=count/pagesize;
			if(count<pagesize){
				pageNum=1;
			}
		}else{
			pageNum=count/pagesize+1;
		}
		List<RequestInfo> infoList=new ArrayList<RequestInfo>();
		for(int i=0;i<pageNum;i++){
			WorkflowRequestInfo[] temp;
			try {
				temp = binding.getProcessedWorkflowRequestList(i, pagesize, count, userId.intValue(), conditions);
				for(WorkflowRequestInfo workflowRequestInfo:temp){
					RequestInfo requestInfo;
					try {
						requestInfo = binding2.getRequest(Integer.parseInt(workflowRequestInfo.getRequestId()));
						infoList.add(requestInfo);
					} catch (Exception e) {
						LogPrinter.info("oa材料发货接口获取详细信息发生异常");
						LogPrinter.error(e);
						e.printStackTrace();
					} 
				}
			} catch (RemoteException e) {
				LogPrinter.info("oa材料发货接口获取已归档流程发生异常");
				LogPrinter.error(e);
				e.printStackTrace();
			}
		}
		if(null!=infoList&&infoList.size()>0){
			if(count ==infoList.size()){
				return infoList;
			}
		}
		return null;
	}
	
	public List<RequestInfo> getRepairProcess(Long userId, Long workflowId, Date date) {

		oa.weaver.services.WorkflowService.WorkflowServiceHttpBindingStub binding;
		oa.weaver.services.RequestService.RequestServiceHttpBindingStub binding2;
		
		try {
			WorkflowService service = new WorkflowServiceLocator();
			binding=(WorkflowServiceHttpBindingStub) service.getWorkflowServiceHttpPort();
			RequestService service2 = new RequestServiceLocator();
			binding2=(RequestServiceHttpBindingStub) service2.getRequestServiceHttpPort();
		} catch (javax.xml.rpc.ServiceException e) {
			LogPrinter.info("oa返修流程接口连接时发生异常");
			LogPrinter.error(e);
			if (e.getLinkedCause() != null){
				e.getLinkedCause().printStackTrace();
			}
			throw new junit.framework.AssertionFailedError("JAX-RPC ServiceException caught: " + e);
		}
		binding.setTimeout(60000);
		String []  conditions=new String[2];
		conditions[0]="t1.workflowid="+workflowId;
		Date dateend=date;
		Calendar cal=Calendar.getInstance(); 
		cal.setTime(dateend);
		cal.add(Calendar.HOUR, -1);
		Date datestart = cal.getTime();
		//此处的时间要修改为从定义的数据表中获取的数据。
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String startDate=sdf.format(datestart);
		String endDate=sdf.format(dateend);
		conditions[1]=" t1.lastoperatedate||"+"' '"+"||t1.lastoperatetime>='"+startDate+"' and t1.lastoperatedate||"+"' '"+"||t1.lastoperatetime<'"+endDate+"'";
		int count=0;
		try {
			count = binding.getProcessedWorkflowRequestCount(userId.intValue(), conditions);
		} catch (RemoteException e) {
			LogPrinter.info("oa返修接口获取已经归档数量发生异常");
			LogPrinter.error(e);
			e.printStackTrace();
		}
		int pagesize=count+1;
		int pageNum=0;
		if(count%pagesize==0){
			pageNum=count/pagesize;
			if(count<pagesize){
				pageNum=1;
			}
		}else{
			pageNum=count/pagesize+1;
		}
		List<RequestInfo> infoList=new ArrayList<RequestInfo>();
		for(int i=0;i<pageNum;i++){
			WorkflowRequestInfo[] temp;
			try {
				temp = binding.getProcessedWorkflowRequestList(i, pagesize, count, userId.intValue(), conditions);
				for(WorkflowRequestInfo workflowRequestInfo:temp){
					RequestInfo requestInfo;
					try {
						requestInfo = binding2.getRequest(Integer.parseInt(workflowRequestInfo.getRequestId()));//
						infoList.add(requestInfo);
					} catch (Exception e) {
						LogPrinter.info("oa返修流程接口获取详细信息发生异常");
						LogPrinter.error(e);
						e.printStackTrace();
					} 
				}
			} catch (RemoteException e) {
				LogPrinter.info("oa返修流程接口获取已归档流程发生异常");
				LogPrinter.error(e);
				e.printStackTrace();
			}
		}
		if(null!=infoList&&infoList.size()>0){
			if(count ==infoList.size()){
				return infoList;
			}
		}
		return null;
	}

	public List<InterfaceOperateInfo> getUnfinishOperate(String userId,String workflowId) {
		Long userid=Long.parseLong(userId);
		Long workflowid=Long.parseLong(workflowId) ;
		List<InterfaceOperateInfo> list=ioimDao.getInterfaceOperateInfo(userid, workflowid);
		List<InterfaceOperateInfo> ioiList=new ArrayList<InterfaceOperateInfo>();
		for(InterfaceOperateInfo ioi:list){
			if(ioi.getServiceFlag()==0||ioi.getWorkflowFlag()==0||ioi.getDealFlag()==0){
				ioiList.add(ioi);
			}
		}
		return ioiList;
	}

	public void updateInterface(InterfaceOperateInfo ioi) {
		
		ioimDao.update(ioi);
		
	}


	public void saveMaterialVolumeWorkflowRequestInfoItems(List<RequestInfo> riList,InterfaceOperateInfo ioi) {
		if(null!=riList&&riList.size()>0){
			for(RequestInfo requestInfo:riList){
				String creatorId=requestInfo.getCreatorid();
				String requestId=requestInfo.getRequestid();
				DetailTable[] listInfo= requestInfo.getDetailTableInfo().getDetailTable();
				for(DetailTable detailTable:listInfo){
					Row[] rowArray=detailTable.getRow();
					for(Row row:rowArray){
						Cell[] cellArray=row.getCell();
						if(cellArray.length>=8){
							String dateTime=cellArray[0].getValue();
							String infoName=cellArray[1].getValue();
							String memberName=cellArray[2].getValue();
							String paperNum=cellArray[3].getValue();
							String price=cellArray[4].getValue();
							String rmbORdoolar=cellArray[7].getValue();
							String regEx="^(0|([1-9]\\d{0,9}))(\\.\\d{1,2})?$";
							Pattern pat = Pattern.compile(regEx);  
							Matcher mat = pat.matcher(price); 
							
							double total =0.00;
							if(price.startsWith("$")){
								total=Double.parseDouble(price.replace("$", ""));
							}else if(price.startsWith("￥")){
								total=Double.parseDouble(price.replace("￥", ""));
							}else if(mat.matches()){
								total=Double.parseDouble(price);
							}else{
								continue;
							}
							
							DecimalFormat df=new DecimalFormat(".##");
							String tempTotal=df.format(total);
							WorkflowRequestinfoItems wrii=new WorkflowRequestinfoItems();
							wrii.setCreatorId(creatorId);
							wrii.setRequestId(Long.parseLong(requestId));
							wrii.setMemberId(memberName);
							wrii.setInterfaceId(ioi.getId());
							wrii.setCashFlag((byte)(Integer.parseInt(rmbORdoolar)));
							wrii.setTotal(total);
							SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
							try {
								wrii.setWorkflowTime(sdf.parse(dateTime));
							} catch (ParseException e) {
								LogPrinter.info("料册时间转化发生异常");
								LogPrinter.error(e);
								e.printStackTrace();
							}
							wrii.setFlowFlag((byte)0);
							wrii.setRequestInfo(infoName+"("+paperNum+")");
							wrii.setWorkflowId(ioi.getWorkflowId());
							wrii.setUserId(ioi.getUserId());
							wrii.setItemId((long)81);
							wrii.setTotal(Double.parseDouble(tempTotal));
							this.saveOrUpdateWorkflowRequestInfoItems(wrii);
						}
					}
				}
			}	
		}
		
	}
	public void saveMaterialWorkflowRequestInfoItems(List<RequestInfo> riList,InterfaceOperateInfo ioi) {
		
		if(null!=riList&&riList.size()>0){
			for(RequestInfo requestInfo:riList){
				String memberName=requestInfo.getMainTableInfo().getProperty()[9].getValue();
				String dateTime=requestInfo.getMainTableInfo().getProperty()[8].getValue()+" "+requestInfo.getMainTableInfo().getProperty()[4].getValue();
				String itemName="";
				String creatorId=requestInfo.getCreatorid();
				String requestId=requestInfo.getRequestid();
				DetailTable[] listInfo= requestInfo.getDetailTableInfo().getDetailTable();
				Row[] rowArray=listInfo[1].getRow();
				for(Row row:rowArray){
					Cell[] cellArray=row.getCell();
					itemName += cellArray[4].getValue();
					itemName += "("+cellArray[1].getValue();
					itemName += cellArray[3].getValue()+")";
					String sum=cellArray[6].getValue();
					String rmbORdoolar="0";//此处默认设置为人民币，出错的话，由填写人负责
					if(null!=cellArray[2].getValue()&&!"".equals(cellArray[2].getValue())){
						rmbORdoolar=cellArray[2].getValue();
					}
					
					String regEx="^(0|([1-9]\\d{0,9}))(\\.\\d{1,2})?$";
					Pattern pat = Pattern.compile(regEx);  
					Matcher mat = pat.matcher(sum); 
					double total =0.00;
					
					if(sum.startsWith("$")){
						total=Double.parseDouble(sum.replace("$", ""));
					}else if(sum.startsWith("￥")){
						total=Double.parseDouble(sum.replace("￥", ""));
					}else if(mat.matches()){
						total=Double.parseDouble(sum);
					}else{
						continue;
					}
					DecimalFormat df=new DecimalFormat(".##");
					String tempTotal=df.format(total);
					
					WorkflowRequestinfoItems wrii=new WorkflowRequestinfoItems();
					wrii.setCreatorId(creatorId);
					wrii.setMemberId(memberName);
					wrii.setInterfaceId(ioi.getId());
					wrii.setCashFlag((byte)Integer.parseInt(rmbORdoolar));
					wrii.setTotal(total);
					SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
					try {
						wrii.setWorkflowTime(sdf.parse(dateTime));
					} catch (ParseException e) {
						LogPrinter.info("材料发货时间转化发生异常");
						LogPrinter.error(e);
						e.printStackTrace();
					}
					wrii.setFlowFlag((byte)0);
					wrii.setRequestId(Long.parseLong(requestId));
					wrii.setRequestInfo(itemName);
					wrii.setWorkflowId(ioi.getWorkflowId());
					wrii.setUserId(ioi.getUserId());
					wrii.setTotal(Double.parseDouble(tempTotal));
					wrii.setItemId((long)101);
					this.saveOrUpdateWorkflowRequestInfoItems(wrii);
				}
			}
		}
	}

	public void saveRepairWorkflowRequestInfoItems(List<RequestInfo> riList,InterfaceOperateInfo ioi) {
		
		if(null!=riList&&riList.size()>0){
		for(RequestInfo requestInfo:riList){
			String memberName=requestInfo.getMainTableInfo().getProperty()[1].getValue();
			String dateTime=requestInfo.getMainTableInfo().getProperty()[22].getValue();
			String rmbORdoolar="";
			String itemName="返修费";
			String creatorId=requestInfo.getCreatorid();
			String requestId=requestInfo.getRequestid();
			DetailTable[] listInfo= requestInfo.getDetailTableInfo().getDetailTable();
			Row[] rowArray0=listInfo[0].getRow();
			Row[] rowArray1=listInfo[1].getRow();
			Row[] rowArray=null;
			if(null!=rowArray0&&0<rowArray0.length){
				rmbORdoolar="0";
				rowArray=rowArray0;
			}else if(null!=rowArray1&&0<rowArray1.length){
				rmbORdoolar="1";
				rowArray=rowArray1;
			}else{
				continue;
			}
			for(Row row:rowArray){
				Cell[] cellArray=row.getCell();
				String sum="";
				if("0".equals(rmbORdoolar)){
					sum=cellArray[2].getValue();
				}else if("1".equals(rmbORdoolar)){
					sum=cellArray[2].getValue();
				}
				String regEx="^(0|([1-9]\\d{0,9}))(\\.\\d{1,2})?$";
				Pattern pat = Pattern.compile(regEx);  
				Matcher mat = pat.matcher(sum); 
				double total =0.00;
				
				if(mat.matches()){
					total=Double.parseDouble(sum);
				}else{
					continue;
				}
				DecimalFormat df=new DecimalFormat(".##");
				String tempTotal=df.format(total);
				
				WorkflowRequestinfoItems wrii=new WorkflowRequestinfoItems();
				wrii.setCreatorId(creatorId);
				wrii.setMemberId(memberName);
				wrii.setInterfaceId(ioi.getId());
				wrii.setCashFlag((byte)Integer.parseInt(rmbORdoolar));
				wrii.setTotal(total);
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
				try {
					wrii.setWorkflowTime(sdf.parse(dateTime));
				} catch (ParseException e) {
					LogPrinter.info("返修时间转化发生异常");
					LogPrinter.error(e);
					e.printStackTrace();
				}
				wrii.setFlowFlag((byte)0);
				wrii.setRequestId(Long.parseLong(requestId));
				wrii.setRequestInfo(itemName);
				wrii.setWorkflowId(ioi.getWorkflowId());
				wrii.setUserId(ioi.getUserId());
				wrii.setTotal(Double.parseDouble(tempTotal));
				wrii.setItemId((long)87);
				this.saveOrUpdateWorkflowRequestInfoItems(wrii);
			}
		}
		}
	}	
	public void saveOrUpdateWorkflowRequestInfoItems(WorkflowRequestinfoItems wrii) {
		
		Long id=wrii.getInterfaceId();
		Long workflowid=wrii.getWorkflowId();
		Long userid=wrii.getUserId();
		Date date =wrii.getWorkflowTime();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		List<WorkflowRequestinfoItems> wriiList=wriimDao.getAllByInterfaceId(id,workflowid,userid,date);
		for(WorkflowRequestinfoItems wriiTemp:wriiList){
			Date datew=wrii.getWorkflowTime();
			Date datet=wriiTemp.getWorkflowTime();
			
			if(wriiTemp.getCreatorId().equals(wrii.getCreatorId())
					&&wriiTemp.getRequestId().equals(wrii.getRequestId())
					&&wrii.getMemberId().equals(wriiTemp.getMemberId())
					&&sdf.format(datet).equals(sdf.format(datew))
					&&wrii.getTotal().equals(wriiTemp.getTotal())
					&&wrii.getRequestInfo().equals(wriiTemp.getRequestInfo())
					){
				wrii.setId(wriiTemp.getId());
				wrii.setFlowFlag(wriiTemp.getFlowFlag());
				break;
			}
		}
		wriimDao.saveOrUpdate(wrii);
	}

	public void saveDealInfo(List<WorkflowRequestinfoItems> wriiList,List<Member> memberList) {
		
		for(WorkflowRequestinfoItems wrii:wriiList){
				Date dateTime=wrii.getWorkflowTime();
				String memberName=wrii.getMemberId();
				String memo=wrii.getRequestInfo();
				Double total =wrii.getTotal();
				int cashFlag=wrii.getCashFlag();
				int moneySign=0;
				if(cashFlag==0){
					moneySign=10361;
				}else if(cashFlag==1){
					moneySign=10360;
				}
				boolean userflag =false;
				for (Member member : memberList) {
					// 得到用户姓名
					String userName = member.getUsername();
					String memberId=member.getID();
					
					//确定参数是member名字 还有币种一样
					if(userName.equals(memberName)){
						userflag=true;
						//或者是根据主键获取用户id，但是现在输入的只有名字（已经暂时确认member的名字没有重复的值
						Deal deal = new Deal();
						deal.setDealDate(dateTime);
						deal.setMemberId(member.getID());
						deal.setAccountOut(total);
						deal.setDealItemId(wrii.getItemId().intValue());
						deal.setMemo(memo);
						int moneyflag=0;
						Cash cash = cashManager.getCashByMemberID(memberId);
						if (cash == null) {
							Member parentMember = mmDao.getMemberByID(member.getParentID());
							cash=cashManager.getCashByMemberID(parentMember.getID());
							moneyflag=parentMember.getMoneySignID();
						}else{
							moneyflag=member.getMoneySignID();
						}
						if (cash == null) {
							wrii.setRemark("用户cash为空");
							wriimDao.saveOrUpdate(wrii);
							break;
						}else if (cash.getNoticeNum() == null || cash.getStopNum() == null || cash.getNum() == null) {
							wrii.setRemark(" 账户余额为空，或者停用金额为空，或者提醒金额为空");
							wriimDao.saveOrUpdate(wrii);
							break;
						}
						if(moneyflag==moneySign){
							java.math.BigDecimal c = new java.math.BigDecimal(cash.getNum());// 扣款前余额
							java.math.BigDecimal d = new java.math.BigDecimal(deal.getAccountOut()); // 订单金额
							Double localNum = c.subtract(d).doubleValue(); // 扣款后余额
							if (localNum >= cash.getStopNum() || cash.getNoticeNum() < 0) {
								// 当前余额小于和等于停用金额或者提醒金额为负数，执行扣款
								deal.setMemo(deal.getMemo()+memberName);
								deal.setLocalNum(localNum);
								Session session= DataAccessObject.openSessionFactory().openSession();
								Transaction transaction=session.beginTransaction();
								try {
									session.saveOrUpdate(deal);
									cash.setNum(localNum);
									session.saveOrUpdate(cash);
									transaction.commit();
								} catch (Exception e) {
									e.printStackTrace();
									transaction.rollback();
								}finally{
									session.close();
								}
								wrii.setFlowFlag((byte)1);
								wriimDao.saveOrUpdate(wrii);
							} else {
								wrii.setRemark("余额不足无法扣费!");
								wriimDao.saveOrUpdate(wrii);
								break;
							}
						}else{
							wrii.setRemark("业务员把币种选错了!");
							wriimDao.saveOrUpdate(wrii);
							break;
						}
					}
				}
				if(userflag==false){
					wrii.setRemark("用户名不存在!");
					wriimDao.saveOrUpdate(wrii);
				}
			}
		}
		
	public List<Member> getAllMember() {
		return mmDao.getAllMember();
	}

	public List<WorkflowRequestinfoItems> getAllWorkflowInfoByInterfaceId(InterfaceOperateInfo ioi) {
		List<WorkflowRequestinfoItems> wriiList=wriimDao.getAllWorkflowInfoByInterfaceId(ioi.getId());
		return wriiList;
	}

	public long getMaxrInterfaceId(long userId,long workflowId) {
		return ioimDao.getMaxInterfaceId(userId,workflowId);
	}

	public InterfaceOperateInfo getInterfaceById(long maxInterfaceId) {
		return ioimDao.getInterfaceById(maxInterfaceId);
	}

	public InterfaceOperateInfo saveInterface(InterfaceOperateInfo ioi) {
		return ioimDao.save(ioi);
	}

}
