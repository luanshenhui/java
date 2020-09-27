package cn.rkylin.apollo.utils;

import java.awt.geom.GeneralPath;
import java.awt.geom.Point2D;
import java.util.List;

public class GraphUtil {
	
	/**
	 * 坐标点是否在多边形内
	 * lng 经度 , lat纬度  new Point2D.Double(经度,纬度);  
	 * @param point
	 * @param polygon
	 * @return
	 */
	public static boolean containsPoint(Point2D.Double point, List<Point2D.Double> polygon) {
	   GeneralPath p = new GeneralPath();
	   Point2D.Double first = polygon.get(0);
	   p.moveTo(first.x, first.y);
	   for (Point2D.Double d : polygon) {
	      p.lineTo(d.x, d.y);
	   }
	   p.lineTo(first.x, first.y);
	   p.closePath();
	   return p.contains(point);
	}
}
