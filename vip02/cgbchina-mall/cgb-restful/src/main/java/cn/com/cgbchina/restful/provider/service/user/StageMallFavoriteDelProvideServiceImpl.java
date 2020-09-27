package cn.com.cgbchina.restful.provider.service.user;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import cn.com.cgbchina.user.service.UserFavoriteService;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDel;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDelIds;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDelReturn;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteDelReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteDelVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL303 删除收藏商品(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 *
 */
@Service
@TradeCode(value = "MAL303")
@Slf4j
public class StageMallFavoriteDelProvideServiceImpl implements SoapProvideService<StageMallFavoriteDelVO, StageMallFavoriteDelReturnVO> {
    @Resource
    UserFavoriteService userFavoriteService;

    @Override
    public StageMallFavoriteDelReturnVO process(SoapModel<StageMallFavoriteDelVO> model, StageMallFavoriteDelVO content) {
        StageMallFavoriteDel stageMallFavoriteDel = BeanUtils.copy(content, StageMallFavoriteDel.class);
//		StageMallFavoriteDelReturn stageMallFavoriteDelReturn = stageMallFavoriteDelService.del(stageMallFavoriteDel);
        StageMallFavoriteDelReturn stageMallFavoriteDelReturn = new StageMallFavoriteDelReturn();
        try {
            if (stageMallFavoriteDel.getIds() != null && stageMallFavoriteDel.getIds().size() > 0) {
            	List<String> list=new ArrayList<>();
            	for(StageMallFavoriteDelIds ids:stageMallFavoriteDel.getIds()){
            		list.add(ids.getId());
            	}
                userFavoriteService.delectPhoneFavorite(stageMallFavoriteDel.getCustId(), list);
                stageMallFavoriteDelReturn.setReturnCode("000000");
                stageMallFavoriteDelReturn.setReturnDes("取消收藏成功");
            } else {
                stageMallFavoriteDelReturn.setReturnCode("000008");
                stageMallFavoriteDelReturn.setReturnDes("报文参数错误");
            }
        } catch (Exception e) {
            log.error("删除收藏发生异常");
            stageMallFavoriteDelReturn.setReturnCode("000027");
            stageMallFavoriteDelReturn.setReturnDes("删除收藏发生异常");
            StageMallFavoriteDelReturnVO stageMallFavoriteDelReturnVO = BeanUtils.copy(stageMallFavoriteDelReturn,
                    StageMallFavoriteDelReturnVO.class);
            return stageMallFavoriteDelReturnVO;
        }

        StageMallFavoriteDelReturnVO stageMallFavoriteDelReturnVO = BeanUtils.copy(stageMallFavoriteDelReturn,
                StageMallFavoriteDelReturnVO.class);
        return stageMallFavoriteDelReturnVO;
    }

}
