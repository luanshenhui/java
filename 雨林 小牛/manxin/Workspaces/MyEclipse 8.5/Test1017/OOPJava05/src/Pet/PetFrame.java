package Pet;
import java.awt.*;
import java.awt.event.*;
	/**����ϵͳ��Frame
	 * 2014-10-31
	 *���ܣ�showFrame
	 *		����ֵ������ֵ��
	 */

public class PetFrame extends Frame{
	public static void main(String[] args){
		PetFrame pf = new PetFrame();
	}

	public PetFrame(){
		
		setTitle("�ҵĳ���");
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

