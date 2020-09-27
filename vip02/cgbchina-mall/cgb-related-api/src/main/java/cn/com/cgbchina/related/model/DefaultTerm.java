package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 11140721050130 on 2016/4/3.
 */
public class DefaultTerm implements Serializable {

	private static final long serialVersionUID = 1990266652998529098L;
	@Getter
	@Setter
	private Long id;
	@Getter
	@Setter
	private String termName;
	@Getter
	@Setter
	private String status;

	@Override
	public String toString() {
		return "DefaultTerm{" + "id=" + id + ", termName='" + termName + '\'' + ", status='" + status + '\'' + '}';
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		DefaultTerm that = (DefaultTerm) o;

		if (id != null ? !id.equals(that.id) : that.id != null)
			return false;
		if (status != null ? !status.equals(that.status) : that.status != null)
			return false;
		if (termName != null ? !termName.equals(that.termName) : that.termName != null)
			return false;

		return true;
	}

	@Override
	public int hashCode() {
		int result = id != null ? id.hashCode() : 0;
		result = 31 * result + (termName != null ? termName.hashCode() : 0);
		result = 31 * result + (status != null ? status.hashCode() : 0);
		return result;
	}
}
