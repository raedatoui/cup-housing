package com.modestmaps.mapproviders.google {
import com.modestmaps.core.Coordinate;
import com.modestmaps.mapproviders.IMapProvider;

/**
 * @author darren
 * $Id: GoogleRoadMapProvider.as 701 2008-09-30 05:54:20Z migurski $
 */
public class GoogleRoadMapProvider extends AbstractGoogleMapProvider implements IMapProvider {
    public function GoogleRoadMapProvider(minZoom:int = MIN_ZOOM, maxZoom:int = MAX_ZOOM) {
        super(minZoom, maxZoom);
    }

    public function toString():String {
        return "GOOGLE_ROAD";
    }

    public function getTileUrls(coord:Coordinate):Array {
        // TODO: http://mt1.google.com/mt?v=w2.83&hl=en&x=10513&s=&y=25304&z=16&s=Gal
        return ["http://mt" + Math.floor(Math.random() * 4) + ".google.com/mt?n=404&v=" + __roadVersion + getZoomString(sourceCoordinate(coord))];
    }

    protected function getZoomString(coord:Coordinate):String {
        return "&x=" + coord.column + "&y=" + coord.row + "&zoom=" + (17 - coord.zoom);
    }
}
}