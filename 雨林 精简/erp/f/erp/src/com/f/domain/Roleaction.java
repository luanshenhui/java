/**
 * 
 */
package com.f.domain;

/**
 * @author ��ѧ��
 *
 * 2015-2-2����11:09:02
 *Ȩ�ޱ�
 *
 *
 */
public class Roleaction extends BaseDomain{
		private String rolename ;
		public Roleaction(){
			this("");
		}

		public Roleaction(String rolename) {
			super();
			this.rolename = rolename;
		}

		public String getRolename() {
			return rolename;
		}

		public void setRolename(String rolename) {
			this.rolename = rolename;
		}
		@Override
		public String toString() {
			return "Roleaction [rolename=" + rolename + "]";
		}	
}
