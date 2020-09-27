package chinsoft.service.orden;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.List;

import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.tempService.SpliceHtmlStr;

import com.opensymphony.xwork2.ActionSupport;

public class AddOrdenAction extends ActionSupport {
	private Orden orden;
	private String copyFlag;
	/**初始化标识  页面初始化后  此参数为"1"*/
	private String  isInit;
	/**服装分类*/
	private List<Dict> dicts;
	
	/**迭代工艺信息用 服装 二件套*/
	private List<Dict> cloth_double;
	
	
	/**尺寸分类 净体 成衣 标准号*/
	private String size_category;
	/**英寸 厘米*/
	private String size_unit;
	/**欧码。亚码。。。*/
	private String size_area;
	/**录入的尺寸信息*/
	private String size_spec_part;
	/**勾选的尺寸信息*/
	private String size_bodytype;
	/**长短款*/
	private String style_title;
	/**加单裤*/
	private String more_pants;
	/**衬衣数量*/
	private String more_shirt;
	/**图片*/
	private String imgHtml;
	public String execute(){
		//未从此入口 初始化的
		try {
			if(!"1".equals(isInit)){
				isInit = "1";
				dicts = new ClothingManager().getClothing();
				
				cloth_double = new ArrayList<Dict>();
				//默认初始化时是二件套 的
				String[] set2 = new String[]{"3","2000"};
				for(int i =0;i<set2.length;i++){
					cloth_double.add(DictManager.getDictByID(Utility.toSafeInt(set2[i])));
				}
				ClothingManager clothingManager = new ClothingManager();
				size_category = clothingManager.getOrdenSize_categoryHtml(null);
			    InetAddress localHostAddress = InetAddress.getLocalHost(); 
			    
//			    ServletContext servletContext = (ServletContext)ActionContext.getContext().get(ServletActionContext.SERVLET_CONTEXT);  
//			    String rootPath = servletContext.getRealPath("/");  
//			    String path = ServletActionContext.getServletContext().getRealPath("/");  
//			    int currentVersion =  CVersion.getCurrentVersionID();
//			    path = path + "size\\" + currentVersion + "\\";
			    
			    
	            size_unit = clothingManager.getOrdenSize_unitHtml(null);
	            size_spec_part = new SpliceHtmlStr().spliceBody();
	            size_bodytype = new SpliceHtmlStr().spliceBodytype();
	            style_title = clothingManager.getOrdenStyle_titleHtml(null);
	            
	            imgHtml = clothingManager.showImg(null);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
		
		return "addOrden";
	}

	public String getIsInit() {
		return isInit;
	}

	public void setIsInit(String isInit) {
		this.isInit = isInit;
	}

	public List<Dict> getDicts() {
		return dicts;
	}

	public void setDicts(List<Dict> dicts) {
		this.dicts = dicts;
	}

	public List<Dict> getCloth_double() {
		return cloth_double;
	}

	public void setCloth_double(List<Dict> cloth_double) {
		this.cloth_double = cloth_double;
	}

	public Orden getOrden() {
		return orden;
	}

	public void setOrden(Orden orden) {
		this.orden = orden;
	}

	public String getCopyFlag() {
		return copyFlag;
	}

	public void setCopyFlag(String copyFlag) {
		this.copyFlag = copyFlag;
	}

	public String getSize_category() {
		return size_category;
	}

	public void setSize_category(String size_category) {
		this.size_category = size_category;
	}

	public String getSize_unit() {
		return size_unit;
	}

	public void setSize_unit(String size_unit) {
		this.size_unit = size_unit;
	}

	public String getSize_area() {
		return size_area;
	}

	public void setSize_area(String size_area) {
		this.size_area = size_area;
	}

	public String getSize_spec_part() {
		return size_spec_part;
	}

	public void setSize_spec_part(String size_spec_part) {
		this.size_spec_part = size_spec_part;
	}

	public String getSize_bodytype() {
		return size_bodytype;
	}

	public void setSize_bodytype(String size_bodytype) {
		this.size_bodytype = size_bodytype;
	}

	public String getStyle_title() {
		return style_title;
	}

	public void setStyle_title(String style_title) {
		this.style_title = style_title;
	}

	public String getMore_pants() {
		return more_pants;
	}

	public void setMore_pants(String more_pants) {
		this.more_pants = more_pants;
	}

	public String getMore_shirt() {
		return more_shirt;
	}

	public void setMore_shirt(String more_shirt) {
		this.more_shirt = more_shirt;
	}

	public String getImgHtml() {
		return imgHtml;
	}

	public void setImgHtml(String imgHtml) {
		this.imgHtml = imgHtml;
	}

	
	
	
}
