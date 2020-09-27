package com.dpn.dpows.standard.service;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;











/* log4j log
import org.apache.log4j.Logger;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
*/
/* slf4j log */
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dpn.dpows.standard.repository.work.EventLogRepository;
import com.dpn.dpows.common.util.UUIDHexGenerator;
import com.dpn.dpows.standard.model.WorkDeclareDto;
import com.dpn.dpows.standard.model.WorkDeclareGoods;
import com.dpn.dpows.standard.model.WorkDeclareGoodsDto;
import com.dpn.dpows.standard.repository.work.WorkRepository;





/**
 * WorkService.
 *
 * @author zhaoqian@dpn.com.cn
 * @since 1.0.0 zhaoqian@dpn.com.cn
 * @version 1.0.0 zhaoqian@dpn.com.cn
 * Created by ZhaoQian on 2017-9-6 14:27:26.
**/
@Service("workService")
public class WorkService {
    /*
    *               WorkServiceImpl.java
    *public interface WorkService
    *public class WorkServiceImpl implements WorkService
    *import com.dpn.dpos.service.impl.WorkServiceImpl;
    */

    /* *** 接口 *** */
    /*
    //###########################################  < WorkDeclareDto >  ###########################################
    public WorkDeclareDto getWorkDeclareDto(String id) throws Exception;
    public List<WorkDeclareDto> getListWorkDeclareDto(Map<String,String> map) throws Exception;
    public List<WorkDeclareDto> getListWorkDeclareDto8noLimit(Map<String,String> map) throws Exception;
    public Integer getSizeWorkDeclareDto(Map<String,String> map) throws Exception;
    public void insertWorkDeclareDto(WorkDeclareDto dto) throws Exception;
    public void updateWorkDeclareDto(WorkDeclareDto dto) throws Exception;
    public void deleteWorkDeclareDto(Map<String,String> map) throws Exception;

    //###########################################  < WorkDeclareGoodsDto >  ###########################################
    public WorkDeclareGoodsDto getWorkDeclareGoodsDto(String id) throws Exception;
    public List<WorkDeclareGoodsDto> getListWorkDeclareGoodsDto(Map<String,String> map) throws Exception;
    public List<WorkDeclareGoodsDto> getListWorkDeclareGoodsDto8noLimit(Map<String,String> map) throws Exception;
    public Integer getSizeWorkDeclareGoodsDto(Map<String,String> map) throws Exception;
    public void insertWorkDeclareGoodsDto(WorkDeclareGoodsDto dto) throws Exception;
    public void updateWorkDeclareGoodsDto(WorkDeclareGoodsDto dto) throws Exception;
    public void deleteWorkDeclareGoodsDto(Map<String,String> map) throws Exception;

    */

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    public WorkRepository workDao;
    
    @Autowired
    @Qualifier("eventLog")
    private EventLogRepository eventLogRepository;


    /* *** 手动事务处理,spring 2.x版本适用 *** */
    /*
    /导入类
    import org.springframework.transaction.TransactionStatus;
    import org.springframework.transaction.PlatformTransactionManager;
    import org.springframework.transaction.support.DefaultTransactionDefinition;


    protected PlatformTransactionManager transactionManager;

    public void setTransactionManager(PlatformTransactionManager transactionManager) {
        this.transactionManager = transactionManager;
    }

    //示例
    public void sample(){
        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        TransactionStatus status = transactionManager.getTransaction(def);

        try{
            this.evcDao.insertVslDecMaster(vslDecMasterDto);
            this.evcDao.insertDclr(dclr);

            transactionManager.commit(status);
        }catch (Exception e) {
            transactionManager.rollback(status);
            log.error("******* createDclr trnasaction rollback *******:", e);
            this.insertEventLog("MSA","MSA",UUIDHexGenerator.getInstance().generate(), "createDclr", "error", dclr.toString(), errStr);
        }
    }
    */

    /* *** 自动动事务处理,spring 3.x版本适用 *** */
    /*
    @Transactional
    public void submit(PublishPlanDto dto) throws Exception{
        this.deleteTicketDetailDto(tdDto.getId());
        this.updatePublishPlanDetailDto(ppdDto);
        if("edit".equals(tiDto.getEditType())){
            this.updateTicketInfoDto(tiDto);
        }
    }
    */

    public WorkService(){}


    /********************** WorkDeclareDto *************************/
    public WorkDeclareDto getWorkDeclareDto(String id) throws Exception{
        Map<String,String> map = new HashMap<String,String>();
        map.put("id",id);
        map.put("oneRow","1");

        return this.workDao.getWorkDeclareDto(map);
    }


