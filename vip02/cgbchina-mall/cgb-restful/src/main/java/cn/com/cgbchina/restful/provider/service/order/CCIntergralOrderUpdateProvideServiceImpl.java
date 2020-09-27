package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdate;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdateReturn;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrderUpdateService;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderUpdateVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL106 CC积分商城订单修改 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL106")
@Slf4j
public class CCIntergralOrderUpdateProvideServiceImpl
        implements SoapProvideService<CCIntergralOrderUpdateVO, CCIntergralOrderUpdateReturnVO> {
    @Resource
    CCIntergralOrderUpdateService cCIntergralOrderUpdateService;

    @Override
    public CCIntergralOrderUpdateReturnVO process(SoapModel<CCIntergralOrderUpdateVO> model,
                                                  CCIntergralOrderUpdateVO content) {
        CCIntergralOrderUpdate cCIntergralOrderUpdate = BeanUtils.copy(content, CCIntergralOrderUpdate.class);
        CCIntergralOrderUpdateReturn ccIntergralOrderUpdateReturn = cCIntergralOrderUpdateService
                .update(cCIntergralOrderUpdate);

        return BeanUtils.copy(ccIntergralOrderUpdateReturn, CCIntergralOrderUpdateReturnVO.class);
    }

}
