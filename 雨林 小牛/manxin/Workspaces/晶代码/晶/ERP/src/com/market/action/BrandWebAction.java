package com.market.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.BrandService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.Brand;
import com.opensymphony.xwork2.ActionSupport;

public class BrandWebAction extends ActionSupport {

	/**
	 * Service层实例
	 */
	private BrandService brandService;

	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private Brand brand = new Brand();

	private Long id;

	@SuppressWarnings("unchecked")
	public String queryBrand() {
		log.debug("queryBrand" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = brandService.getCount(brand);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_BRAND, resultSize,
				request);
		List list = brandService.findPageInfoBrand(brand, pageBean);
		request.setAttribute(Constants.BRAND_LIST, list);
		log.debug("queryBrand" + "结束");
		return Constants.LIST;
	}

	/**
	 * 
	 * 进入增加界面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toAddBrand() {
		log.debug("toAddBrand" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddBrand" + "结束");
		return Constants.ADD;
	}

	/**
	 * 
	 * 增加
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String addBrand() {
		log.debug("addBrand" + "开始");
		try {
			brandService.save(brand);
			brand = new Brand();
		} catch (Exception e) {
			log.error("addBrand failed" + brand.toString());
		}
		log.debug("addBrand" + "结束");
		return queryBrand();
	}

	/**
	 * 
	 * 删除
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String delBrand() {
		log.debug("delBrand" + "开始");
		try {
			brand.setId(id);
			brandService.delete(brand);
		} catch (Exception e) {
			log.error("delBrand failed" + brand.toString());
		}
		log.debug("delBrand" + "结束");
		return queryBrand();
	}

	/**
	 * 
	 * 进入编辑界面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toEditBrand() {
		log.debug("toEditBrand" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		brand = brandService.getBrand(id);
		initSelect(request);
		log.debug("toEditBrand" + "结束");
		return Constants.EDIT;
	}

	/**
	 * 
	 * 查看信息
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String viewBrand() {
		log.debug("viewBrand" + "开始");
		brand = brandService.getBrand(id);
		log.debug("viewBrand" + "结束");
		return Constants.VIEW;
	}

	/**
	 * 
	 * 编辑
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String editBrand() {
		log.debug("editBrand" + "开始");
		try {
			brandService.update(brand);
			brand = new Brand();
		} catch (Exception e) {
			log.error("editBrand failed" + brand.toString());
		}
		log.debug("editBrand" + "结束");
		return queryBrand();
	}

	/**
	 * @param BrandService
	 *            the BrandService to set
	 */
	public void setBrandService(BrandService brandService) {
		this.brandService = brandService;
	}

	public Brand getBrand() {
		return brand;
	}

	public void setBrand(Brand brand) {
		this.brand = brand;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request) {
		request.setAttribute("qyzt", DataSource.YHLX);
		// request.setAttribute("ywfw",DataSource.YWFW);
		// request.setAttribute("jydy",DataSource.JYDY);
		// request.setAttribute("gszt",DataSource.GSZT);
	}

}
