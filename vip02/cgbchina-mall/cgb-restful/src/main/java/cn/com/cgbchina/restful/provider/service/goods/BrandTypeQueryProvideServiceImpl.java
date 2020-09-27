package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.EspNavCategoryInfModel;
import cn.com.cgbchina.item.model.Goods;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.EspNavCategoryInfService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.vo.goods.BrandTypeVO;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.alibaba.dubbo.container.page.Page;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.BrandTypeQuery;
import cn.com.cgbchina.rest.provider.model.goods.BrandTypeQueryReturn;
import cn.com.cgbchina.rest.provider.vo.goods.BrandTypeQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.BrandTypeQueryVO;
import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * MAL336 类别品牌查询 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 *
 */
@Service
@TradeCode(value = "MAL336")
@Slf4j
public class BrandTypeQueryProvideServiceImpl implements  SoapProvideService <BrandTypeQueryVO,BrandTypeQueryReturnVO>{

	@Resource
	EspNavCategoryInfService espNavCategoryInfService;

	@Resource
	BrandService brandService;

	/**
	 * 类别品牌查询接口
	 * @param model
	 * @param content 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160729
	 */
	@Override
	public BrandTypeQueryReturnVO process(SoapModel<BrandTypeQueryVO> model, BrandTypeQueryVO content) {
		BrandTypeQueryReturnVO brandTypeQueryReturnVO = new BrandTypeQueryReturnVO();

//		String mallType = content.getMallType(); //商城类型
		String queryType = StringUtil.dealNull(content.getQueryType());//查询类型-- 查询大类：01 ， 查询指定类别下品牌：02
		String typeId = content.getTypeId();//大类ID
		String rowsPage = content.getRowsPage();//每页行数
		String currentPage = content.getCurrentPage();//当前页数
		List<BrandTypeVO> brandTypeList = Lists.newArrayList();//定义返回结果集
		//页面大小
		int rowsPageInt = 1;
		int currentPageInt = 1;
		if(rowsPage!=null && !"".equals(rowsPage)){
			rowsPageInt=Integer.parseInt(rowsPage);
		}
		if(currentPage!=null && !"".equals(currentPage)){
			currentPageInt=Integer.parseInt(currentPage);
		}
		try {
			//获取总的条数
			Long totalCount = 0l;
			//构造查询参数
			Map<String,Object> paramMap = Maps.newHashMap();
			PageInfo info = new PageInfo(currentPageInt,rowsPageInt);
			paramMap.put("offset",info.getOffset());//当前页数
			paramMap.put("limit",info.getLimit());//每页显示数据数量
			paramMap.put("ordertypeId",Contants.BUSINESS_TYPE_YG);
			paramMap.put("brandState", Contants.BRAND_STATE_1);
			paramMap.put("brandInforStatus",Contants.BRAND_APPROVE_STATUS_01);
			if("01".equals(queryType)){
				//查询品牌大类列表
//				pager = tblGoodsBrandBySqlDao.queryBrandType(searchVo);
				Response<Pager<EspNavCategoryInfModel>> navCategoryResponse = espNavCategoryInfService.findByPage(paramMap);
				if(!navCategoryResponse.isSuccess()){
					log.error("BrandTypeQueryProvideServiceImpl.process->espNavCategoryInfService.findByPage.error paramMap:{}",
							paramMap);
					brandTypeQueryReturnVO.setReturnCode("000009");
					brandTypeQueryReturnVO.setReturnDes("系统异常");
				}

				Pager<EspNavCategoryInfModel> pager  = navCategoryResponse.getResult();
				totalCount = pager.getTotal();//总数据条数
				if(pager.getData() != null && pager.getData().size() > 0){
					for (EspNavCategoryInfModel navCategoryInfModel:pager.getData()) {
						BrandTypeVO brandTypeVO = new BrandTypeVO();
						brandTypeVO.setTypeId(StringUtil.dealNull(navCategoryInfModel.getCategoryId()));//大类ID
						brandTypeVO.setParentId(StringUtil.dealNull(navCategoryInfModel.getCategoryId()));//上一级ID
						brandTypeVO.setOrderTypeId("YG");//订单类别ID
						brandTypeVO.setLevelCode("1");//级别代码 1：主类别  2：子类别
						brandTypeVO.setLevelNm(StringUtil.dealNull(navCategoryInfModel.getCategoryName()));//类别名称
						brandTypeVO.setLevelSeq(String.valueOf(navCategoryInfModel.getCategorySeq()));//类别顺序
						brandTypeVO.setLevelDesc(StringUtil.dealNull(navCategoryInfModel.getCategoryDesc()));//说明
						brandTypeVO.setPictureUrl("");

						brandTypeList.add(brandTypeVO);
					}
				}
			}else if("02".equals(queryType)){
				if(StringUtils.isNotEmpty(typeId)){
					paramMap.put("brandCategoryId",typeId);
				}

				Response<Pager<GoodsBrandModel>> response = brandService.findGoodsBrandByPage(paramMap);
				if(!response.isSuccess()){
					log.error("BrandTypeQueryProvideServiceImpl.process->brandService.findGoodsBrandByPage.error paramMap:{}",
							paramMap);
					brandTypeQueryReturnVO.setReturnCode("000009");
					brandTypeQueryReturnVO.setReturnDes("系统异常");
				}
				//查询typeId的品牌列表
//				pager = tblGoodsBrandBySqlDao.queryBrandById(typeId, searchVo);
				Pager<GoodsBrandModel> brandPager = response.getResult();
				totalCount = brandPager.getTotal();
				if(brandPager.getData() != null && brandPager.getData().size() > 0){
					for (GoodsBrandModel brandModel: brandPager.getData()) {
						BrandTypeVO brandTypeVO = new BrandTypeVO();
						//数据解析
						brandTypeVO.setTypeId(String.valueOf(brandModel.getId()));//品牌ID
						brandTypeVO.setParentId(StringUtil.dealNull(brandModel.getBrandCategoryId()));//上一级ID
						brandTypeVO.setOrderTypeId("YG");//订单类别ID
						brandTypeVO.setLevelCode("2");//级别代码 1：主类别  2：子类别
						brandTypeVO.setLevelNm(StringUtil.dealNull(brandModel.getBrandName()));//品牌名称
						brandTypeVO.setLevelSeq(String.valueOf(brandModel.getBrandSeq()));//品牌顺序
						brandTypeVO.setLevelDesc(StringUtil.dealNull(brandModel.getBrandDesc()));//说明
						brandTypeVO.setPictureUrl(StringUtil.dealNull(brandModel.getBrandImage()));//品牌图片链接

						brandTypeList.add(brandTypeVO);
					}
				}

			}else{
				//查询类型参数错误
				brandTypeQueryReturnVO.setReturnCode("000008");
				brandTypeQueryReturnVO.setReturnDes("查询类型错误");
				return brandTypeQueryReturnVO;
			}

			//计算总的分页数 = 总条数 / 每页条数
			BigDecimal totalCountDecimal = new BigDecimal(totalCount);
			BigDecimal pageSizeDecimal = new BigDecimal(rowsPageInt);
			Long totalPage = totalCountDecimal.divide(pageSizeDecimal,0,BigDecimal.ROUND_CEILING).longValue();

			brandTypeQueryReturnVO.setTotalCount(String.valueOf(totalCount));//总数据数量
			brandTypeQueryReturnVO.setTotalPages(String.valueOf(totalPage));//总页数
			brandTypeQueryReturnVO.setBrandTypes(brandTypeList);
			brandTypeQueryReturnVO.setReturnCode("000000");
			brandTypeQueryReturnVO.setReturnDes("类别品牌查询成功");
		} catch (Exception e) {
			log.error("BrandTypeQueryProvideServiceImpl.process.error Exception:{}", Throwables.getStackTraceAsString(e));
			brandTypeQueryReturnVO.setReturnCode("000009");
			brandTypeQueryReturnVO.setReturnDes("系统异常");
		}

		return brandTypeQueryReturnVO;
	}

}
