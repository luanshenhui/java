package rcmtm.synchronousDealCash;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import oa.weaver.soa.workflow.request.RequestInfo;
import centling.entity.Deal;
import chinsoft.core.LogPrinter;
import chinsoft.entity.InterfaceOperateInfo;
import chinsoft.entity.Member;
import chinsoft.entity.WorkflowRequestinfoItems;

/**
 * @author Wk
 * @version 20140114
 * 获取service返回的参数，并将其格式化为与用户对应的订单对象
 * 此处要根据用户id获取,可是我并不确定根据此种方式获取的数据的正确性
 * 
 * */
public class SearchDealCashService {
	
	SearchDealCashDao sdcd=new SearchDealCashDao();
	List<Member> memberList = sdcd.getAllMember();
	
	public void findMaterialVolumesDealCash(String userId,String workflowId,Date date){
		LogPrinter.info("料册扣费接口开始");
		List<InterfaceOperateInfo> unfinishList=sdcd.getUnfinishOperate(userId,workflowId);
		if(null!=unfinishList&&0!=unfinishList.size()){
			for(InterfaceOperateInfo ioi:unfinishList){
				if((ioi.getServiceFlag()==0&&ioi.getWorkflowFlag()==0&&ioi.getDealFlag()==0)
						||(ioi.getWorkflowFlag()==0&&ioi.getDealFlag()==0)){
					List<RequestInfo> riList=new ArrayList<RequestInfo>();
					try {
						riList=sdcd.getMaterialVolumeProcess(ioi.getUserId(),ioi.getWorkflowId(),ioi.getStartTime());
					} catch (Exception e) {
						LogPrinter.info("继续未完成料册扣费任务发生异常");
						LogPrinter.error(e);
						e.printStackTrace();
					}
					ioi.setServiceFlag((byte)1);
					ioi.setWorkflowFlag((byte) 0);
					ioi.setDealFlag((byte) 0);
					ioi.setOperateType((byte) 1);
					sdcd.updateInterface(ioi);
					sdcd.saveMaterialVolumeWorkflowRequestInfoItems(riList,ioi);
					ioi.setWorkflowFlag((byte)1);
					ioi.setOperateType((byte)1);
					sdcd.updateInterface(ioi);
					List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
					sdcd.saveDealInfo(wriiList,memberList);
					ioi.setDealFlag((byte)1);
					ioi.setOperateType((byte)2);
					ioi.setEndTime(new Date());
					sdcd.updateInterface(ioi);	
				}else if(ioi.getDealFlag()==0){
					List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
					sdcd.saveDealInfo(wriiList,memberList);
					ioi.setDealFlag((byte)1);
					ioi.setOperateType((byte)2);
					ioi.setEndTime(new Date());
					sdcd.updateInterface(ioi);	
				}
			}
		}
		long userid=Long.parseLong(userId);
		long workflowid=Long.parseLong(workflowId);
		long maxInterfaceId=sdcd.getMaxrInterfaceId(userid,workflowid);
		InterfaceOperateInfo ioiMax=sdcd.getInterfaceById(maxInterfaceId);
		InterfaceOperateInfo ioi=new InterfaceOperateInfo();
		//接口开始时间为    查询接口数据的结束时间
		if(ioiMax!=null){
			Date dateLast=ioiMax.getStartTime();
			Calendar cal=Calendar.getInstance(); 
			cal.setTime(dateLast);
			cal.add(Calendar.HOUR, 1);
			Date start = cal.getTime();
			long temp = date.getTime()-dateLast.getTime();
			long d =temp/1000/60/60;
		    if(d<1){
		    	return ;
		    }
			ioi.setStartTime(start);
		}else{
			ioi.setStartTime(date);
		}
		ioi.setWorkflowId(workflowid);
		ioi.setUserId(userid);
		List<RequestInfo> riList=new ArrayList<RequestInfo>();
		try {
			riList = sdcd.getMaterialVolumeProcess(userid,workflowid,ioi.getStartTime());
		} catch (Exception e) {
			LogPrinter.info("料册扣费接口发生异常");
			LogPrinter.error(e);
			e.printStackTrace();
		}
		ioi.setServiceFlag((byte) 1);
		ioi.setWorkflowFlag((byte) 0);
		ioi.setDealFlag((byte) 0);
		ioi.setOperateType((byte) 1);
		if(null!=riList&&riList.size()>0){
			ioi.setItemCount(Long.parseLong(riList.size()+""));
		}else{
			ioi.setItemCount((long) 0);
		}
		ioi=sdcd.saveInterface(ioi);
		sdcd.saveMaterialVolumeWorkflowRequestInfoItems(riList,ioi);
		ioi.setWorkflowFlag((byte) 1);
		ioi.setOperateType((byte) 2);
		sdcd.updateInterface(ioi);
		List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
		sdcd.saveDealInfo(wriiList,memberList);
		ioi.setDealFlag((byte) 1);
		ioi.setOperateType((byte) 3);
		ioi.setEndTime(new Date());
		sdcd.updateInterface(ioi);
		
		Date dateStart=ioi.getStartTime();
		
		long temp = date.getTime()-dateStart.getTime();
		long d =temp/1000/60/60;
	    if(d>=1){
	    	this.findMaterialVolumesDealCash(userId, workflowId, date);
	    }
		
	}

