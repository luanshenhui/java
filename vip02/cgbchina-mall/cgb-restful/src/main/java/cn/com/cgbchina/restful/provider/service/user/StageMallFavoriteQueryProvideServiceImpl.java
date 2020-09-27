package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteGoods;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.UserFavoriteService;
import cn.com.cgbchina.user.service.UserInfoService;

import com.alibaba.druid.Constants;
import com.google.common.base.Strings;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteQuery;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoritesReturn;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoritesReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteQueryVO;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;

/**
 * MAL302 查询收藏商品(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL302")
@Slf4j
public class StageMallFavoriteQueryProvideServiceImpl implements SoapProvideService<StageMallFavoriteQueryVO, StageMallFavoritesReturnVO> {
    @Resource
    UserFavoriteService userFavoriteService;
    @Resource
    ItemService itemService;
    @Resource
    UserInfoService userInfoService;
    @Resource
    GoodsPayWayService goodsPayWayService;
    @Resource
    GoodsService goodsService;

    @Override
    public StageMallFavoritesReturnVO process(SoapModel<StageMallFavoriteQueryVO> model, StageMallFavoriteQueryVO content) {
        StageMallFavoriteQuery stageMallFavoriteQuery = BeanUtils.copy(content, StageMallFavoriteQuery.class);
//		StageMallFavoritesReturn stageMallFavoritesReturn = stageMallFavoriteQueryService.query(stageMallFavoriteQuery);
        StageMallFavoritesReturn stageMallFavoritesReturn = new StageMallFavoritesReturn();
        //发起方
        String origin = stageMallFavoriteQuery.getOrigin();
        //客户号
        String cust_id = stageMallFavoriteQuery.getCustId();
        //页面大小
        String rowsPage = stageMallFavoriteQuery.getRowsPage();
        //当前页码
        String currentPage = stageMallFavoriteQuery.getCurrentPage();
        currentPage = currentPage != "" ? currentPage : "1";
        int rowsPageInt = 1;
        int currentPageInt = 1;
        if (rowsPage != null && !"".equals(rowsPage)) {
            rowsPageInt = Integer.parseInt(rowsPage);
        }
        if (currentPage != null && !"".equals(currentPage)) {
            currentPageInt = Integer.parseInt(currentPage);
        }
        if (Contants.SOURCE_ID_CELL.equals(origin) && Strings.isNullOrEmpty(cust_id)) {
            //手机渠道客户号必填
            stageMallFavoritesReturn.setReturnCode("000008");
            stageMallFavoritesReturn.setReturnDes("报文参数错误:客户号不能为空");
            StageMallFavoritesReturnVO stageMallFavoritesReturnVO = BeanUtils.copy(stageMallFavoritesReturn,
                    StageMallFavoritesReturnVO.class);
            return stageMallFavoritesReturnVO;
        }
        PageInfo pageInfo = new PageInfo();
        int firstResult;
        if(currentPageInt <= 1){
            firstResult = 0;
        }else if(currentPageInt == 2){
            firstResult = rowsPageInt;
        }else{
            firstResult =(rowsPageInt - 1) * rowsPageInt;
        }
        pageInfo.setLimit(rowsPageInt);
        pageInfo.setOffset(firstResult);
        User user = new User();
        user.setId(cust_id);
        Pager<MemberGoodsFavoriteModel> pager = null;
        try {
            Response<Pager<MemberGoodsFavoriteModel>> response = userFavoriteService.findByPager(pageInfo, user);
            pager = new Pager<MemberGoodsFavoriteModel>();
            List<MemberGoodsFavoriteModel> list = new ArrayList<MemberGoodsFavoriteModel>();
            if(response.isSuccess() && response.getResult() != null){
                pager = response.getResult();
                list = pager.getData();
            }
            stageMallFavoritesReturn.setTotalCount(pager.getTotal().toString());
            int totalCount = pager.getTotal().intValue();
            int pageCount;
            if(totalCount==0){
                pageCount=0;
            }else if(totalCount<=rowsPageInt){
                pageCount=1;
            }else{
                if(pager.getTotal() % rowsPageInt > 0){
                    pageCount = totalCount / rowsPageInt +1;
                }else{
                    pageCount = totalCount / rowsPageInt;
                }
            }
            stageMallFavoritesReturn.setTotalPages(String.valueOf(pageCount));

            stageMallFavoritesReturn.setTotalCount(String.valueOf(totalCount));

            String goods_pic_path = "";
            String picture_url = "";
            if (list != null && list.size() > 0){//如果存在搜藏的商品
                log.debug("该页的数据大小："+list.size());
                List<StageMallFavoriteGoods> stageMallFavoriteGoodses = new ArrayList<StageMallFavoriteGoods>();
                StageMallFavoriteGoods stageMallFavoriteGoods = null;
                for(MemberGoodsFavoriteModel memberGoodsFavoriteModel :list){
                    stageMallFavoriteGoods = new StageMallFavoriteGoods();
                    stageMallFavoriteGoods.setCustId(memberGoodsFavoriteModel.getCustId());
                    stageMallFavoriteGoods.setId(memberGoodsFavoriteModel.getId().toString());
                    stageMallFavoriteGoods.setGoodsId(memberGoodsFavoriteModel.getItemCode());

                    String item_id = "";
                    if(memberGoodsFavoriteModel.getGoodsCode() != null){

                        item_id = memberGoodsFavoriteModel.getItemCode();
                    }else{

                        item_id = "";
                    }

                    Response<ItemModel> itemModelResponse = itemService.findByItemcode(item_id);
                    ItemModel itemModel = null;
                    if(itemModelResponse.isSuccess()){
                        itemModel = itemModelResponse.getResult();
                    }
                    if(itemModel == null){
                        continue;
                    }
                    Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
                    GoodsModel goodsModel = null;
                    if(goodsModelResponse.isSuccess()) {
                        goodsModel = goodsModelResponse.getResult();
                    }


                    Response<VendorInfoModel> vendorInfoModelResponse = userInfoService.findVendorInfoByVendorId(item_id);
                    VendorInfoModel vendorInfoModel = null;
                    if(vendorInfoModelResponse.isSuccess()){
                        vendorInfoModel = vendorInfoModelResponse.getResult();
                    }
                    String ordertype_id = "";
                    if(vendorInfoModel != null){
                        ordertype_id = vendorInfoModel.getBusinessTypeId();
                    }
                    //获取广发搜藏商品id对应的具体价格信息
                    if(itemModel.getXid()==null||"".equals(itemModel.getXid().trim())||!"JF".equals(ordertype_id)){//广发商品
                        Response<List<TblGoodsPaywayModel>> goodsPaywayResponse = goodsPayWayService.findGoodsPayWayInfoList(itemModel.getCode());
                        List<TblGoodsPaywayModel> goodsPaywayModelList = null;
                        if(goodsPaywayResponse.isSuccess()){
                            goodsPaywayModelList = goodsPaywayResponse.getResult();
                        }
                        if (goodsPaywayModelList != null && goodsPaywayModelList.size() > 0) {
                            log.debug("paramList大小：" + goodsPaywayModelList.size());
                            TblGoodsPaywayModel goodsPaywayModel = (TblGoodsPaywayModel)goodsPaywayModelList.get(0);
                            if(goodsPaywayModel != null){
                                stageMallFavoriteGoods.setGoodsNm(goodsModel.getName());
                                stageMallFavoriteGoods.setGoodsPriceY(String.valueOf(goodsPaywayModel.getGoodsPrice()));
                                int stages_num = 1;
                                if (goodsPaywayModel.getStagesCode() != null && !"".equals(goodsPaywayModel.getStagesCode().toString())) {
                                    stages_num = Integer.parseInt(goodsPaywayModel.getStagesCode().toString());
                                }
   
                                stageMallFavoriteGoods.setGoodsPriceF(goodsPaywayModel.getPerStage() != null ? goodsPaywayModel.getPerStage().toString() : "0");
                                stageMallFavoriteGoods.setStagesNum(String.valueOf(stages_num));
                                stageMallFavoriteGoods.setPaywayIdY("");
                                stageMallFavoriteGoods.setPaywayIdF(goodsPaywayModel.getGoodsPaywayId());
                                stageMallFavoriteGoods.setOrdertypeId(ordertype_id);
                            }
                        }
                    }else{//获取积分对应的支付信息
                        Response<List<TblGoodsPaywayModel>> goodsPaywayResponse = goodsPayWayService.findGoodsPayWayInfoList(itemModel.getCode());
                        List<TblGoodsPaywayModel> goodsPaywayModelList = null;
                        if(goodsPaywayResponse.isSuccess()){
                            goodsPaywayModelList = goodsPaywayResponse.getResult();
                        }
                        if(goodsPaywayModelList!=null && goodsPaywayModelList.size()>0){
                            for(int k=0;k<goodsPaywayModelList.size();k++){
                                TblGoodsPaywayModel goodsPaywayModel = (TblGoodsPaywayModel)goodsPaywayModelList.get(k);
                                if(goodsPaywayModel!=null){
                                    stageMallFavoriteGoods.setGoodsNm(goodsModel.getName());
                                    stageMallFavoriteGoods.setGoodsType(goodsModel.getGoodsType());
                                    if(goodsPaywayModel.getMemberLevel()!=null&&"0000".equals(goodsPaywayModel.getMemberLevel())){//金普价
                                        stageMallFavoriteGoods.setJpPricePayid(goodsPaywayModel.getGoodsPaywayId());

                                        stageMallFavoriteGoods.setJpPrice(goodsPaywayModel.getGoodsPoint() != null ? goodsPaywayModel.getGoodsPoint().toString() : "0");
                                    }else if(goodsPaywayModel.getMemberLevel()!=null&&"0001".equals(goodsPaywayModel.getMemberLevel())){//钛金/臻享白金
                                        stageMallFavoriteGoods.setTzPricePayid(goodsPaywayModel.getGoodsPaywayId());

                                        stageMallFavoriteGoods.setTzPrice(goodsPaywayModel.getGoodsPoint() != null ? goodsPaywayModel.getGoodsPoint().toString() : "0");
                                    }else if(goodsPaywayModel.getMemberLevel()!=null&&"0002".equals(goodsPaywayModel.getMemberLevel())){//顶级/增值白金
                                        stageMallFavoriteGoods.setDzPricePayid(goodsPaywayModel.getGoodsPaywayId());

                                        stageMallFavoriteGoods.setDzPrice(goodsPaywayModel.getGoodsPoint() != null ? goodsPaywayModel.getGoodsPoint().toString() : "0");
                                    }else if(goodsPaywayModel.getMemberLevel()!=null&&"0003".equals(goodsPaywayModel.getMemberLevel())){//VIP
                                        stageMallFavoriteGoods.setVipPricePayid(goodsPaywayModel.getGoodsPaywayId());

                                        stageMallFavoriteGoods.setVipPrice(goodsPaywayModel.getGoodsPoint() != null ? goodsPaywayModel.getGoodsPoint().toString() : "0");
                                    }else if(goodsPaywayModel.getMemberLevel()!=null&&"0004".equals(goodsPaywayModel.getMemberLevel())){//生日
                                        stageMallFavoriteGoods.setBrhPricePayid(goodsPaywayModel.getGoodsPaywayId());

                                        stageMallFavoriteGoods.setBrhPrice(goodsPaywayModel.getGoodsPoint() != null ? goodsPaywayModel.getGoodsPoint().toString() : "0");
                                    }else if(goodsPaywayModel.getMemberLevel()!=null&&"0005".equals(goodsPaywayModel.getMemberLevel())){//积分+现金
                                        stageMallFavoriteGoods.setJfxjPricePayid(goodsPaywayModel.getGoodsPaywayId());

                                        stageMallFavoriteGoods.setJfPart(goodsPaywayModel.getGoodsPoint() != null ? goodsPaywayModel.getGoodsPoint().toString() : "0");
                                        stageMallFavoriteGoods.setXjPart(goodsPaywayModel.getGoodsPrice() != null ? goodsPaywayModel.getGoodsPrice().toString() : "0");
                                    }

                                    stageMallFavoriteGoods.setGoodsBacklog(itemModel.getStock() != null ? itemModel.getStock().toString() : "0");
                                    stageMallFavoriteGoods.setAlertNum(itemModel.getStockWarning() != null ? itemModel.getStockWarning().toString() : "0");
                                    stageMallFavoriteGoods.setOrdertypeId(ordertype_id);
                                }
                            }
                        }
                    }
                    stageMallFavoriteGoods.setDoDate(DateHelper.date2string(memberGoodsFavoriteModel.getCreateTime(), DateHelper.YYYYMMDD));
                    stageMallFavoriteGoods.setDoTime(DateHelper.date2string(memberGoodsFavoriteModel.getCreateTime(), DateHelper.HHMMSS));
                    stageMallFavoriteGoods.setFavoriteDesc(memberGoodsFavoriteModel.getMemo() != null ? memberGoodsFavoriteModel.getMemo() : "");
                    String status = "";//上下架状态
                    if(Contants.SOURCE_ID_APP.equals(origin)){
                    	String goodsStatus = goodsModel.getChannelApp();
                    	if (Contants.CHANNEL_APP_02.equals(goodsStatus)) {
                    		status = "0203";
    					} else if(Contants.CHANNEL_APP_01.equals(goodsStatus)){
    						status = "0204";
    					} else{
    						status = "0202";
    					}
                    }
                    stageMallFavoriteGoods.setPictureUrl(itemModel.getImage1());
                    stageMallFavoriteGoods.setStatus(status);//增加“上下架状态”
                    stageMallFavoriteGoodses.add(stageMallFavoriteGoods);
                }
                stageMallFavoritesReturn.setStageMallFavoriteGoodses(stageMallFavoriteGoodses);
            }
            stageMallFavoritesReturn.setReturnCode("000000");
        } catch (Exception e) {
            log.error("查询收藏出现异常");
            stageMallFavoritesReturn.setReturnCode("000009");
            stageMallFavoritesReturn.setReturnDes("查询收藏出现异常");
            StageMallFavoritesReturnVO stageMallFavoritesReturnVO = BeanUtils.copy(stageMallFavoritesReturn,
                    StageMallFavoritesReturnVO.class);
            return stageMallFavoritesReturnVO;
        }
        StageMallFavoritesReturnVO stageMallFavoritesReturnVO = BeanUtils.copy(stageMallFavoritesReturn,
                StageMallFavoritesReturnVO.class);
        return stageMallFavoritesReturnVO;
    }

}
