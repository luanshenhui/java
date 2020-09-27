package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import chinsoft.business.ClothingManager;
import chinsoft.business.CustomerManager;
import chinsoft.business.DictManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.entity.Customer;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.tempService.MapUtil;
import chinsoft.tempService.SpliceHtmlStr;

import com.opensymphony.xwork2.ActionSupport;

public class EditOrdenAction extends ActionSupport {
	
	private Orden orden;
	private Customer customer;
	private String copyFlag;
	
	/**初始化标识  页面初始化后  此参数为"1"*/
	private String  isInit;
	/**服装分类*/
	private List<Dict> dicts;
	
	/**库存信息*/
	private String fabric_resultHtml;
	/**托管信息*/
	private String autoContainerHtml;
	
	/**迭代工艺信息用 服装*/
	private List<Dict> cloth_category;
	private List<MapUtil> cloth_process;
	private List<MapUtil> cloth_embroid;

	
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
	private String jtSize;
	public String execute(){
		if(orden==null || "".equals(orden.getOrdenID())){
			return null;
		}
		orden = new OrdenManager().getOrdenByID(orden.getOrdenID());
		//orden = new OrdenManager().extendOrden(orden);
		if(orden.getCustomerID()!=null && !"".equals(orden.getCustomerID())){
			customer = new CustomerManager().getCustomerByID(orden.getCustomerID());
		}
		//未从此入口 初始化的
		try {
			if(!"1".equals(isInit)){
				isInit = "1";
				dicts = new ClothingManager().getClothing();
				cloth_process = new ArrayList<MapUtil>();
				cloth_category = new ArrayList<Dict>();
				String[] clothArr;
				//默认初始化时是二件套 的
				switch (orden.getClothingID()) {
				case 1:
					clothArr = new String[]{"3","2000"};
					break;
				case 2:
					clothArr = new String[]{"3","2000","4000"};
					break;
				case 4:
					clothArr = new String[]{"4000","2000"};
					break;
				case 5:
					clothArr = new String[]{"90000","2000"};
					break;
				case 6:
					clothArr = new String[]{"3","4000"};
					break;
				case 7:
					clothArr = new String[]{"95000","98000"};
					break;
				default:
					clothArr = new String[]{orden.getClothingID().toString()};
					break;
				}
				//工艺
				for(int i =0;i<clothArr.length;i++){
					cloth_category.add(DictManager.getDictByID(Utility.toSafeInt(clothArr[i])));
					cloth_process.add(new MapUtil(DictManager.getDictByID(Utility.toSafeInt(clothArr[i])),
							new ClothingManager().getOrderProcessHtml(orden.getOrdenID(),Utility.toSafeInt(clothArr[i]))));
				}
				//刺绣
				cloth_embroid = new ArrayList<MapUtil>();
//				int n=0;
//				for(int i =0;i<clothArr.length;i++){
//					if("90000".equals(clothArr[i]) ||"95000".equals(clothArr[i]) || "98000".equals(clothArr[i])){
//						n++;
//					}
//				}
//				if(n==0){
					cloth_embroid = new ClothingManager().GetOrdenEmbroids(orden);
//				}

				ClothingManager clothingManager = new ClothingManager();
				
				fabric_resultHtml = clothingManager.getFabric_resultHtml(orden);//面料库存
				autoContainerHtml = clothingManager.getAutoContainerHtml(orden);//面料托管
				size_category = clothingManager.getOrdenSize_categoryHtml(orden);
	            size_unit = clothingManager.getOrdenSize_unitHtml(orden);
	            size_area = clothingManager.getOrdenSize_areaHtml(orden);
	            size_spec_part = new SpliceHtmlStr().spliceBodySpec(orden);
	            jtSize = orden.getJtSizeName();//老平台净体量体（成衣、净体都有时）
	            size_bodytype = new SpliceHtmlStr().spliceSizeBodyType(orden);
	            imgHtml = clothingManager.showImg(orden);
	            style_title = clothingManager.getOrdenStyle_titleHtml(orden);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "editOrden";
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

	public List<Dict> getCloth_category() {
		return cloth_category;
	}

	public void setCloth_category(List<Dict> cloth_category) {
		this.cloth_category = cloth_category;
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

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}


	public List<MapUtil> getCloth_process() {
		return cloth_process;
	}

	public void setCloth_process(List<MapUtil> cloth_process) {
		this.cloth_process = cloth_process;
	}

	public List<MapUtil> getCloth_embroid() {
		return cloth_embroid;
	}

	public void setCloth_embroid(List<MapUtil> cloth_embroid) {
		this.cloth_embroid = cloth_embroid;
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

	public String getFabric_resultHtml() {
		return fabric_resultHtml;
	}

	public void setFabric_resultHtml(String fabric_resultHtml) {
		this.fabric_resultHtml = fabric_resultHtml;
	}

	public String getAutoContainerHtml() {
		return autoContainerHtml;
	}

	public void setAutoContainerHtml(String autoContainerHtml) {
		this.autoContainerHtml = autoContainerHtml;
	}

	public String getJtSize() {
		return jtSize;
	}

	public void setJtSize(String jtSize) {
		this.jtSize = jtSize;
	}

	
}