	public void findMaterialDealCash(String userId,String workflowId,Date date)throws Exception {
		LogPrinter.info("材料发货扣费接口开始");
		List<InterfaceOperateInfo> unfinishList=sdcd.getUnfinishOperate(userId,workflowId);
		if(null!=unfinishList&&0<unfinishList.size()){
			for(InterfaceOperateInfo ioi:unfinishList){
				if((ioi.getServiceFlag()==0&&ioi.getWorkflowFlag()==0&&ioi.getDealFlag()==0)
						||(ioi.getWorkflowFlag()==0&&ioi.getDealFlag()==0)){
					List<RequestInfo> riList=new ArrayList<RequestInfo>();
					try {
						riList=sdcd.getMaterialProcess(ioi.getUserId(),ioi.getWorkflowId(),ioi.getStartTime());
					} catch (Exception e) {
						LogPrinter.info("继续未完成材料发货扣费接口发生异常");
						LogPrinter.error(e);
						e.printStackTrace();
					}
					ioi.setServiceFlag((byte) 1);
					ioi.setWorkflowFlag((byte) 0);
					ioi.setDealFlag((byte) 0);
					ioi.setOperateType((byte) 1);
					sdcd.updateInterface(ioi);
					sdcd.saveMaterialWorkflowRequestInfoItems(riList,ioi);
					ioi.setWorkflowFlag((byte) 1);
					ioi.setOperateType((byte) 1);
					sdcd.updateInterface(ioi);
					List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
					sdcd.saveDealInfo(wriiList,memberList);
					ioi.setDealFlag((byte) 1);
					ioi.setOperateType((byte) 2);
					ioi.setEndTime(new Date());
					sdcd.updateInterface(ioi);	
				}else if(ioi.getDealFlag()==0){
					List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
					sdcd.saveDealInfo(wriiList,memberList);
					ioi.setDealFlag((byte) 1);
					ioi.setOperateType((byte) 2);
					ioi.setEndTime(new Date());
					sdcd.updateInterface(ioi);	
				}
			}
		}
		long userid=Long.parseLong(userId);
		long workflowid=Long.parseLong(workflowId);
		long maxInterfaceId=sdcd.getMaxrInterfaceId(userid,workflowid);
		InterfaceOperateInfo ioiMax=sdcd.getInterfaceById(maxInterfaceId);
		InterfaceOperateInfo ioi=new InterfaceOperateInfo();
		if(ioiMax!=null){
			Date dateLast=ioiMax.getStartTime();
			Calendar cal=Calendar.getInstance(); 
			cal.setTime(dateLast);
			cal.add(Calendar.HOUR, 1);
			Date start = cal.getTime();
			long temp = date.getTime()-dateLast.getTime();
		    long d =temp/1000/60/60;
		    if(d<1){
		    	return ;
		    }
		    ioi.setStartTime(start);
		}else{
			ioi.setStartTime(date);
		}
		
		ioi.setUserId(userid);
		ioi.setWorkflowId(workflowid);
		List<RequestInfo> riList=new ArrayList<RequestInfo>();
		try {
			riList = sdcd.getMaterialProcess(userid,workflowid,ioi.getStartTime());
		} catch (Exception e) {
			LogPrinter.info("材料发货扣费接口发生异常");
			LogPrinter.error(e);
			e.printStackTrace();
		}
		ioi.setServiceFlag((byte) 1);
		ioi.setWorkflowFlag((byte) 0);
		ioi.setDealFlag((byte) 0);
		ioi.setOperateType((byte) 1);
	
		if(null!=riList&&riList.size()>0){
			ioi.setItemCount((long)riList.size());
		}else{
			ioi.setItemCount((long) 0);
		}
		ioi=sdcd.saveInterface(ioi);
		sdcd.saveMaterialWorkflowRequestInfoItems(riList,ioi);
		ioi.setWorkflowFlag((byte) 1);
		ioi.setOperateType((byte) 1);
		sdcd.updateInterface(ioi);
		List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
		sdcd.saveDealInfo(wriiList,memberList);
		ioi.setDealFlag((byte) 1);
		ioi.setOperateType((byte) 3);
		ioi.setEndTime(new Date());
		sdcd.updateInterface(ioi);
		
		Date dateStart=ioi.getStartTime();
		long temp = date.getTime()-dateStart.getTime();
		long d =temp/1000/60/60;
	    
	    if(d>=1){
	    	this.findMaterialDealCash(userId, workflowId, date);
	    }
		
		
	}
	
