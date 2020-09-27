package Pet;
import java.awt.*;
import java.awt.event.*;
	/**宠物系统，Frame
	 * 2014-10-31
	 *功能：showFrame
	 *		饥饿值，心情值等
	 */

public class PetFrame extends Frame{
	public static void main(String[] args){
		PetFrame pf = new PetFrame();
	}

	public PetFrame(){
		
		setTitle("我的宠物");
		setSize(800,600);
		setBackground(Color.cyan);
		setAlwaysOnTop(true);
		addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e){
				System.exit(0);
			}
		});
	} 
}

