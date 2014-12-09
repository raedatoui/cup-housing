package com.shashi.svg {
import com.modestmaps.Map;
import com.modestmaps.geo.Location;
import com.modestmaps.overlays.Polyline;
import com.modestmaps.overlays.PolylineClip;

import flash.geom.Point;

public class SVGPolylineClip extends PolylineClip implements ISVGExportable {
    public function SVGPolylineClip(map:Map) {
        super(map);
    }

    public function exportLine(line:Polyline):String {
        if (line.locationsArray.length > 1) {
            var l:Location = line.locationsArray[0];
            var p:Point = this.localToGlobal(map.locationPoint(l, this));
            var pathStr:String = '<path d="M ' + p.x + ' ' + p.y + ' L ';

            var pts:Array = [];
            for each (var loc:Location in line.locationsArray) {
                p = this.localToGlobal(map.locationPoint(loc, this));
                pts.push(p.x);
                pts.push(p.y);
            }

            var styleStr:String = SVGConstants.getStyleString(line.lineThickness, line.lineColor,
                    line.lineAlpha, 0, 0, line.caps,
                    line.joints, line.miterLimit);
            pathStr = pathStr + pts.join(' ') + '" ' + styleStr + '/>';
            trace(pathStr);
            return pathStr;
        }

        return '';
    }

    public function export():String {
        var results:Array = [];
        for each (var line:Polyline in polylines) {
            results.push(exportLine(line));
        }
        return results.join('\n');
    }
}
}