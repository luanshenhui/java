package rcmtm.entity;

/**
* <p>Title: Geo.java</p>
* <p>Description: 中国地域分布</p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: RCOLLAR</p>
* @author <a href="mailto:fanjinhu@gmail.com">fjh</a>
* @date 2014-1-11
* @version 1.0
 */
public class Geo {

	private Integer id;
	private Integer parentid;
	private String name;
	private String shortening;
	private Long ipto;
	private Long ipfrom;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getParentid() {
		return parentid;
	}
	public void setParentid(Integer parentid) {
		this.parentid = parentid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getShortening() {
		return shortening;
	}
	public void setShortening(String shortening) {
		this.shortening = shortening;
	}
	public Long getIpto() {
		return ipto;
	}
	public void setIpto(Long ipto) {
		this.ipto = ipto;
	}
	public Long getIpfrom() {
		return ipfrom;
	}
	public void setIpfrom(Long ipfrom) {
		this.ipfrom = ipfrom;
	}
	@Override
	public String toString() {
		return "Geo [id=" + id + ", parentid=" + parentid + ", name=" + name + ", shortening=" + shortening + ", ipto=" + ipto + ", ipfrom=" + ipfrom + "]";
	}
	
}
