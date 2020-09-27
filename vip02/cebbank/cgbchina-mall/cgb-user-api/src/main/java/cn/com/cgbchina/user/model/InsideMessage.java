package cn.com.cgbchina.user.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by yuxinxin on 16-4-8.
 */
public class InsideMessage implements Serializable {

	private static final long serialVersionUID = 8508578513245457072L;
	@Getter
	@Setter
	private Long id;
	@Getter
	@Setter
	private String inside;
	@Getter
	@Setter
	private String creatTime;
	@Getter
	@Setter
	private String insideMessage;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		InsideMessage that = (InsideMessage) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.inside, that.inside)
				&& Objects.equal(this.insideMessage, that.insideMessage)
				&& Objects.equal(this.creatTime, that.creatTime);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, inside, insideMessage, creatTime);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("inside", inside).add("inside_message", insideMessage)
				.add("creatTime", creatTime).toString();
	}
}