    /*
    public List<WorkDeclareDto> getListWorkDeclareDto(String ……) throws Exception{
        Map<String,String> map = new HashMap<String, String>();
        map.put("id",id);
        return this.workDao.getListWorkDeclareDto(map);
    }
    */


    //有限制查询(分页查询)
    public List<WorkDeclareDto> getListWorkDeclareDto(Map<String,String> map) throws Exception{
        map.put("moreRow","yes");
        return this.workDao.getListWorkDeclareDto(map);
    }


    //无限制查询
    public List<WorkDeclareDto> getListWorkDeclareDto8noLimit(Map<String,String> map) throws Exception{
        if(map.containsKey("moreRow"))
            map.remove("moreRow");

        return this.workDao.getListWorkDeclareDto(map);
    }



    public Integer getSizeWorkDeclareDto(Map<String,String> map) throws Exception{
        return this.workDao.getSizeWorkDeclareDto(map);
    }



    public void insertWorkDeclareDto(WorkDeclareDto dto) throws Exception{
        dto.setId(UUIDHexGenerator.getInstance().generate());
        this.workDao.insertWorkDeclareDto(dto);
    }



    public void updateWorkDeclareDto(WorkDeclareDto dto) throws Exception{
        this.workDao.updateWorkDeclareDto(dto);
    }


   
    public void deleteWorkDeclareDto(Map<String,String> map) throws Exception{
        this.workDao.deleteWorkDeclareDto(map);
    }



    public void deleteWorkDeclareDto(String id) throws Exception{
        Map<String,String> map = new HashMap<String,String>();
        map.put("id",id);

        this.workDao.deleteWorkDeclareDto(map);
    }




    /********************** WorkDeclareGoodsDto *************************/
    public WorkDeclareGoodsDto getWorkDeclareGoodsDto(String id) throws Exception{
        Map<String,String> map = new HashMap<String,String>();
        map.put("id",id);
        map.put("oneRow","1");

        return this.workDao.getWorkDeclareGoodsDto(map);
    }


    /*
    public List<WorkDeclareGoodsDto> getListWorkDeclareGoodsDto(String ……) throws Exception{
        Map<String,String> map = new HashMap<String, String>();
        map.put("id",id);
        return this.workDao.getListWorkDeclareGoodsDto(map);
    }
    */


    //有限制查询(分页查询)
    public List<WorkDeclareGoodsDto> getListWorkDeclareGoodsDto(Map<String,String> map) throws Exception{
        map.put("moreRow","yes");
        return this.workDao.getListWorkDeclareGoodsDto(map);
    }


    //无限制查询
    public List<WorkDeclareGoodsDto> getListWorkDeclareGoodsDto8noLimit(Map<String,String> map) throws Exception{
        if(map.containsKey("moreRow"))
            map.remove("moreRow");

        return this.workDao.getListWorkDeclareGoodsDto(map);
    }



    public Integer getSizeWorkDeclareGoodsDto(Map<String,String> map) throws Exception{
        return this.workDao.getSizeWorkDeclareGoodsDto(map);
    }



    public void insertWorkDeclareGoodsDto(WorkDeclareGoodsDto dto) throws Exception{
        dto.setId(UUIDHexGenerator.getInstance().generate());
        this.workDao.insertWorkDeclareGoodsDto(dto);
    }



    public void updateWorkDeclareGoodsDto(WorkDeclareGoodsDto dto) throws Exception{
        this.workDao.updateWorkDeclareGoodsDto(dto);
    }

    public void updateWorkDeclareGoodsList(List<WorkDeclareGoodsDto> workDeclarGoodslist) throws Exception{
    	if(workDeclarGoodslist!=null && workDeclarGoodslist.size()>0){
    		for(WorkDeclareGoodsDto workDeclareGoods:workDeclarGoodslist){
    			saveEventLog("syqyld","dpn","审批","更新审批状态",workDeclareGoods.getId(),"更新货物信息");
    			this.workDao.updateWorkDeclareGoodsDto(workDeclareGoods);
    		}
    	}
    }
    @Transactional
    public void updateWorkDeclareAndDeclareGoods(WorkDeclareDto workDeclareDto,List<WorkDeclareGoods> workGoodslist) throws Exception{
    	List<WorkDeclareGoodsDto> workDeclarGoodslist = new ArrayList<WorkDeclareGoodsDto>();
    	if(workGoodslist!= null && workGoodslist.size()>0){
    		for(WorkDeclareGoods workDeclareGoods:workGoodslist){
    			if(workDeclareGoods!= null){
    				WorkDeclareGoodsDto workDeclareGoodsDto = new WorkDeclareGoodsDto();
    				workDeclareGoodsDto.setId(workDeclareGoods.getDeclareGoodsId());
    				workDeclareGoodsDto.setStatusStr(workDeclareGoods.getStatus());
    				workDeclareGoodsDto.setVerify_user_id(workDeclareGoods.getVerifyUserId());
    				workDeclareGoodsDto.setVerify_optinion(workDeclareGoods.getVerifyOpinion());
    				workDeclareGoodsDto.setGmt_verify(new Date());
    				workDeclarGoodslist.add(workDeclareGoodsDto);
    			}
    		}
    	}
    	if(workDeclarGoodslist!= null && workDeclarGoodslist.size()>0){
    		updateWorkDeclareGoodsList(workDeclarGoodslist);
    	}
    	saveEventLog("syqyld","dpn","审批","更新审批状态",workDeclareDto.getId(),"更新主表信息");
    	updateWorkDeclareDto(workDeclareDto);
    }
    
