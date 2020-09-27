package com.dpn.dpows.standard.service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.dpn.dpows.standard.model.WorkDeclareDto;
import com.dpn.dpows.standard.model.WorkDeclareGoodsDto;
import com.dpn.dpows.standard.repository.WorkRepository;





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
    

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    public WorkRepository workDao;
  

    public WorkService(){}


    public Integer getSizeWorkDeclareDto(String id) throws Exception{
    	Map<String,String> map = new HashMap<String,String>();
    	map.put("id", id);
    	
        return this.workDao.getSizeWorkDeclareDto(map);
    }



    public void updateWorkDeclareDto(WorkDeclareDto dto) throws Exception{
        this.workDao.updateWorkDeclareDto(dto);
    }


    public void updateWorkDeclareGoodsDto(WorkDeclareGoodsDto dto) throws Exception{
        this.workDao.updateWorkDeclareGoodsDto(dto);
    }

    
    public void updateWorkDeclareGoodsList(List<WorkDeclareGoodsDto> list) throws Exception{
    	for(WorkDeclareGoodsDto wdgDto : list){
			this.workDao.updateWorkDeclareGoodsDto(wdgDto);
		}
    }
    
    
    @Transactional
    public void updateWorkDeclareAndDeclareGoods(WorkDeclareDto dto) throws Exception{
    	updateWorkDeclareDto(dto);
    	for(WorkDeclareGoodsDto wdgDto : dto.getGoods()){
			this.workDao.updateWorkDeclareGoodsDto(wdgDto);
		}
    }
    
 

}