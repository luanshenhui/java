package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.GoodsCommendDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dto.GoodsCommendDto;
import cn.com.cgbchina.item.dto.RecommendGoodsDto;
import cn.com.cgbchina.item.manager.BrandManager;
import cn.com.cgbchina.item.manager.GoodsCommendManager;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsCommendModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
public class GoodsCommendServiceImpl implements GoodsCommendService {

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	private GoodsCommendDao goodsCommendDao;
	@Resource
	private ItemDao itemDao;
	@Resource
	private GoodsDao goodsDao;
	@Resource
	private BrandManager brandManager;
	@Resource
	private GoodsCommendManager goodsCommendManager;
	@Resource
	private GoodsService goodsService;

    /**
     * 新增推荐商品
     *
     * @param model，user
     * @return
     */
    @Override
    public Response<Boolean> createGoodsCommend(GoodsCommendModel model) {
        Response<Boolean> response = new Response<>();
        try {
            // 取得添加前该品牌下推荐商品的数量
            if (model != null) {
                Long count = goodsCommendDao.countByBrandId(model.getTypeId());
                if (count > 10) {
                    response.setResult(Boolean.FALSE);
                    response.setError("exceed.limit.of.ten.error");
                }
                if (StringUtils.isNotEmpty(model.getGoodsId())) {
                    // 根据单品编码取得单品信息
                    ItemModel itemModel = itemDao.findItemDetailByMid(model.getGoodsId());
                    String goodsId = "";
                    if (itemModel != null) {
                        goodsId = itemModel.getCode();
                        model.setGoodsId(goodsId);
                        // 根据商品编码取得商品信息
                        GoodsModel recommendGoods = goodsDao.findById(itemModel.getGoodsCode());
                        if (recommendGoods != null) {
                            String brandId = model.getTypeId();
                            if (StringUtils.isNotEmpty(brandId)) {
                                Long goodsBrandId = recommendGoods.getGoodsBrandId();
                                String goodsBrandIdToString = Long.toString(goodsBrandId);
                                if (!brandId.equals(goodsBrandIdToString)) {
                                    response.setResult(Boolean.FALSE);
                                    response.setError("goods.and.brands.do.not.correspond.error");
                                } else {
                                    // 判断是否已存在
                                    GoodsCommendModel goodsComment = goodsCommendDao.findByGoodsId(model.getGoodsId());
                                    if (goodsComment != null) {
                                        response.setResult(Boolean.FALSE);
                                        response.setError("goods.has.existed.error");
                                    } else {
                                        // 判断显示顺序是否已存在
                                        GoodsCommendModel goodsCommentSeq = goodsCommendDao.findByModel(model);
                                        if (goodsCommentSeq != null) {
                                            response.setResult(Boolean.FALSE);
                                            response.setError("order.repeated.error");
                                        } else {
                                            model.setDelFlag(0);
                                            Boolean result = goodsCommendManager.insert(model);
                                            if (!result) {
                                                response.setError("create.goods.commend.error");
                                                return response;
                                            }
                                            response.setResult(result);

											// 更新品牌表
											GoodsBrandModel goodsBrandModel = new GoodsBrandModel();
											goodsBrandModel.setGoodsBrand(model.getTypeId());
											goodsBrandModel.setPublishStatus("01");
											brandManager.updateByGoodsBrand(goodsBrandModel);
										}
									}
								}
							}
						}else{
							response.setResult(Boolean.FALSE);
							response.setError("goods.not.exists.error");
						}
					}else{
						response.setResult(Boolean.FALSE);
						response.setError("item.not.exists.error");
					}
				}else {
					response.setResult(Boolean.FALSE);
					response.setError("goods.code.null.error");
				}
			}else{
				response.setResult(Boolean.FALSE);
				response.setError("input.goods.info.error");
			}
		} catch (Exception e) {
			log.error("create.goods.commend.error{}", Throwables.getStackTraceAsString(e));
			response.setError("create.goods.commend.error");
		}
		return response;
	}

    /**
     * 获取推荐商品
     *
     * @param brandId
     * @return
     */
    @Override
    public Response<List<GoodsCommendDto>> findGoodsCommends(String brandId) {
        Response<List<GoodsCommendDto>> response = Response.newResponse();
        List<GoodsCommendDto> list = new ArrayList<GoodsCommendDto>();
        try {
            List<GoodsCommendModel> goodsCommendModel = goodsCommendDao.findGoodsCommends(brandId);
            if (goodsCommendModel != null) {
                for (GoodsCommendModel item : goodsCommendModel) {
                    GoodsCommendDto dto = new GoodsCommendDto();
                    dto.setGoodsCommendModel(item);
                    if (item != null) {
                        Response<RecommendGoodsDto> goodsInfo = goodsService.findItemInfoByItemCode(item.getGoodsId());
                        if (goodsInfo.isSuccess()) {
                            RecommendGoodsDto goodsDto = goodsInfo.getResult();
                            dto.setItemName(goodsDto.getGoodsName());
                        }
                    }
                    list.add(dto);
                }
            }
            response.setResult(list);
        } catch (Exception e) {
            log.error("find.goods.commend.error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.goods.commend.error");
        }
        return response;
    }

    /**
     * 根据mid取得推荐单品名称
     *
     * @param mid
     * @return
     */
    @Override
    public Response<String> findItemNameByMid(String mid) {
        Response<String> response = Response.newResponse();
        String itemName = "";
        try {
            // 根据单品编码取得单品信息
            ItemModel itemModel = itemDao.findItemDetailByMid(mid);
            if (itemModel != null) {
                // 根据商品编码取得商品信息
                GoodsModel recommendGoods = goodsDao.findById(itemModel.getGoodsCode());
                if (recommendGoods != null) {
                    itemName = recommendGoods.getName();
                }
                if (!Strings.isNullOrEmpty(itemModel.getAttributeName1()) && !"无".equals(itemModel.getAttributeName1())){
                    itemName += "/" + itemModel.getAttributeName1();
                }
                if (!Strings.isNullOrEmpty(itemModel.getAttributeName2()) && !"无".equals(itemModel.getAttributeName2())){
                    itemName += "/" + itemModel.getAttributeName2();
                }
            }
            response.setResult(itemName);
            return response;
        } catch (Exception e) {
            log.error("find.itemname.by.mid.error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.itemname.by.mid.error");
            return response;
        }
    }

    /**
     * 删除推荐商品
     *
     * @param id
     * @return
     */
    public Response<Boolean> deleteGoodsCommend(Long id) {
        Response<Boolean> response = new Response<>();
        try {
            GoodsCommendModel model = new GoodsCommendModel();
            model.setId(id);
            Boolean result = goodsCommendManager.delete(model);
            if (!result) {
                response.setError("delete.goods.commend.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("delete.goods.commend.error{}", Throwables.getStackTraceAsString(e));
            response.setError("delete.goods.commend.error");
        }
        return response;
    }

}
