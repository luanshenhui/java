package gfvh;

/**
 * AdminRole entity. @author MyEclipse Persistence Tools
 */

public class AdminRole implements java.io.Serializable {

	// Fields

	private AdminRoleId id;

	// Constructors

	/** default constructor */
	public AdminRole() {
	}

	/** full constructor */
	public AdminRole(AdminRoleId id) {
		this.id = id;
	}

	// Property accessors

	public AdminRoleId getId() {
		return this.id;
	}

	public void setId(AdminRoleId id) {
		this.id = id;
	}

}