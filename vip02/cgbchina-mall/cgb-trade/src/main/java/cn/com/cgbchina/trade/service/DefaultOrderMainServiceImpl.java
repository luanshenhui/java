package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dto.OrderCommitInfoDto;
import cn.com.cgbchina.trade.dto.OrderCommitSubmitDto;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderMainSingleCheckDto;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import javax.annotation.Resource;
import java.util.List;
import java.util.concurrent.*;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by lvzd on 2016/9/14.
 */
@Slf4j
public abstract class DefaultOrderMainServiceImpl {
    @Resource
    VendorService vendorService;
    /**
     * 供应商检证
     * @param orderMainDto
     * @return
     */
    protected void vendorCheck(OrderMainDto orderMainDto) {
        // 取得供应商简称
        Response<List<VendorInfoModel>> vendorInfoModelList = vendorService.findByVendorIds(orderMainDto.getVendorCodes());
        if(!vendorInfoModelList.isSuccess()){
            log.error("Response.error,error code: {}", vendorInfoModelList.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
        }
        for (VendorInfoModel vendorInfoModel : vendorInfoModelList.getResult()) {
            checkArgument(StringUtils.isNotEmpty(vendorInfoModel.getMerId()), "没有此供应商:" + vendorInfoModel.getVendorId());
            orderMainDto.putVendorInfo(vendorInfoModel.getVendorId(), vendorInfoModel);
        }
    }
    /**
     * 供应商检证
     * @param orderMainDto
     * @return
     */
    protected void vendorCheckJF(OrderMainDto orderMainDto) {
        // 取得供应商简称
        Response<List<VendorInfoModel>> vendorInfoModelList = vendorService.findByVendorIds(orderMainDto.getVendorCodes());
        if(!vendorInfoModelList.isSuccess()){
            log.error("Response.error,error code: {}", vendorInfoModelList.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
        }
        for (VendorInfoModel vendorInfoModel : vendorInfoModelList.getResult()) {
            orderMainDto.putVendorInfo(vendorInfoModel.getVendorId(), vendorInfoModel);
        }
    }

    protected Response<OrderMainDto> execOrderSubmit(OrderCommitSubmitDto orderCommitSubmitDto, User user, String cardType) throws Exception {
        Response<OrderMainDto> retRsp = Response.newResponse();
        OrderMainDto orderMainDto = new OrderMainDto();
        List<OrderCommitInfoDto> orderCommitInfoDtoList = orderCommitSubmitDto.getOrderCommitInfoList();
        if (orderCommitInfoDtoList.size() == 1) {
            OrderCommitInfoDto orderCommitInfoDto = orderCommitInfoDtoList.get(0);
            orderCommitInfoDto.setEntryCard(orderCommitSubmitDto.getEntryCard());
            orderCommitInfoDto.setMiaoFlag(orderCommitSubmitDto.getMiaoFlag());
            orderCommitInfoDto.setCardType(cardType);
            OrderMainSingleCheckDto ret = singleCommitCheck(orderCommitInfoDtoList.get(0), user);
            orderMainDto.addOrderMainData(ret);
        } else {
            // 多线程执行
            ExecutorService executorService = Executors.newFixedThreadPool(orderCommitInfoDtoList.size());
            CompletionService completionService = new ExecutorCompletionService(executorService);
            for (OrderCommitInfoDto orderCommitInfoDto : orderCommitInfoDtoList) {
                orderCommitInfoDto.setEntryCard(orderCommitSubmitDto.getEntryCard());
                orderCommitInfoDto.setMiaoFlag(orderCommitSubmitDto.getMiaoFlag());
                orderCommitInfoDto.setCardType(cardType);
                completionService.submit(callSingleCommitCheck(orderCommitInfoDto, user));
            }
            for (int j = 0; j < orderCommitInfoDtoList.size(); j++) {
                OrderMainSingleCheckDto ret = (OrderMainSingleCheckDto) completionService.take().get();
                if (ret.getError() != null) {
                    log.error("DefaultOrderMainServiceImpl checkCreateOrderArgumentAndGetInfos error,error code: {}", ret.getError());
                    retRsp.setError(ret.getError());
                    return retRsp;
                }
                orderMainDto.addOrderMainData(ret);
            }
            executorService.shutdown();
        }
        retRsp.setResult(orderMainDto);
        return retRsp;
    }
    /**
     * 异步执行处理
     */
    private Callable<OrderMainSingleCheckDto> callSingleCommitCheck(final OrderCommitInfoDto orderCommitInfoDto, final User user) {
        Callable<OrderMainSingleCheckDto> ret = new Callable<OrderMainSingleCheckDto>() {
            @Override
            public OrderMainSingleCheckDto call() throws Exception {
                try {
                    return singleCommitCheck(orderCommitInfoDto, user);
                } catch (IllegalArgumentException e) {
                    OrderMainSingleCheckDto error = new OrderMainSingleCheckDto();
                    error.setError(e.getMessage());
                    return error;
                }
            }
        };
        return ret;
    }

    /**
     * 商品list
     * @param orderCommitInfoDto
     * @param user
     * @return
     */
    protected abstract OrderMainSingleCheckDto singleCommitCheck(OrderCommitInfoDto orderCommitInfoDto, User user);
}
