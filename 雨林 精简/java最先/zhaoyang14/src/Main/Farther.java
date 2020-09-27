package Main;

public abstract class Farther {
	private String name;

	/**
	 * @param name
	 */
	public Farther(String name) {

		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return name;
	}

}