	public void findReturnRepairDealCash(String userId,String workflowId,Date date)throws Exception {
		LogPrinter.info("返修扣费接口开始");
		List<InterfaceOperateInfo> unfinishList=sdcd.getUnfinishOperate(userId,workflowId);
		if(null!=unfinishList&&0<unfinishList.size()){
			for(InterfaceOperateInfo ioi:unfinishList){
				if((ioi.getServiceFlag()==0&&ioi.getWorkflowFlag()==0&&ioi.getDealFlag()==0)
						||(ioi.getWorkflowFlag()==0&&ioi.getDealFlag()==0)){
					List<RequestInfo> riList=new ArrayList<RequestInfo>();
					try {
						riList=sdcd.getRepairProcess(ioi.getUserId(),ioi.getWorkflowId(),ioi.getStartTime());
					} catch (Exception e) {
						LogPrinter.info("继续未完成的返修扣费接口发生异常");
						LogPrinter.error(e);
						e.printStackTrace();
					}
					ioi.setServiceFlag((byte) 1);
					ioi.setWorkflowFlag((byte) 0);
					ioi.setDealFlag((byte) 0);
					ioi.setOperateType((byte) 1);
					sdcd.updateInterface(ioi);
					sdcd.saveRepairWorkflowRequestInfoItems(riList,ioi);
					ioi.setWorkflowFlag((byte) 1);
					ioi.setOperateType((byte) 1);
					sdcd.updateInterface(ioi);
					List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
					sdcd.saveDealInfo(wriiList,memberList);
					ioi.setDealFlag((byte) 1);
					ioi.setOperateType((byte) 2);
					ioi.setEndTime(new Date());
					sdcd.updateInterface(ioi);	
				}else if(ioi.getDealFlag()==0){
					List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
					sdcd.saveDealInfo(wriiList,memberList);
					ioi.setDealFlag((byte) 1);
					ioi.setOperateType((byte) 2);
					ioi.setEndTime(new Date());
					sdcd.updateInterface(ioi);	
				}
			}
		}
		
		long userid=Long.parseLong(userId);
		long workflowid=Long.parseLong(workflowId);
		long maxInterfaceId=sdcd.getMaxrInterfaceId(userid,workflowid);
		InterfaceOperateInfo ioiMax=sdcd.getInterfaceById(maxInterfaceId);
		InterfaceOperateInfo ioi=new InterfaceOperateInfo();
		if(ioiMax!=null){
			Date dateLast=ioiMax.getStartTime();
			Calendar cal=Calendar.getInstance(); 
			cal.setTime(dateLast);
			cal.add(Calendar.HOUR, 1);
			Date start = cal.getTime();
			long temp = date.getTime()-dateLast.getTime();
			long d = temp/1000/60/60;
		    if(d<1){
		    	return ;
		    }
			ioi.setStartTime(start);
		}else{
			ioi.setStartTime(new Date());
		}
		
		ioi.setUserId(userid);
		ioi.setWorkflowId(workflowid);
		List<RequestInfo> riList=new ArrayList<RequestInfo>();
		try {
			riList = sdcd.getRepairProcess(userid,workflowid,ioi.getStartTime());
		} catch (Exception e) {
			LogPrinter.info("返修扣费接口发生异常");
			LogPrinter.error(e);
			e.printStackTrace();
		}
		ioi.setServiceFlag((byte) 1);
		ioi.setWorkflowFlag((byte) 0);
		ioi.setDealFlag((byte) 0);
		ioi.setOperateType((byte) 1);
	
		if(null!=riList&&riList.size()>0){
			ioi.setItemCount((long)riList.size());
		}else{
			ioi.setItemCount((long) 0);
		}
		ioi=sdcd.saveInterface(ioi);
		sdcd.saveRepairWorkflowRequestInfoItems(riList,ioi);
		ioi.setWorkflowFlag((byte) 1);
		ioi.setOperateType((byte) 1);
		sdcd.updateInterface(ioi);
		List<WorkflowRequestinfoItems> wriiList =sdcd.getAllWorkflowInfoByInterfaceId(ioi);
		sdcd.saveDealInfo(wriiList,memberList);
		ioi.setDealFlag((byte) 1);
		ioi.setOperateType((byte) 3);
		ioi.setEndTime(new Date());
		sdcd.updateInterface(ioi);
		
		
		Date dateStart=ioi.getStartTime();
		long temp = date.getTime()-dateStart.getTime();
		long d =temp/1000/60/60;
	    if(d>=1){
	    	this.findReturnRepairDealCash(userId, workflowId, date);
	    }
		
	}
	
}
