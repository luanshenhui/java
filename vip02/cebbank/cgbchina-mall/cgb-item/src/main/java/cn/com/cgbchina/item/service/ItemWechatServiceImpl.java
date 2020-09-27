package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dto.ItemWechatDto;
import cn.com.cgbchina.item.dto.UploadItemWeChatDto;
import cn.com.cgbchina.item.manager.ItemManager;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Tanliang
 * @since 2016-6-13
 */
@Service
@Slf4j
public class ItemWechatServiceImpl implements ItemWechatService {

    @Resource
    private GoodsDao goodsDao;
    @Resource
    private VendorService vendorService;
    @Resource
    private ItemService itemService;
    @Resource
    private ItemManager itemManager;
    @Resource
    private BackCategoriesService backCategoriesService;
    @Resource
    private GoodsService goodsService;

    @Override
    public Response<Pager<ItemWechatDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                  @Param("code") String code, @Param("name") String name, @Param("vendorName") String vendorName) {
        Response<Pager<ItemWechatDto>> response = new Response<>();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        paramMap.put("offset", pageInfo.getOffset());
        paramMap.put("limit", pageInfo.getLimit());
        // 非空判断
        if (StringUtils.isNotEmpty(code)) {
            paramMap.put("code", code);
        }
        if (StringUtils.isNotEmpty(name)) {
            paramMap.put("name", name);
        }
        if (StringUtils.isNotEmpty(vendorName)) {
            // 根据供应商名称模糊查询 检索出相对应的ID
            Response<List<String>> vendorResponse = vendorService.findIdByName(vendorName);
            if (vendorResponse.isSuccess()) {
                List<String> vendorIds = vendorResponse.getResult();
                paramMap.put("vendorIds", vendorIds);
            }
        }
        // 微信商品，只检索广发商城和信用卡商城微信已经上架的商品
        paramMap.put("channelState", Contants.CHANNEL_MALL_WX_02); //
        // 创建List DTo实例对象
        List<ItemWechatDto> itemWechatDtos = new ArrayList<ItemWechatDto>();
        try {
            Pager<GoodsModel> pager = goodsDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
            if (pager.getTotal() > 0) {
                List<GoodsModel> goodsModelList = pager.getData();
                for (GoodsModel goods : goodsModelList) {
                    // 防止多条List重复，取得重复数据，创建新的实例
                    List<String> itemCodes = Lists.newArrayList();
                    // 得到商品code
                    itemCodes.add(goods.getCode());
                    // 根据商品codeList取得单品list
                    // 首先循环单品有多少单品就有多少条数据
                    List<ItemModel> itemModelList = Lists.newArrayList();
                    Response<List<ItemModel>> itemResponse = itemService.findItemListByGoodsCodeList(itemCodes);
                    if (itemResponse.isSuccess()) {
                        itemModelList = itemResponse.getResult();
                    }
                    if (itemModelList.size() > 0) {
                        for (ItemModel itemModel : itemModelList) {
                            ItemWechatDto itemWechatDto = new ItemWechatDto();
                            itemWechatDto.setPrice(itemModel.getPrice()); // 实际价格
                            itemWechatDto.setCode(itemModel.getCode()); // 单品code
                            if (itemModel.getWxOrder() != null) { // 微信顺序
                                itemWechatDto.setWxOrder(itemModel.getWxOrder());
                            }
                            List<Long> backCategoryIdList = Lists.newArrayList();
                            Response<List<BackCategory>> backCategoryRespone = new Response<List<BackCategory>>();
                            List<BackCategory> backCategoryList = Lists.newArrayList();
                            Response<VendorInfoDto> vendorResponse = new Response<>();
                            // 后台类目id赋值到backCategoryIdList
                            backCategoryIdList.add(goods.getBackCategory1Id());
                            backCategoryIdList.add(goods.getBackCategory2Id());
                            backCategoryIdList.add(goods.getBackCategory3Id());
                            // 根据后台类目id（backCategoryIdList）取得后台类目名称
                            backCategoryRespone = backCategoriesService.findByIds(backCategoryIdList);
                            if (backCategoryRespone.isSuccess()) {
                                // 非空判断，如果不为null 就set 后台类目名称到goodsInfoDto
                                backCategoryList = backCategoryRespone.getResult();
                                if (!backCategoryList.isEmpty()) {
                                    // 因为只有三级后台类目，所以不用循环，只取0 1 2即可
                                    itemWechatDto.setBackCategory1Name(backCategoryList.get(0).getName());
                                    itemWechatDto.setBackCategory2Name(backCategoryList.get(1).getName());
                                    itemWechatDto.setBackCategory3Name(backCategoryList.get(2).getName());
                                }
                            }
                            // 将数据放入DTO里面
                            itemWechatDto.setGoodsCode(goods.getCode()); // 商品code
                            //itemWechatDto.setInstallmentNumber(goods.getInstallmentNumber());// 最高期数
                            itemWechatDto.setName(goods.getName());// 商品名称
                            // 如果广发银行（微信） 不为空判断状态
                            if (StringUtils.isNotEmpty(goods.getChannelMallWx())) {
                                // 广发银行（微信）已上架
                                if (goods.getChannelMallWx().equals(Contants.CHANNEL_MALL_WX_02)) {
                                    itemWechatDto.setChannelMallWxName(Contants.CHANNEL_MALL_WX_02_NAME);
                                }
                                // 广发银行（微信）处理中
                                if (goods.getChannelMallWx().equals(Contants.CHANNEL_MALL_WX_00)) {
                                    itemWechatDto.setChannelMallWxName(Contants.CHANNEL_MALL_WX_00_NAME);
                                }
                                // 广发银行（微信）在库
                                if (goods.getChannelMallWx().equals(Contants.CHANNEL_MALL_WX_01)) {
                                    itemWechatDto.setChannelMallWxName(Contants.CHANNEL_MALL_WX_01_NAME);
                                }
                            }
                            // 如果信用卡中心（微信） 不为空判断状态
                            if (StringUtils.isNotEmpty(goods.getChannelCreditWx())) {
                                // 信用卡中心（微信）已上架
                                if (goods.getChannelCreditWx().equals(Contants.CHANNEL_CREDIT_WX_02)) {
                                    itemWechatDto.setChannelCreditWxName(Contants.CHANNEL_CREDIT_WX_02_NAME);
                                }
                                // 信用卡中心（微信）处理中
                                if (goods.getChannelCreditWx().equals(Contants.CHANNEL_CREDIT_WX_00)) {
                                    itemWechatDto.setChannelCreditWxName(Contants.CHANNEL_CREDIT_WX_00_NAME);
                                }
                                // 信用卡中心（微信）在库
                                if (goods.getChannelCreditWx().equals(Contants.CHANNEL_CREDIT_WX_01)) {
                                    itemWechatDto.setChannelCreditWxName(Contants.CHANNEL_CREDIT_WX_01_NAME);
                                }
                            }
                            // 根据vendorId查询vendor信息，放入goodsInfoDto中
                            vendorResponse = vendorService.findById(goods.getVendorId());
                            if (vendorResponse.isSuccess()) {
                                itemWechatDto.setVendorName(vendorResponse.getResult().getSimpleName());
                            }
                            // 单品有多少单品就有多少条数据
                            itemWechatDtos.add(itemWechatDto);
                        }
                    }
                }
            }
            Pager<ItemWechatDto> infoDtoPager = new Pager<ItemWechatDto>(pager.getTotal(), itemWechatDtos);
            response.setResult(infoDtoPager);
            return response;
        } catch (Exception e) {
            log.error("ItemWeChat.error", Throwables.getStackTraceAsString(e));
            response.setError("ItemWeChat.error");
            return response;
        }
    }

    /**
     * 根据单品code 删除单品（逻辑删除）
     *
     * @param code
     * @return
     */
    @Override
    public Response<Boolean> deleteItemByCode(String code) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            itemManager.deleteItemByCode(code);
            response.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("delete.deleteItem.error,cause:{}", code, Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
        }
        return response;
    }

    /**
     * 编辑微信商品（更改排序）
     *
     * @param wxOrder
     * @param code
     * @return
     */
    @Override
    public Response<Boolean> editItemWeChat(Long wxOrder, String code) {
        Response<Boolean> response = new Response<Boolean>();
        // 根据单品code 取得单品信息
        ItemModel itemModel = itemService.findItemDetailByCode(code);
        // 如果单品的顺序不为空 并且传入了想要更改的顺序
        if (itemModel.getWxOrder() != null && StringUtils.isNotEmpty(code)) {
            // 取得改单品的顺序呢进行比较
            Long order = itemModel.getWxOrder();
            // 和原本的顺序进行比较
            if (wxOrder.equals(order)) {
                response.setResult(Boolean.TRUE); // 表示没有更改
            } else {
                Long total = itemService.wxOrderCheck(wxOrder);
                if (total != 0) {
                    response.setResult(Boolean.FALSE);
                } else {
                    // 如果顺序不重复 更新顺序
                    ItemModel model = new ItemModel();
                    model.setWxOrder(wxOrder);
                    model.setCode(code);
                    Boolean result = itemManager.editItemOrder(model);
                    if (!result) {
                        response.setError("editItemOrder.error");
                        return response;
                    }
                    response.setResult(Boolean.TRUE);// 顺序不重复
                }
            }
            // 如果原来顺序为空，并且传入了想要更改的顺序,进行check
        } else if (itemModel.getWxOrder() == null && StringUtils.isNotEmpty(code)) {
            Long total = itemService.wxOrderCheck(wxOrder);
            if (total != 0) {
                response.setResult(Boolean.FALSE);
            } else {
                response.setResult(Boolean.TRUE);
                ItemModel model = new ItemModel();
                model.setWxOrder(wxOrder);
                model.setCode(code);
                Boolean result = itemManager.editItemOrder(model);
                if (!result) {
                    response.setError("editItemOrder.error");
                    return response;
                }
            }
        }
        return response;
    }

    /**
     * 导入微信商品
     *
     * @param models
     */
	public Response<Boolean> uploadItemWeChat(List<UploadItemWeChatDto> models)throws Exception{
		Response<Boolean> response = new Response<Boolean>();

		List<UploadItemWeChatDto> results = new ArrayList<UploadItemWeChatDto>();
		for(UploadItemWeChatDto item : models){
			ItemModel temp = itemService.findItemDetailByCode(item.getItemCode());
			// 判断是否存在该单品
			if(temp != null){
				GoodsModel goodsModel = goodsService.findById(temp.getGoodsCode()).getResult();
				if(goodsModel != null){
					String channelMallWx = goodsModel.getChannelMallWx();
					String channelCreditWx = goodsModel.getChannelCreditWx();
					// 判断该单品是否已上架
					if( "02".equals(channelMallWx) ||  "02".equals(channelCreditWx)){
						// 判断导入的顺序是否为数字
						if(isNumeric(item.getWxOrder())){
							long count = itemService.wxOrderCheck(Long.parseLong(item.getWxOrder()));
							if(count == 0){
								ItemModel updateModel = new ItemModel();
								updateModel.setCode(item.getItemCode());
								updateModel.setWxOrder(Long.parseLong(item.getWxOrder()));
								 // 更新单品表中“微信商品显示顺序”自段
								Integer updateCount = itemManager.update(updateModel);
								if(updateCount == 1){
									item.setUploadFlag("成功");
									response.setResult(Boolean.TRUE);
								}
							}else{
								item.setUploadFlag("失败");
								item.setUploadFailedReason("该显示顺序已存在");
								response.setResult(Boolean.FALSE);
							}
						}else{
							item.setUploadFlag("失败");
							item.setUploadFailedReason("显示顺序字段不是数字");
							response.setResult(Boolean.FALSE);
						}
					}else{
						item.setUploadFlag("失败");
						item.setUploadFailedReason("该单品未上架");
						response.setResult(Boolean.FALSE);
					}
				}
			}else{
				item.setUploadFlag("失败");
				item.setUploadFailedReason("该单品不存在");
				response.setResult(Boolean.FALSE);
			}
		}
		// 生成excel

		createExcel(models);
		return response;
	}
    private void createExcel(List<UploadItemWeChatDto> models) {

        String path = "C:/upload/Test1.xls";
        // 创建一个webbook，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        // 添加一个sheet,对应Excel文件中的sheet
        HSSFSheet sheet = wb.createSheet("导入微信商品");
        sheet.setDefaultColumnWidth(20);
        // 在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
        HSSFRow row = sheet.createRow((int) 0);
        // 创建单元格，并设置值表头 设置表头居中
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式

        HSSFCell cell = row.createCell(0);
        cell.setCellValue("成功标识");
        cell.setCellStyle(style);
        cell = row.createCell(1);
        cell.setCellValue("错误原因");
        cell.setCellStyle(style);
        cell = row.createCell(2);
        cell.setCellValue("商品编码(5位)");
        cell.setCellStyle(style);
        cell = row.createCell(3);
        cell.setCellValue("显示顺序");
        cell.setCellStyle(style);

        for (int i = 0; i < models.size(); i++) {
            row = sheet.createRow(i + 1);
            UploadItemWeChatDto model = models.get(i);
            // 第四步，创建单元格，并设置值
            row.setRowStyle(style);
            row.createCell(0).setCellValue(model.getUploadFlag());
            row.createCell(1).setCellValue(model.getUploadFailedReason());
            row.createCell(2).setCellValue(model.getItemCode());
            row.createCell(3).setCellValue(model.getWxOrder());
        }
        // 将文件存到指定位置
        try {
            // 判断文件是否存在
            if (fileExist(path)) {
                // 若存在，则删除
                deleteExcel(path);
            }
            FileOutputStream fout = new FileOutputStream(path);
            wb.write(fout);
            fout.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 判断字符串是否为数字
     *
     * @param str 字符串
     * @return
     */
    private boolean isNumeric(String str) {
        Pattern pattern = Pattern.compile("[0-9]*");
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }

    /**
     * 判断文件是否存在.
     *
     * @param fileDir 文件路径
     * @return
     */
    private boolean fileExist(String fileDir) {
        boolean flag = false;
        File file = new File(fileDir);
        flag = file.exists();
        return flag;
    }

    /**
     * 删除文件.
     *
     * @param fileDir 文件路径
     * @return
     */
    private boolean deleteExcel(String fileDir) {
        boolean flag = false;
        File file = new File(fileDir);
        // 判断目录或文件是否存在
        if (!file.exists()) {  // 不存在返回 false
            return flag;
        } else {
            // 判断是否为文件
            if (file.isFile()) {  // 为文件时调用删除文件方法
                file.delete();
                flag = true;
            }
        }
        return flag;
    }

}