    /**
	 * 提交事件日志 ，用于记录delete、insert、update时的数据库操作，保存全部提交信息
	 * @param actionUser 操作人代码
	 * @param orgCode 操作人组织
	 * @param actionType 操作类型
	 * @param actionName 动作名称
	 * @param indexValue 操作功能主键编号
	 * @param strings 1-5的备注
	 * @throws Exception
	 */
	public void saveEventLog(String actionUser,String orgCode
			,String actionType,String actionName,String indexValue,String ...strings) throws Exception{
		Map<String,String> map = new HashMap<String,String>();	
		map.put("action_user", actionUser);
		map.put("action_org_code", orgCode);
		map.put("action_type", actionType);
		map.put("action_name", actionName);
		map.put("index_value", indexValue);
		if(strings != null){
			if(strings.length <=5){
				for (int i = 0; i < strings.length; i++) {
					map.put("details_"+(i+1), strings[i]);			
				}
			}else{
				new Exception("参数过长");
			}
		}		
		this.eventLogRepository.insertEventLog(map);
	}

    public void deleteWorkDeclareGoodsDto(Map<String,String> map) throws Exception{
        this.workDao.deleteWorkDeclareGoodsDto(map);
    }



    public void deleteWorkDeclareGoodsDto(String id) throws Exception{
        Map<String,String> map = new HashMap<String,String>();
        map.put("id",id);

        this.workDao.deleteWorkDeclareGoodsDto(map);
    }

    /**********************  WorkSealDto *************************/

    
    
    
/********************** WorkDeclareAndGoods*************************/
    
    //有限制查询(分页查询)
    public List<WorkDeclareDto> getListWorkDeclareAndGoods(Map<String,String> map) throws Exception{
        map.put("moreRow","yes");
        return this.workDao.getListWorkDeclareAndGoods(map);
    }
    
    
    public Integer getSizeWorkDeclareAndGoods(Map<String,String> map) throws Exception{
        return this.workDao.getSizeWorkDeclareAndGoods(map);
    }
    
    
    
    
    /********************** 事务演示 *************************/
    /********************** transactional *************************/

    /*
    * 保存操作 {新增|更新}
    * 演示事务处理,保持最小操作性原则，将查询等操作放到外边用参数带进来。
    *//*
    @Transactional
    public void save(MdgPrmyPrptInfDto dto) throws Exception{
        if("add".equals(dto.getEditType())){
            dto.setId(UUIDHexGenerator.getInstance().generate());
            this.attributeDao.insertMdgPrmyPrptInfDto(dto);

            for(MdgCmptIdntDto cmptIdntDto : dto.getCmptIndtList()){
                cmptIdntDto.setId(UUIDHexGenerator.getInstance().generate());
                cmptIdntDto.setMdg_prmy_prpt_inf_id(dto.getDmnd_src_id());
                this.attributeDao.insertMdgCmptIdntDto(cmptIdntDto);
            }
        }else{//update
            this.attributeDao.updateMdgPrmyPrptInfDto(dto);
            //1).用dto.getID()删除成份识别表的相关数据
            this.deleteMdgCmptIdntDto8PrmyId(dto.getId());
            //2). 重新插入成份识别信息
            for(MdgCmptIdntDto cmptIdntDto : dto.getCmptIndtList()){
                cmptIdntDto.setId(UUIDHexGenerator.getInstance().generate());
                cmptIdntDto.setMdg_prmy_prpt_inf_id(dto.getDmnd_src_id());
                this.attributeDao.insertMdgCmptIdntDto(cmptIdntDto);
            }
        }
    }
    */

    /*
    * 删除
    *//*
    @Transactional
    public void remove(String id) throws Exception{
        //??? 执行删除操作还是将数据置为无效 ???
        this.updateMdgPrmyPrptInfDto4vldMrk(id);//将数据置为无效
        this.deleteMdgPrmyPrptInfDto(id);//执行删除操作
        this.deleteMdgCmptIdntDto8PrmyId(id);
    }
    */
    

}